/**
 * Created with JetBrains RubyMine.
 * User: cooker
 * Date: 4/13/13
 * Time: 10:44 PM
 * To change this template use File | Settings | File Templates.
 */
$(function() {


  function initMap(handler, options) {
    var opt = $.extend({
      level: 13 //初始地图视野级别
      //center:new MMap.LngLat(116.397428,39.90923),//设置地图中心点

    }, options || {});
    var attached = handler.attr('id');
    var mapObj = new AMap.Map(attached, opt);
    mapObj.plugin(["AMap.ToolBar", "AMap.OverView", "AMap.Scale"], function() {
      toolbar = new AMap.ToolBar();
      toolbar.autoPosition = false; //加载工具条
      mapObj.addControl(toolbar);
      overview = new AMap.OverView(); //加载鹰眼
      mapObj.addControl(overview);
      scale = new AMap.Scale(); //加载比例尺
      mapObj.addControl(scale);
    });
    handler.data('mapObj', mapObj);
    return handler;
  };

  function initMap_without_tools(handler, options) {
    var opt = $.extend({
      level: 10, //初始地图视野级别
      //center:new MMap.LngLat(116.397428,39.90923),//设置地图中心点
      //doubleClickZoom: true, //双击放大地图
      //scrollWheel: true //鼠标滚轮缩放地图
    }, options || {});
    var attached = handler.attr('id');
    mapObj = new AMap.Map(attached, opt);

    handler.data('mapObj', mapObj);
    return handler;
  };

  function clickPoint(handler, objx, objy) {
    var mapObj = handler.data('mapObj');
    var marker = handler.data("marker");
    mapObj.bind(mapObj, 'click', function(e) {
      objx.val(e.lnglat.lng);
      objy.val(e.lnglat.lat);
      if (marker) {
        marker.setPosition(e.lnglat);
      } else {
        marker = new AMap.Marker({
          id: 'mypoint',
          position: e.lnglat,
          icon: "http://code.mapabc.com/images/lan_1.png", //复杂图标
          offset: new AMap.Pixel(-7, -28), //相对于基点的偏移量
          visible: true
        })
        mapObj.addOverlays(marker);
        mapObj.setFitView(); //设置地图合适视野级别

      };
    });
    handler.data('mapObj', mapObj);
    handler.data('marker', marker);
    return handler;
  };

  function addPoint(handler, mid, location, msg) {
    var mapObj = handler.data('mapObj');
    var marker = new AMap.Marker({
      id: mid,
      position: location,
      icon: "http://code.mapabc.com/images/lan_1.png", //复杂图标
      offset: new AMap.Pixel(-7, -28), //相对于基点的偏移量
      visible: true
    })
    mapObj.addOverlays(marker);
    var infoWindow = new AMap.infoWindow({
      content: msg,
      offset: new AMap.Pixel(-106, -61)
    });
    mapObj.bind(marker, 'click', function(evnet) {
      inforWindow.open(mapObj, marker.getPosition());
    })
    handler.data('mapObj', mapObj);

  }


  function addOnePoint(handler, mid, location) {
    var mapObj = handler.data('mapObj');
    var marker = handler.data('marker');
    if (marker){
      marker.setPosition(location);

    }else{
    marker=new AMap.Marker({
      id: mid,
      position: location,
      icon: "http://code.mapabc.com/images/lan_1.png", //复杂图标
      offset: new AMap.Pixel(-7, -28), //相对于基点的偏移量
      visible: true
    });
  }
    mapObj.addOverlays(marker);
    mapObj.setFitView([marker]);
    mapObj.setZoom(14);
    handler.data('marker', marker);
    handler.data('mapObj', mapObj);
    return handler;
  };



  $("div#maped_list").each(function() {
    var handle = initMap($(this));
    $('div.course_items').each(function(n) {
      var mylng = $(this).attr('data-positionx');
      var mylat = $(this).attr('data-positiony');
      if (mylng && mylat) {
        var location = new AMap.Lnglat(mylng, mylat);
        var msg = $(this).find('.course_title').text() + '<br/>' + $(this).find('.company_name').text() + '<br/> 价格:' + $(this).find('.course_price').text() + '<br/> 推荐率:' + $(this).find('.course_rank').text();
        var mid = 'm' + n;
        addPoint(handler, mid, location, msg);
      }
    })
  })

  $('#mmap').each(function() {
    var handler = initMap($(this));
    handler = clickPoint(handler, $('#positionx'), $('#positiony'));
  });


   $(".course_map").each(function(id) {
    var handle = initMap_without_tools($(this));
    var mylng = $(this).attr('data-positionx');
    var mylat = $(this).attr('data-positiony');
    if (mylng && mylat) {
      var location = new AMap.LngLat(mylng, mylat);
      addOnePoint(handle, 'mm' + id, location);
    }
  });

  $("#lesson_map,.course_map").each(function(id) {
    var handle = initMap_without_tools($(this));
    var mylng = $(this).attr('data-positionx');
    var mylat = $(this).attr('data-positiony');
    if (mylng && mylat) {
      var location = new AMap.LngLat(mylng, mylat);
      addOnePoint(handle, 'mm' + id, location);
    }
  });

  $('.branch').each(function(id) {
    var mypoint = $(this).find(".mymap")
    if (mypoint.size() > 0) {
      var handler = initMap(mypoint);
      var px = $(this).find('.positionx').first();
      var py = $(this).find('.positiony').first();
      if (px.val() && py.val()) {
        var location = new AMap.LngLat(px.val(), py.val());
        handler = addOnePoint(handler, 'mm' + id, location);

      }
      getGeocode($(this), handler,"mm"+id);
      handler = clickPoint(handler, px, py);
    }
  });



  $('#add_branch').click(function() {
    var added = $("#new_branch ").children().clone()

    var myid = 'new_map' + Math.round(Math.random() * 100);
    var element = $("<div class='mymap set_point'>").attr("id", myid);

    $("#branches").append(added.append(element));
    var handler = initMap(element);
    handler = clickPoint(handler, added.find('.positionx'), added.find('.positiony'));
  });


  $("form").on('nested:fieldAdded', function(e) {
    var point = e.field.find('.mymap');
    var location = e.field.find('.positionx');
    var id_pattern = /[a-z|_]+_(\d+)_geolng$/i
    var newId = location.attr('id').match(id_pattern).pop();

    point.attr('id', "mmap" + newId)
    var handler = initMap(point);
    handler = clickPoint(handler, e.field.find('.positionx'), e.field.find('.positiony'));
    getGeocode(e.field, handler,'mypoint');
  });



  function getGeocode(position, handler,mid) {
    // set point in map by decoding address
    var MGeocoder;
    var callbackfn = function(data) {
      var noticePoint = position.find('.map_notice');
      var listItem;
      if (data.resultNum == 1) {
        noticePoint.html("定位" + data.geocodes[0].formattedAddress + "请检查地图的标志是否正确");
      } else {
        noticePoint.html("有多个位置匹配该地址， 请在列表中选择正确的项， 或在地图上标出位置");
        var addtml = $('<ul>');
        $.each(data.geocodes, function(index, p) {
          listItem = $('<li>').html(p.formattedAddress).data('location', p.location).on('click', function(event) {
            handler = addOnePoint(handler, mid, $(this).data('location'));
          });

          addtml.append(listItem);
        });
        noticePoint.append(addtml);
      }

      var location = data.geocodes[0].location
      var lat = location.getLat();
      var lng = location.getLng();
      position.find('.positiony').val(lat);
      position.find('.positionx').val(lng);
      handler = addOnePoint(handler, mid, location);


    }

    position.find('.address').on('change','.street', function(event) {
      var address = position.find('.province').find("option:selected").text() + position.find('.city').find("option:selected").text() + position.find('.district').find("option:selected").text() + position.find(".street").val();
      var mapObj = handler.data('mapObj');
      mapObj.plugin(["AMap.Geocoder"], function() {

        MGeocoder = new AMap.Geocoder();

        AMap.event.addListener(MGeocoder, "complete", callbackfn);
        MGeocoder.getLocation(address);
      });
    });
  }
})