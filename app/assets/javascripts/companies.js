$(function(){

    $('#branches').on('click','.remove_branch',function(){
        $(this).parent().remove();
    })
    $("#branches").on('ajax:success',".delete_branch",function(){
        $(this).parent().remove();
    })
})
