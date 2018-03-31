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
    var api = [
        '${contextRoot}/resourceCenter/achievements',//数据治理
        '${contextRoot}/resourceCenter/dataAnalysis',//数据分析
        '${contextRoot}/resourceCenter/visualization',//可视化
        '${contextRoot}/resourceCenter/hierarchicalManagement'//分级管理
    ];
    var option = function () {
        return {
            tooltip : {
                trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            color: ['#43b2fa','#20e1e3','#907bf4','#ff88be','#03d269','#fed227','#ff88be']
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
            getSeries: function (r, c, d, f, labelBool) {
                return {
                        type: 'pie',
                        radius : r,
                        center: c,
                        data:d,
                        itemStyle: {
                        normal : {
                            label : {
                                show : labelBool,
                                formatter: f
                            },
                            labelLine : {
                                show : labelBool
                            }
                        }
                    }
                }
            },
            getHandleOpt: function (lenD, d) {
                return $.extend(option(), {
                    legend: {
                        orient: 'vertical',
                        x: 'right',
                        y: 'center',
                        data: lenD
                    },
                    series: [ this.getSeries(['30%', '60%'], ['40%', '50%'], d, '{c} ({d}%)', true) ]
                });
            },
            getAnalysisOpt: function (d) {
                return $.extend(option(), {
                    series: [ this.getSeries(['30%', '60%'], ['50%', '50%'], d, '{c} ({d}%)', true) ]
                });
            },
            getVisualizationOpt: function (lenD, d1, d2) {
                return $.extend(option(), {
//                    legend: {
//                        orient: 'vertical',
//                        x: 'right',
//                        y: 'center',
//                        data: lenD
//                    },
                    series: [
                        this.getSeries(['20%', '50%'], ['50%', '50%'], d1, '{c} ({d}%)', false),
                        this.getSeries(['50%', '80%'], ['50%', '50%'], d2, '{c} ({d}%)', false)
                    ]
                });
            },
            getVisualizationOpt2: function (lenD, d) {
                return $.extend(option(), {
//                    legend: {
//                        orient: 'vertical',
//                        x: 'right',
//                        y: 'center',
//                        data: lenD
//                    },
                    series: [ this.getSeries(['30%', '80%'], ['50%', '50%'], d, '', false) ]
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
                        me.dataHandle = res[0].detailModelList;
                        setTimeout(function () {
                            var myEchar1 = echarts.init(document.getElementById('echart1'));
                            myEchar1.setOption(option0);
                        }, 300);
                    }
                    if (res[1].successFlg) {
                        var analysisData = res[1].detailModelList[0].view[1],
                            d = me.getSeriesData(analysisData)[0];
                        option1 = me.getAnalysisOpt(d);
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
                    } else {
                        me.runTimeout = setTimeout(function () {
                            clearTimeout(me.runTimeout);
                            $('.dc-circle-item').eq(me.deg).removeClass('active');
                        }, 2000);
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
                $('#runningDom')[0].style.animationPlayState = sta;
                $('#runningDom')[0].style.WebkitAnimationPlayState = sta;
            },
            change: function (n) {
                var me = this;
                if (me.sta && n != this.oldInd) {
                    me.sta = false;
                    $('.dc-info-circle').addClass('active');
                    $('.dc-icon').addClass('active');
                    $('.dc-item-info').eq(me.oldInd).removeClass('fadeInUp').addClass('fadeInDown1');
                    $('.dc-icon' + me.oldInd).removeClass('active');
                    $('.dc-icon' + n).addClass('active');
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
                window.parent.postMessage({
                    type: 'fullScreen'
                }, '*');
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
        }
    });
</script>