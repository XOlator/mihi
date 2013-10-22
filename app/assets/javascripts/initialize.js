Handlebars.registerHelper('downcase', function(str) {return (str && str != '' ? str.toLowerCase() : '');});
Handlebars.registerHelper('matches', function(a,b) {return (a == b);});
Handlebars.registerHelper('simple_format', function() {
  var str = [], html = '', o = Array.prototype.pop.call(arguments);

  if (arguments.length > 0) {
    for (var i in arguments) {
      if (typeof(arguments[i]) == 'object') {
        for (var j in arguments[i]) str.push(o && o.fn ? o.fn(arguments[i][j]) : arguments[i][j]);
      } else {
        str.push(o && o.fn ? o.fn(arguments[i]) : arguments[i]);
      }
    }
  } else {
    str.push(o && o.fn ? o.fn(this) : '')
  }

  for (var i in str) {
    html += (str[i] && str[i] != '' ? ('<p>'+ ((str[i] +'').replace(/((\r)?\n){2,}/m, '</p><p>').replace(/(\r)?\n/m, '<br />')) +'</p>') : '');
  }

  return new Handlebars.SafeString(html);
});

jQuery.fn.preOn = function (t,d,fn) {
  return this.each(function () {
    jQuery(this).on(t,d,fn);
    var cur = jQuery._data(this, 'events')[t];
    if (jQuery.isArray(cur)) cur.unshift(cur.pop());
  });
};

var _root = {extend : function() {var src, copyIsArray, copy, name, options, clone, target = arguments[0] || {}, i = 1, length = arguments.length, deep = false;if ( typeof target === "boolean" ) {deep = target;target = arguments[1] || {};i = 2;}if ( typeof target !== "object" && !typeof target !== "function" ) target = {};if ( length === i ) {target = this; --i;}for ( ; i < length; i++ ) {if ( (options = arguments[ i ]) != null ) {for ( name in options ) {src = target[ name ];copy = options[ name ];if ( target === copy ) continue;if ( deep && copy && ( typeof copy === "object" || (copyIsArray = (typeof copy === "array")) ) ) {if ( copyIsArray ) {copyIsArray = false;clone = src && jQuery.isArray(src) ? src : [];} else {clone = src && typeof src === "object" ? src : {};}target[ name ] = MIHI.extend( deep, clone, copy );} else if ( copy !== undefined ) {target[ name ] = copy;}}}}return target;}};


var MIHI = function() {};
MIHI.fn = MIHI.prototype = {init : function() {}};
