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
//= require jquery.xpath.min
//= require_tree .

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

MIHI.Share = function(p,u) {
  return this.open(p,u)
};
MIHI.Share.prototype = {
  _open : false,
  _open_intv : null,
  _open_url : null,

  open : function(p,url) {
    if (!p || p == '' || !url || url == '') return false;
    var t = this, w = 550, h = 600;

    switch(p) {
      case 'twitter':   h = 375; break
      case 'facebook':  w = 626; h = 436; break;
    }

    t._open_url = url;
    t._open = window.open(t._open_url,'_mihi_share','width='+w+',height='+h+',top='+ ((screen.height-h)/2) +',left='+((screen.width-w)/2));
    t._open.focus()
    t.track(p,'share')
    return this;
  },
  close : function() {
    clearInterval(this._open_intv);
    try {this._open.close()} catch(e) {}
  },
  track : function(p,o) {
    // console.log('Share Track:', p,o)
  }
};



MIHI.Frame = function() {}
MIHI.Frame.Current = MIHI.Frame.prototype = _root;
MIHI.Frame.Current.extend({
  _container : null,
  _frame : null,
  _initialized : false,

  container : function() {
    if (!this._container) this._container = jQuery('#exhibition_piece_iframe');
    return this._container;
  },

  offsite : function(url) {
    var t = this;
    $('#offsite_frame').remove();
    // TODO : Add close button
    $('body').append('<div id="offsite_frame" style=""><div id="offsite_frame_bg"></div><a href="javascript:;" id="offsite_frame_close"><i class="icon-remove"></i></a><div id="offsite_frame_container"><iframe src="'+ url +'" width="100%" height="100%" framespacing="0" frameborder="0"></iframe></div></div>');
    $('#offsite_frame_bg, #offsite_frame_container #offsite_frame_close').css({opacity: 0});
    $('#offsite_frame_bg, #offsite_frame_close').on('click', function() {t.close_offsite();})
    setTimeout(function() {$('#offsite_frame_bg').animate({'opacity':.8}, 500);}, 250);
    setTimeout(function() {$('#offsite_frame_container, #offsite_frame_close').animate({'opacity':1}, 500);}, 750);
    MIHI.Browse.Current._unloadable = false;
    $(window).on('keydown', this.keypress_close).focus();
  },
  
  keypress_close : function(e) {
    return ([27].indexOf(e.keyCode) >= 0 ? (MIHI.Frame.Current.close_offsite() && false) : true);
  },
  
  close_offsite : function() {
    $('#offsite_frame').animate({opacity: 0}, {duration: 500, complete : function() {$('#offsite_frame').remove();}});
    $(window).off('keypress', this.keypress_close);
    MIHI.Browse.Current._unloadable = true;
  },

  initialize : function() {
    var t = this;

    t.frame().find('a[href]').on('click', function(e) {
      var href = $(this).attr('href');
      if (href && href != '#' && !href.match(/^javascript\:/i) && href != '') {
        t.offsite(href);
        return false;
      }
      return true;
    }).preOn('click', function(e) {
      MIHI.Browse.Current._unloadable = true;
    });
    return (t._initialized = true);
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
        case 'click':
          return this.click(evt.array);
          break;
        case 'popup':
          return this.popup(evt.array, evt.text);
          break;
        case 'scroll':
          return this.scroll(evt.array);
          break;
        case 'scroll_to_element':
          return this.scrollToElement(evt.array);
          break;
      }
    } catch(e) {
      // console.error(e)
    }
    return false;
  },

  click : function(p) {
    var elm = this.find_element(p[0],p[1]);
    return (elm && elm.size() > 0 && elm.trigger('click'));
  },

  popup : function(p,t) {
    if (!p || !p[0]) return false;

    var elm = this.find_element(p[0],p[1]);
    if (elm && elm.size() > 0) {
      var o = elm.offset(), ey = o.top, ex = o.left;
      try {this.frame().find('#mihi_popup').remove();} catch(e) {}

      // TODO : FIXUP STYLE HERE
      this.frame('body').append('<div id="mihi_popup" style="opacity:0;position:absolute !important;z-index:999999 !important;width:300px !important; height:auto !important;background-color:#000 !important;color:#fff !important;"></div>');
      var b = this.frame().find('#mihi_popup');

      if (b && b.size() > 0) {
        b.css({'top' : ey+'px', 'left': (ex-30 > 0 ? (ex-30) : 0)+'px'}).html('<p style="margin:0 !important;padding:12px !important;">'+ t +'</p>');
        ey = ey-b.height()-10;
        if (ey < 0) ey = 0;
        b.css({'top' : ey+'px'}); // reset above
        // TODO : if at top of page, set below? damn hovers!
        this.frame(navigator.userAgent.match(/webkit/i) ? 'body' : 'html').animate(
          {scrollTop : ey, scrollLeft : ex},
          {duration: 500, complete: function() {b.animate({'opacity': 1}, 500);} }
        );
        return true;
      }
    }
    return false;
  },

  scroll : function(i) {
    if (!i || !i[0]) return false;
    this.frame(navigator.userAgent.match(/webkit/i) ? 'body' : 'html').animate({scrollTop : i[0]}, 500);
    return true;
  },

  scrollToElement : function(p) {
    if (!p || !p[0]) return false;
    var elm = this.find_element(p[0],p[1]);
    if (elm && elm.size()) {
      var o = elm.offset();
      this.frame(navigator.userAgent.match(/webkit/i) ? 'body' : 'html').animate({scrollTop : o.top, scrollLeft : o.left},500);
      // o.scrollTop(o.top).scrollLeft(o.left);
      return true;
    }
    return false;
  },

  find_element : function(e,m) {
    return (m && m == 'xpath' ? this.frame().xpath(e).first() : this.frame().find(e).first());
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
  _unloadable : true,

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
      return MIHI.Browse.Current.page(pid);
    });
    $('#exhibition_navigate_previous a, exhibition_navigate_next a').on('click', function() {
      var pid = $(this).attr('data-exhibition_piece_id');
      return (pid != '' ? MIHI.Browse.Current.page(pid) : false);
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

    // SHARE BOX
    $('a[data-share_box]').on('click', function() {
      var p = $(this).attr('data-share_box'), href = $(this).attr('href');
      if (p && p != '') {
        var s = new MIHI.Share(p,href);
        return false;
      }
    });

    // START THE SHOW! :D
    this.start();
  },

  next : function() {
    
  },

  previous : function() {
    
  },

  page : function(pid) {
    $('#exhibition_pagination_tooltip').hide();
    $('#exhibition_piece_pagination .pagination li').removeClass('current loading').find('i').addClass('icon-circle-blank').removeClass('icon-circle');
    $('#exhibition_piece_pagination .pagination li a[data-exhibition_piece_id="'+ pid +'"]').parent().addClass('current loading');
    $('#exhibition_piece_pagination .pagination li a[data-exhibition_piece_id="'+ pid +'"]').find('i').addClass('icon-circle').removeClass('icon-circle-blank');
    return true;
  },

  load : function() {
    
  },

  loaded : function() {
    $('#exhibition_piece_pagination .loading').removeClass('loading');
    $('.piece_page .loading_page').addClass('hide');
    setTimeout(function() {$('.piece_page .loading_page').hide();}, 1000)
  },

  unload_setup : function() {
    var t = this;
    $(window).on('beforeunload', function(e) {
      if (t._unloadable) return null;
      return 'Oh no, this preview page is trying to navigate away from this collection.';
    });

    $('a[href]').preOn('click', function() {MIHI.Browse.Current._unloadable = true;});

    if (MIHI.Frame.Current.container().size() > 0) {
      MIHI.Browse.Current._unloadable = false;
      MIHI.Frame.Current.container().load(function() {
        setTimeout(function() {MIHI.Browse.Current._unloadable = true;}, 2000);
      });
      setTimeout(function() {MIHI.Browse.Current._unloadable = true;}, 5000);
    }
  },

  start : function() {
    this._event = 0;

    this.unload_setup();

    var p, t = this;
    if ((p = this.piece()) && p) {
      if (MIHI.Frame.Current.container().size() > 0) {
        MIHI.Frame.Current.container().load(function() {
          MIHI.Frame.Current.initialize();
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