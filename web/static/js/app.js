// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

window.beer = require("./beer")
var modules = [
  "util",
  "table",
  "menu",
  "napkin",
  "bottle",
  "undo_redo",
  "layering",
  "asset",
  "common_asset_events",
  "assets/button",
  "assets/checkbox",
  "assets/circle",
  "assets/combo_box",
  "assets/image",
  "assets/paragraph",
  "assets/radio",
  "assets/rectangle",
  "assets/text_input",
];
_.each(modules, function(m) {
  require("./" + m)
});

// not sure why this is needed to make Phoenix delete links work
$(function() {
  $("a[data-submit=parent]").click(function() {
    $(this).parent().submit();
  });
});
