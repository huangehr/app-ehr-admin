<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/11/1
  Time: 9:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>
<script src="${contextRoot}/develop/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script type="text/javascript">

    $(function(){

        //数据接口
        var pi = [
            /*
             *获取健康档案图表
             *requestType:
             *            archiveIdentify（档案识别）、archiveHospital（住院/门诊）、archiveStatistical（数据统计）、archiveTotalVisit（累计就诊人数）
             */
            '${contextRoot}/resourcesStatistics/stasticReport/getArchiveReportInfo',
            //电子病历-最近七天采集总数统计，门诊住院数
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsElectronicMedicalCount',
            //电子病历 - 今天 门诊住院数统计
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsMedicalEventTypeCount',
            //全员人口个案库 - 年龄段人数统计
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsDemographicsAgeCount',
            //获取健康卡绑定量
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsUserCards',
            //按机构医生、护士、床位的统计
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsDoctorByRoleType',
            //全市医生、护士、床位的统计
            '${contextRoot}/resourcesStatistics/stasticReport/getStatisticsCityDoctorByRoleType'

        ];
        var requestType = ['archiveIdentify', 'archiveHospital', 'archiveStatistical', 'archiveTotalVisit'];

        var mh = {
            rtLen: 0,
            $el1: document.getElementById("div_jkda_chart1"),
            $el2: document.getElementById("div_jkda_chart2"),
            $el3: document.getElementById("div_jkda_chart3"),
            $el4: document.getElementById("div_jkda_chart4"),
            $el5: document.getElementById("div_jkda_chart5"),
            $el6: document.getElementById("div_jkda_chart6"),
            $el7: document.getElementById("div_jkda_chart7"),
//            $el8: document.getElementById("div_jkda_chart8"),
            $el9: document.getElementById("div_jkda_chart9"),
            myCharts1: null,
            myCharts2: null,
            myCharts3: null,
            myCharts4: null,
            myCharts5: null,
            myCharts6: null,
            myCharts7: null,
//            myCharts8: null,
            myCharts9: null,
            init: function () {
                var me = this;
                Promise.all([
                    me.getData(pi[0], {
                        requestType: requestType[this.rtLen]
                    }, me.loadArcCB),
                    me.loadENRData(),
                    me.loadMCTData(),
                    me.loadUCData(),
                    me.loadDACData(),
                    me.loadDBData(),
                    me.loadDBData(),
                    me.loadCDBRData()
                ]).then(function () {
                    me.bindEvents();
                });
                $(".div-main-content").mCustomScrollbar({
                    theme:"dark", //主题颜色
                    scrollButtons:{
                        enable:false,
                        scrollType:"continuous",
                        scrollSpeed:10,
                        scrollAmount:40
                    },
                    horizontalScroll:false,
                });
            },
            getData: function (url, data, cb) {
                var me = this;
                me.mhPromiseReq(url, 'GET', data).then(function (res) {
                    cb && cb.call(this, res, me);
                });
            },
            //获取健康档案图表
            loadArcCB: function (res, me) {
                debugger
                if (res.successFlg) {
                    var d = res.detailModelList && res.detailModelList[0].dataModels,
                            obj = res.obj;
                    switch (requestType[me.rtLen]) {
                        case 'archiveIdentify':
                            me.loadChart1(d);
                            $('#arcNum').html(obj.archiveIdentify);//档案识别总数
                            $('#identNum').html(obj.identify);//可以识别
                            $('#unIdentNum').html(obj.unIdentify);//不可识别
                            break;
                        case 'archiveHospital':
                            me.loadChart2(d);
                            $('#hosCountNum').html(obj['hospital/outpatient']);
                            $('#hosNum').html(obj.hospital);
                            $('#odNum').html(obj.outpatient);
                            $('#tjNum').html(obj.physical);
                            break;
                        case 'archiveStatistical':
                            me.loadChart3(d);
                            $('#dataNum').html(obj.dataStatistical);
                            $('#tadayNum').html(obj.todayInWarehouse);
                            break;
                        case 'archiveTotalVisit':
                            $('#newNum').html(obj.dailyAdd);
                            $('#odCountNum').html(obj.totalVisits);
                            break;
                    }
                    me.rtLen++;
                    if (me.rtLen < requestType.length) {
                        me.getData(pi[0], {
                            requestType: requestType[me.rtLen]
                        }, me.loadArcCB);
                    }
                }
            },
            //电子病历 - 今天 门诊住院数统计
            loadENRData: function () {
                var me = this;
                this.getData(pi[1], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        if (dataList.length > 0) {
                            me.loadChart4(dataList);
                        }
                    }
                });
            },
            //电子病历 - 今天 门诊住院数统计
            loadMCTData: function () {
                var me = this;
                this.getData(pi[2], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        if (dataList.length > 0) {
                            me.loadChart5(dataList);
                            $('#dzCNum').html(res.obj['hospital/outpatient']);
                            $('#dzHosNum').html(res.obj['hospital']);
                            $('#dzConNum').html(res.obj['outpatient']);
                        }
                    }
                });
            },
            //全员人口个案库 - 年龄段人数统计
            loadDACData: function () {
                var me = this;
                this.getData(pi[3], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        if (dataList.length > 0) {
                            me.loadChart7(dataList[0]);
                        }
                    }
                });
            },
            //获取健康卡绑定量
            loadUCData: function () {
                var me = this;
                this.getData(pi[4], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        if (dataList.length > 0) {
                            me.loadChart6(dataList[0]);
                        }
                        $('#tdCNum').html(res.obj.totalDemographicsNum);
                    }
                });
            },
            loadDBData: function () {
                var me = this;
                this.getData(pi[5], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart9(dataList);
                    }
                });
            },
            loadCDBRData: function () {
                var me = this;
                this.getData(pi[6], {}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.obj.dataModels;
                        for (var i = 0; i < dataList.length; i++) {
                            switch (dataList[i].name) {
                                case 'Doctor':
                                    $('#qsDocNum').html(dataList[i].value);
                                    break;
                                case 'Nurse':
                                    $('#qsHsNum').html(dataList[i].value);
                                    break;
//                                case '床位':
//                                    $('#qsCwNum').html(dataList[i].value);
//                                    break;
                            }
                        }
                    }
                });
            },
            loadChart1:function(data){
                var me = this;
                me.myCharts1 = echarts.init(me.$el1);
                var option = {
//                    tooltip : {
//                        trigger: 'item',
//                        formatter: "{a} <br/>{b} : {c} ({d}%)"
//                    },
//                    title: {
////                        itemGap: 5,
//                        text: '15256',
//                        textStyle: {
//                            color: '#333',
//                            fontStyle: 'normal',
//                            fontWeight: 'bolder',
//                            fontFamily: 'sans-serif',
//                            fontSize: 16,
//                        },
//                        subtext: ' 数据统计',
//                        subtextStyle: {
//                            color: '#333',
//                            fontStyle: 'normal',
//                            fontWeight: 'normal',
//                            fontFamily: 'sans-serif',
//                            fontSize: 12,
//                        },
//                        x: 'center',
//                        y: 'center'
//                    },
                    color:[ '#ffbd5c','#42d16f'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果
                            radius : ['70%', '85%'],
//                            center:['50%','50%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data:data
                        }
                    ]
                };
                me.myCharts1.setOption(option);
            },
            loadChart2:function(data){
                var me = this;
                me.myCharts2 = echarts.init(me.$el2);
                var option = {
                    color:['#5bc9f4', '#ffbd5c','#9a9cf4'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果
                            radius : ['70%', '85%'],
//                            center:['50%','50%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data:data
                        }
                    ]
                };
                me.myCharts2.setOption(option);
            },
            loadChart3:function(data){
                var me = this;
                me.myCharts3 = echarts.init(me.$el3);
                var option = {
                    color:['#d08dff', '#ffbd5c'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果
                            radius : ['70%', '85%'],
//                            center:['50%','50%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data:data
                        }
                    ]
                };
                me.myCharts3.setOption(option);
            },
            loadChart4:function(data){
                var me = this;
                me.myCharts4 = echarts.init(me.$el4);
                var option = {
                    tooltip : {
                        trigger: 'axis'
                    },
                    legend: {
                        data:['采集总数','住院','门诊']
                    },
                    grid: {
                        borderWidth:0
                    },
                    calculable : true,
                    xAxis : [
                        {
                            type : 'category',
                            boundaryGap : false,
                            data : data[0].xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            axisLabel: {show:true,textStyle:{
                                color: '#909090',
                                fontSize:14
                            }},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    yAxis : [
                        {
                            type : 'value',
                            name : '单位:人',
                            nameTextStyle:{
                                color: '#909090',
                                fontSize:12
                            },
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick : {    // 轴标记
                                show:false
                            },
                            splitLine : {
                                show:true,
                                lineStyle: {
                                    color: '#dddddd',
                                    type: 'dotted',
                                    width: 2
                                }
                            },
                            splitArea: {show:false},
                            axisLabel: {show:true,textStyle:{
                                color: '#909090',
                                fontSize:14
                            }},
                        }
                    ],
                    series : [
                        {
                            name: '采集总数',
                            type:'line',
                            symbol:'circle',
                            symbolSize:10,
                            itemStyle : {
                                normal : {
                                    color: "#28a9e3",
                                    lineStyle:{
                                        color:'#28a9e3'
                                    }
                                }
                            },
                            data: data[0].yData
                        },
                        {
                            name: '住院',
                            type:'line',
                            symbol:'circle',
                            symbolSize:10,
                            itemStyle : {
                                normal : {
                                    color: "#ffae43",
                                    lineStyle:{
                                        color:'#ffae43'
                                    }
                                }
                            },
                            data: data[2].yData
                        },
                        {
                            name: '门诊',
                            type:'line',
                            symbol:'circle',
                            symbolSize:10,
                            itemStyle : {
                                normal : {
                                    color: "#45d16f",
                                    lineStyle:{
                                        color:'#45d16f'
                                    }
                                }
                            },
                            data: data[1].yData
                        }
                    ]
                };
                me.myCharts4.setOption(option);
            },
            loadChart5:function(data){
                var me = this;
                me.myCharts5 = echarts.init(me.$el5);
                var option = {
                    color:['#42d16f', '#ffbd5c'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果
                            radius : ['70%', '85%'],
//                            center:['50%','50%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data: data[0].dataModels
                        }
                    ]
                };
                me.myCharts5.setOption(option);
            },
            loadChart6:function(data){
                var me = this;
                me.myCharts6 = echarts.init(me.$el6);
                var option = {
                    tooltip : {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                    },
                    color:['#ea0e69', '#F7F7F7'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            radius : ['70%', '85%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data: data.dataModels
                        }
                    ]
                };
                me.myCharts6.setOption(option);
            },
            loadChart7:function(data){
                var me = this;
                me.myCharts7 = echarts.init(me.$el7);
                var xAxisData = data.xData;
                var option = {
                    grid: {
                        borderWidth:0
                    },
                    tooltip : {
                        show: true,
                        trigger: 'item'
                    },
                    xAxis: [{
                        name : '年龄',
                        data: xAxisData,
                        axisLine : {    // 轴线
                            show: false
                        },
                        axisTick: {show:false},
                        axisLabel: {show:true,textStyle:{
                            color: '#909090',
                            fontSize:12
                        }},
                        splitArea: {show:false},
                        splitLine: {show:false}
                    }, {
                        // 辅助 x 轴
                        show: false,
                        data: xAxisData
                    }],
                    yAxis: {
                        type : 'value',
                        name : '单位:人',
                        axisLine : {    // 轴线
                            show: false
                        },
                        axisTick : {    // 轴标记
                            show:false
                        },
                        axisLabel: {show:true,textStyle:{
                            color: '#909090',
                            fontSize:12
                        }},
                        splitLine : {
                            show:false
                        },
                        splitArea : {
                            show: false
                        }
                    },
                    series: [
                        {
                            // 辅助系列
                            type           : 'bar',
                            silent         : true,
                            xAxisIndex     : 1,
                            itemStyle      : {
                                normal         : {
                                    barBorderRadius: 0,
                                    color: '#f7f7ff'
                                }
                            },
                            barWidth: 20,
                            data: data.yData.map(function (val) {
                                return _.max(data.yData);
                            })
                        },
                        {
                            type: 'bar',
                            data: data.yData,
                            barWidth: 20,
                            itemStyle: {
                                normal: {
                                    barBorderRadius: 0,
                                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                        offset: 0,
                                        color: '#9c9af4'
                                    }, {
                                        offset: 1,
                                        color: '#65c5ff'
                                    }])
                                }
                            }
                        }
                    ]
                };
                me.myCharts7.setOption(option);
            },
            loadChart8:function(){
                var me = this;
                me.myCharts8 = echarts.init(me.$el8);
                var option = {
                    color:['#42d16f', '#ffbd5c','#5bc9f4'],
                    calculable : false,
                    series : [
                        {
                            name:'访问来源',
                            type:'pie',
                            hoverAnimation:false,//是否开启 hover 在扇区上的放大动画效果
                            radius : ['70%', '85%'],
//                            center:['50%','50%'],
                            selectedMode: 'single',
                            itemStyle : {
                                normal : {
                                    label : {
                                        show : false
                                    },
                                    labelLine : {
                                        show : false
                                    }
                                }
                            },
                            data:[
                                {value:335, name:'男'},
                                {value:310, name:'女',selected:true},
                                {value:234, name:'未知'}
                            ]
                        }
                    ]
                };
                me.myCharts8.setOption(option);
            },
            loadChart9:function(data){
                var me = this;
                me.myCharts9 = echarts.init(me.$el9);
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['医生', '护士']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 140
                    },
                    calculable : true,
                    yAxis : [
                        {
                            type : 'value',
                            boundaryGap : [0, 0.01],
                            axisLine : {    // 轴线
                                show: false,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick : {    // 轴标记
                                show:false
                            },
                            splitLine : {
                                show:true,
                                lineStyle: {
                                    color: '#dddddd',
                                    type: 'dotted',
                                    width: 2
                                }
                            },
                            splitArea: {show:false},
                            axisLabel: {show:true,textStyle:{
                                color: '#909090',
                                fontSize:14
                            }}
                        }
                    ],
                    xAxis : [
                        {
                            type : 'category',
                            data : data[0].xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            axisLabel: {
                                interval:0,
                                formatter : function(params){
                                    var newParamsName = "";
                                    var paramsNameNumber = params.length;
                                    var provideNumber = 4;
                                    var rowNumber = Math.ceil(paramsNameNumber / provideNumber);
                                    if (paramsNameNumber > provideNumber) {
                                        for (var p = 0; p < rowNumber; p++) {
                                            var tempStr = "";
                                            var start = p * provideNumber;
                                            var end = start + provideNumber;
                                            if (p == rowNumber - 1) {
                                                tempStr = params.substring(start, paramsNameNumber);
                                            } else {
                                                tempStr = params.substring(start, end) + "\n";
                                            }
                                            newParamsName += tempStr;
                                        }

                                    } else {
                                        newParamsName = params;
                                    }
                                    return newParamsName
                                },
//                                rotate:90,
                                show:true,
                                textStyle:{
                                    color: '#909090',
                                    fontSize:14,
                                }},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    series : [
                        {
                            name: '医生',
                            type:'bar',
                            barGap:2,
                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#44d4ca',
                                    lineStyle:{
                                        color:'#44d4ca'
                                    }
                                }
                            },
                            data: data[0].yData
                        },
                        {
                            name:'护士',
                            type:'bar',
                            barGap:2,
                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#FFBD5C',
                                    lineStyle:{
                                        color:'#FFBD5C'
                                    }
                                }
                            },
                            data:data[1].yData
                        },
