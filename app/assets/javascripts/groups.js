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
