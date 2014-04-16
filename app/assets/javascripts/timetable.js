/**
 * Created by cooker on 1/6/14.
 */
$(function(){
    var pad=function(n){
       return (n < 10) ? ("0" + n) : n;

    }

    $('.date_picker').datepicker({
        dateFormat: $.datepicker.ATOM
    });
    $('#class_times').on('nested:fieldAdded', function(e){
        var field= e.field
        var dateField=field.find('.date_picker');
        dateField.datepicker({
            dateFormat: $.datepicker.ATOM
        });
        field.find('.class_title').val($('#title').html());
    })

    $('form.new_timetable,form.edit_timetable').submit(function(e){

        var validate=true;
        var error_msg='';


        $('#class_times .class_time').each(function(){
            class_str=new Date($(this).find('.start_day').val());
            class_end=new Date($(this).find('.end_day').val());
            if(class_str>class_end){
                error_msg=error_msg+"上课开始日期应早于结束日期\n";
                validate=false;
            }


            start_hour=$(this).find('#timetable_class_times_attributes__start_time_hour').val();
            end_hour=$(this).find('#timetable_class_times_attributes__end_time_hour').val();
            start_minute=$(this).find('#timetable_class_times_attributes__end_time_minute').val();
            end_minute=$(this).find('#timetable_class_times_attributes__end_time_minute').val();
            if(start_hour>end_hour||start_minute>end_minute){
                error_msg=error_msg+"开始时间应小于结束时间\n";
                validate=false;;
            }
        });
         if(!validate){
             alert(error_msg);
             return false;
         }


    });

    $('#timetable').fullCalendar({
        header: {
            left: 'prev, today title',
            center: '',
            right: 'month,agendaWeek,agendaDay next'
        },
        events: $('#timetable').data('events'),
        timeFormat: 'hh:mmt',
        handleWindowResize: true,
        aspectRatio: 2,
        buttonText: {
            today: '今天',
            day: '日',
            week: '周',
            month: '月'
        },
        allDaySlot:false



    });
    
    $('#edit_class_time').fullCalendar({
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
        eventClick: function(event,jsevent,view){
            
            $('#modify_class_time').on('click','#remove_class_time',function(e){
                $.post('remove_class_time',{class_time_id: event.id,start: event.start},function(data,status,xhr){
                   window.location.href='/timetables/'+data.id;
                });
            })

            $('#modify_class_time').on('click','#change_class_time',function(e){
                $('#command_line').hide();
                $('#update_time_form').show();

            })

            $('#update_time_form #event_id').val(event.id);
            $('#update_time_form #start').val(event.start);
            $('#update_time_form #start_day').val($.format.date(event.start.getTime(), "yyyy-MM-dd"));
            $('#update_time_form #start_time_hour').val(pad(event.start.getHours()));
            $('#update_time_form #start_time_minute').val(pad(event.start.getMinutes()));
            $('#update_time_form #end_time_hour').val(pad(event.end.getHours()));
            $('#update_time_form #end_time_minute').val(pad(event.end.getMinutes()));

            $('#modify_class_time').dialog({
                open: function(e,ui){
                     $('#update_time_form').hide();
                },
                close: function(e,ui){
                    $('#command_line').show();
                }
            });
        }




    });


})