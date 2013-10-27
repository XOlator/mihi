
//= require jquery.ui.draggable
//= require jquery.ui.sortable


(function($) {
  $(document).ready(function() {
    $('ul.sortable').each(function() {
      $(this).addClass('sortable').sortable({
        axis : 'y', 
        handle : '.drag',
        items: '> li:not(.new)',
        placeholder: "ui-state-highlight",
        containment : 'parent',
        update : function(e,ui) {
          var p = [], d = {}, n = $(this).attr('data-sortable_name'), u = $(this).attr('data-sortable_url');
          if (!n || !u || n == '' || u == '') {
            $(this).sortable('cancel');
            return false;
          }

          $(this).children('li').each(function(i,v) {
            p.push({id : $(v).attr('data-sortable_id'), sort_index : i});
          });

          if (p.length > 0) {
            d[n] = p;
            $.ajax({
              url : u, type : 'PUT', data : d,
              success : function(d,s,x) {
                if (d.success) {
                  // do nothing
                } else {
                  alert('An error has occurred with sorting this list. Please try again.')
                  $(this).sortable('cancel');
                }
              },
              error : function(x,s,e) {
                alert('An error has occurred with sorting this list. Please try again.');
                $(this).sortable('cancel');
              }
            });
          } else {
            alert('nah');
          }
        }
      });
    });
  });
})(jQuery);