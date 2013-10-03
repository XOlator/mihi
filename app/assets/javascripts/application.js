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


var MIHI = function() {};
MIHI.fn = MIHI.prototype = {init : function() {}};

MIHI.Frame = function() {}
MIHI.Frame.Current = MIHI.Frame.prototype = _root;
MIHI.Frame.Current.extend({
  _container : null,
  _frame : null,

  container : function() {
    if (!this._container) this._container = jQuery('#exhibition_piece_iframe');
    return this._container;
  },

  frame : function(f) {
    try {
      this._frame = this.container().contents();
      return (f ? this._frame.find(f) : this._frame);
    } catch(e) {return false;}
  },

  process : function(evt) {
    if (!this.frame() || !evt || !evt.action) return false;
    try {
      switch(evt.action) {
        case 'scroll':
          return this.scroll(evt.array[0]);
          break;
        case 'scroll_element':
          return this.scrollToElement(evt.array[0]);
          break;
      }
    } catch(e) {
      console.log(e)
    }
    return false;
  },

  scroll : function(i) {
    this.frame('body').scrollTop(this.frame('body').scrollTop()+i);
    return true;
  },

  scrollToElement : function(p) {
    var elm = this.frame.find(p);
    if (elm) {
      var o = elm.offset();
      o.scrollTop(o.top).scrollLeft(o.left);
      return true;
    }
    return false;
  }
})


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
  pieces : function(p) {
    if (p === true || p == 'current') p = this._piece;
    try {
      return (p && p != '' ? this.exhibition().pieces[p] : this.exhibition().pieces);
    } catch(e) {
      return null;
    }
  },
  piece : function(p) {if (p) this._piece = p; return this.pieces(this._piece);},
  events : function(e) {if (e) this._events = e; return this._events;},

  init : function() {
    var pagination_hover_timeout;

    $('#exhibition_piece_pagination .pagination a').hover(function() {
      clearTimeout(pagination_hover_timeout);

      var tt = $('#exhibition_pagination_tooltip');
      tt.find('h6').html( $(this).text() );
      tt.find('a').attr('href', $(this).attr('href')).attr('data-exhibition_piece_id', $(this).attr('data-exhibition_piece_id'));
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
    });

    $('#exhibition_piece_pagination .pagination a, #exhibition_pagination_tooltip a').on('click', function() {
      var pid = $(this).attr('data-exhibition_piece_id');
      $('#exhibition_pagination_tooltip').hide();
      $('#exhibition_piece_pagination .pagination li').removeClass('current');
      $('#exhibition_piece_pagination .pagination li a[data-exhibition_piece_id="'+ pid +'"]').parent().addClass('current loading');
      // TODO : LOAD NEXT PAGE
      // return false;
    });

    this.start();
  },

  next : function() {
    
  },

  previous : function() {
    
  },

  load : function() {
    
  },

  start : function() {
    var p;
    if ((p = this.piece()) && p) {
      if (p.piece && p.piece.events && p.piece.events.length > 0) {
        MIHI.Frame.Current.container().load(function() {
          setTimeout(function() {
            MIHI.Frame.Current.process(p.piece.events[0]);
          }, 10);
        });
      }
    }
  },

  play : function() {
    
  },

  pause : function() {
    
  },

  stop : function() {
  
  }
});