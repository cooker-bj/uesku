/**
 * Created by cooker on 1/6/14.
 */
$(function(){
    $('.date_picker').datepicker({
        dateFormat: $.datepicker.ATOM
    });

    $('form#new_timetable').submit(function(e){
        var start=new Date($(this).find('#timetable_start_day').val());
        var end_day=new Date($(this).find('#timetable_end_day').val());
        var validate=true;
        var error_msg='';
        if(end_day < start) {
            error_msg=error_msg+"结束日期必须晚于开始日期\n";
            validate=false;
        }

        $('#class_times .class_time').each(function(){
            class_str=new Date($(this).find('#timetable_class_times_attributes__start_day').val());
            class_end=new Date($(this).find('#timetable_class_times_attributes__end_day').val());
            if(class_str>class_end){
                error_msg=error_msg+"上课开始日期应早于结束日期\n";
                validate=false;
            }
            if(class_str<start || class_end>end_day){
                error_msg=error_msg+"上课开始日期不应早于整体开始时间或晚于整体结束时间\n";
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

    $('#class_times').on('click','.remove_class_time',function(){
        $(this).parent().remove();
    })
    $("#class_times").on('ajax:success',".delete_class_time",function(){
        $(this).parent().remove();
    });
    $("#add_new_class_time").click(function(e){
        var add_item=$('#new_class_time').children().clone(true);
        $('#class_times').append(add_item);
    })
})