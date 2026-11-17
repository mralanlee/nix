// New space. Two modes:
//
// Picker (cmd-n, "New space" in wt-new-menu, wt-spaces' "+"): lists the git
// repos in ~/projects, most recently active first, the focused terminal's
// repo preselected. Enter makes a worktree of the chosen one; Esc, Cancel or
// a click outside makes a plain new space (what space.new did before).
//
// Direct (props.folder, from wt-new-menu's agents): no UI; a worktree of that
// folder's repo, with the agent (props.tab + props.argv) as its first tab.
//
// Either way the worktree is Conductor-style: fetched from origin and branched
// from its default branch (origin/HEAD, e.g. origin/main), never from what the
// checkout is on; named after a random city: branch <BRANCH_PREFIX>/<city>,
// checkout ~/.herdr/worktrees/<repo>/<BRANCH_PREFIX>-<city>; a taken name gets
// -v1, -v2… No origin: the repo's HEAD. Fetch fails (offline): the local
// origin/<default> ref as it is.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input, Scrollbar } from "gpui-base";
import { run, props, closeOverlay, spaces, panes, exec, home, theme } from "herdr";
import { CITIES } from "./cities.js";

const BRANCH_PREFIX = "alan";
// Where the picker looks for repos (direct children with a .git folder).
const PROJECTS = "projects"; // under $HOME
// false: skip the fetch and branch from the local origin/<default> as it is.
const FETCH = true;

