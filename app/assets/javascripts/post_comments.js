$(function(){
    var mydialog;
    var comment_add_point;
    $('#post_comments_list').on('click','.edit_comment',function(evt){
        evt.preventDefault();
        var comment_id=$(this).attr('data-id');
        var handler="div#edit_comment_"+comment_id;
        comment_add_point=$(handler).parents('li');
        if (mydialog &&mydialog.dialog('isOpen')) {
              mydialog.dialog('close');

        }
        mydialog= $(handler).dialog({
            open: function(){
                var spinner=$('<div id="loading">');
                $(this).append(spinner);

                $("#loading").css({'top':($(this).height()-spinner.height())/2,'left': ($(this).width()-spinner.width())/2}).fadeIn('normal');
               $(this).load("/post_comments/"+comment_id+"/edit",function(){
                $('#loading').fadeOut('fast').remove();
                keditor= KindEditor.create('#comment_editor',
                    {"width":300,"height":50,"allowFileManager":true,"uploadJson":"/kindeditor/upload","fileManagerJson":"/kindeditor/filemanager"})
            }); },
            title: "修改" ,
            width:450,
            minHeight:100,
            beforeClose:function(){
                KindEditor.remove('#comment_editor');
            },
            close: function(){mydialog.empty()}

        })
    });
    $('body').on('ajax:beforeSend','#edit_comment_form',function(evt,xhr,setting){
        $(this).css({'visibility':'hidden'});
        var addpoint=$(this).parent();
        var spinner= $('<div id="loading">');

        addpoint.append(spinner.css({'display':'block','top':(addpoint.height()-spinner.height())/2,'left': (addpoint.width()-spinner.width())/2}));

    }).on('ajax:success','#edit_comment_form',function(evt,data,status,xhr){
         comment_add_point.html(xhr.responseText);
    }).on('ajax:complete','#edit_comment_form',function(evt,xhr,status){
            $('div#loading').fadeOut('fast');
            $(this).css({'visibility':'visible'});
             if(status=='success'){
                 $('div#loading').fadeOut('fast');
                 $(this).css({'visibility':'visible'});
                 mydialog.dialog('close');
             }
    } ).on('ajax:error','#edit_comment_form',function(evt,xhr,status,error){
            var $form = $(this),
                errors,
                errorText;

            try {
                // Populate errorText with the comment errors
                errors = $.parseJSON(xhr.responseText);
            } catch(err) {
                // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
                errors = {message: "请重试"};
            }

            // Build an unordered list from the list of errors
            errorText = "提交错误: \n<ul>";

            for ( error in errors ) {
                errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
            }

            errorText += "</ul>";

            // Insert error list into form
            $form.find('div.validation-error').html(errorText);
        });

     $('#post_comments_list,#comment_list').on('ajax:success','.delete_comment',function(evnt,data,status,xhr){
         $(this).parents('ul').remove();
     })
})
