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
//= require handlebars.runtime
//= require_tree ./templates
//= require_tree .


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
MIHI.Frame.Current = MIHI.Frame.prototype = jQuery.extend(true, {}, _root);
MIHI.Frame.Current.extend({
  _container : null,
  _frame : null,
  _initialized : false,

  container : function() {
    if (!this._container) this._container = jQuery('#exhibition_piece_iframe');
    return this._container;
  },

  reset : function() {
    this._container = null;
    this._frame = null;
    this._initialized = false;
  },

  offsite : function(url) {
    var t = this;
    $('#offsite_frame').remove();
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
MIHI.Browse.Current = MIHI.Browse.prototype = jQuery.extend(true, {}, _root);
MIHI.Browse.Current.extend({
  _exhibition : null,
  _piece : null,
  _events : [],
  _pages : null,
  _event : null,
  _events_length : 0,
  _events_timeat : 0,
  _target : null,
  _position : 0,
  _timeout : null,
  _event_timeout : null,
  _unloadable : true,

  target : function(t) {if (t) this._target = t; return this._target;},
  exhibition : function(e) {if (e) {this.reset(); this._exhibition = e;} return $.extend(true, {}, this._exhibition);},
  pieces : function(p) {
    if (p === true || p == 'current') p = this._piece;
    try {
      return $.extend(true, {}, (p && p != '' ? this.exhibition().pieces[p] : this.exhibition().pieces));
    } catch(e) {
      return null;
    }
  },
  piece : function(p) {if (p) this._piece = p; return $.extend(true, {}, this.pieces(this._piece));},
  events : function(e) {if (e) this._events = e; return $.extend(true, {}, this._events);},
  reset : function() {
    this._exhibition = null;
    this._piece = null;
    this._events = [];
    this._pages = null;
    this._event = null;
    this._target = null;
    this._position = 0;
    this._timeout = null;
    this._event_timeout = null;
    this._unloadable = true;
  },

  init : function() {
    
    // Generate HTML
    this.load();

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

    $(window).on('popstate', function(e) {
      var s = e.originalEvent.state;
      if (s && s.exhibition && s.piece) {
        if (MIHI.Browse.Current.exhibition().id != s.exhibition.id) {
          alert('todo: reload new exhibition')
        } else if (MIHI.Browse.Current.piece().id != s.piece.id) {
          MIHI.Browse.Current.piece(s.piece.id);
          MIHI.Browse.Current.page(s.piece.id);
        }
      }
    });
    window.history.replaceState({exhibition:this.exhibition(), piece:this.piece()}, "", this.piece().urls.canonical);

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
    $('body').on('click', '#exhibition_piece_play_button', function() {
      if ($(this).attr('data-status') == 'stopped') {
        MIHI.Browse.Current.play();
      } else {
        MIHI.Browse.Current.pause();
      }
      return false;

    // SHARE BOX
    }).on('click', 'a[data-share_box]', function() {
      var p = $(this).attr('data-share_box'), href = $(this).attr('href');
      if (p && p != '') {
        var s = new MIHI.Share(p,href);
        return false;
      }
    }).on('click', 'a[data-piece_event_index]', function() {
      var p = $(this).attr('data-piece_event_index');
      if (p && p != '') {
        MIHI.Browse.Current._event = parseInt(p);
        MIHI.Browse.Current.run_event();
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
    $('#exhibition_piece_pagination .pagination li').removeClass('current loading');
    $('#exhibition_piece_pagination .pagination li a[data-exhibition_piece_id="'+ pid +'"]').parent().addClass('current loading');

    var t = this, p = t.piece(pid);
    t.set_piece_url();
    t.Render.new_piece();
    t.start();

    return false;
  },

  set_piece_url : function(pid) {
    var p = this.pieces(pid ? pid : true), n = this._unloadable;
    if (p && p.urls && p.urls.canonical && p.urls.canonical != location.href) {
      this._unloadable = true;
      window.history.pushState({exhibition: this.exhibition(), piece: p}, "", p.urls.canonical);
      this._unloadable = n;
    }
  },

  pages : function(flatten) {
    var t = this;

    if (!t._pages) {
      t._pages = [];

      $.each(t.exhibition().sections, function(i,s) {
        var x = {};
        $.each(s.exhibition_pieces, function(i,p) {
          x[p] = t.pieces(p);
          if (t._piece == p) x[p].current = true;
        });
        s.exhibition_pieces = x;
        t._pages.push(s);
      });
    }

    if (!!flatten) {
      var pg = [];
      $.each(t._pages, function(i,s) {
        $.each(s.exhibition_pieces, function(i,p) {
          var x = t.pieces(p.id);
          if (t._piece == p.id) x.current = true;
          pg.push(x)
        });
      });
    
      return pg;
    } else {
      return t._pages;
    }

  },

  page_previous : function(pid) {
    var p = null;
    if (!pid) pid = this.piece().id;
    $.each(this.pages(true), function(i,v) {
      if (v.id == pid) return false;
      p = v;
    });
    return p;
  },

  page_next : function(pid) {
    var p = null;
    if (!pid) pid = this.piece().id;
    $.each(this.pages(true).reverse(), function(i,v) {
      if (v.id == pid) return false;
      p = v;
    });
    return p;
  },


  load : function() {
    // Load framework HTML
    if ($('#browse_container').size() < 1) {
      var html = HandlebarsTemplates['exhibition']({});
      $('#content').html(html);
    }

    this.Render.parent = this;
    this.Render.navigation();
    this.Render.pagination();
    this.Render.new_piece();
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

  start : function(i) {
    this._event = parseInt(i && i != '' ? i : 0);
    this.unload_setup();

    var p, t = this;
    if ((p = this.piece()) && p) {
      MIHI.Frame.Current.reset();

      if (MIHI.Frame.Current.container().size() > 0) {
        MIHI.Frame.Current.container().load(function() {
          MIHI.Frame.Current.initialize();
          t.loaded();
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
          setTimeout(function() { t.run_event(true); }, 10);
        });

        $('#exhibition_piece_play_button').attr('data-status', 'playing');
        return true;
      }
    }

    this.stop();
    return false;
  },

  run_event : function(play) {
    var t = this, p = this.piece();
    if (!p) return false;

    MIHI.Frame.Current.process(p.piece.events[this._event]);
    this._mark_trackbar_events();

    var st = 0;
    $.each(p.piece.events, function(i,v) {
      if (i == t._event) return false;
      st += v.timeout;
    });

    var et = st + p.piece.events[t._event].timeout+1,
        sp = (t._event == 0 ? 0 : ((st*100)/t._events_length)),
        ep = ((et*100)/t._events_length);

    $('#exhibition_piece_trackbar_durationbar').stop().css('right', (100-sp)+'%').animate({'right' : (100-ep)+'%'}, {
      duration : (et-st),
      easing: 'linear',
      complete : function() {
        t._events_timeat = et;
        t._mark_trackbar_events();

        if (p.piece.events.length > (t._event+1)) {
          t._event++;
          if (!!play) t.play();
        } else {
          t.stop();
        }
      },
    });
  },
  _mark_trackbar_events : function() {
    var i = this._event;
    $('#exhibition_piece_trackbar_events a').removeClass('completed').each(function() {
      var id = $(this).attr('data-piece_event_index');
      if (id > i) return false;
      $(this).addClass('completed');
    });    
  },

  pause : function() {
    clearTimeout(this._event_timeout);
    $('#exhibition_piece_play_button').attr('data-status', 'stopped');
    $('#exhibition_piece_trackbar_durationbar').stop();
    return true;
  },

  stop : function() {
    clearTimeout(this._event_timeout);
    $('#exhibition_piece_play_button').attr('data-status', 'stopped');
    this._event = 0;
    this._events_length = 0;
    this._events_timeat = 0;
    return true;
  },


  Render : {
    new_piece : function() {
      this.piece();
      this.description();
      this.play_controls();
      this.trackbar();
      this.share()
      this.comments();
      $('#exhibition_navigation_buttons').html(HandlebarsTemplates['browse/navigation_buttons']({prev_piece : this.parent.page_previous(), next_piece : this.parent.page_next()}));
      return true;
    },
    
    comments : function() {
      // Comments : TODO REPLACE
      var html = HandlebarsTemplates['browse/comments'](this.parent.piece().comments);
      $('#exhibition_piece_comments').html(html);
    },

    description : function() {
      var piece = this.parent.piece(), obj = {title: piece.title, subtitle: '', description: (piece.piece ? piece.piece.description : '')};

      switch((piece.type || '').toLowerCase()) {
        case 'page':
          if (piece.piece) {
            if (piece.piece.year) obj.subtitle += piece.piece.year;
            if (piece.piece.urls && piece.piece.urls.original) obj.subtitle += (obj.subtitle != '' ? ', ' : '') + piece.piece.urls.original;
          }
          break;
        case 'text':
          break;
      }

      $('#exhibition_description').html(HandlebarsTemplates['browse/description'](obj));
    },

    navigation : function() {
      var html = HandlebarsTemplates['browse/navigation']({
        exhibition: this.parent.exhibition(), 
        piece:      this.parent.piece(),
        prev_piece: null, // TODO
        next_piece: null  // TODO
      });
      $('#exhibition_navigation').html(html);
    },

    pagination : function() {
      var html = HandlebarsTemplates['browse/pagination']({pagination: this.parent.pages()});
      $('#exhibition_pagination').html(html);
    },

    piece : function() {
      var obj = {piece : this.parent.piece()};
      
      // TODO, better title
      $('title').text(obj.piece.title);

      obj['piece_'+ (obj.piece.type || '').toLowerCase()] = true;
      $('#exhibition_piece_content').html(HandlebarsTemplates['browse/piece'](obj));
    },

    play_controls : function() {
      var obj = {piece : this.parent.piece()};
      obj['piece_'+ (obj.piece.type || '').toLowerCase()] = true;
      $('#exhibition_play_controls').html(HandlebarsTemplates['browse/play_controls'](obj));
    },

    share : function() {
      var e = this.parent.exhibition(), p = this.parent.piece(), 
          obj = {}, text = [], url = null, image = '';
      if (!p || !e) return;

      if (p.title && p.title != '') text.push(p.title);
      if (e.title && e.title != '') text.push(e.title);
      text = encodeURI(text.join(', '));

      if (p.urls) url = encodeURI(p.urls.canonical)
      if (!url && e.urls) url = encodeURI(e.urls.canonical)

      obj['twitter'] = {url: url, text: text};
      obj['facebook'] = obj['gplus'] = {url: url}
      if (image) obj['pinterest'] = {url: url, text: text, image: image};

      $('#exhibiton_piece_share').html(HandlebarsTemplates['browse/share'](obj));
    },

    trackbar : function() {
      var evts;
      try {evts = this.parent.piece().piece.events;} catch(e) {};

      if (!evts || evts.length < 1) {
        $('#exhibition_piece_trackbar').html('');
        return;
      }

      $('#exhibition_piece_trackbar').html(HandlebarsTemplates['browse/trackbar']({events: evts}));

      var l = 0, a = 0;
      $.each(evts, function(i,v) {l += v.timeout;});
      this.parent._events_length = l;
      this.parent._events_timeat = 0;

      $.each(evts, function(i,v) {
        $('#exhibition_piece_trackbar_event_'+ v.id).css('left', ((a*100)/l)+'%');
        a += v.timeout;
      });
    }
  }

});