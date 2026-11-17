// Spike: a local Draw board beside the terminals. Read-only; editing stays in the browser.
import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, panes, focused, exec, readTextFile, watchFolder, theme, home, notify } from "herdr";

const HEAD = 42, FOOT = 92, PAD = 24, LIT_MS = 60000;

function folder() {
  const space = spaces().find((s) => s.active), f = focused();
  const pane = f?.pane ? panes().find((p) => p.pane === f.pane) : null;
  return pane?.cwd || f?.cwd || space?.folder || null;
}

// An elbow between two rects on screen: straight runs only, so plain boxes can draw it.
function route(a, b) {
  const ax = a.x + a.w / 2, ay = a.y + a.h / 2, bx = b.x + b.w / 2, by = b.y + b.h / 2;
  if (b.y >= a.y + a.h || b.y + b.h <= a.y) {
    const y1 = b.y >= a.y + a.h ? a.y + a.h : a.y, y2 = b.y >= a.y + a.h ? b.y : b.y + b.h, m = (y1 + y2) / 2;
    return { runs: [[ax, y1, ax, m], [ax, m, bx, m], [bx, m, bx, y2]], from: [ax, y1], to: [bx, y2], label: [(ax + bx) / 2, m] };
  }
  const x1 = b.x >= a.x + a.w ? a.x + a.w : a.x, x2 = b.x >= a.x + a.w ? b.x : b.x + b.w, m = (x1 + x2) / 2;
  return { runs: [[x1, ay, m, ay], [m, ay, m, by], [m, by, x2, by]], from: [x1, ay], to: [x2, by], label: [m, (ay + by) / 2] };
}

export default class Board extends View {
  init(_props, cx) {
    this.boards = []; this.size = { width: 0, height: 0 }; this.zoom = 1; this.pan = { x: 0, y: 0 };
    this.seen = {}; this.lit = {}; this.choice = null; this.selected = null;
    this.reload(cx);
    cx.spawn(async (cx) => {
      try { for (;;) { await watchFolder(`${home()}/.redcrayon/local`); this.reload(cx); } } catch { /* no local boards folder yet: the timer below still finds one */ }
    });
    cx.timer.every(15000, (cx) => this.reload(cx));
  }

