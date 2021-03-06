/*
 *cyc-menu.js 1.21
 *20160505
 *cyc
 *修复弹窗关闭BUG
 * */
$(function(){
    /*总支撑左侧导航*/
    var isTrigger = false;
    var MenuId = sessionStorage.getItem("MenuId");//获取MenuId
    $.extend({MenuInit:function(obj,data){
        var lastData = data[data.length - 1];
        if (lastData['MenuId']) {
            MenuId = lastData['MenuId'];
        }
        $(obj).InitHmtl(obj,data);
    }})
    $.fn.extend({
        InitHmtl:function(obj,data){//初始化侧边栏
            var menuData = data, html = '', me = this;
            $.each(menuData, function (key, object) {
                var pid = '', htm = '';
                if (object.level == 1) {
                    pid = object.id;
                    $.each(menuData, function (ke, obj) {
                        var p = '', h = '';
                        if (obj.pid == pid) {
                            p = obj.id;
                            $.each(menuData, function (k, o) {
                                if (o.pid == p) {
                                    h += ['<li class="li" id="' + o.id + '" data-id="'+ o.id +'">',
                                        '<a href="javascript:void(0);" class="last-a has-url" data-url="'+
                                        (o.url ? o.url : '') +
                                        '" title="'+ o.text +
                                        '" data-find="'+ o.id +'" data-pid="' + pid + ',' + p + '">',
                                        '<i class="last-icon"></i>'+ o.text +'</a><ul></ul></li>'].join('');
                                }
                            });
                            htm += ['<li class="li" id="' + obj.id + '" data-id="'+ obj.id +'">',
                                '<a href="javascript:void(0);" class="active ' + (h != '' ? 'has-child' : 'has-url no-child') + '" data-url="'+
                                (obj.url ? obj.url : '') +
                                '" title="'+ obj.text +
                                '" data-find="'+ obj.id +'" data-pid="' + pid + '">',
                                 obj.text +'<i class="' + (h != '' ? 'has-icon' : 'none-icon') + '"></i>'+'</a><ul style="display: block">'].join('');
                            htm += h + '</ul></li>';
                        }
                    });html += ['<li class="li" id="' + object.id + '" data-id="'+ object.id +'">',
                                '<a href="javascript:void(0);" class="first-a active" data-url="'+
                                (object.url ? object.url : '') +
                                '" title="'+ object.text +
                                '" data-find="'+ object.id +'" data-pid="">',
                                    ''+ object.text + (htm != '' ? '<span class=" icon-jt"></span>' : '<span class="none-icon-jt"></span>') + '</a><ul style="display: block">'].join('');
                    html+= htm + '</ul></li>';
                }
            });
            //大数据中心
            // var ndnndn='<li class="li" id="1024" data-id="1024"><a href="javascript:void(0);" class="first-a on" data-url="/ehr/resourceBrowse/dataCenterIndex" title="数据资源中心" data-find="1024" data-pid=""><i class="menu-tit1 one"></i>数据资源中心<span class="none-icon-jt"></span></a><ul style="display: none"></ul></li><li class="li" id="727" data-id="727"><a href="javascript:void(0);" class="first-a" data-url="/ehr/resourceBrowse/customQuery" title="综合查询" data-find="727" data-pid="">综合查询<span class="none-icon-jt"></span></a><ul style="display: none"></ul></li><li class="li" id="761" data-id="761"><a href="javascript:void(0);" class="first-a" data-url="/ehr/resourceBrowse/dataCenter" title="数据存储分析" data-find="761" data-pid="">数据存储分析<span class="none-icon-jt"></span></a><ul style="display: none"></ul></li>'
            //医疗资源管理
            // var ndnndn='<li class="li" id="148" data-id="148"><a href="javascript:void(0);" class="first-a active on" data-url="" title="医疗资源管理" data-find="148" data-pid="">医疗资源管理<span class=" icon-jt"></span></a><ul style="display: block"><li class="li" id="227" data-id="227"><a href="javascript:void(0);" class="active has-url no-child on" data-url="/ehr/organization/initial" title="机构管理" data-find="227" data-pid="148">机构管理<i class="none-icon"></i></a><ul style="display: block"></ul></li><li class="li" id="986" data-id="986"><a href="javascript:void(0);" class="active has-url no-child" data-url="/ehr/org/healthCategory/index" title="卫生机构类别" data-find="986" data-pid="148">卫生机构类别<i class="none-icon"></i></a><ul style="display: block"></ul></li><li class="li" id="420" data-id="420"><a href="javascript:void(0);" class="active has-url no-child" data-url="/ehr/doctor/initial" title="卫生人员" data-find="420" data-pid="148">卫生人员<i class="none-icon"></i></a><ul style="display: block"></ul></li><li class="li" id="1048" data-id="1048"><a href="javascript:void(0);" class="active has-url no-child" data-url="/ehr/device/initial" title="医疗设备管理" data-find="1048" data-pid="148">医疗设备管理<i class="none-icon"></i></a><ul style="display: block"></ul></li></ul></li>';
            // $(obj).html('<ul class="menucyc">'+ndnndn+html +'</ul>');
            $(obj).html('<ul class="menucyc">'+ html +'</ul>');
            $(".menucyc").menu(".menucyc")
            if($("#form_login").length==0){
                $('.menucyc').bind('mousewheel', function(event, delta, deltaX, deltaY) {
                    $(".three").next("ul").hide();
                    $(this).closest("#mCSB_1_container").attr("class","mCSB_container mCS_y_hidden mCS_no_scrollbar_y")
                    $(this).closest("#mCSB_1").attr("class","mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside")
                    $("#div_main_content").find(">div:eq(0)").attr("class","l-layout-left mCustomScrollbar _mCS_1 mCS-autoHide mCS_no_scrollbar").css({"position":"relative","z-index":"0"})
                });
            }
            me.clickSessionId();
        },
        clickSessionId: function () {
            var $a = [];
            if(MenuId){
                $a = $("a[data-find='" + MenuId + "']");
                if ($a.length > 0) {
                    $("a[data-find='" + MenuId + "']").click();
                    return;
                }else{
                    debugger
                    MenuId="";
                    var ObjCyc=$(this).find("a");
                    if(!MenuId){
                        var $url=ObjCyc.closest("a").attr("data-url");
                        if($url){
                            MenuId=ObjCyc.closest("a").attr("data-find");
                            sessionStorage.setItem("MenuId",MenuId );
                            this.clickSessionId();
                        }
                    }
                }
            }
            $('.menucyc').find('.has-url').eq(0).trigger('click');
        },
        menu:function(){
            var ObjCyc=$(this).find("a");
            if(!MenuId){
                var $url=ObjCyc.closest("a").attr("data-url");
                if($url){
                    MenuId=ObjCyc.closest("a").attr("data-find");
                    sessionStorage.setItem("MenuId",MenuId );
                }
            }
            ObjCyc.on('click', function (e) {
                e.stopPropagation();
                var $that = $(this),
                    $pUl = $that.closest('.menucyc'),
                    thatId = $that.attr('data-find'),
                    pid = $that.attr('data-pid'),
                    title = $that.attr('title'),
                    url = $that.attr('data-url'), titArr = [];
                if (url) {
                    $pUl.find('.on').removeClass('on');
                    $that.addClass('on');
                    $.each(pid.split(','), function (k, o) {
                        var $o = $('#' + o);
                        if ($o.length > 0) {
                            $('#' + o).children().eq(0).addClass('on');
                        }
                        titArr.push($o.children('a').attr('title'))
                    });
                    titArr.push('<span style="color: #337ab7">' + title + '</span>');
                    window._SHOWTAB({name: title=="数据资源中心"?"首页":title, url: url,findid:thatId, cb: function ($ifram) {
                        if ($ifram[0].attachEvent){
                            $ifram[0].attachEvent("onload", function(){
                                var cw = $ifram.prop('contentWindow');//window
                                // cw.postMessage(titArr, '*');
                                cw.postMessage([title], '*');
                            });
                        } else {
                            $ifram[0].onload = function(e){
                                var cw = $ifram.prop('contentWindow');//window
                                // cw.postMessage(titArr, '*');
                                cw.postMessage([title], '*');
                            };
                        }
                    }});
                    sessionStorage.setItem("MenuId", thatId);
                    if (!isTrigger) {
                        // var $ul = $that.closest('ul');
                        // debugger
                        // $ul.parent().parent().prev().trigger('click');
                        // $ul.prev().trigger('click');
                        // isTrigger = true;
                    }
                } else {
                    if ($that.hasClass('active')) {
                        $that.removeClass('active');
                    } else {
                        $that.addClass('active');
                    }
                    $that.next().slideToggle();
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
            }
        });
    });
});
