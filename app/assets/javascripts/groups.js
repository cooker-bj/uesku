$(function() {
    function loadposts(url) {
        var pid = $("div#post_list").attr('data-group-id');
        url = url || ("/groups/" + pid + "/posts");
        $("div#post_list").load(url, function(e) {
            $('div.pagination a').attr("data-remote", true).click(function(e) {
                e.preventDefault();
                loadposts($(this).attr('href'));
            })
        });
    };

    loadposts();

    $("#dylist").on("ajax:success", 'div#post_list', function(evt, data, status, xhr) {
        loadposts();
    });

    $("#new_post").on('ajax:beforeSend', function(evt, xhr, setting) {
        $(this).find('input[name="commit"]').prop('disabled',true);
        var spinner = $('<div id="loading">');
        $(this).append(spinner);

        $("#loading").css({
            'top': ($(this).height() - spinner.height()) / 2,
            'left': ($(this).width() - spinner.width()) / 2
        }).fadeIn('normal');
        $(this).find('#comment_area').fadeOut();

    }).on("ajax:success", function(evt, data, status, xhr) {
        window.location.replace(xhr.responseJSON.url);
    }).on("ajax:errors", function(evt, xhr, status, error) {
        var errors, errorText;
        $('#loading').fadeOut('fast').remove();
        $(this).find('#comment_area').fadeIn();
         $(this).find('input[name="commit"]').prop('disabled',false);
        try {
            erros = $.parseJSON(xhr.responseText);
        } catch (err) {
            errors = {
                msg: '请再试试'
            };
        }
        errorText = '有以下错误导致无法保存:\n<ul>';
        for (err in errors) {
            errorText += '<li>' + err + ':' + errors[err] + '</li>';
        }
        errorText += '</ul>';
        $("#errmsgs").html(errorText);
    });
    // edit post

    var mydialog;
    var post_add_point;
    var keditor;
    $('#edit_post').on('click',  function(evt) {
        evt.preventDefault();
        var post_id = $(this).attr('data-id');
        
        post_add_point = $(this).parents('li').find('.comment_content');
        if (mydialog && mydialog.dialog('isOpen')) {
            mydialog.dialog('close');

        }
        mydialog = $('<div>').dialog({
            open: function() {
                var spinner = $('<div id="loading">');
                $(this).append(spinner);

                $("#loading").css({
                    'top': ($(this).height() - spinner.height()) / 2,
                    'left': ($(this).width() - spinner.width()) / 2
                }).fadeIn('normal');
                $(this).load("/posts/" + post_id + "/edit", function() {
                    $('#loading').fadeOut('fast').remove();
                    keditor = KindEditor.create('#comment_editor', {
                        "width": 300,
                        "height": 50,
                        "allowFileManager": true,
                        "uploadJson": "/kindeditor/upload",
                        "fileManagerJson": "/kindeditor/filemanager"
                    })
                });
            },
            title: "修改",
            width: 450,
            minHeight: 250,
            beforeClose: function() {
                KindEditor.remove('#comment_editor');
            },
            close: function() {
                mydialog.empty();
            }

        })
    });
    $('body').on('ajax:beforeSend', 'form.edit_post', function(evt, xhr, setting) {
        $(this).css({
            'visibility': 'hidden'
        });
        var addpoint = $(this).parent();
        var spinner = $('<div id="loading">');

        addpoint.append(spinner.css({
            'display': 'block',
            'top': (addpoint.height() - spinner.height()) / 2,
            'left': (addpoint.width() - spinner.width()) / 2
        }));

    }).on('ajax:success', 'form.edit_post', function(evt, data, status, xhr) {
        post_add_point.html(keditor.html());
    }).on('ajax:complete', 'form.edit_post', function(evt, xhr, status) {
        $('div#loading').fadeOut('fast');
        $(this).css({
            'visibility': 'visible'
        });
        if (status == 'success') {
            $('div#loading').fadeOut('fast');
            $(this).css({
                'visibility': 'visible'
            });
            mydialog.dialog('close');
        }
    }).on('ajax:error', 'form.edit_post', function(evt, xhr, status, error) {
        var $form = $(this),
            errors,
            errorText;

        try {
            // Populate errorText with the comment errors
            errors = $.parseJSON(xhr.responseText);
        } catch (err) {
            // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
            errors = {
                message: "请重试"
            };
        }

        // Build an unordered list from the list of errors
        errorText = "提交错误: \n<ul>";

        for (error in errors) {
            errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
        }

        errorText += "</ul>";

        // Insert error list into form
        $form.find('div.validation-error').html(errorText);
    });




    //---------------------------------------------

    $(document).on('ajax:success',"div#pending_list", function(evt, data, status, xhr) {
        $(this).html(data);
    });
    $(document).on("ajax:success", "div#manager_list",function(evt, data, status, xhr) {
        $(this).html(data);
    });
    $(document).on("ajax:success", "div#query_member #query_name", function(evt, data, status, xhr) {
        $(this).siblings("div#query_result").html(data);

    });
    $(document).on("ajax:success", "div#query_result", function(evt, data, status, xhr) {
        $(this).html("");
        $(this).parent().siblings("div#manager_list").html(data);
    })
});