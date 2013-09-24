/**
 * Created with JetBrains RubyMine.
 * User: cooker
 * Date: 4/7/13
 * Time: 3:13 PM
 * To change this template use File | Settings | File Templates.
 */
$(function(){

    $('div#select_level input').change(function(event){
        var checked_button=$(event.target).val();
        switch(checked_button){
            case "root":
                $('div#add_options').empty();
                break;
            case 'medium':
                $('div#add_options').html("选择一级目录<select id='category_parent_id' name=category[parent_id]> </select>")
                    .find('#category_parent_id').append($('div#root_content').children().clone());

                break;
            case 'leaves':
                $('div#add_options').html("选择一级目录<select id='select_category' > </select> 选择二级目录：<select id='category_parent_id' name=category[parent_id]> </select>")
                    .find('#category_parent_id').append($('div#second_content').children().clone()).end()
                     .find('#select_category').append($('div#root_content').children().clone()).change(function(event){
                        $('#category_parent_id').load('/admin/categories/select',{mid: $('#select_category').val()})});
                break;

        }
    });
    $('div#select_level input:checked').trigger('change');
      var input_value=$('input#category_name').val();
      if (input_value) {
          $('div#select_level input').unbind('change');
      } ;



})
