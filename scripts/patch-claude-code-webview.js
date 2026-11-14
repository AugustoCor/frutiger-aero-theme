#!/usr/bin/env node
// Patches the Claude Code extension's webview CSS so tool blocks (Bash IN/OUT etc.)
// stay readable with the Frutiger Aero glass setup.
//
// Why: tool rows fade out with `mask-image: linear-gradient(var(--app-primary-background) ...)`,
// and --app-primary-background is sideBar.background, which our settings make #00000000 so the
// glass shows through. A mask only reads alpha, so a transparent color hides the row entirely.
// We swap it for opaque black (same fade, alpha-only) and lift the dim IN/OUT labels.
//
// Extension updates replace the file, so re-run after Claude Code updates:
//   node scripts/patch-claude-code-webview.js
// Then run "Developer: Reload Window".

const fs = require("fs");
const path = require("path");
const os = require("os");

const roots = [".vscode", ".antigravity"].map((d) => path.join(os.homedir(), d, "extensions"));

const patches = [
  {
    name: "tool row fade mask",
    from: /mask-image:linear-gradient\(to bottom,var\(--app-primary-background\)/g,
    to: "mask-image:linear-gradient(to bottom,#000 ",
  },
  {
    name: "IN/OUT label opacity",
    from: /(\.toolBodyRowLabel_[\w-]+\{[^}]*?)opacity:\.5/g,
    to: "$1opacity:.85",
  },
];

let touched = 0;
for (const root of roots) {
  if (!fs.existsSync(root)) continue;
  for (const dir of fs.readdirSync(root).filter((d) => d.startsWith("anthropic.claude-code-"))) {
    const css = path.join(root, dir, "webview", "index.css");
    if (!fs.existsSync(css)) continue;
    let text = fs.readFileSync(css, "utf8");
    const applied = [];
    for (const p of patches) {
      const next = text.replace(p.from, p.to);
      if (next !== text) applied.push(p.name);
      text = next;
    }
    if (applied.length) {
      fs.writeFileSync(css, text);
      touched++;
      console.log(`[patched] ${css}\n          ${applied.join(", ")}`);
    } else {
      console.log(`[ok]      ${css} (already patched or rules changed)`);
    }
  }
}
if (!touched) console.log("Nothing to patch.");
