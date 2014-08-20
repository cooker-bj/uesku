element_in_scroll= (elem)->
  if $(elem)&& $(elem).size()>0
    docViewTop= $(window).scrollTop()
    docViewBottom= docViewTop+$(window).height()
    elemTop=$(elem).offset().top
    elemBottom=elemTop+$(elem).height()
    more_post_url=$.mobile.activePage.find('.pagination a.next_page').attr('href')
    if more_post_url && (elemBottom <= docViewBottom) && (elemTop >=docViewTop)
      $('.pagination').html("<img scr='assets/spinner.gif' alt='loading...'/>")
      $.ajax 
        url: more_post_url,
        beforeSend: (xhr)->
          xhr.setRequestHeader("Accept","text/javascript");
$ ->
  $(document).on 'pageinit',(e) ->
    $(document).on 'scroll',(event) ->
      switch
        when $.mobile.activePage.find("ul[data-role='listview'].lists_phone").length then element_in_scroll("ul[data-role='listview'].lists_phone li:last")
        when $.mobile.activePage.find('div#comment_list ul.comment_items_phone').length then element_in_scroll("div#comment_list ul.comment_items_phone li:last")
        when $.mobile.activePage.find('div#posts_list ul[data-role="listview"]').length then element_in_scroll("div#posts_list ul li:last")

        
      