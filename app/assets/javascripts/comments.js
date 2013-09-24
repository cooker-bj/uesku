$(function(){
    function loadComment(myurl){
        myurl=myurl||("/lessons/"+$("#comment_list").attr('data-lesson_id')+"/comment");
        $("#comment_list").load(myurl,function(e){
            $('div.pagination a').attr("data-remote",true).click(function(e){
                e.preventDefault();
                loadComment($(this).attr('href'));
            })



        } );
    };
    function submitComment(){
        $.post("/comments",$('#new_comment').serialize(),function(data,status,xhr){
            if(data.success){
                loadComment();
            }else
            {
                { var str="";
                    for(var error in data.errors){
                        str=str+error;
                        for (var value in data.errors[error])
                        {
                            str=str+data.errors[error][value];
                        }
                    }
                    $("#comment_error").html(str)
                }
            }
        })
    } ;
    loadComment();


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

