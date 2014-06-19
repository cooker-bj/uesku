$(function(){
    $('#tabs').tabs({selected:'0'});

    $('body').on('ajax:success','.add_friend',function(evt,data,status,xhr){
        alert("已向"+data.friend+"发出邀请");
    }).on('ajax:error','.add_friend',function(evt,xhr,status,error){
            var errors,
                errorText;

            try {
                // Populate errorText with the comment errors
                errors = $.parseJSON(xhr.responseText);
            } catch(err) {
                // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
                errors = {message: "请重试"};
            }

            // Build an unordered list from the list of errors
            errorText = "错误: \n<ul>";

            for ( error in errors ) {
                errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
            }

            errorText += "</ul>";

            // Insert error list into form
            alert(errorText)

        });

     $('#friends').on("ajax:success",'.friends_option',function(evt,data,status,xhr){
         $('#friends').html(xhr);
     })
     $('#query_user').on('click','#query_submit',function(event){
        $('#query_result').load('/query/query_users',{argm: $('#query_user input#argm').val()})
    });

     function readURL(input) {

    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#avatar').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#user_avatar").change(function(){
    readURL(this);
});
})
