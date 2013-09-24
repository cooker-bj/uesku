$(function(){
   // $('select#main_category').change(function(event){
   //     $('select#second_category').load("/admin/categories/select",{mid:$(event.target).val()},function(){
   /*         $('select#second_category').trigger('change');
        });

    });
    $('select#second_category').change(function(event){
        $('select#course_category_id').load("/admin/categories/select",{mid:$(event.target).val()})
    });*/
    function category()
      {$('div#course_category select:not(".fcategory")').change(function(event){
        $('div#course_category').load('/admin/categories/course_select',{mid:$(event.target).val()} ,category)
    }) };
    category();
  $("table#course_index input[type='checkbox']").change(function(e){
      var check=this.checked;
      var value=$(this).val();
      $.post("/admin/courses/recommendation",{checked: check,id: value})
  })
})