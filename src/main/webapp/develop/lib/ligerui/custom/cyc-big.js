//放大CYC TODO 20160701
$(function(){
    $("body").delegate("a.fangda","click",function(){
        var imgSrc=$(this).closest("li").find(".imgWrap img").attr("src");
        var htmlLayer;//要弹窗的 html

        if($(".cyc-layer.imgfada").length==0){
            var img = new Image();
            img.src =imgSrc;
            img.onload = function(){// 打印
                width=img.width;
                height=img.height;
                winWidth=window.innerWidth;
                winHeight=window.innerHeight;
                if(width>winWidth){
                    height=(winWidth/width)*height-20;
                    width=winWidth-20
                }
                if(height>winHeight){
                    width=(winHeight/height)*width-20;
                    height=winHeight-20;
                }
                htmlLayer='<div class="cyc-layer imgfada">'+
                    '<div class="img" style="width:'+width+'px;height:'+height+'px" data-type="0">'+
                    '<img src="'+imgSrc+'" style="width:'+width+'px;height:'+height+'px"/>'+
                    '</div>'+
                    '<div class="nav"><a href="javascript:void(0);" class="rotateLeft" title="逆时针旋转"></a><a href="javascript:void(0);" class="rotateRight" title="顺时针旋转"></a></div>'+
                    '</div>';
                $("body").append(htmlLayer)
            };

        }

    })
    $("body").delegate(".cyc-layer.imgfada","click",function(){
        $(this).remove();
    })
    $("body").delegate(".cyc-layer.imgfada .rotateLeft","click",function(e){

        e.stopPropagation();
        var obj=$(".cyc-layer.imgfada .img");
        var dataType=parseInt(obj.attr("data-type"))-1;

        $(".cyc-layer.imgfada .img").attr("data-type",dataType);
        obj[0].style.transform="rotate("+dataType*90+"deg)";
        obj[0].style.webkitTransform="rotate("+dataType*90+"deg)";
        obj[0].style.MozTransform ="rotate("+dataType*90+"deg)";

    })
    $("body").delegate(".cyc-layer.imgfada .rotateRight","click",function(e){
        e.stopPropagation();

        var obj=$(".cyc-layer.imgfada .img");
        var dataType=parseInt(obj.attr("data-type"))+1;
        $(".cyc-layer.imgfada .img").attr("data-type",dataType);
        obj[0].style.transform="rotate("+dataType*90+"deg)";
        obj[0].style.webkitTransform="rotate("+dataType*90+"deg)";
        obj[0].style.MozTransform ="rotate("+dataType*90+"deg)";
    })
})