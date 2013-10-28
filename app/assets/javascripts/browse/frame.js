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
    $('body').append('<div id="offsite_frame" style=""><div id="offsite_frame_bg"></div><a href="javascript:;" id="offsite_frame_close"><i class="fa fa-remove"></i></a><div id="offsite_frame_container"><iframe src="'+ url +'" width="100%" height="100%" framespacing="0" frameborder="0"></iframe></div></div>');
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
    try {this.frame().find('.mihi_popup').animate({opacity: 0}, {duration: (evt.action.match(/^click/i) ? 1 : 150), complete: function() {$(this).remove();}});} catch(e) {}
    try {
      switch(evt.action) {
        case 'clickthrough':
          return this.clickthrough(evt.array);
          break;
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

  clickthrough : function(p) {
    var elm = this.find_element(p[0],p[1]);
    if (elm && elm.size() > 0) {
      MIHI.Browse.Current._unloadable = true;
      this.frame().get(0).location.href = elm.attr('href');
      return true;
    }
    return true;
  },

  click : function(p) {
    var elm = this.find_element(p[0],p[1]);
    if (elm && elm.size() > 0) {
      MIHI.Browse.Current._unloadable = true;
      return elm.trigger('click');
    }
    return true;
  },

  popup : function(p,t) {
    if (!p || !p[0]) return false;

    var elm = this.find_element(p[0],p[1]);
    if (elm && elm.size() > 0) {
      var o = elm.offset(), ey = o.top, ex = o.left, n = Math.floor(Math.random()*10000);

      // TODO : FIXUP STYLE HERE
      this.frame('body').append('<div class="mihi_popup" data-popup="'+ n +'" style="opacity:0;position:absolute !important;z-index:999999 !important;width:300px !important; height:auto !important;background-color:#000 !important;color:#fff !important;"></div>');
      var b = this.frame().find('.mihi_popup[data-popup="'+ n +'"]');

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
});