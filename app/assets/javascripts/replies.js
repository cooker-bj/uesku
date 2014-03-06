$(function() {

    $("#comment_list").on('click', 'span.comment_commands a[href=""]', function(e) {
        e.preventDefault();
        $("<div>").html("请点击<a href='/users/sign_in'>登录</a>回复").dialog({
            modal: true
        });

    });
    $("#comment_list").on('click', '.comment_commands a[href="#"]', function(e) {
        e.preventDefault();
        var id = $(this).attr('data-msg_id');
        var selector = 'div[data-msg_id=' + id + ']';
        var addpoint = "#reply" + id;
        var handler = $(addpoint);
        if (handler.data('dialog'))
            handler.data('dialog').dialog("open");
        else {
            var dialog = $(selector).removeClass('undisplay').dialog({
                modal: true,
                height: 200,
                title: '回复'
            });

            $(addpoint).data('dialog', dialog);
        }
    });

    $("body").on("ajax:success", 'div.ui-dialog-content.ui-widget-content form#new_reply', function(evt, data, status, xhr) {
        var $form = $(this);
        var $cid = $(this).find("#reply_comment_id").val();
        $form.find('input[type="text"]').val("");
        var addpoint = "#reply" + $cid;
        $(addpoint).append(xhr.responseText);
    }).on("ajax:complete", 'div.ui-dialog-content.ui-widget-content form#new_reply', function(evt, status, xhr) {
        var $cid = $(this).find("#reply_comment_id").val();
        var addpoint = "#reply" + $cid;
        var handler = $(addpoint);
        var dialog = handler.data('dialog');
        dialog.dialog('close');
    })
    $('.user').on("mouseenter", ".pop_out", function() {
        var handler = $(this);
        var p = $(this).parent().position();
        var dp = [p.top, p.left + 10];
        if (handler.data('user')) {
            handler.data('user').diaglog('open')
        } else {
            var dialog = handler.removeClass('undisplay').diaglog({
                modal: true,
                position: dp
            });
            handler.data('user', dialog);
        }
    }).on('mouseleave', '.popout', function() {
        if ($(this).dialog('isOpen')) {
            $(this).dialog('close');
        }
    });
    $("#comment_list").on("ajax:success", ".delete_reply", function(evt, data, status, xhr) {
        $(this).parents('div.reply').remove();
    })
})