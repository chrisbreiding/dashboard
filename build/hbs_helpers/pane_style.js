(function() {
  define(['lib/handlebars'], function(Handlebars) {
    return Handlebars.registerHelper('pane_style', function(properties) {
      return _.reduce(properties, function(style, property) {
        return style + ("" + property.name + ": " + property + ";");
      }, '');
    });
  });

}).call(this);