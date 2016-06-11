exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js",

      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      order: {
         before: [
           "web/static/js/vendor/bind.min.js",
           "web/static/js/github.js",
           "web/static/js/beer.js",
           "web/static/js/util.js",
           "web/static/js/layering.js",
           "web/static/js/undo_redo.js",
           "web/static/js/share.js",
           "web/static/js/common_asset_events.js",
           "web/static/js/napkin.js",
           "web/static/js/bottle.js",
           "web/static/js/menu.js",
           "web/static/js/table.js",
           "web/static/js/asset.js",
           "web/static/js/assets/button.js",
           "web/static/js/assets/checkbox.js",
           "web/static/js/assets/circle.js",
           "web/static/js/assets/combo_box.js",
           "web/static/js/assets/image.js",
           "web/static/js/assets/paragraph.js",
           "web/static/js/assets/radio.js",
           "web/static/js/assets/rectangle.js",
           "web/static/js/assets/text_input.js",
         ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css"
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true,
    // Whitelist the npm deps to be pulled in as front-end assets.
    // All other deps in package.json will be excluded from the bundle.
    whitelist: ["phoenix", "phoenix_html"]
  }
};
