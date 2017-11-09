/*
 *cyc-menu.js 1.21
 *20160505
 *cyc
 *修复弹窗关闭BUG
 * */
$(function(){
    /*总支撑左侧导航*/

    var MenuId=sessionStorage.getItem("MenuId");//获取MenuId
    setTimeout(function(){
        if(MenuId){
            var arr=MenuId.split(",")
            for(var i=0;i<arr.length;i++){
                if(i==(arr.length-1)){//只触发一次事件
                    $("a[data-find='"+arr[i]+"']").click();
                }
                if(i>2){
                    $("a[data-find='"+arr[2]+"']").closest("ul").find("ul").attr("style","")
                }

            }
        } else {
            $('.menucyc').find("a.two").eq(0).trigger('click');
        }
    },500)

    $.extend({MenuInit:function(obj,data){
        $(obj).InitHmtl(obj,data);
    }})
    $.fn.extend({
        InitHmtl:function(obj,data){
            var ObjHtml="";//拼入部分
            var DataDO=data;
            for(var i=0;i<DataDO.data.length;i++){
                var Htmladd='';
                var AClass='';
                var iClass='';
                var url='';
                switch(DataDO.data[i]['level']){
                    case 1:AClass="menu-tit1 one";IClass="a"+DataDO.data[i]['id'];break;//判断是否第一级菜单
                    case 2:AClass="two";IClass="me two";break;
                    case 3:AClass="three";IClass="me ";break;
                    default:AClass="rignav";IClass="me";break;
                }
                if(DataDO.data[i]["url"]){
                    url=DataDO.data[i]["url"];
                }
                if(typeof(DataDO.data[i]['pid'])=='undefined'){
                    ObjHtml+='<li class="li" data-id="'+DataDO.data[i]["id"]+'"><a href="javascript:void(0);" class="'+AClass+'" data-url="'+url+'" title="'+DataDO.data[i]["text"]+'" data-find="'+DataDO.data[i]["id"]+'"><i class="'+IClass+'"></i>'+DataDO.data[i]["text"]+'</a><ul></ul></li>'
                }else{
                    var size=10*(DataDO.data[i]['level']-1);
                    /*if($(ObjHtml).find("li[data-id="+DataDO.data[i]['pid']+"]").length!=0){
                     size=20
                     }*/
                    ObjHtml=ObjHtml.substr(0,ObjHtml.length-size)+'<li class="li" data-id="'+DataDO.data[i]['id']+'"><a href="javascript:void(0);" class="'+AClass+'" data-url="'+url+'" title="'+DataDO.data[i]["text"]+'" data-find="'+DataDO.data[i]["id"]+'"><i class="'+IClass+'"></i>'+DataDO.data[i]['text']+'</a><ul></ul></li>'+ObjHtml.substr(ObjHtml.length-size,ObjHtml.length);
                }

            };
            ObjHtml=ObjHtml.replace(/<ul><\/ul>/g,'');//删除多余<UL></ul>
            var Objcount='<ul class="menucyc">'+ObjHtml+'</ul>'//初始化
            //$('body').html(Objcount);
            $(obj).html(Objcount);
            $(".menucyc").menu(".menucyc")
            if($("#form_login").length==0){
                $('.menucyc').bind('mousewheel', function(event, delta, deltaX, deltaY) {
                    $(".three").next("ul").hide();
                    /*$("#mCSB_1_container").css("overflow","hidden");
                     $("#mCSB_1").css("overflow","hidden");*/
                    $(this).closest("#mCSB_1_container").attr("class","mCSB_container mCS_y_hidden mCS_no_scrollbar_y")
                    $(this).closest("#mCSB_1").attr("class","mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside")
                    $("#div_main_content").find(">div:eq(0)").attr("class","l-layout-left mCustomScrollbar _mCS_1 mCS-autoHide mCS_no_scrollbar").css({"position":"relative","z-index":"0"})
                });
            }

        },
        menu:function(obj){
            var Obj=obj;
            var ObjCyc=$(this).find("a");
            ObjCyc.bind("click",function(){
                if($(this).attr("href")=="javascript:void(0);"){
                    if (parentOrder == '' || parentOrder == 'callChild') {

                        parentOrder = parentOrder == '' ? '' : 'openTab';

                        $(this).not(".three").addClass("on").next("ul").slideToggle();
                        //$(this).closest("li").siblings("li").find("ul").slideUp();
                        $(this).closest("li").siblings("li").find(".on").removeClass("on");
                        if($(this).find("i.two") && $(this).closest("li").find("ul").length!=0){
                            $(this).find("i.two").toggleClass("on")
                        }
                        var naval='';//面包屑
                        var navalId=''//id
                        if($(this).attr("data-url")){
                            $("#contentPage").load($(this).attr("data-url"), function () {
                                $("#contentPage").change();
                            });

                            //加ON
                            $(Obj).find(".on").removeClass("on");
                            $(this).addClass("on");
                            var thisobj=$(this).closest("ul");
                            while(thisobj.prev("a").length>0){
                                thisobj.prev("a").addClass("on");
                                thisobj=thisobj.prev("a").closest("ul");
                            }
                            $.each($(".menucyc a.on"),function(i,val){
                                naval+="<span>"+$(this).attr("title")+"</span> &gt; ";
                                navalId+=$(this).attr("data-find")+",";
                            })
                            naval=naval.substr(0,naval.length-5);
                            navalId=navalId.substr(0,navalId.length-1);
                            $("#span_nav_breadcrumb_content").html(naval).attr("data-sesson",navalId).find("span:nth-of-type(1)").addClass("strong")
                            $("#span_nav_breadcrumb_content").find("span:nth-last-of-type(1)").addClass("on");
                            sessionStorage.setItem("MenuId", navalId);
                            naval="";
                        }


                        if($(this).hasClass("three")){//第三级

                            $(this).closest("li").siblings("li").find("ul").hide();
                            $(this).addClass("on").next("ul").fadeIn();

                            $(this).closest("#mCSB_1_container").attr("class","")
                            $(this).closest("#mCSB_1").attr("class","")
                            $("#div_main_content").find(">div:eq(0)").attr("class","").css({"position":"relative","z-index":"100","width":"197px"})
                            var mscbTop=$(this).closest("#mCSB_1_container").css("top");
                            $(this).closest("#mCSB_1_container").css("top","mscbTop")
                            $(this).closest("#mCSB_1_container").attr("id","xmCSB_1_container");
                            setTimeout(function(){
                                $("#xmCSB_1_container").attr("id","mCSB_1_container");

                            },200)
                        }
                        if($(this).hasClass("rignav") &&$(this).attr("data-url")!="") {
                            $(".rignav").closest("ul").slideUp()
                        }
                        if($(this).hasClass("one")||$(this).hasClass("two")){
                            $(".rignav").closest("ul").slideUp()
                        }
                    } else if (ha.indexOf("#signin") >= 0 && parentOrder == 'openTab') {
                        var navalId = $(this).closest('.li').attr('data-id') + ',' + $(this).attr("data-find");
                        sessionStorage.setItem("MenuId", navalId);
                        window.parent.postMessage({
                            msg: 'openTab',
                            id: $(this).attr("data-find"),
                            name: $(this).attr("title")
                        }, '*');
                    }
                }

            });
        }
    })
    $(window).load(function(){
        $(".l-layout-left").mCustomScrollbar({
            theme:"dark", //主题颜色
            scrollButtons:{
                enable:true //是否使用上下滚动按钮
            },
            autoHideScrollbar: true, //是否自动隐藏滚动条
            scrollInertia :0,//滚动延迟
            horizontalScroll : false,//水平滚动条
            callbacks:{
                //onCreate:function(){console.log("onCreate")},
                //onInit:function(){console.log("onInit")},
                //onScrollStart:function(){console.log("onScrollStart")},
                //onScroll:function(){console.log("onScroll")},
                //onTotalScroll:function(){console.log("onTotalScroll")},
                //onTotalScrollBack:function(){console.log("onTotalScrollBack")},
                //whileScrolling:function(){console.log("whileScrolling")},
                //onOverflowY:function(){console.log("onOverflowY")},
                //onOverflowX:function(){console.log("onOverflowX")},
                //onOverflowYNone:function(){console.log("onOverflowYNone")},
                //onOverflowXNone:function(){console.log("onOverflowXNone")},
                //onImageLoad:function(){console.log("onImageLoad")},
                //onSelectorChange:function(){console.log("onSelectorChange")},
                //onBeforeUpdate:function(){console.log("onBeforeUpdate")},
                //onUpdate:function(){console.log("onUpdate")}
                //$("#mCSB_1_container").css("overflow","hidden");
                //$("#mCSB_1").css("overflow","hidden");
            }
        });

    });

})
