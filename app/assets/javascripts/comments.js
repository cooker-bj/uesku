$(function(){
    function loadComment(myurl){
        myurl=myurl||("/"+$("#comment_list").attr('data-type')+"/"+$("#comment_list").attr('data-id')+"/comments");
        $("#comment_list").load(myurl,function(e){
            $('div.pagination a').attr("data-remote",true).click(function(e){
                e.preventDefault();
                loadComment($(this).attr('href'));
            })



        } );
    };
    
    loadComment();

    $('#new_comment').on('ajax:success',function(evt,data,status,xhr){
        if(data.success) {
            loadComment();
            KindEditor.instances[0].html('');
            $('#errmsgs').html('');
        }
    }).on('ajax:error',function(evt,xhr,status,error){
        var errors,errorText;
        try{
            erros=$.parseJSON(xhr.responseText);
        }catch(err){
            errors={msg: '请再试试'};
        }
        errorText='有以下错误导致无法保存:\n<ul>';
        for(err in errors){
            errorText+='<li>'+err+':'+errors[err]+'</li>';
        }
        errorText+='</ul>';
        $("#errmsgs").html(errorText);
    })


     /*
    $('#new_comment').submit(function(e){
        if($("div#utility a[href $='sign_in']").size()!=0) {
            var dialog=$("<div>").dialog=$('<div id="box" >').dialog({

                open: function(){$(this).load("/users/sign_in",function(){
                    $("#new_user").bind("ajax:success",function(evt,data,status,xhr){
                        if(data.success){
                            $("div#utility").html('welcome'+data.user+' |<a href="/users/sign_out" data-method="delete" rel="nofollow">閫€鍑?/a> ') ;

                            dialog.dialog('close');
                            submitComment();
                        }else
                        {
                            $("p.notice").html(data.errors)
                        }
                    }) ;
                }) },
                title: 'Sign in '
            });
        }else{
            submitComment();
        }
    })  */
})

