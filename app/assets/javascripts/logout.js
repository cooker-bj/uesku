$(function(){
    $('#logout').click(function(){
        $('<iframe src="https://mail.google.com/mail/u/0/?logout&hl=en">').onload(function(){
            alert("I loaded it")
        });
        return false;
    })
})