const slug = (b) => b.replace(/[^A-Za-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "");

async function git(cwd, args, on) {
  const r = await exec("git", args, { cwd, on });
  return { ok: r.code === 0, out: (r.stdout ?? "").trim(), err: (r.stderr ?? r.stdout ?? "").trim() };
}

async function homeOf(on) {
  return on ? (await exec("sh", ["-c", 'printf %s "$HOME"'], { on })).stdout.trim() : home();
}

// The repo a folder is in: its main checkout, name, and checkouts folder.
async function repoOf(folder, on) {
  const common = await git(folder, ["rev-parse", "--path-format=absolute", "--git-common-dir"], on);
  if (!common.ok) return null;
  const main = common.out.endsWith("/.git") ? common.out.slice(0, -5) : common.out;
  const name = main.split("/").pop();
  return { main, name, root: `${await homeOf(on)}/.herdr/worktrees/${name}` };
}

// ~/projects/* that are main checkouts (.git is a folder), newest .git first.
async function projects(on) {
  const r = await exec("sh", ["-c", 'cd "$HOME/$1" 2>/dev/null || exit 0; ls -1dt -- */.git 2>/dev/null | while read -r g; do [ -d "$g" ] && printf "%s\\n" "$PWD/${g%/.git}"; done', "sh", PROJECTS], { on });
  return (r.stdout ?? "").split("\n").filter(Boolean).map((path) => ({ path, name: path.split("/").pop() }));
}

// What to branch from: origin's default branch, fetched first; else HEAD.
async function base(repo, on) {
  const head = await git(repo.main, ["symbolic-ref", "--short", "refs/remotes/origin/HEAD"], on);
  let ref = head.ok ? head.out : null; // e.g. "origin/main"
  if (!ref && (await git(repo.main, ["show-ref", "--verify", "--quiet", "refs/remotes/origin/main"], on)).ok) ref = "origin/main";
  if (!ref) return "HEAD";
  if (FETCH) {
    // Never prompt, and give up on an unreachable remote quickly.
    await exec("sh", ["-c", 'GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=5" git fetch --quiet origin "$1"', "sh", ref.slice("origin/".length)], { cwd: repo.main, on });
  }
  return ref;
}

// A city branch no branch or checkout folder already uses.
async function cityBranch(repo, on) {
  const free = async (b) => !(await git(repo.main, ["show-ref", "--verify", "--quiet", `refs/heads/${b}`], on)).ok
    && (await exec("test", ["!", "-e", `${repo.root}/${slug(b)}`], { on })).code === 0;
  const pool = [...CITIES].sort(() => Math.random() - 0.5);
  for (const c of pool.slice(0, 20)) if (await free(`${BRANCH_PREFIX}/${c}`)) return `${BRANCH_PREFIX}/${c}`;
  for (let v = 1; v < 100; v++) for (const c of pool.slice(0, 5)) if (await free(`${BRANCH_PREFIX}/${c}-v${v}`)) return `${BRANCH_PREFIX}/${c}-v${v}`;
  return null;
}

// Make the worktree and open its space. Returns "" or an error message.
async function makeWorktree(repo, on, agent, status) {
  status?.("Fetching origin…");
  const from = await base(repo, on);
  const branch = await cityBranch(repo, on);
  if (!branch) return "No free city name.";
  status?.(`Creating ${branch} from ${from}…`);
  const path = `${repo.root}/${slug(branch)}`;
  // --no-track: a push from the new branch must never default to main.
  const r = await git(repo.main, ["worktree", "add", "--no-track", "-b", branch, path, from], on);
  if (!r.ok) return r.err || "git worktree add failed.";
  // Unnamed, so the space follows its checkout folder and nests under the repo.
  run("space.new", { folder: path, machine: on, ...agent });
  return "";
}

export default class NewSpace extends View {
  init(_props, cx) {
    const p = props() ?? {};
    const space = spaces().find((s) => s.active);
    this.machine = p.machine ?? space?.machine;
    this.on = this.machine || undefined;
    this.done = false;
    this.direct = Boolean(p.folder);
    if (this.direct) return this.runDirect(p, space, cx);

    // Picker.
    this.list = undefined;
    this.text = "";
    this.at = 0;
    this.busy = "";
    this.error = "";
    this.handle = cx.focus_handle();
    this.input = InputState.new({ value: "", placeholder: `filter ~/${PROJECTS}` });
    this.input.on("change", (_e, cx) => { this.text = this.input.value(); this.at = 0; this.error = ""; cx.notify(); });
    this.input.on("submit", (_e, cx) => this.choose(this.shown()[this.at], cx));
    this.inputFocused = true;
    this.input.on("focus", (_e, cx) => { this.inputFocused = true; cx.notify(); });
    this.input.on("blur", (_e, cx) => { this.inputFocused = false; cx.notify(); });
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    const focusedFolder = panes().find((x) => x.focused)?.cwd ?? space?.folder;
    cx.spawn(async (cx) => {
      try {
        const [list, current] = await Promise.all([projects(this.on), focusedFolder ? repoOf(focusedFolder, this.on).catch(() => null) : null]);
        this.list = list.map((r) => ({ ...r, current: current?.main === r.path }));
        // The focused terminal's repo first, then by recency.
        this.list.sort((a, b) => b.current - a.current);
      } catch (e) {
        this.list = [];
        this.error = String(e?.message ?? e);
      }
      cx.notify();
    });
  }

  runDirect(p, space, cx) {
    const agent = p.argv ? { tab: p.tab, argv: p.argv } : {};
    cx.spawn(async () => {
      let err = "not in git";
      try {
        const repo = await repoOf(p.folder, this.on);
        if (repo) err = await makeWorktree(repo, this.on, agent);
      } catch (e) { err = String(e?.message ?? e); }
      this.done = true;
      closeOverlay(p.overlay);
      // Couldn't make one: start the agent (or space) in place instead.
      if (err) {
        if (p.argv) run("tab.new", { name: p.tab, space: space?.id, argv: p.argv });
        else run("space.new", this.machine === undefined ? {} : { machine: this.machine ?? "" });
      }
    });
  }

  shown() {
    const f = this.text.trim().toLowerCase();
    return (this.list ?? []).filter((r) => !f || r.name.toLowerCase().includes(f));
  }

  choose(r, cx) {
    if (!r || this.busy || this.done) return;
    // Input submit and the parent Enter handler can fire before the first await finishes.
    this.busy = "Preparing worktree…";
    this.error = "";
    cx.notify();
    cx.spawn(async (cx) => {
      // Only the spawn's own cx stays valid across the awaits below.
      const status = (s) => { this.busy = s; cx.notify(); };
      let err;
      try {
        const repo = await repoOf(r.path, this.on);
        err = repo ? await makeWorktree(repo, this.on, {}, status) : `${r.name} is not a git repository.`;
      } catch (e) { err = String(e?.message ?? e); }
      this.busy = "";
      if (err) { this.error = err; return cx.notify(); }
      this.done = true;
      closeOverlay(props().overlay);
    });
  }

  plain() {
    if (this.busy) return;
    this.done = true;
    closeOverlay(props().overlay);
    run("space.new", this.machine === undefined ? {} : { machine: this.machine ?? "" });
  }

  // Esc or a click outside closes the dialog without a pick: a plain space.
  async close() {
    if (this.direct || this.done || this.busy) return;
    this.done = true;
    run("space.new", this.machine === undefined ? {} : { machine: this.machine ?? "" });
  }

  key(e, cx) {
    const n = this.shown().length;
    if (e.key === "escape") { cx.stop_propagation(); return this.plain(); }
    if (e.key === "enter") this.choose(this.shown()[this.at], cx);
    else if ((e.key === "down" || e.key === "up") && n) this.at = (this.at + (e.key === "down" ? 1 : n - 1)) % n;
    else return;
    cx.stop_propagation();
    cx.notify();
  }

  render() {
    if (this.direct) return div();
    const t = theme();
    const rows = this.shown();
    const all = this.list ?? [];
    const row = (r, i) => {
      const sel = i === this.at;
      return v_flex()
        .id(`p-${i}`).flex_none().h(44).px(10).justify_center().rounded(7).cursor_pointer()
        .when(sel, (el) => el.bg(t.selected))
        .when(!sel, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click((_e, cx) => { this.at = i; this.choose(r, cx); })
        .child(h_flex().gap(8).items_center()
          .child(div().flex_1().min_w(0).truncate().text_color(t.foreground).child(r.name))
          .when(r.current, (el) => el.child(div().flex_none().text_size(11).text_color(t.accent).child("focused"))))
        .child(div().truncate().text_size(11.5).text_color(t.dim).child(`~/${PROJECTS}/${r.name}`));
    };
    const button = (id, label, action, primary) => div().id(id).px(10).py(4).rounded(6).cursor_pointer()
      .border(1).border_color(primary ? t.accent : t.border).text_color(t.foreground)
      .hover((s) => s.bg(t.hover)).on_click(action).child(label);
    return v_flex()
      .id("wt-new-space").track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .size_full().p(16).gap(10).bg(t.popover).text_size(13)
      .child(h_flex()
        .child(div().flex_1().font_semibold().text_color(t.foreground).child("New space: worktree from…"))
        .child(div().text_size(11).text_color(t.dim).child(this.list ? `${rows.length}/${all.length} repos` : "")))
      .child(div().text_color(t.muted).child(`A fresh ${BRANCH_PREFIX}/<city> branch off origin's default branch. Cancel for a plain space.`))
      .child(Input.new(this.input).h(32).px(10).items_center().rounded(6).border(1)
        .border_color(this.inputFocused ? t.accent : t.input).bg(t.background).text_color(t.foreground))
      .child(div().relative().flex_1().min_h(0)
        .child(v_flex().id("p-list").size_full().overflow_y_scroll()
          .when(this.list === undefined, (el) => el.child(div().p(10).text_color(t.dim).child("…")))
          .children(rows.map(row))
          .when(this.list !== undefined && rows.length === 0, (el) => el.child(div().p(10).text_color(t.dim).child(`No git repos in ~/${PROJECTS} match.`))))
        .child(Scrollbar.vertical("p-list").absolute().inset_0()))
      .when(Boolean(this.error), (el) => el.child(div().text_color(t.blocked).child(this.error)))
      .child(h_flex().gap(8).items_center()
        .child(div().flex_1().text_size(11).text_color(t.dim).child(this.busy || "↑↓ choose · ↵ worktree · esc plain space"))
        .child(button("plain", "Cancel", () => this.plain(), false))
        .child(button("go", "Create worktree", (_e, cx) => this.choose(this.shown()[this.at], cx), true)));
  }
}
