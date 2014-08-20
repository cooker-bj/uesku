load_posts_phone= ->
  url ="/groups/#{$.mobile.activePage.find('#posts_list').attr('data-group-id')}/posts"
  loadpoint=$.mobile.activePage.find('#posts_list')
  if loadpoint.length >0 
    loadpoint.load url,->
      loadpoint.trigger 'create'
      
      
      
$ ->
  $(document).on 'ajax:success','div[data-role="content"] div#posts_list', (evt, data, status, xhr)->
    load_posts_phone()
    
    
    
  $(document).on 'pagebeforeshow', ->
    if $.mobile.activePage.find('#post_editor').length>0
      KindEditor.create '#post_editor',
                        'width': "100%",
                        'height': 300,
                        'allowFileManager' : true,
                        'uploadJson' : '/kindeditor/upload',
                        'fileManagerJson': 'kindeditor/filemanager',
                        'items':['fontname','fontsize','|','forecolor','hilitecolor','bold',"italic","underline","removeformat","|","justifyleft","justifycenter","justifyright","insertorderedlist","insertunorderedlist","|","emoticons","image","link"]
    
    load_posts_phone()
   
        
    