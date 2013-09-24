$(function(){
    $('.recommend_items').click(function(){
        var id=$(this).attr('data-id');
        var url='/lessons/'+id;
        window.location.href=url;
    })
})
