(function(){
  fabric.BeerComboBox = beer.util.createClass(fabric.Group, {
    type: 'beerComboBox',
    initialize: function(objects, object) {
      this.bottle = beer.table.bottle;
      this.svg = _.first(objects)
      this.callSuper('initialize', objects, object);
      var svgUrl = '/images/combo-box.svg';

      if (!this.svg) {
        fabric.loadSVGFromURL(svgUrl, _.bind(function(objects) {
          var group = new fabric.Group(objects);
          this.set({ width: group.getWidth(), height: group.getHeight() })
          this.remove(this.svg);
          this.svg = group;
          this.add(this.svg);
          this.setCoords();
          var scaleX = this.getScaleX();
          var scaleY = this.getScaleY();
          var left = (-1 * (this.getWidth() / 2)) / scaleX;
          var top = (-1 * (this.getHeight() / 2)) / scaleY;
          group.set({ left: left, top: top });
          beer.napkin.canvas.renderAll();
        }, this), _.bind(function(item, object) {
          object.set('id', item.getAttribute('id'));
        }, this));
      }

      (new beer.CommonAssetEvents()).bind(this);
    },
    viewModel: function() {
      var obj = {};
      return obj;
    },
    bind: function() {
      //no-op
    }
  });

  fabric.BeerComboBox.fromObject = function (object, callback) {
    var _enlivenedObjects;
    fabric.util.enlivenObjects(object.objects, function (enlivenedObjects) {
      _enlivenedObjects = enlivenedObjects;
    });
    callback && callback(new fabric.BeerComboBox(_enlivenedObjects, object));
  };

  fabric.BeerComboBox.async = true;

  beer.assets.push(new beer.Asset({
    title: 'Combo Box',
    order: 1,
    Shape: fabric.BeerComboBox,
    name: 'combo-box',
    menuImage: '/images/combo-box.svg',
    createShape: function(bottle, napkin, done) {
      done(new fabric.BeerComboBox([], {  fill: beer.options.stroke_color }));
    }
  }));
})();
