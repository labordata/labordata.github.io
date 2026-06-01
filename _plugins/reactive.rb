# Reactive-cell Jekyll plugin.
#
# For any post with `reactive: true` in its front matter, this turns fenced
# ```js code blocks into live Observable reactive cells — the literate-notebook
# experience (cells re-run when their inputs change, display()/view()/Inputs/
# Plot all available) inside an ordinary _posts/ Markdown file.
#
# How: a pre_render hook pulls the ```js blocks out of the raw Markdown, sends
# their sources to a Node sidecar (_reactive/transpile.mjs) that runs Observable
# Notebook Kit's transpiler to infer each cell's reactive dependencies, then
# replaces the blocks with <div id="cell-N"> mount points and emits one
# <script type="module"> that wires the cells via the Observable runtime.
#
# NOTE: custom plugins require an unsafe Jekyll build (e.g. GitHub Actions),
# not the default GitHub Pages build.
require "json"
require "open3"

module Reactive
  # esm.sh resolves notebook-kit's bare-specifier deps (jsDelivr's raw /dist path
  # does not, so the browser can't load it from there).
  RUNTIME_CDN = "https://esm.sh/@observablehq/notebook-kit/runtime"
  SIDECAR = File.expand_path("../../_reactive/transpile.mjs", __FILE__)

  # match fenced ```js ... ``` blocks
  FENCE = /^```js\s*\n(.*?)\n```$/m

  def self.transpile(sources)
    out, err, status = Open3.capture3("node", SIDECAR, stdin_data: {cells: sources}.to_json)
    raise "reactive: transpile failed: #{err}" unless status.success?
    JSON.parse(out)["cells"]
  end

  def self.render_script(cells)
    defs = cells.map do |c|
      <<~JS
        define(
          {root: document.getElementById(`cell-#{c["id"]}`), expanded: [], variables: []},
          {
            id: #{c["id"]},
            body: #{c["body"]},
            inputs: #{c["inputs"].to_json},
            outputs: #{c["outputs"].to_json},
            output: #{c["output"].to_json},
            autodisplay: #{c["autodisplay"]},
            autoview: #{c["autoview"]},
            automutable: #{c["automutable"]}
          }
        );
      JS
    end.join("\n")

    <<~HTML
      <script type="module">
      import {define, main} from "#{RUNTIME_CDN}";
      import * as Plot from "https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm";
      import * as Inputs from "https://cdn.jsdelivr.net/npm/@observablehq/inputs/+esm";
      // Register Plot and Inputs as reactive variables so cells that reference
      // them resolve through the dependency graph (they aren't runtime builtins).
      main.variable().define("Plot", [], () => Plot);
      main.variable().define("Inputs", [], () => Inputs);
      #{defs}
      </script>
    HTML
  end
end

Jekyll::Hooks.register [:posts, :documents], :pre_render do |doc|
  next unless doc.data["reactive"]

  sources = []
  # replace each ```js block with a mount div, collecting sources in order
  doc.content = doc.content.gsub(Reactive::FENCE) do
    sources << Regexp.last_match(1)
    %(<div id="cell-#{sources.size - 1}" class="reactive-cell"></div>)
  end

  next if sources.empty?

  cells = Reactive.transpile(sources)
  # append the wiring script to the end of the post body
  doc.content += "\n\n" + Reactive.render_script(cells)
end
