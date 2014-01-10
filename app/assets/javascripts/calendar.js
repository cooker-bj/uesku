/**
 * Created by cooker on 1/10/14.
 */
$(function(){
    $('#calendar').fullCalendar({
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
            }
        }
    );
})
