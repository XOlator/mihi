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
    } catch(e) {}
    return false;
  },

  scroll : function(i) {
    this.frame('body').animate({scrollTop : i}, 500);
    // this.frame('body').animate({scrollTop : (this.frame('body').scrollTop()+i)}, 500);
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
  _event : null,
  _target : null,
  _position : 0,
  _timeout : null,
  _event_timeout : null,

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
    // PAGINATION TOOLTIP DISPLAY
    // var pagination_hover_timeout;
    // $('#exhibition_piece_pagination .pagination a').hover(function() {
    //   clearTimeout(pagination_hover_timeout);
    //   var tt = $('#exhibition_pagination_tooltip');
    //   tt.find('h6').html( $(this).text() );
    //   tt.find('a').attr('href', $(this).attr('href')).attr('data-exhibition_piece_id', $(this).attr('data-exhibition_piece_id'));
    //   tt.addClass('invis').show();
    //   var tth = tt.height(), pgt = $(this).offset().top, pgh = $(this).height(), ttt = Math.round(pgt-(tth/2)-(pgh/2));
    //   if (ttt < 0) ttt = 0;
    //   if (ttt+tth > $(window).height()) ttt = $(window).height()-tth
    //   // nipple position
    //   tt.css({'top' : ttt+'px'}).removeClass('invis');
    // }, function() {
    //   pagination_hover_timeout = setTimeout(function() {$('#exhibition_pagination_tooltip').hide();}, 250);
    // });
    // $('#exhibition_pagination_tooltip').hover(function() {
    //   clearTimeout(pagination_hover_timeout);
    // }, function() {
    //   pagination_hover_timeout = setTimeout(function() {$('#exhibition_pagination_tooltip').hide();}, 250);
    // });


    // PAGINATION ONCLICK
    $('#exhibition_piece_pagination .pagination a, #exhibition_pagination_tooltip a').on('click', function() {
      var pid = $(this).attr('data-exhibition_piece_id');
      $('#exhibition_pagination_tooltip').hide();
      $('#exhibition_piece_pagination .pagination li').removeClass('current');
      $('#exhibition_piece_pagination .pagination li a[data-exhibition_piece_id="'+ pid +'"]').parent().addClass('current loading');

      // TODO : LOAD NEXT PAGE
      // return false;
    });


    // PLAY BUTTON
    $('#exhibition_piece_play_button').on('click', function() {
      if ($(this).attr('data-status') == 'stopped') {
        MIHI.Browse.Current.play();
      } else {
        MIHI.Browse.Current.pause();
      }
      return false;
    });


    // START THE SHOW! :D
    this.start();
  },

  next : function() {
    
  },

  previous : function() {
    
  },

  load : function() {
    
  },

  loaded : function() {
    $('#exhibition_piece_pagination .loading').removeClass('loading');
    $('.piece_page .loading_page').addClass('hide');
    setTimeout(function() {$('.piece_page .loading_page').hide();}, 1000)
  },

  start : function() {
    this._event = 0;
    var p, t = this;
    if ((p = this.piece()) && p) {
      if (MIHI.Frame.Current.container().size() > 0) {
        MIHI.Frame.Current.container().load(function() {
          t.loaded();
          if (p.piece && p.piece.events && p.piece.events.length > t._event) {
            setTimeout(function() {
              MIHI.Frame.Current.process(p.piece.events[t._event]);
              t._event++;
            }, 510);
          }
        });

      } else {
        t.loaded();
      }
      return true;
    }

    this.stop();
    return false;
  },

  play : function() {
    var p, t = this;
    if ((p = this.piece()) && p) {
      if (p.piece && p.piece.events && p.piece.events.length > this._event) {
        MIHI.Frame.Current.container().ready(function() {
          setTimeout(function() {
            MIHI.Frame.Current.process(p.piece.events[t._event]);
            if (p.piece.events.length > (t._event+1)) {
              t._event_timeout = setTimeout(function() {t.play();}, (p.piece.events[t._event].timeout || 1)+1);
              t._event++;

            } else {
              setTimeout(function() {t.stop();}, 500);
              return false;
            }
          }, 10);
        });

        $('#exhibition_piece_play_button').attr('data-status', 'playing');
        return true;
      }
    }

    this.stop();
    return false;
  },

  pause : function() {
    clearTimeout(this._event_timeout);
    $('#exhibition_piece_play_button').attr('data-status', 'stopped');
    return true;
  },

  stop : function() {
    clearTimeout(this._event_timeout);
    $('#exhibition_piece_play_button').attr('data-status', 'stopped');
    this._event = 0;
    return true;
  }
});