/**
 * Created with JetBrains RubyMine.
 * User: cooker
 * Date: 4/13/13
 * Time: 10:44 PM
 * To change this template use File | Settings | File Templates.
 */
$(function(){


    function initMap(handler,options){
    var opt = $.extend({
        level:14,//初始地图视野级别
        //center:new MMap.LngLat(116.397428,39.90923),//设置地图中心点
        doubleClickZoom:true,//双击放大地图
        scrollWheel:true//鼠标滚轮缩放地图
    },options||{});
        var attached=handler.attr('id');
     var mapObj = new MMap.Map(attached,opt);
     mapObj.plugin(["MMap.ToolBar","MMap.OverView","MMap.Scale"],function()
    {
        toolbar = new MMap.ToolBar();
        toolbar.autoPosition=false; //加载工具条
        mapObj.addControl(toolbar);
        overview = new MMap.OverView(); //加载鹰眼
        mapObj.addControl(overview);
        scale = new MMap.Scale(); //加载比例尺
        mapObj.addControl(scale);
    });
        handler.data('mapObj',mapObj);
        return handler ;
    };

    function initMap_without_tools(handler,options){
        var opt = $.extend({
            level:14,//初始地图视野级别
            //center:new MMap.LngLat(116.397428,39.90923),//设置地图中心点
            doubleClickZoom:true,//双击放大地图
            scrollWheel:true//鼠标滚轮缩放地图
        },options||{});
        var attached=handler.attr('id');
        mapObj = new MMap.Map(attached,opt);

        handler.data('mapObj',mapObj);
        return handler ;
    };
    function clickPoint(handler,objx,objy){
        var mapObj=handler.data('mapObj');
        var marker=handler.data("marker");
         mapObj.bind(mapObj,'click',function(e){
        objx.val(e.lnglat.lng);
        objy.val(e.lnglat.lat);
        if(marker)
        {
            marker.setPosition(e.lnglat);
        } else
        {
            marker=new MMap.Marker({
                id: 'mypoint',
                position: e.lnglat,
                icon:"http://code.mapabc.com/images/lan_1.png",//复杂图标
                offset:new MMap.Pixel(-7,-28), //相对于基点的偏移量
                visible:true
            })
            mapObj.addOverlays(marker);
            mapObj.setFitView();//设置地图合适视野级别

        };
    });
        handler.data('mapObj',mapObj);
        handler.data('marker',marker);
        return handler;
     };

       function addPoint(handler,mid,location,msg){
           var mapObj=handler.data('mapObj');
           var marker=new MMap.Marker({
               id:mid,
               position:location,
               icon:"http://code.mapabc.com/images/lan_1.png",//复杂图标
               offset:new MMap.Pixel(-7,-28), //相对于基点的偏移量
               visible:true
           })
           mapObj.addOverlays(marker);
           var infoWindow=new MMap.infoWindow({
               content: msg,
               offset: new MMap.Pixel(-106,-61)
           });
           mapObj.bind(marker,'click',function(evnet){
               inforWindow.open(mapObj,marker.getPosition());
           })
           handler.data('mapObj',mapObj);

       }


        function addOnePoint(handler,mid,location) {
            var mapObj=handler.data('mapObj');
            var marker=new MMap.Marker({
                id:mid,
                position:location,
                icon:"http://code.mapabc.com/images/lan_1.png",//复杂图标
                offset:new MMap.Pixel(-7,-28), //相对于基点的偏移量
                visible:true
            })
            mapObj.addOverlays(marker);
            mapObj.setFitView([marker]);
            handler.data('marker',marker);
            handler.data('mapObj',mapObj);
            return handler;
        };


    $("div#maped_list").each(function(){
        var handle=initMap($(this));
        $('div.course_items').each(function(n){
            var location=new MMap.Lnglat($(this).attr('data-positionx'),$(this).attr('data-positiony'));
            var msg=$(this).find('.course_title').text()+'<br/>'+ $(this).find('.company_name').text()+ '<br/> 价格:'+$(this).find('.course_price').text()
            + '<br/> 推荐率:'+$(this).find('.course_rank').text();
            var mid='m'+n;
            addPoint(handler,mid,location,msg);
        })
    })

         $('#mmap').each(function(){
          var handler=initMap($(this));
          handler=clickPoint(handler,$('#positionx'),$('#positiony'));
         });


        $(".course_map").each(function(id){
            var handle=initMap($(this));
            var location=new MMap.LngLat($(this).attr('data-positionx'),$(this).attr('data-positiony'));
            addOnePoint(handle,'mm'+id,location);
        });

    $("#lesson_map").each(function(id){
        var handle=initMap_without_tools($(this));
        var location=new MMap.LngLat($(this).attr('data-positionx'),$(this).attr('data-positiony'));
        addOnePoint(handle,'mm'+id,location);
    });
       $('.branch').each(function(id){
           var mypoint=$(this).find(".mymap")
           if(mypoint.size()>0){
           var handler=initMap(mypoint);
           var px=$(this).find('.positionx').first();
           var py=$(this).find('.positiony').first();
           if(px.val()&& py.val()) {
             var location=new MMap.LngLat(px.val(),py.val());
             handler=addOnePoint(handler,'mm'+id,location);
           }
           handler=clickPoint(handler,px,py);
           }
       }) ;
    $('#add_branch').click(function(){
        var added=$("#new_branch ").children().clone()

        var myid='new_map'+Math.round(Math.random()*100);
        var element=$("<div class='mymap set_point'>").attr("id",myid);

        $("#branches").append(added.append(element) );
        var handler=initMap(element);
        handler=clickPoint(handler,added.find('.positionx'),added.find('.positiony'));
    });

})

