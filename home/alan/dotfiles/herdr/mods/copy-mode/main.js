// Copy mode, as tmux's prefix + [ : a cursor that walks the terminal's screen
// and history with Vim's keys, selects with v / V and yanks with y. Opened over
// the focused terminal (keys.json: "ctrl-a [": "mod.open:copy-mode"); while it
// shows, keys come here instead of going to the program.
//
// The cursor is Herdr's selection, one cell wide until v or V starts a real
// one: a move stretches the selection, then it's made one cell again at its end.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { focused, panes, terminals, run, closeOverlay, props, theme, nextCommand, checking } from "herdr";

// A key (as typed: "G" is shift+g) -> where the cursor goes.
const MOVE = {
  h: "left", j: "down", k: "up", l: "right", left: "left", down: "down", up: "up", right: "right",
  "0": "line_start", "^": "line_start", $: "line_end", home: "line_start", end: "line_end",
  g: "home", G: "end", pageup: "page_up", pagedown: "page_down",
};
// With ctrl held.
const CTRL = { u: "page_up", b: "page_up", d: "page_down", f: "page_down" };

export default class CopyMode extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.cx = cx;
    // The terminal under this: the focused pane's, asked before this takes the keyboard.
    this.terminal = focused()?.terminal ?? panes().find((p) => p.focused && p.terminal)?.terminal ?? null;
    this.mode = null; // null: only a cursor; "cell": v; "line": V
    if (checking() || !this.terminal) return;
    run("terminal.select", { terminal: this.terminal, at: "cursor" });
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    // The same keys as commands ("copy-mode.j"), for scripts and tests.
    cx.spawn(async (cx) => {
      for (;;) {
        // "shift-v" is V: a command's name may not keep its case.
        const c = String(await nextCommand()).split(".").pop().replace(/^shift-(.)$/, (_m, k) => k.toUpperCase());
        if (c !== "focus") this.press(c, false);
        cx.notify();
      }
    });
  }

  selection() {
    return terminals().find((t) => t.address === this.terminal)?.selection ?? null;
  }

  // One cell at the moving end: the cursor, with nothing selected.
  collapse() {
    const end = this.selection()?.end;
    if (end) run("terminal.select", { terminal: this.terminal, at: { row: end.row, col: end.col }, mode: "cell" });
  }

  // The new end is readable a moment after the move, not at once: the cursor
  // is made one cell again then (several quick moves: once, at the last end).
  move(direction) {
    run("terminal.adjust_selection", { terminal: this.terminal, direction });
    if (this.mode === "cell" || this.settling) return;
    this.settling = true;
    this.cx.timer.after(25, () => {
      this.settling = false;
      if (this.left) return;
      if (!this.mode) this.collapse();
      else if (this.mode === "line") this.wholeLine();
    });
  }

  // V: whole lines from the one it began on (`anchor`) to the cursor's. Herdr's
  // own line selection takes nothing on an empty line, so it's a cell selection
  // from the anchor line's first cell, its end kept at the far side of its line.
  wholeLine() {
    const end = this.selection()?.end;
    if (end) run("terminal.adjust_selection", { terminal: this.terminal, direction: end.row >= this.anchor ? "line_end" : "line_start" });
  }

  // The lines of a V selection, exactly, whichever way it was stretched.
  selectLines(a, b) {
    const top = Math.min(a, b), bottom = Math.max(a, b);
    run("terminal.select", { terminal: this.terminal, at: { row: top, col: 0 }, mode: "cell" });
    for (let i = top; i < bottom; i++) run("terminal.adjust_selection", { terminal: this.terminal, direction: "down" });
    run("terminal.adjust_selection", { terminal: this.terminal, direction: "line_end" });
  }

  press(key, ctrl) {
    const to = ctrl ? CTRL[key] : MOVE[key];
    if (to) return this.mode === "line" && (to === "left" || to === "right" || to.startsWith("line_")) ? null : this.move(to);
    if (ctrl) return;
    if (key === "v" || key === "space") {
      // Again: back to only a cursor, where the selection's end was.
      if (this.mode === "cell") { this.mode = null; this.collapse(); } else { this.collapse(); this.mode = "cell"; }
    } else if (key === "V") {
      if (this.mode === "line") { this.mode = null; this.collapse(); return; }
      const end = this.selection()?.end;
      if (!end) return;
      this.anchor = end.row;
      this.selectLines(end.row, end.row);
      this.mode = "line";
    } else if (key === "y" || key === "enter") {
      // Nothing selected: the cursor's line, as yy.
      const end = this.selection()?.end;
      if (this.mode !== "cell" && end) this.selectLines(this.mode ? this.anchor : end.row, end.row);
      run("terminal.copy");
      this.leave();
    } else if (key === "q" || key === "escape") this.leave();
  }

  // Out: nothing selected, the view back at the live screen.
  tidy() {
    if (this.left || !this.terminal) return;
    this.left = true;
    run("terminal.clear_selection", { terminal: this.terminal });
    run("terminal.scroll", { terminal: this.terminal, to: "bottom" });
  }

  leave() {
    this.tidy();
    closeOverlay(props().overlay);
  }

  // Closed from outside (Esc, a click beside it).
  async close() {
    this.tidy();
  }

  render() {
    const t = theme();
    const hint = (keys, what) => h_flex().gap(4).child(div().text_color(t.foreground).child(keys)).child(div().text_color(t.dim).child(what));
    return h_flex().id("copy-mode").track_focus(this.handle).size_full().px(12).gap(14).items_center().bg(t.popover).text_size(12)
      .on_key_down((e, cx) => {
        const m = e.modifiers;
        if (m.platform || m.alt) return;
        this.press(m.control ? e.key : (e.key_char && e.key_char !== " " ? e.key_char : e.key), m.control);
        cx.stop_propagation();
        cx.notify();
      })
      .child(div().flex_none().px(6).rounded(4).bg(this.mode ? t.accent : t.raised).text_color(t.foreground).font_semibold()
        .child(!this.terminal ? "NO TERMINAL" : this.mode === "line" ? "V-LINE" : this.mode === "cell" ? "VISUAL" : "COPY"))
      .child(hint("hjkl", "move"))
      .child(hint("0 $ g G", "ends"))
      .child(hint("^u ^d", "page"))
      .child(hint("v V", "select"))
      .child(hint("y", "yank"))
      .child(hint("q", "quit"));
  }
}
