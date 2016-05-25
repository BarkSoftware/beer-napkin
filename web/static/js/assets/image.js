(function(){
  var AUTH_TOKEN = $("meta[name=csrf]").attr("content");
  var defaultImageUrl = "/images/placeholder.png";

  fabric.BeerImage = beer.util.createClass(fabric.Group, {
    type: 'beerImage',
    initialize: function(objects, object) {
      var objects = typeof objects !== 'undefined' ?  objects : [];
      var object = typeof object !== 'undefined' ?  object : {};
      var model = typeof object.model !== 'undefined' ?  object.model : {
        imageFilter: ''
      };
      this.model = { imageFilter: model.imageFilter };

      var img = objects[0];
      this.image = img;

      this.callSuper('initialize', objects, object);
      beer.napkin.canvas.renderAll();

      (new beer.CommonAssetEvents()).bind(this);
    },
    setFilter: function(filter) {
      if (this.image) {
        this.model.imageFilter = filter;
        this.image.filters.pop();
        var canvas = beer.napkin.canvas;
        if (filter === 'grayscale') {
          this.image.filters.push(new fabric.Image.filters.Grayscale());
        }
        this.image.applyFilters(canvas.renderAll.bind(canvas));
      }
    },
    viewModel: function() {
      var obj = {};
      obj['image-dropzone'] = {
        type: 'html',
        html: "<div class='dropzone'></div>",
      };
      obj['image-filters-header'] = { type: 'h5', label: 'Filters' };
      obj['image-filter'] = [
        { type: 'radio', label: 'None', value: '' },
        { type: 'radio', label: 'Grayscale', value: 'grayscale' }
      ];
      return obj;
    },
    toObject: function() {
      return _.merge(this.callSuper('toObject'), {
        model: this.model
      });
    },
    bind: function() {
      var updateImageUrl = _.bind(function(url) {
        this.image.setSrc(url, _.bind(function() {
          var width = this.image.getWidth();
          var height = this.image.getHeight();
          this.setWidth(width);
          this.setHeight(height);
          this.image.setLeft(-1 * (width / 2))
          this.image.setTop(-1 * (height / 2))
          beer.napkin.canvas.renderAll();
        }, this));
      }, this);
      $(".dropzone").dropzone({
        url: "/uploads",
        sending: function(file, xhr, formData) {
          formData.append("_csrf_token", AUTH_TOKEN);
        },
        maxFilesize: 2,
        maxFiles: 1,
        acceptedFiles: "image/*,.png,.jpg,.gif,.jpeg",
        init: function() {
          this.on("success", function(file, response) {
            updateImageUrl(response.url);
          });
        }
      });
      return Bind(this.model, {
        imageFilter: {
          dom: "input[name='image-filter']",
          callback: _.bind(this.setFilter, this),
        }
      });
    }
  });

  fabric.BeerImage.fromObject = function (object, callback) {
    fabric.util.enlivenObjects(object.objects, function (enlivenedObjects) {
      delete object.objects;
      callback && callback(new fabric.BeerImage(enlivenedObjects, object));
    });
  };

  fabric.BeerImage.async = true;

  beer.assets.push(new beer.Asset({
    title: 'Image',
    order: 1,
    Shape: fabric.BeerImage,
    name: 'image',
    svgUrl: null,
    menuImage: defaultImageUrl,
    menuImageWidth: 80,
    createShape: function(_bottle, _napkin, done) {
      fabric.Image.fromURL(defaultImageUrl, _.bind(function(img) {
        done(new fabric.BeerImage([img], {}));
      }));
    }
  }));
})();
