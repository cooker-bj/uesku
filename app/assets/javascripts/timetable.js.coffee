$ ->
  pad = (n)->  if n<10 then "0#{n}" else n

  $('.date_picker').datepicker
    dateFormat: $.datepicker.ATOM
      
  $(document).on 'nested:fieldAdded',(e)->
    field= e.field
    dateField=field.find('.date_picker');
    if dateField.length >0
      dateField.datepicker
        dateFormat: $.datepicker.ATOM
      field.find('.class_title').val($('#title').html());
      field.trigger('create')

  $(document).on 'submit','form.new_timetable,form.edit_timetable',(e)->
    validate=true
    error_msg=''
    $('#class_times .class_time').each ->
      class_str = new Date($(this).find('.start_day').val())
      class_end = new Date($(this).find('.end_day').val())
      if class_str > class_end
        error_msg = "#{error_msg}上课开始日期应早于结束日期\n"
        validate=false
      start_hour = $(this).find('.start_time_hour').val()
      end_hour = $(this).find('.end_time_hour').val()
      start_minute= $(this).find('start_time_minute').val()
      end_minute= $(this).find('end_time_minute').val()
      if start_hour >= end_hour || start_minute > end_minute
        error_msg= "#{error_msg} 开始时间应小于结束时间\n"
        validate=false
    unless validate
        alert error_msg
        return false
      
  $('#timetable').fullCalendar
    header:
      left: 'prev,today title'
      center: ''
      right: 'month,agendaWeek,agendaDay next'
    events: $('#timetable').data('events')
    timeFormat: 'hh:mmt'
    handleWindowResize: true
    aspectRatio: 2
    buttonText: 
      today: '今天'
      day: '日'
      week: '周'
      month: '月'
    allDaySlot:false
  
  $('#edit_class_time').fullCalendar
    header: {
      left: 'prev, today title',
      center: '',
      right: 'month,agendaWeek,agendaDay next'
    },
    events: $('#edit_class_time').data('events'),
    timeFormat: 'hh:mmt',
    handleWindowResize: true,
    aspectRatio: 2,
    buttonText: {
      today: '今天',
      day: '日',
      week: '周',
      month: '月'
    },
    allDaySlot:false,
    eventClick: (event,jsevent,view)->
      $('#modify_class_time').on 'click','#remove_class_time',(e)->
        $.post 'remove_class_time',{class_time_id: event.id,start: event.start},(data,status,xhr)->
          window.location.href='/timetables/'+data.id
      $('#modify_class_time').on 'click','#change_class_time',(e)->
        $('#command_line').hide()
        $('#update_time_form').show()
      $('#update_time_form #event_id').val(event.id)
      $('#update_time_form #start').val(event.start)
      $('#update_time_form #start_day').val($.format.date(event.start.getTime(), "yyyy-MM-dd"))
      $('#update_time_form #start_time_hour').val(pad(event.start.getHours()))
      $('#update_time_form #start_time_minute').val(pad(event.start.getMinutes()))
      $('#update_time_form #end_time_hour').val(pad(event.end.getHours()))
      $('#update_time_form #end_time_minute').val(pad(event.end.getMinutes()))
      $('#modify_class_time').dialog
          open: (e,ui)->
            $('#update_time_form').hide()
          close: (e,ui)->
            $('#command_line').show()
            
  $(document).on 'pagebeforeshow',->
    $.mobile.activePage.find('.date_picker').datepicker
      dateFormat: $.datepicker.ATOM
    $.mobile.activePage.find('#class_table').css('width',$(window).width())
  
    $.mobile.activePage.find('#remove_event').click (e)->
      e.preventDefault()
      events=$.mobile.activePage.find('#events').data('events')
      array_id=$.mobile.activePage.find('#class_time_id').val()
      class_time_id=events[array_id].id
      start=events[array_id].start
      $.post 'remove_class_time',{class_time_id: class_time_id, start: start},(data,status,xhr)->
        $.mobile.back()
      
    $.mobile.activePage.find('#change_event_time').click (e) ->
      e.preventDefault()
      $.mobile.activePage.find('#remove_event').hide()
      $.mobile.activePage.find('#change_event_time').hide()
      events=$.mobile.activePage.find('#events').data('events')
      array_id=$.mobile.activePage.find('#class_time_id').val()
      event=events[array_id]
      $.mobile.activePage.find('#class_time_id').hide() 
      $.mobile.activePage.find('#events').append(JST["template/timetable/edit_calendar"](event: event))
      $.mobile.activePage.find('.date_picker').datepicker
        dateFormat: $.datepicker.ATOM
      $.mobile.activePage.find('#events').trigger('create')
      

       
          