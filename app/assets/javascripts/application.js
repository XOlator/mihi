// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

var _root = {extend : function() {var src, copyIsArray, copy, name, options, clone, target = arguments[0] || {}, i = 1, length = arguments.length, deep = false;if ( typeof target === "boolean" ) {deep = target;target = arguments[1] || {};i = 2;}if ( typeof target !== "object" && !typeof target !== "function" ) target = {};if ( length === i ) {target = this; --i;}for ( ; i < length; i++ ) {if ( (options = arguments[ i ]) != null ) {for ( name in options ) {src = target[ name ];copy = options[ name ];if ( target === copy ) continue;if ( deep && copy && ( typeof copy === "object" || (copyIsArray = (typeof copy === "array")) ) ) {if ( copyIsArray ) {copyIsArray = false;clone = src && jQuery.isArray(src) ? src : [];} else {clone = src && typeof src === "object" ? src : {};}target[ name ] = MIHI.extend( deep, clone, copy );} else if ( copy !== undefined ) {target[ name ] = copy;}}}}return target;}};


/* tmp */
(function($) {
  $(document).ready(function() {
    var pagination_hover_timeout;

    $('#exhibition_piece_pagination .pagination a').hover(function() {
      clearTimeout(pagination_hover_timeout);

      var tt = $('#exhibition_pagination_tooltip');
      tt.find('h6').html( $(this).text() );
      tt.find('a').attr('href', $(this).attr('href'));
      tt.addClass('invis').show();
      var tth = tt.height(), pgt = $(this).offset().top, pgh = $(this).height(), ttt = Math.round(pgt-(tth/2)-(pgh/2));
      if (ttt < 0) ttt = 0;
      if (ttt+tth > $(window).height()) ttt = $(window).height()-tth
      // nipple position
      tt.css({'top' : ttt+'px'}).removeClass('invis');
    }, function() {
      pagination_hover_timeout = setTimeout(function() {$('#exhibition_pagination_tooltip').hide();}, 250);
    });

    $('#exhibition_pagination_tooltip').hover(function() {
      clearTimeout(pagination_hover_timeout);
    }, function() {
      pagination_hover_timeout = setTimeout(function() {$('#exhibition_pagination_tooltip').hide();}, 250);
    })
  });
})(jQuery);







var MIHI = function() {};
MIHI.fn = MIHI.prototype = {init : function() {}};


MIHI.Browse = function(piece,events) {
  if (piece) this._piece = piece;
  if (events) this._events = events;
};
MIHI.Browse.Current = MIHI.Browse.prototype = _root;
MIHI.Browse.Current.extend({
  _exhibition : null,
  _piece : null,
  _events : [],
  _target : null,
  _position : 0,
  _timeout : null,

  target : function(t) {if (t) this._target = t; return this._target;},
  exhibition : function(e) {if (e) this._exhibition = e; return this._exhibition;},
  piece : function(p) {if (p) this._piece = p; return this._piece;},
  events : function(e) {if (e) this._events = e; return this._events;},

  init : function() {
  
  },

  start : function() {
    
  },

  pause : function() {
    
  },

  stop : function() {
  
  }
});