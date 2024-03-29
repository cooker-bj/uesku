$(function() {
    var timeout;
    var dialogs = [];

    function repeat() {
        var id = $('#short_message_message_group_id').val();
        $.get('short_messages/' + id + '/new_messages', function(respond, status, xhr) {
            $('.messages_area ul.list li:first').prepend(xhr.responseText);
            timeout = setTimeout(repeat, 30000);
        })

    };

    $('#messages_list .new_message').click(function(evt) {
        var users = $('#messages_list input:checkbox:checked').map(function() {
            return $(this).val()
        }).get();
        var title = $('#messages_list input:checkbox:checked').siblings('a').map(function() {
            return $(this).html()
        }).get();
        $('<div>').dialog({
            open: function(event, ui) {
                $(this).load("short_messages/new_message", {
                    'users[]': users
                }, function() {

                    repeat();
                })
            },
            close: function() {
                clearTimeout(timeout)
            },
            title: title,
            modal: true,
            maxHeight: 500,
            minWidth: 350,
            minHeight: 400,
            resizable: true,
            resize: function(event, ui) {
                $(".messages_area").css('max-height', ui.size.height - 120);
            }
        })
    });

    $(".message_item .message").on("ajax:success", function(evt, data, status, xhr) {

        var id = $(this).attr("id");
        var dialog = dialogs[id]
        if (dialog) {
            dialog.dialog("open");
        } else {
            dialogs[id] = $('<div>').dialog({
                title: $(this).html(),
                open: function(event, ui) {
                    $(this).html(xhr.responseText);
                    $(this).css('overflow', 'hidden');
                    //$(".messages_area").css('max-height', ui.size.height() - 120);
                    repeat();
                },
                beforeClose: function() {
                    clearTimeout(timeout);
                },
                modal: true,
                maxHeight: $(window).height() - 50,
                minWidth: 350,
                minHeight: 400,
                resizable: true,
                resize: function(event, ui) {
                    $(".messages_area").css('max-height', ui.size.height - 120);
                }


            })
        }
    });

   // $('body').on("ajax:complete", ".message_box", function(evt, data, status, xhr) {
    //    $(this).find('.messages_area ul li:first').prepend(xhr.responseText);
  //  });

    $('body').on("ajax:complete",".message_box", function(evt, xhr, status) {

        $(this).find('.messages_area ul li:first').prepend(xhr.responseText);
        $(this).find("input[type=text]#short_message_message,input[type=file]").val("");

        $(this).find("input.category").val(0);
        $(this).find("#choose,span#input_file").hide();

    });

    $("body").on('click', ".message_box #add", function() {
        $(this).siblings('#choose').show()
    });

    $("body").on('click', ".message_box #add_img,.message_box #add_audio", function() {
        var category = $(this).attr("data-type");
        $(this).parent().siblings("input.category").val(category);
        $(this).parent().siblings("span#input_file").show();
        $(this).parent().siblings("input[type=submit]").attr('disabled','disabled');
        $(this).parent().hide();

    });

    $('body').on("change", ".message_box input.media", function() {
        var img = /\.(jpg|png|gif)$/;
        var audio = /\.(wav|wma|mp3|mmf)$/;
        var category = $(this).parent().siblings("input.category").val();
        var file = $(this).val()
        if (category == 1) {
            if (file.match(img) != null) {
                $(this).parent().siblings("input[type=submit]").removeAttr('disabled');
            } else {
                alert("请选译图片文件")
            }
        } else if (category == 2) {
            if (file.match(audio) != null) {
                $(this).parent().siblings("input[type=submit]").removeAttr('disabled');
            } else {
                alert("请选择音频文件")

            }
        }
    });

    $("body").on('click', "#cancel", function() {
        $(this).parent().siblings("input.category").val(0);
        $(this).siblings('input[type=file]').val('');
        $(this).parent().siblings("input[type=submit]").removeAttr('disabled');
        $(this).parent().hide();
        $(this).parent().siblings("div#choose").hide();
    });

    $("body").on("ajax:success", "a.message_manage", function(evt, data, status, xhr) {
        var myid = $(this).attr("data-id");
        var dialog = dialogs[myid];
        if (dialog) {
            dialog.dialog("open");
        } else {
            dialogs[myid] = $("<div>").dialog({
                title: $(this).attr("data-title"),
                modal: true,
                open: function() {
                    $(this).html(xhr.responseText)
                }
            })
        };
    });

    $("body").on("click", "div#add_friends button", function() {
        var users = $(this).siblings("input:checkbox:checked").map(function() {
            return $(this).val()
        }).get()
        var id = $(this).attr("data-id");
        if (users.length != 0) {
            $.post("short_messages/add_users", {
                id: id,
                users: users
            }, function(data, status, xhr) {
                dialogs["manage_" + id].dialog("close");
            })
        }
    });

    $("body").on("click", "div#remove_users button", function() {
        var users = $(this).siblings("input:checkbox:checked").map(function() {
            return $(this).val()
        }).get()
        var id = $(this).attr("data-id");
        if (users.length != 0) {
            $.post("short_messages/remove_users", {
                id: id,
                users: users
            }, function(data, status, xhr) {
                dialogs["manage_" + id].dialog("close");
            })
        }
    });

})