  reload(cx) {
    if (this.loading) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        const listed = await exec("sh", ["-c", 'ls -t "$HOME"/.redcrayon/local/*/boards.json 2>/dev/null | head -20']);
        const boards = [];
        for (const path of listed.stdout.split("\n").filter(Boolean)) {
          const text = await readTextFile(path).catch(() => null);
          if (!text) continue;
          try { for (const board of JSON.parse(text).boards ?? []) boards.push({ ...board, store: path.slice(0, path.lastIndexOf("/")) }); } catch { /* mid-write or newer format: keep the rest */ }
        }
        const now = Date.now();
        for (const board of boards) {
          const old = this.seen[board.slug], next = {};
          for (const node of board.nodes) {
            next[node.id] = JSON.stringify(node);
            if (old && old[node.id] !== next[node.id]) this.lit[`${board.slug}/${node.id}`] = now;
          }
          this.seen[board.slug] = next;
        }
        this.boards = boards; this.error = null;
      } catch (e) { this.error = String(e); }
      finally { this.loading = false; cx.notify(); }
    });
  }

  current() {
    const cwd = folder();
    const here = this.boards.filter((b) => cwd && (cwd === b.repo || cwd.startsWith(`${b.repo}/`)));
    const board = this.boards.find((b) => b.slug === this.choice) ?? here[0] ?? this.boards[0] ?? null;
    return { board, here: Boolean(board && here.includes(board)) };
  }

  next(cx) {
    const { board } = this.current();
    if (this.boards.length < 2) return;
    this.choice = this.boards[(this.boards.indexOf(board) + 1) % this.boards.length].slug;
    this.selected = null; this.zoom = 1; this.pan = { x: 0, y: 0 };
    cx.notify();
  }

  open(board, cx) {
    cx.spawn(async () => {
      try {
        const endpoint = JSON.parse(await readTextFile(`${board.store}/endpoint.json`));
        await fetch(endpoint.origin);
        await exec("open", [`${endpoint.origin}/#local&key=${endpoint.token}`]);
      } catch { notify({ title: "Board server is not running", body: "Run draw in this repository, then try again." }); }
    });
  }

  canvas(board, t, W, H) {
    const nodes = board.nodes;
    if (!nodes.length) return [div().absolute().top(12).left(14).text_color(t.dim).child("This board is empty")];
    const minX = Math.min(...nodes.map((n) => n.x)), minY = Math.min(...nodes.map((n) => n.y));
    const bw = Math.max(...nodes.map((n) => n.x + n.w)) - minX, bh = Math.max(...nodes.map((n) => n.y + n.h)) - minY;
    const k = Math.min((W - PAD * 2) / bw, (H - PAD * 2) / bh, 1) * this.zoom;
    const ox = (W - bw * k) / 2 - minX * k + this.pan.x, oy = (H - bh * k) / 2 - minY * k + this.pan.y;
    const rect = (n) => ({ x: n.x * k + ox, y: n.y * k + oy, w: n.w * k, h: n.h * k });
    const at = Object.fromEntries(nodes.map((n) => [n.id, rect(n)]));
    const font = Math.max(8, Math.min(13, 15 * k)), now = Date.now(), line = t.muted;
    const out = [];
    const box = (n, r) => {
      const plain = n.kind === "note" || n.kind === "text", frame = n.kind === "boundary";
      const lit = now - (this.lit[`${board.slug}/${n.id}`] ?? 0) < LIT_MS, picked = this.selected === n.id;
      return v_flex().id(`node-${n.id}`).absolute().left(r.x).top(r.y).w(r.w).h(r.h).overflow_hidden().rounded(Math.max(3, 8 * k))
        .text_size(font).text_color(frame ? t.muted : t.foreground).cursor_pointer()
        .when(!plain, (e) => e.border_1().border_color(picked ? t.accent : lit ? t.working : t.input).bg(frame ? t.background : lit ? t.working + "22" : t.raised))
        .when(n.kind === "external", (e) => e.border_dashed())
        .when(n.kind === "datastore", (e) => e.border_b(Math.max(2, 4 * k)))
        .when(frame, (e) => e.p(Math.max(3, 8 * k)))
        .when(!frame, (e) => e.items_center().justify_center().text_center().px(Math.max(2, 6 * k)).font_semibold())
        .on_click((_e, cx) => { this.selected = picked ? null : n.id; cx.notify(); })
        .child(n.label || n.kind);
    };
    for (const n of nodes.filter((n) => n.kind === "boundary")) out.push(box(n, at[n.id]));
    for (const edge of board.edges) {
      const a = at[edge.from], b = at[edge.to];
      if (!a || !b) continue;
      const path = route(a, b);
      for (const [x1, y1, x2, y2] of path.runs) out.push(div().absolute().left(Math.min(x1, x2)).top(Math.min(y1, y2)).w(Math.max(Math.abs(x2 - x1), 1)).h(Math.max(Math.abs(y2 - y1), 1)).bg(line));
      const dot = ([x, y]) => out.push(div().absolute().left(x - 3).top(y - 3).w(6).h(6).rounded(3).bg(line));
      if (edge.direction !== "none") dot(path.to);
      if (edge.direction === "both") dot(path.from);
      if (edge.label && k > 0.5) out.push(div().absolute().left(path.label[0] - 60).top(path.label[1] - 8).w(120).text_center().text_size(10).text_color(t.muted).child(div().px(3).bg(t.background).child(edge.label)));
    }
    for (const n of nodes.filter((n) => n.kind !== "boundary")) out.push(box(n, at[n.id]));
    return out;
  }

  render(_cx) {
    const t = theme(), { board, here } = this.current();
    const node = board?.nodes.find((n) => n.id === this.selected) ?? null;
    const W = Math.max(0, this.size.width - 2), H = Math.max(0, this.size.height - HEAD - (node ? FOOT : 0) - 2);
    const button = (id, label, act) => div().id(id).h(26).px(9).flex().items_center().rounded(6).border_1().border_color(t.border).text_size(12).text_color(t.foreground).cursor_pointer().hover((s) => s.bg(t.hover)).on_click((_e, cx) => act(cx)).child(label);
    const step = (id, label, act) => div().id(id).px(6).h(22).flex().items_center().text_size(11).text_color(t.muted).cursor_pointer().hover((s) => s.text_color(t.foreground)).on_click((_e, cx) => { act(); cx.notify(); }).child(label);
    return v_flex().id("root").size_full().min_h(0).rounded(10).overflow_hidden().bg(t.background).border_1().border_color(t.border).text_color(t.foreground).text_size(13)
      .on_size_change((size, cx) => { this.size = size; cx.notify(); })
      .child(h_flex().h(HEAD).flex_none().px(14).gap(8).items_center().border_b(1).border_color(t.border)
        .child(div().font_semibold().child("Board"))
        .when(Boolean(board), (e) => e
          .child(div().id("board-name").flex_1().min_w(0).truncate().text_color(t.muted).when(this.boards.length > 1, (n) => n.cursor_pointer().hover((s) => s.text_color(t.foreground)).on_click((_e, cx) => this.next(cx))).child(board.name))
          .child(button("board-open", "Open in browser", (cx) => this.open(board, cx)))))
      .child(div().id("board-canvas").flex_1().min_h(0).relative().overflow_hidden()
        .on_scroll_wheel((e, cx) => { this.pan.x += e.delta.x ?? 0; this.pan.y += e.delta.y ?? 0; cx.notify(); })
        .when(!board, (e) => e.child(div().p(14).text_color(t.dim).child(this.error ?? (this.loading ? "Looking for boards…" : "No local boards yet. Ask your agent to create a draw board."))))
        .when(Boolean(board) && W > 0, (e) => e.children(this.canvas(board, t, W, H)))
        .when(Boolean(board) && !here, (e) => e.child(div().absolute().top(8).left(12).text_size(11).text_color(t.dim).child("No board for this folder. Showing another one.")))
        .when(Boolean(board), (e) => e.child(h_flex().absolute().left(10).bottom(10).px(2).rounded(6).border_1().border_color(t.border).bg(t.chrome)
          .child(step("zoom-out", "−", () => { this.zoom = Math.max(0.5, this.zoom / 1.25); }))
          .child(div().text_size(11).text_color(t.muted).child(`${Math.round(this.zoom * 100)}%`))
          .child(step("zoom-in", "+", () => { this.zoom = Math.min(6, this.zoom * 1.25); }))
          .child(step("zoom-fit", "fit", () => { this.zoom = 1; this.pan = { x: 0, y: 0 }; })))))
      .when(Boolean(node), (e) => e.child(v_flex().h(FOOT).flex_none().px(14).py(10).gap(4).overflow_hidden().border_t(1).border_color(t.border)
        .child(h_flex().gap(8).items_center().child(div().font_semibold().truncate().child(node.label || node.kind))
          .when(Boolean(node.refs?.length), (r) => r.child(div().text_size(11).text_color(t.dim).truncate().child(`${node.refs[0].path}:${node.refs[0].start}`))))
        .child(div().text_size(12).text_color(t.muted).child(node.description || "No description"))));
  }
}
