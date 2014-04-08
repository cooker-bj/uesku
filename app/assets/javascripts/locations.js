
$(function(){

    $('div#select_area input[type="radio"]').change(function(event){
        var checked_button=$(event.target).val();
        var options= $('div#add_options');
        var rootcontent=$('div#root_content');
        switch(checked_button){
            case "root":
              options.empty();
                break;
            case 'medium':
               options.html("省<select id='location_parent_id' name=location[parent_id]> </select>")
                    .find('#location_parent_id').append(rootcontent.children().clone());

                break;
            case 'leaves':
                options.html("省<select id='select_province' > </select> 市：<select id='location_parent_id' name=location[parent_id]> </select>")
                    .find('#location_parent_id').append($('div#second_content').children().clone()).end()
                    .find('#select_province').append(rootcontent.children().clone()).end().change(function(event){
                        $('#location_parent_id').load('/admin/locations/select',{mid: $('#select_province').val()})});
                break;

        }
    });
    $('div#select_area input:checked').trigger('change');
    var input_value=$('input#location_name').val();
    if (input_value) {
        $('div#select_area input').unbind('change');
    }

   $("form#new_course select#course_province_id").change(function(e){
       $("select#course_city_id").load('/admin/locations/select',{mid: $(this).val()},function(e){
           $("select#course_district_id").load("/admin/locations/select",{mid: $(this).val()});
       });
   });

    $("form#new_course select#course_city_id").change(function(e){
        $('select#courses_district_id').load("/admin/locations/select",{mid:$(this).val()});
    })

    $("div.address select:not('.district')").change(function(e){
      $.post("/locations/select",{mid: $(e.target).val()},function(data){
        var addpoint=$(e.target).next();
        addpoint.empty();
        $.each(data,function(index,value){
          addpoint.append($('<option>').attr('value',value.id).html(value.name));
        })
        addpoint.trigger('change');

      })
    })

})
