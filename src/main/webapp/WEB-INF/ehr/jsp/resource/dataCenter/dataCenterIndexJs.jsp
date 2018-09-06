<%--
  Created by IntelliJ IDEA.
  User: 黄仁伟
  Date: 2018/3/28
  Time: 15:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>
    $('#contentPage').css({
        padding: 0
    });
    var width = window.screen.width;
    $("html").css("font-size", (width/10)+"px");

    var api = [
        '${contextRoot}/resourceCenter/achievements',//数据治理
        '${contextRoot}/resourceCenter/dataAnalysis',//数据分析
        '${contextRoot}/resourceCenter/visualization',//可视化
        '${contextRoot}/resourceCenter/hierarchicalManagement'//分级管理
    ];
    var color = [
        '#907bf4',
        '#ff88be',
        '#20e1e3',
        '#03d269',
        '#fed227',
        '#30aafa',
        '#7eed7e',
        '#ff88be',
        '#f97e0f',
        '#1cd2bb',
        '#a693fe',
        '#ffc329',
        '#ff9aa4',
        '#ffe30c',
        '#7cf084',
        '#77c2fc',
        '#7f8bbb',
        '#9ede28',
        '#e1ac7b',
        '#70ecf8',
        '#e3eb9e',
        '#ff5f5f',
        '#c6adc3',
        '#f29804',
        '#9fb6ed',
        '#8abf87'
    ];

    var option = function () {
        return {
            tooltip : {
                trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            color: color
        }
    };
    var option0 = {}, option1 = {}, option2 = {}, option3 = {};
    var dcVm = new Vue({
        el: '#dcApp',
        data: {
            runTimeout: null,
            deg: 0,
            index: 0,
            oldInd: 0,
            sta: true,
            isFullScreen: false,
            itemData: [
                {
                    title: '数据治理',
                    content: '数据管理、数据采集、数据存储',
                    icon: '${staticRoot}/images/shujuzili_icon.png'
                },
                {
                    title: '数据分析',
                    content: '指标管理',
                    icon: '${staticRoot}/images/shujufenxi_icon.png'
                },
                {
                    title: '可视化',
                    content: '视图配置管理、视图报表管理',
                    icon: '${staticRoot}/images/keshihua_icon.png'
                },
                {
                    title: '分级管理',
                    content: '政府工作人员、医生工作者、公众居民',
                    icon: '${staticRoot}/images/fenjiguanli_icon.png'
                }
            ],
            dataHandle: [],
            dataAnalysis: [],
            dataVisualization: [],
            dataHM: [],
            isClick: {1: null, 2: null}
        },
        methods: {
            getDataHandle: function () {//数据治理
                return this.getDataPromise(api[0]);
            },
            getDataAnalysis:function () {//可视化
                return this.getDataPromise(api[1])
            },
            getDataVisualization: function () {//数据分析
                return this.getDataPromise(api[2]);
            },
            getDataHM: function () {//分级管理
                return this.getDataPromise(api[3]);
            },
            getSeriesData: function (data) {
                var d = [],
                    lenD = [];
                _.each(data, function (obj, key) {
                    _.each(obj, function (v, k) {
                        lenD.push(k);
                        d.push({
                            name: k,
                            value: v
                        })
                    });
                });
                return [d, lenD];
            },
            getSeries: function (r, c, d, f, labelBool, name, position) {
                var fontsize = (14/1920) * width;
                return {
                        name: name || '',
                        type: 'pie',
                        radius : r,
                        center: c,
                        data:d,
                        itemStyle : {
                            normal : {
                                label : {
                                    show : labelBool,
                                    formatter: f,
                                    position : position || 'outter',
                                    fontSize: fontsize
                                },
                                labelLine : {
                                    show : labelBool
                                }
                            }
                        },
                        avoidLabelOverlap: true,
                    }
            },
            getHandleOpt: function (lenD, d) {
                return $.extend(option(), {
//                    legend: {
//                        orient: 'vertical',
//                        x: 'right',
//                        y: 'center',
//                        data: lenD
//                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{b}: {c} ({d}%)"
                    },
                    series: [ this.getSeries(['50%', '80%'], ['50%', '50%'], d, '{b}:{c}', true) ]
                });
            },
            getAnalysisOpt: function (lenD, d) {
                var padd = (20/1920) * width;
                return $.extend(option(), {
                    legend: {
                        orient: 'vertical',
                        x: 'right',
                        y: 'center',
                        data: lenD,
                        padding: padd
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{b}: {c} ({d}%)"
                    },
                    series: [ this.getSeries(['40%', '70%'], ['40%', '50%'], d, '{c} ({d}%)', false) ]
                });
            },
            getVisualizationOpt: function (lenD, d1, d2) {
                var op = option();
                $.extend(op, {
//                    legend: {
//                        orient: 'vertical',
//                        x: 'right',
//                        y: 'center',
//                        data: lenD
//                    },
                    series: [
                        this.getSeries([0, '45%'], ['50%', '50%'], d1, '{b}', true, '视图', 'inner'),
                        this.getSeries(['60%', '80%'], ['50%', '50%'], d2, '{c} ({d}%)', false, '视图')
                    ]
                });
                op.series[0].itemStyle.normal.labelLine.show = false;
                return op;
            },
            getVisualizationOpt2: function (lenD, d) {
                return $.extend(option(), {
//                    legend: {
//                        orient: 'vertical',
//                        x: 'right',
//                        y: 'center',
//                        data: lenD
//                    },
                    series: [ this.getSeries(['30%', '80%'], ['50%', '50%'], d, '', false, '资源报表') ]
                });
            },
            getAllData: function () {
                var me = this;
                Promise.all([
                    me.getDataHandle(),
                    me.getDataAnalysis(),
                    me.getDataVisualization(),
                    me.getDataHM()
                ]).then(function (res) {
                    if (res[0].successFlg) {
                        var achievementsData = res[0].detailModelList[0].view[1],
                            d1 = me.getSeriesData(achievementsData)[0],
                            lenD1 = me.getSeriesData(achievementsData)[1];
                        option0 = me.getHandleOpt(lenD1, d1);
                        option0.series[0].radius = ['30%','50%']
                        debugger
                        me.dataHandle = res[0].detailModelList;
                        setTimeout(function () {
                            var myEchar1 = echarts.init(document.getElementById('echart1'));
                            myEchar1.setOption(option0);
                        }, 300);
                    }
                    if (res[1].successFlg) {
                        var analysisData = res[1].detailModelList[0].view[1],
                            d = me.getSeriesData(analysisData)[0],
                            lenD1 = me.getSeriesData(analysisData)[1];
                        option1 = me.getAnalysisOpt(lenD1, d);
                        me.dataAnalysis = res[1].detailModelList[0];
                    }
                    if (res[2].successFlg) {
                        var visualizationData1 = res[2].detailModelList[0].view[1],
                            visualizationData2 = res[2].detailModelList[0].view[2],
                            visualizationData3 = res[2].detailModelList[1].view[1],
                            lD1 = me.getSeriesData(visualizationData1)[1],
                            lD2 = me.getSeriesData(visualizationData2)[1],
                            lD3 = me.getSeriesData(visualizationData3)[1],
                            dOne = me.getSeriesData(visualizationData1)[0],
                            dTwo = me.getSeriesData(visualizationData2)[0],
                            dThree = me.getSeriesData(visualizationData3)[0];
                        option2 = me.getVisualizationOpt(_.union(lD1, lD2), dOne, dTwo);
                        option3 = me.getVisualizationOpt2(lD3, dThree);
                        me.dataVisualization = res[2].detailModelList;
                    }
                    if (res[3].successFlg) {
                        me.dataHM = res[3].detailModelList;
                    }
                }).catch(function (res) {
                    
                });
            },
            stopRun: function () {
                var me = this;
                me.runTimeout = setTimeout(function () {
                    me.setSta("paused");
                    $('.dc-circle-item').eq(me.deg).addClass('active');
                    if (me.deg < 3) {
                        me.running();
                    } else if(me.deg == 3) {
                        me.running();
//                        clearTimeout(me.runTimeout);

                    }else{
                        clearTimeout(me.runTimeout);
                        me.setSta("running");
                        me.runTimeout = setTimeout(function () {
                            me.deg = -1;
                            clearTimeout(me.runTimeout);
                            me.running();
                            $('.dc-circle-item').eq(me.deg).removeClass('active');
                        }, 6500);
                    }
                }, 2300);
            },
            running: function () {
                var me = this;
                this.runTimeout = setTimeout(function () {
                    me.setSta("running");
                    $('.dc-circle-item').eq(me.deg++).removeClass('active');
                    me.stopRun();
                }, 2000);
            },
            setSta: function (sta) {
                var el = document.getElementById("runningDom");
                el.style.animationPlayState = sta;
                el.style.WebkitAnimationPlayState = sta;
            },
            change: function (n) {
                var me = this;
                if (me.sta && n != this.oldInd) {
//                    $(".item-info").find("span").removeClass("fadeLeftIn");
                    me.sta = false;
                    $('.dc-info-circle').addClass('active');
                    $('.dc-icon').addClass('active');
                    $('.dc-item-info').eq(me.oldInd).removeClass('fadeInUp').addClass('fadeInDown1');
                    $('.dc-icon' + me.oldInd).removeClass('active');
                    $('.dc-icon' + n).addClass('active');
                    $(".dc-circle-item").removeClass("loaded");
                    $(".dc-circle-item").eq(n).addClass("loaded");
                    (function (num) {
                        setTimeout(function () {
                            me.index = n;
                            if (!me.isClick[n]) {
                                me.isClick[n] = n;
                                setTimeout(function () {
                                    me.showChart(n);
                                },300);
                            }
                            $('.dc-info-circle').removeClass('active');
                            $('.dc-icon').removeClass('active');
//                            $(".item-info").find("span").addClass("fadeLeftIn");
//                            $(".item-tit").animate({
//                                left:'250px',
//                                opacity:'0.5',
//                                height:'150px',
//                                width:'150px'
//                            });

                            $('.dc-item-info').eq(me.oldInd).removeClass('fadeInDown1');
                            $('.dc-item-info').eq(me.index).addClass('fadeInUp');
                            me.sta = true;
                            me.oldInd = num;
                        }, 1000);
                    })(n);
                }
            },
            showChart: function (n) {
                var opt = {}, myEchart = null;
                switch (n) {
                    case 1:
                        opt = option1;
                        break;
                    case 2:
                        opt = option2;
                        var myEchart2 = echarts.init(document.getElementById('echart' + (n + 2)));
                        myEchart2.setOption(option3);
                        break;
                    default:
                        return; 
                }
                myEchart = echarts.init(document.getElementById('echart' + (n + 1)));
                myEchart.setOption(opt);
            },
            checkInfo: function (appId, menuId) {
                if (!appId || !menuId || menuId == '' || appId == '') {
                    alert('参数有误！');
                    return;
                }
                window.parent.postMessage({
                    type: 'jump',
                    data: {
                        appId: appId,
                        menuId: menuId
                    }
                }, '*');
            },
            toggleFullscreen: function () {
//                window.parent.postMessage({
//                    type: 'fullScreen'
//                }, '*');
                var elem = document.getElementById("dcApp");
                if(this.isFullScreen){
                    exitFullScreen();
                }else{
                    requestFullScreen(elem);
                }
                this.isFullScreen = !this.isFullScreen;
            },
            getDataPromise: function (url, data) {
                return new Promise(function (resolve, reject) {
                    $.ajax($.extend({
                        url: url || '',
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            resolve(res);
                        },
                        error: function (e) {
                            reject(e);
                        }
                    }, {data: data || {}}));
                })
            }
        },
        created: function () {
            $('#dcApp').show();
            this.setSta("paused");
            this.running();
        },
        mounted: function () {
            this.$nextTick(function() {
                this.getAllData();
            });
        },
        filters: {
            formatNumber: function (value) {
                return formatNumber(value)
            }
        }
    });

    function formatNumber(str){
        var newStr = "";
        var count = 0;
        str = str + "";
        if(str.indexOf(".")==-1){
            for(var i=str.length-1;i>=0;i--){
                if(count % 3 == 0 && count != 0){
                    newStr = str.charAt(i) + "," + newStr;
                }else{
                    newStr = str.charAt(i) + newStr;
                }
                count++;
            }
            str = newStr; //自动补小数点后两位
        }
        else
        {
            for(var i = str.indexOf(".")-1;i>=0;i--){
                if(count % 3 == 0 && count != 0){
                    newStr = str.charAt(i) + "," + newStr; //碰到3的倍数则加上“,”号
                }else{
                    newStr = str.charAt(i) + newStr; //逐个字符相接起来
                }
                count++;
            }
            str = newStr + (str + "00").substr((str + "00").indexOf("."),3);
        }
        return str;
    }

    function requestFullScreen(element) {
        var requestMethod = element.requestFullScreen || element.webkitRequestFullScreen || element.mozRequestFullScreen || element.msRequestFullScreen;
        if (requestMethod) {
            requestMethod.call(element);
        } else if (typeof window.ActiveXObject !== "undefined") {
            var wscript = new ActiveXObject("WScript.Shell");
            if (wscript !== null) {
                wscript.SendKeys("{F11}");
            }
        }
    }

    function exitFullScreen(){
        // 判断各种浏览器，找到正确的方法
        var exitMethod = document.exitFullscreen || //W3C
            document.mozCancelFullScreen || //Chrome等
            document.webkitExitFullscreen || //FireFox
            document.webkitExitFullscreen; //IE11
        if (exitMethod) {
            exitMethod.call(document);
        }
        else if (typeof window.ActiveXObject !== "undefined") {//for Internet Explorer
            var wscript = new ActiveXObject("WScript.Shell");
            if (wscript !== null) {
                wscript.SendKeys("{F11}");
            }
        }
    }
</script>