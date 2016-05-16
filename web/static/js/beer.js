var beer = beer || {
  version: "0.0.1",
  assets: [],
  options: {
    stroke_color: '#001966',
    background: { source: "/images/napkin.png", repeat: 'repeat' },
    fontFamily: 'Amatic SC',
    menu: {
      width: 200,
      height: $(window).height() - 80
    },
    napkin: {
      width: function() { return $(window).width() - 200 },
      height: function() { return $(window).height() - 61 },
    },
    bottle: {
      height: 80,
      width: $(window).width()
    }
  }
};
module.exports = beer;
