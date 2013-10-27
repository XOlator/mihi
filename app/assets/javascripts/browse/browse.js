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
  _playing : false,
  defaults : {
    event : [{action:'scroll',array:[0],timeout:10000}]
  },

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

    var sidebartimeout;

    // PAGINATION ONCLICK
    $('body').on('click', '#exhibition_piece_pagination .pagination a, #exhibition_pagination_tooltip a', function() {
      var pid = $(this).attr('data-exhibition_piece_id');
      MIHI.Browse.Current.pause();
      return MIHI.Browse.Current.page(pid);
    }).on('click', '#exhibition_navigate_previous a, #exhibition_navigate_next a', function() {
      var pid = $(this).attr('data-exhibition_piece_id');
      MIHI.Browse.Current.pause();
      return (pid != '' ? MIHI.Browse.Current.page(pid) : false);

    // PLAY BUTTON
    }).on('click', '#exhibition_piece_play_button', function() {
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
        MIHI.Browse.Current.pause();
        return false;
      }
    }).on('click', 'a[data-piece_event_index]', function() {
      var p = $(this).attr('data-piece_event_index');
      if (p && p != '') {
        MIHI.Browse.Current._event = parseInt(p);
        MIHI.Browse.Current.run();
        return false;
      }

    // SIDEBAR
    }).on('click', '#exhibition_piece_sidebar', function(e) {
      $(this).addClass('open');
      MIHI.Browse.Current.pause();
    }).on('mouseleave', '#exhibition_piece_sidebar', function(e) {
      var t = $(this);
      clearTimeout(sidebartimeout);
      sidebartimeout = setTimeout(function() {t.removeClass('open');}, 500);
    }).on('mouseenter', '#exhibition_piece_sidebar', function(e) {
      var t = $(this);
      clearTimeout(sidebartimeout);
      sidebartimeout = setTimeout(function() {t.addClass('open');}, 500);
    });

    // START THE SHOW! :D
    this.start();
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
    this.Render.information();
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
          if (t._playing) t.play(true);
        });

      } else {
        t.loaded();
        if (t._playing) t.play(true);
      }
      return true;
    }


    this.stop();
    return false;
  },

  play : function() {
    var p, t = this;
    if ((p = this.piece()) && p && p.piece) {
      var e = p.piece.events;
      if (!e || e.length == 0) e = t.defaults.event;
      if (e.length > this._event) {
        $('#exhibition_details').removeClass('open');
        $('#exhibition_piece_play_button').attr('data-status', 'playing');

        if (MIHI.Frame.Current.container().size() > 0) {
          MIHI.Frame.Current.container().ready(function() {
            setTimeout(function() { t.run(true); }, 10);
          });
        } else {
          t.run(true);
        }
      } else {
        this.next(true);
      }
      return true;
    }

    this.stop();
    return false;
  },

  next : function(play) {
    var p = this.page_next();

    this._event = 0;
    this._events_length = 0;
    this._events_timeat = 0;
    this._playing = (!!play);

    if (p) {
      this.page(p.id);
    } else {
      this.stop();
    }
  },
  previous : function(play) {
    var p = this.page_previous();

    this._event = 0;
    this._events_length = 0;
    this._events_timeat = 0;
    this._playing = (!!play);

    if (p) {
      this.page(p.id);
    } else {
      this.stop();
    }
  },

  run : function(play) {
    var t = this, p = this.piece();
    if (!p || !p.piece) return false;
    var e = p.piece.events, st = 0;
    if (!e || e.length == 0) e = t.defaults.event;

    MIHI.Frame.Current.process(e[this._event]);
    this._mark_trackbar_events();

    $.each(e, function(i,v) {
      if (i == t._event) return false;
      st += v.timeout;
    });

    var et = st + e[t._event].timeout+1,
        sp = (t._event == 0 ? 0 : ((st*100)/t._events_length)),
        ep = ((et*100)/t._events_length);

    $('#exhibition_piece_trackbar_durationbar').stop().css('right', (100-sp)+'%').animate({'right' : (100-ep)+'%'}, {
      duration : (et-st),
      easing: 'linear',
      complete : function() {
        t._events_timeat = et;
        t._mark_trackbar_events();
        if (e.length > (t._event+1)) {
          t._event++;
          if (!!play) t.play();
        } else {
          t.next(true);
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
    this._playing = false;
    return true;
  },

  stop : function() {
    clearTimeout(this._event_timeout);
    $('#exhibition_piece_play_button').attr('data-status', 'stopped');
    this._event = 0;
    this._events_length = 0;
    this._events_timeat = 0;
    this._playing = false;
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
      var html = HandlebarsTemplates['browse/comments']({count: 1, comments:this.parent.piece().comments});
      $('#exhibition_piece_comments').html(html);
    },

    description : function() {
      var piece = this.parent.piece(), obj = {title: piece.title, subtitle: '', description: (piece.piece ? piece.piece.description : '')};

      switch((piece.type || '').toLowerCase()) {
        case 'page':
          if (piece.piece) {
            if (piece.piece.year) obj.subtitle += piece.piece.year;
            if (piece.piece.urls && piece.piece.urls.original) obj.subtitle += (obj.subtitle != '' ? ', ' : '') +'<a href="'+ piece.piece.urls.original +'" target="_blank" title="'+ piece.piece.urls.original +'" class="to nw">'+ piece.piece.urls.original +'</a>';
            obj.subtitle = new Handlebars.SafeString(obj.subtitle);
          }
          break;
        case 'text':
          break;
      }

      $('#exhibition_description').html(HandlebarsTemplates['browse/description'](obj));
      $('#exhibition_details_close').on('click', function(e) {
        $('#exhibition_details').removeClass('open');
        return false;
      });
    },

    information : function() {
      var html = HandlebarsTemplates['browse/information']({exhibition: this.parent.exhibition()});
      $('#exhibition_information').html(html);
    },

    navigation : function() {
      var t = this, p = t.parent.piece(), html = HandlebarsTemplates['browse/navigation']({
        exhibition: t.parent.exhibition(), 
        piece:      p,
        prev_piece: null, // TODO
        next_piece: null  // TODO
      });
      $('#exhibition_navigation').html(html);

      $('#exhibition_navigate_exhibition').on('click', function(e) {
        $('#exhibition_details').toggleClass('open');

        if ($('#exhibition_details').hasClass('open') && p) {
          var n = $('#exhibition_details').find('a[data-exhibition_piece_id="'+ p.id +'"]');
          if (n) $('#exhibition_details').scrollTop(n.position().top);
        }

        t.parent.pause();
        return false;
      });
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

      if (!evts || evts.length < 1) evts = this.parent.defaults.event;

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