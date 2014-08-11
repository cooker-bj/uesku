$(function(){

    $('#branches').on('click','.remove_branch',function(){
        $(this).parent().remove();
    })
    $("#branches").on('ajax:success',".delete_branch",function(){
        $(this).parent().remove();
    });
	
	/* -------------------------------
	this function is for infinite scroll page for phone view
	----------------------------------*/
	
	function element_in_scroll(elem){
		if($(elem)&& $(elem).size()>0){
			var docViewTop= $(window).scrollTop();
			var docViewBottom= docViewTop+$(window).height();
			var elemTop=$(elem).offset().top;
			var elemBottom=elemTop+$(elem).height();
			var more_post_url=$.mobile.activePage.find('.pagination a.next_page').attr('href');
			if (more_post_url && (elemBottom <= docViewBottom) && (elemTop >=docViewTop)){
				//$(document).off('scroll');
				$('.pagination').html("<img scr='assets/spinner.gif' alt='loading...'/>");
				$.ajax({
					url: more_post_url,
					beforeSend: function(xhr){
						xhr.setRequestHeader("Accept","text/javascript");
					}
				});
			
			}
		}
	}
	
	$(document).on('pageinit',function(e){
		$(document).scroll(function(e){
		
        if($.mobile.activePage.find("ul[data-role='listview'].lists_phone").length){
          element_in_scroll("ul[data-role='listview'].lists_phone li:last");
        }else if($.mobile.activePage.find('div#comment_list ul.comment_items_phone').length){
          element_in_scroll("div#comment_list ul.comment_items_phone li:last");
        }
     
			
		});
	});
})