//                        {
//                            name:'床位',
//                            type:'bar',
//                            barGap:2,
//                            barMaxWidth:6,
//                            itemStyle : {
//                                normal : {
//                                    barBorderRadius:[6],
//                                    color:'#28a9e6',
//                                    lineStyle:{
//                                        color:'#28a9e6'
//                                    }
//                                }
//                            },
//                            data:[11000, 12000, 13000, 14000, 1500,1000, 2000, 3000, 4000, 5000]
//                        }
                    ]
                };
                me.myCharts9.setOption(option);
            },
            bindEvents: function () {
                var me = this;
                window.onresize = function () {
                    me.myCharts1.resize();
                    me.myCharts2.resize();
                    me.myCharts3.resize();
                    me.myCharts4.resize();
                    me.myCharts5.resize();
                    me.myCharts6.resize();
                    me.myCharts7.resize();
//                    me.myCharts8.resize();
                    me.myCharts9.resize();
                };

            },
            mhPromiseReq: function ( url, type, data) {
                var me = this;
                return new Promise(function ( res, rej) {
                    me.mhAjax( url, type, data, '', '', res);
                });
            },
            mhAjax: function ( url, type, data, scb, ecb, res) {
                $.ajax({
                    url: url,
                    type: type,
                    dataType: 'json',
                    data: data,
                    async:true,
                    success: function (r) {
                        $.isFunction(res) && res(r);
                        $.isFunction(scb) && scb.call( this, r);
                    },
                    error: function (e) {
                        $.isFunction(ecb) && ecb.call( this, e);
                    }
                });
            }
        };
        mh.init();
    });
</script>