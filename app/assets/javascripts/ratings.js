$(function(){

	 
	
	$('.auto-submit-star').rating({
		callback: function(value,link){
			var myid=$('#start_rating').data('id');
			var url=$('#start_rating').data('url');
			
			if(myid){
				$.ajax({url: url+'/'+myid,data: {rating: {value: value}},DataType:'json',type: 'PUT'});
			}else{
				$.post(url,{rating: {value:value}},function(data,status,xhr){
					$('#start_rating').data('id',data.id);

				});
			}
		}
	});
	
	$(document).on('pagecontainershow',function(e){
		$('.star').rating( );
		$('.auto-submit-star').rating({
			callback: function(value,link){
				var myid=$('#start_rating').data('id');
				var url=$('#start_rating').data('url');
			
				if(myid){
					$.ajax({url: url+'/'+myid,data: {rating: {value: value}},DataType:'json',type: 'PUT'});
				}else{
					$.post(url,{rating: {value:value}},function(data,status,xhr){
						$('#start_rating').data('id',data.id);

					});
				}
			}
		});
		
	});
})
	