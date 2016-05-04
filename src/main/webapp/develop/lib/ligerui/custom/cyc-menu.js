$(function(){
	/*总支撑左侧导航*/
	var MenuId=sessionStorage.getItem("MenuId");//获取MenuId
	setTimeout(function(){
		if(MenuId){
			var arr=MenuId.split(",")
			for(var i=0;i<arr.length;i++){
				$("a[data-find='"+arr[i]+"']").click();
				if(i>2){
					$("a[data-find='"+arr[2]+"']").closest("ul").find("ul").attr("style","")
				}

			}
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
					case 1:AClass="menu-tit1";IClass="a"+DataDO.data[i]['id'];break;//判断是否第一级菜单
					case 2:AClass="";IClass="me two";break;
					case 3:AClass="three";IClass="me ";break;
					default:AClass="";IClass="me";break;
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
			var Objcount='<ul class="menucyc"><li class="li first-tit"><i></i>导航栏菜单</li>'+ObjHtml+'</ul>'//初始化
			//$('body').html(Objcount);
			$(obj).html(Objcount);
			$(".menucyc").menu(".menucyc")
            if($("#form_login").length==0){
                $('.menucyc').bind('mousewheel', function(event, delta, deltaX, deltaY) {
                    $(".three").next("ul").hide();
                    $("#mCSB_1_container").css("overflow","hidden");
                    $("#mCSB_1").css("overflow","hidden");
                });
            }

		},
		menu:function(obj){
			var Obj=obj;
			var ObjCyc=$(this).find("a");
			ObjCyc.bind("click",function(){
				if(ObjCyc.attr("href")=="javascript:void(0);"){
					$(this).not(".three").addClass("on").next("ul").slideToggle();
					//$(this).closest("li").siblings("li").find("ul").slideUp();
					$(this).closest("li").siblings("li").find(".on").removeClass("on");
					if($(this).find("i.two") && $(this).closest("li").find("ul").length!=0){
						$(this).find("i.two").toggleClass("on")
					}
					var naval='';//面包屑
					var navalId=''//id
					if($(this).attr("data-url")){
						$("#contentPage").load($(this).attr("data-url"));
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
					//console.log()
				}
				if($(this).hasClass("three")){//第三级
					$(this).closest("li").siblings("li").find("ul").hide();
					$(this).addClass("on").next("ul").fadeIn();
					$("#mCSB_1_container").css("overflow","inherit");
					$("#mCSB_1").css("overflow","inherit");
				}
			})

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
	$("body").delegate(".menucyc> li","click",function(){
		//$(this).siblings().find("ul").slideUp()
	})
	//火狐banding
	//var scrollFunc=function(e){
	//	$(".three").next("ul").hide();
	//	$("#mCSB_1_container").css("overflow","hidden");
	//	$("#mCSB_1").css("overflow","hidden");
	//}
	///*注册事件*/
	//if(navigator.userAgent.indexOf('Firefox') >= 0){
	//	if($("#form_login").length==0){
	//		document.getElementsByClassName("l-layout")[0].addEventListener('DOMMouseScroll',scrollFunc,false);
	//	}//W3C
	//}
	if($("#form_login").length==0){
		//$(".l-layout")[0].onmousewheel = function(event) {
		//	$(".three").next("ul").hide();
		//	$("#mCSB_1_container").css("overflow","hidden");
		//	$("#mCSB_1").css("overflow","hidden");
		//};
		// jquery 兼容的滚轮事件

	}



})