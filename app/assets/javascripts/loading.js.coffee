$ ->
  $(document).on 'ajaxStart', (evt, xhr, setting)->
    addpoint = $('body.desktop')
    if addpoint.length >0
      spinner = if $('#loading').length>0 then $('#loading') else $('<div id="loading">')
      addpoint.append spinner.css
        'display': 'block',
        'top': ($(window).height() - spinner.height()) / 2
        'left': ($(window).width() - spinner.width()) / 2
  .ajaxComplete ->$('div#loading').fadeOut('fast');
    