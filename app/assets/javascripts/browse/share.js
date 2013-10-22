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