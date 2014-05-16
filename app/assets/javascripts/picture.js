$(function() {
  $('#fileupload').fileupload();
  $('#fileupload').on('fileuploaddone', function(e, data) {

    $.each(data.jqXHR.responseJSON.files, function(index, value) {
      $("<input type='hidden' class='jadded'>").attr('name', 'place[pictures][]').val(value.id).appendTo($('#pictures'));
    })

  }).on('fileuploaddestroy', function(e, data) {

    console.log('Processing ' + data.url.match(/pictures\/(\d+)/) + ' done.');
    $('input.jadded[value=' + data.url.match(/pictures\/(\d+)/)[1] + ']').remove();
  })


  // Initialize the jQuery File Upload widget:

  // 
  // Load existing files:
  $.getJSON($('#fileupload').prop('action'), {
    id: $('#fileupload').data('place'),
    class_name: $('#fileupload').data('name')
  }, function(files) {
    var fu = $('#fileupload').data('blueimp-fileupload'),
      template;
    fu._adjustMaxNumberOfFiles(-files.length);
    template = fu._renderDownload(files)
      .appendTo($('#fileupload .files'));
    // Force reflow:
    fu._reflow = fu._transition && template.length &&
      template[0].offsetWidth;
    template.addClass('in');
    $('#loading').remove();
  });

})