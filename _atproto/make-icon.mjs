// One-time helper: rasterize ../assets/favicon.svg into a 512x512 icon.png for
// the Standard.Site publication card. Run with `npm run icon`; commit icon.png.
// Re-run only when the favicon changes.

import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { Resvg } from "@resvg/resvg-js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const svg = readFileSync(path.join(__dirname, "..", "assets", "favicon.svg"), "utf8");

const resvg = new Resvg(svg, {
  fitTo: { mode: "width", value: 512 },
  background: "#ffffff",
});
const png = resvg.render().asPng();

const out = path.join(__dirname, "icon.png");
writeFileSync(out, png);
console.log(`Wrote ${out} (${png.length} bytes).`);
