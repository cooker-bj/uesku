$(function(){
	function loadCompany(url){
		url=url||'/companies/select_company';
		$('#company_select_list').load(url,function(e){
			$('div.pagination a').attr("data-remote", true).click(function(e) {
                e.preventDefault();
                loadCompnay($(this).attr('href'));
            });
		});
	}
	loadCompany();

	$('.autocomplete').autocomplete({minlength: 2, source: '/query/query_companies_auto'});

	$('#query_form').on('ajax:success',function(e,data,status,xhr){
		$('#company_select_list').html(xhr.responseText);

	})
	
})