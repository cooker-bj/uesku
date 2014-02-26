$(function(){
    function loadposts(url){
    var pid=$("div#post_list").attr('data-group-id');
     url=url||("/groups/"+pid+"/posts");
    $("div#post_list").load(url,function(e){
        $('div.pagination a').attr("data-remote",true).click(function(e){
            e.preventDefault();
            loadposts($(this).attr('href'));
        })
    });
    };
    loadposts();
    $("#dylist").on("ajax:success",'div#post_list',function(evt,data,status,xhr){


           loadposts();


    });

    $("#new_post").on("ajax:success",function(evt,data,status,xhr){
        window.location.replace(xhr.responseJSON.url);
    }).on("ajax:errors",function(evt,xhr,status,error){
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

    $("div#pending_list").on('ajax:success',function(evt,data,status,xhr){
        $(this).html(data);
    });
    $("div#manager_list").on("ajax:success",function(evt,data,status,xhr){
        $("div#manager_list").html(data);
    }) ;
    $("div#query_member").on("ajax:success",'#query_name',function(evt,data,status,xhr){
       $("div#query_result").html(data);

    })  ;
    $("div#query_result").on("ajax:success",'a',function(evt,data,status,xhr){
        $("div#manager_list").html(data);
        $("div#query_result").html("");
    })
});
