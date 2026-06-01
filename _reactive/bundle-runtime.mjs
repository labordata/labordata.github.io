#!/usr/bin/env node
// Bundle the Observable reactive runtime into a single self-hosted ESM file,
// so reactive posts have NO live third-party dependency at page-load time.
//
// Output: assets/js/reactive-runtime.js  (committed, served from our own domain)
// Exports: define, main (notebook-kit runtime) + Plot, Inputs (for cells to use)
//
// An esbuild alias swaps notebook-kit's inspect module for our DOM-aware one
// (_reactive/inspect.js), so display() of a string renders as plain text.
import {build} from "esbuild";
import {fileURLToPath} from "node:url";
import {dirname, join} from "node:path";

const here = dirname(fileURLToPath(import.meta.url));
const repo = join(here, "..");
const out = join(repo, "assets", "js", "reactive-runtime.js");

// the module notebook-kit uses for inspection, which we override
const realInspect = join(here, "node_modules", "@observablehq", "notebook-kit", "dist", "src", "runtime", "inspect.js");
const ourInspect = join(here, "inspect.js");

// a tiny entry that re-exports exactly what the plugin's generated script imports
const entry = `
export {define, main} from "@observablehq/notebook-kit/runtime";
export * as Plot from "@observablehq/plot";
export * as Inputs from "@observablehq/inputs";
`;

await build({
  stdin: {contents: entry, resolveDir: here, sourcefile: "reactive-entry.js", loader: "js"},
  bundle: true,
  format: "esm",
  outfile: out,
  minify: true,
  legalComments: "none",
  plugins: [{
    name: "swap-inspector",
    setup(b) {
      // notebook-kit's runtime/display.js and runtime/index.js import "./inspect.js";
      // redirect that to our DOM-aware version. Match the relative path "./inspect.js"
      // whose importer is inside notebook-kit's runtime dir (NOT @observablehq/inspector).
      b.onResolve({filter: /(^|\/)inspect\.js$/}, (args) => {
        if (/notebook-kit[\/\\]dist[\/\\]src[\/\\]runtime[\/\\]/.test(args.importer)) {
          return {path: ourInspect};
        }
      });
    },
  }],
});

console.log("wrote", out);
