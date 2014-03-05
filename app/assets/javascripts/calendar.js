/**
 * Created by cooker on 1/10/14.
 */
$(function() {
    var build = [];
    var show =[];

    function replaceInputIds(nodes, perfix) {
        nodes.find('form').find('input').each(function() {
            $(this).attr('id', perfix + '_' + this.id);
        });

    }

    function getInputSelector(selector, perfix) {
        return ('input' + '#' + perfix + '_' + selector);

    }



    var newCalendarEvent = function(date, allDay, jsEvent, view) {
        var dialogId = date.getTime(); //当月视图的事件id与周视图和日视图的全天的slot id 相同
        if (build[dialogId]) {
            build[dialogId].dialog('open');
        } else {
            build[date.getTime()] = $('<div>').dialog({
                title: "新建事件",
                open: function() {
                    $(this).load('/calendar_events/new', function() {
                        replaceInputIds($(this), dialogId);
                        //modify  form id
                        $(this).find('form').each(function() {
                            $(this).attr('id', dialogId + '_' + this.id);
                        });



                        mySelector = function(selector) {
                            return getInputSelector(selector, dialogId);
                        }


                        $('.time_picker').timepicker({
                            closeText: '关闭',
                            currentText: '当前',
                            hourText: '小时',
                            minuteText: '分钟',
                            timeOnlyTitle: '选择时间',
                            timeText: '时间'
                        });

                        $('.date_picker').datepicker({
                            dateFormat: $.datepicker.ATOM
                        });

                        if (allDay) {
                            $(mySelector('calendar_event_all_day')).attr('checked', true);
                        } else {
                            $(mySelector('start_hour')).val($.format.date(date.getTime(), "HH:mm"));
                            $(mySelector('end_hour')).val($.format.date(date.getTime() + 30 * 60000, "HH:mm"));
                        }
                        $(mySelector('start_date')).val($.format.date(date.getTime(), "yyyy-MM-dd"));
                        $(mySelector('end_date')).val($.format.date(date.getTime(), "yyyy-MM-dd"));
                        $('#' + dialogId + '_' + 'new_calendar_event,' + '#' + dialogId + '_' + 'edit_calendar_event').submit(function(event) {
                            var mystart = $(this).find(mySelector("start")).val($(this).find(mySelector('start_date')).val() + ' ' + $(this).find(mySelector('start_hour')).val());
                            var my_end = $(this).find(mySelector("end")).val($(this).find(mySelector('end_date')).val() + ' ' + $(this).find(mySelector('end_hour')).val());
                            //validate
                            validate=false;
                            error_msg='';
                            var event_start = new Date(mystart.val().trim());
                            var event_end = new Date(my_end.val().trim());

                            if (event_start > event_end) {
                               error_msg=error_msg+'事件开始时间不能晚于结束时间\n'
                                validate=true;
                            }
                            if ($(mySelector('calendar_event_title')).val().trim()==''){
                                error_msg=error_msg+'事件标题不能为空\n';
                                validate=true;
                            }

                            if ($(mySelector('repeat')).checked && (isNaN(parseInt($(mySelector('repeat_params_time')).val()))|| isNaN(new Date($(mySelect('repeate_params_end_day')).val())))){
                                error_msg=error_msg+'重复事件的到期日期或重复次数不能同时为空\n';
                                validate=true;
                            }
                            if(validate){
                                alert(error_msg);
                                return false;
                            }

                        });
                        $(mySelector('calendar_event_repeat')).click(function() {
                            $('div#repeat_area').toggle();
                        });

                        $(this).one('ajax:success',function(event,data,status,xhr){
                            build[dialogId].dialog('close');
                            
                            $('#calendar_events').fullCalendar('addEventSource',data['events']);


                        });


                    });
                }
            });
        }
    };

    var showEvent=function(event,jsevent,view){
        var dialogId=event.realId;
        if (show[dialogId]){
            show[dialogId].dialog('open');
        }else{
            show[dialogId]=$('<div>').dialog({
                title: '事件详情',
                open: function(){
                    $(this).load(event.url,function(){
                        $(this).on('ajax:success','[id^="remove_"]',function(event,data,status,xhr){
                            $.each(data['events'],function(index,value){
                                $('#calendar_events').fullCalendar('removeEvents',function(eventObject){
                                    return eventObject['realId']==value['realId'];
                                })
                            });
                            show[dialogId].dialog('close');
                        });
                        $(this).on('ajax:success',"[id^='edit_']",function(event,data,status,xhr){
                            var local=$(this).parent(".show_window").html(xhr.responseText);
                            local.on('ajax:success',"form",function(event,data,status,xhr){
                                show[dialogId].dialog('close');
                            })
                        })

                    });
                }
            })
        }

        return false;

    }


    $('#calendar_events').fullCalendar({
        header: {
            left: 'prev, today title',
            center: '',
            right: 'month,agendaWeek,agendaDay next'
        },
        timeFormat: 'hh:mmt',
        handleWindowResize: true,
        aspectRatio: 1,
        buttonText: {
            today: '今天',
            day: '日',
            week: '周',
            month: '月'
        },
        events: $('#calendar_events').data('events'),
        dayClick: newCalendarEvent,
        eventClick: showEvent

    });

    $('form#new_calendar_event').submit(function(event) {
        var start = new Date($(this).find("input#start").val($(this).find('#start_date').val() + ' ' + $(this).find('#start_hour').val()));
        var end_slot = new Date($(this).find("input#end").val($(this).find('#end_date').val() + ' ' + $(this).find('#end_hour').val()));
        //check inputed values match our requirements
        var validate = true;
        if (start > end_slot) {
            validate = false;
            alert("开始时间必需早于结束时间");
        }
        return validate;

    });
    $('.time_picker').timepicker({
        closeText: '关闭',
        currentText: '当前',
        hourText: '小时',
        minuteText: '分钟',
        timeOnlyTitle: '选择时间',
        timeText: '时间'
    });


})