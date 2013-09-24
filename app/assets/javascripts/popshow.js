$(function(){


    var methods = {
        open_right: function(event,handler){
            event.preventDefault();

            var pop = $(handler);
            var box = $(handler).parent().find('.right_box');



            if(box.css('display') == 'block'){
             /*   methods.close();  */
            } else {
                box.css({'display': 'block', 'top': (pop.height()-box.height())/2, 'left': (pop.width() )});
            }
        },

        close: function(){
            $('.right_box,.top_box').fadeOut("fast");
        },

        open_top: function(event,handler){
            var pop = $(handler);
            var box = $(handler).parent().find('.top_box');
            if(box.css('display')!='block') {
                box.css({'display': 'block','top': -box.height()-36, 'left': ((pop.width()/2) -(box.width()+12)/2 )})
            }
        }
    };

    $('body').on('mouseenter','.pop_show_right',function(e){
     methods.open_right(e,this);
    });
    $('body').on('mouseenter','.pop_show_top',function(e){
        methods.open_top(e,this);
    });

    $('body').on('mouseleave','.pop_show_right,.pop_show_top',function(e){
        methods.close();
    });

})