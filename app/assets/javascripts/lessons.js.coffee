$ ->
  loadCompany= (url)->
    url ||= '/companies/select_company'
    $('#company_select_list').load url,(e)->
      $('div.pagination a').attr("data-remote",true).click (e)->
        e.preventDefault()
        loadCompany $(this).attr('href')
    
  loadCompany()
  $('.autocomplete').autocomplete {minlength:2, source: '/query/query_companies_auto'}
  $('#query_form').on 'ajax:success',(e,data,status,xhr)->$('#company_select_list').html xhr.responseText
  
  addFilter = (this_style,this_id,filters) ->
    switch this_style
      when 'category' 
        if filters.category then filters.category.push this_id else filters.category=[this_id]
      when 'district' 
        if filters.district then filters.district.push this_id else filters.district=[this_id]
      when 'age_range' then filters.age_range=this_id
      when 'rank_range' then filters.rank_range=this_id
      when 'free_try' then filters.free_try=this_id
    filters
    
  $(document).on 'click','.filter_item',(e)->
    style=$(this).data('style')
    value=$(this).data('id')
    filters={}
    duplicate=false
    $('.filter_box').each ->
      this_style=$(this).data('style')
      this_id=$(this).data('id')
      if style == this_style and value == this_id
        duplicate=true
        return false
      addFilter(this_style,this_id,filters)
    if duplicate
      return false
    addFilter(style,value,filters)
    params=$.param({filters: filters})
    $.get '/lessons',params,(data,status,xhr)->
      $('#main_content').html(data)
      
  $(document).on 'click','.filter_box',(e) ->
    style=$(this).data('style')
    value=$(this).data('id')
    filters={}
    $('.filter_box').each ->
      this_style=$(this).data('style')
      this_id=$(this).data('id')
      if style == this_style and value == this_id
        return true
      addFilter(this_style,this_id,filters)
    params=$.param({filters: filters})
    $.get '/lessons',params,(data,status,xhr)->
      $('#main_content').html(data)
        
        
          
      
  
    