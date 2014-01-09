/**
 * Created by cooker on 1/6/14.
 */
$(function(){
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



})