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
            '${contextRoot}/resourcesStatistics/stasticReport/getArchiveReportAll',
            '${contextRoot}/resourcesStatistics/stasticReport/getRecieveOrgCount',
            '${contextRoot}/resourcesStatistics/stasticReport/getArchivesInc',
            '${contextRoot}/resourcesStatistics/stasticReport/getArchivesFull',
            '${contextRoot}/resourcesStatistics/stasticReport/getArchivesTime',
            '${contextRoot}/resourcesStatistics/stasticReport/getDataSetCount'
        ];

        var mh = {
            rtLen: 0,
            $el1: document.getElementById("chart1"),
            $el2: document.getElementById("chart2"),
            $el3: document.getElementById("chart3"),
            $el4: document.getElementById("chart4"),
            $el5: document.getElementById("chart5"),
            $el6: document.getElementById("chart6"),
            $startDate1:$("#start_date1"),
            $endDate1:$("#end_date1"),
            $startDate2:$("#start_date2"),
            $endDate2:$("#end_date2"),
            $startDate3:$("#start_date3"),
            $endDate3:$("#end_date3"),
            $date1:$("#date1"),
            $date2:$("#date2"),
            $date3:$("#date3"),
            $searchBtn: $('#btn_search'),
            $searchBtn1: $('#btn_search1'),
            $searchBtn2: $('#btn_search2'),
            $searchBtn3: $('#btn_search3'),
            $searchBtn4: $('#btn_search4'),
            $searchBtn5: $('#btn_search5'),
            $orgCode1: $('#orgCode1'),
            $orgCode2: $('#orgCode2'),
            $orgCode3: $('#orgCode3'),
            $orgCode4: $('#orgCode4'),
            myCharts1: null,
            myCharts2: null,
            myCharts3: null,
            myCharts4: null,
            myCharts5: null,
            list4:[],
            init: function () {
                var me = this;
                var url = '${contextRoot}/deptMember/getHospitalList';
                this.$orgCode1.customCombo(url);
                this.$orgCode2.customCombo(url);
                this.$orgCode3.customCombo(url);
                this.$orgCode4.customCombo(url);
                me.$startDate1.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$endDate1.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$startDate2.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$endDate2.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$startDate3.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$endDate3.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$date1.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$date2.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$date3.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$startDate1.ligerDateEditor("setValue",me.getSevenDays());
                me.$endDate1.ligerDateEditor("setValue",me.getCurrentDate());
                me.$startDate2.ligerDateEditor("setValue",me.getSevenDays());
                me.$endDate2.ligerDateEditor("setValue",me.getCurrentDate());
                me.$startDate3.ligerDateEditor("setValue",me.getSevenDays());
                me.$endDate3.ligerDateEditor("setValue",me.getCurrentDate());
                me.$date1.ligerDateEditor("setValue",me.getCurrentDate());
                me.$date2.ligerDateEditor("setValue",me.getCurrentDate());
                me.$date3.ligerDateEditor("setValue",me.getCurrentDate());
                Promise.all([
                    me.getChart1(),
                    me.getChart2(),
                    me.getChart3(),
                    me.getChart4(),
                    me.getChart5(),
                    me.getChart6()
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
            getChart1: function () {
                var me = this;
                me.myCharts1 = echarts.init(me.$el1);
                me.myCharts1.showLoading();
                this.getData(pi[0], {startDate: me.$startDate1.val(),endDate:me.$endDate1.val()}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart1(dataList);
                    }
                });
            },
            getChart2: function () {
                var me = this;
                me.myCharts2 = echarts.init(me.$el2);
                me.myCharts2.showLoading();
                this.getData(pi[1], {date:me.$date1.val()}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart2(dataList);
                    }
                });
            },
            getChart3: function () {
                var me = this;
                me.myCharts3 = echarts.init(me.$el3);
                me.myCharts3.showLoading();
                this.getData(pi[2], {date: me.$date2.val(),orgCode:  $("#orgCode1").ligerGetComboBoxManager().getValue() }, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart3(dataList);
                    }
                });
            },
            getChart4: function () {
                var me = this;
                me.myCharts4 = echarts.init(me.$el4);
                me.myCharts4.showLoading();
                this.getData(pi[3], {startDate: me.$startDate2.val(),endDate:me.$endDate2.val(),orgCode:  $("#orgCode2").ligerGetComboBoxManager().getValue() }, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        list4=res.detailModelList;
                        var obj = res.obj;
                        $("#total").html(obj.total+"/"+obj.total_es);
                        $("#total_rate").html(me.toDecimal(obj.total_rate)+"%");
                        $("#oupatient_total").html(obj.oupatient_total+"/"+obj.oupatient_total_es);
                        $("#oupatient_rate").html(me.toDecimal(obj.oupatient_rate)+"%");
                        $("#inpatient_total").html(obj.inpatient_total+"/"+obj.inpatient_total_es);
                        $("#inpatient_rate").html(me.toDecimal(obj.inpatient_rate)+"%");

                        $("#total_sc").html(obj.total+"/"+obj.total_sc);
                        $("#total_rate_sc").html(me.toDecimal(obj.total_rate_sc)+"%");
                        $("#oupatient_total_sc").html(obj.oupatient_total+"/"+obj.oupatient_total_sc);
                        $("#oupatient_rate_sc").html(me.toDecimal(obj.oupatient_rate_sc)+"%");
                        $("#inpatient_total_sc").html(obj.inpatient_total+"/"+obj.inpatient_total_sc);
                        $("#inpatient_rate_sc").html(me.toDecimal(obj.inpatient_rate_sc)+"%");
                        console.info(obj);
                        me.loadChart4(dataList);
                    }
                });
            },
            getChart5: function () {
                var me = this;
                me.myCharts5 = echarts.init(me.$el5);
                me.myCharts5.showLoading();
                this.getData(pi[4], {startDate: me.$startDate3.val(),endDate:me.$endDate3.val(),orgCode:  $("#orgCode3").ligerGetComboBoxManager().getValue() }, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        var obj = res.obj;
                        $("#total_time").html(obj.total+"/"+obj.total_es);
                        $("#total_rate_time").html(me.toDecimal(obj.total_rate)+"%");
                        $("#oupatient_total_time").html(obj.oupatient_total+"/"+obj.oupatient_total_es);
                        $("#oupatient_rate_time").html(me.toDecimal(obj.oupatient_rate)+"%");
                        $("#inpatient_total_time").html(obj.inpatient_total+"/"+obj.inpatient_total_es);
                        $("#inpatient_rate_time").html(me.toDecimal(obj.inpatient_rate)+"%");
                        me.loadChart5(dataList);
                    }
                });
            },
            getChart6: function () {
                var me = this;
                me.myCharts6 = echarts.init(me.$el6);
                me.myCharts6.showLoading();
                this.getData(pi[5], {date: me.$date3.val(), orgCode: $("#orgCode4").ligerGetComboBoxManager().getValue() }, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart6(dataList);
                    }
                });
            },
            loadChart1:function(data){
                var me = this;
                var xData=[];
                var data1=[];
                var data2=[];
                var data3=[];
                $.each(data,function (id1,item1) {
                    $.each(item1, function (key,value) {
                        xData.push(key);
                        $.each(value,function (id2,item2) {
                            data1.push(me.toZore(item2.waiting));
                            data2.push(me.toZore(item2.successful));
                            data3.push(item2.total);
                        });
                    });
                });
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['全部', '解析成功', '未解析']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 60
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
                            data : xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    series : [
                        {
                            name: '全部',
                            type:'bar',
                            barGap:2,
                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#28a9e6',
                                    lineStyle:{
                                        color:'#28a9e6'
                                    }
                                }
                            },
                            data: data3
                        },
                        {
                            name:'解析成功',
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
                            data:data2
                        },
                        {
                            name:'未解析',
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
                            data:data1
                        }
                    ]
                };
                me.myCharts1.on('click', function(param) {
                    me.$date1.ligerDateEditor("setValue",param.name);
                    me.getChart2();
                });
                me.myCharts1.hideLoading();
                me.myCharts1.setOption(option);
            },
            loadChart2:function(data){
                var me = this;
                var xData=[];
                var data1=[];
                var data2=[];
                var data3=[];
                var data4=[];
                $.each(data,function (id,item) {
                    xData.push(item.org_name);
                    data1.push(me.toZore(item.successful));
                    data2.push(me.toZore(item.waiting));
                    data3.push(item.total);
                    data4.push(me.toDecimal(item.rate));
                });
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['全部', '解析成功', '未解析','成功率']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 140
                    },
                    calculable : true,
                    yAxis : [
                        {
                            type : 'value',
                            name: '数量',
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
                        },
                        {
                            type : 'value',
                            name: '成功率',
                            min: 0,
                            max: 100,
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
                                show:false
                            },
                            splitArea: {show:false},
                            axisLabel: {
                                formatter: '{value} %',
                                show:true,
                                textStyle:{
                                color: '#909090',
                                    fontSize:14
                            }}
                        }
                    ],
                    xAxis : [
                        {
                            type : 'category',
                            data : xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            axisLabel: {
                                rotate:-40,
                                interval:0,
                                formatter : function(params){
                                    var newParamsName = "";
                                    var paramsNameNumber = params.length;
                                    var provideNumber = 10;
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
                            name: '全部',
                            type:'bar',
                            barGap:2,
                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#28a9e6',
                                    lineStyle:{
                                        color:'#28a9e6'
                                    }
                                }
                            },
                            data: data3
                        },
                        {
                            name:'解析成功',
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
                            data:data1
                        },
                        {
                            name:'未解析',
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
                            data:data2
                        },
                        {
                            name:'成功率',
                            type:'line',
                            yAxisIndex: 1,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#9c9af4',
                                    lineStyle:{
                                        color:'#9c9af4'
                                    }
                                }
                            },
                            data:data4
                        }
                    ]
                };
                me.myCharts2.hideLoading();
                me.myCharts2.setOption(option);
            },
            loadChart3:function(data){
                var me = this;
                var xData=[];
                var data1=[];
                var data2=[];
                var data3=[];
                var data4=[];
                $.each(data,function (id,item) {
                    xData.push(item.ed);
                    data1.push(me.toZore(item.inpatient_total));
                    data2.push(me.toZore(item.oupatient_total));
                    data3.push(item.inpatient_inc);
                    data4.push(item.oupatient_inc);
                });
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['住院', '门诊', '新增住院','新增门诊']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 80
                    },
                    dataZoom: [
                        {
                            show: true,
                            start: 94,
                            end: 100,
                            bottom:"20"
                        },
                        {
                            type: 'inside',
                            start: 94,
                            end: 100
                        }
                    ],
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
                            data : xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    series : [
                        {
                            name: '住院',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#28a9e6',
                                    lineStyle:{
                                        color:'#28a9e6'
                                    }
                                }
                            },
                            data: data1
                        },
                        {
                            name:'门诊',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#44d4ca',
                                    lineStyle:{
                                        color:'#44d4ca'
                                    }
                                }
                            },
                            data:data2
                        },
                        {
                            name:'新增住院',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#FFBD5C',
                                    lineStyle:{
                                        color:'#FFBD5C'
                                    }
                                }
                            },
                            data:data3
                        },
                        {
                            name:'新增门诊',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#9c9af4',
                                    lineStyle:{
                                        color:'#9c9af4'
                                    }
                                }
                            },
                            data:data4
                        }
                    ]
                };
                me.myCharts3.hideLoading();
                me.myCharts3.setOption(option);
            },
            loadChart4:function(data){
                var me = this;
                var xData=[];
                var data1=[];
                var data2=[];
                var data3=[];
                var data4=[];
                var data5=[];
                var data6=[];
                $.each(data,function (id,item) {
                    $.each(item, function (key,value) {
                        xData.push(key);
                        if($("#chart4-head .div-items.active").index()==0){
                            data1.push(me.toDecimal(value.total_rate));
                            data2.push(me.toDecimal(value.oupatient_rate));
                            data3.push(me.toDecimal(value.inpatient_rate));
                        }else{
                            data1.push(me.toDecimal(value.total_rate_sc));
                            data2.push(me.toDecimal(value.oupatient_rate_sc));
                            data3.push(me.toDecimal(value.inpatient_rate_sc));
                        }
                    });
                });
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['就诊人次', '门诊人次','住院人次']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 80
                    },
                    calculable : true,
                    yAxis : [
                        {
                            type : 'value',
                            min: 0,
                            max: 100,
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
                            axisLabel: {
                                show:true,
                                formatter: '{value} %',
                                textStyle:{
                                color: '#909090',
                                fontSize:14
                            }}
                        }
                    ],
                    xAxis : [
                        {
                            type : 'category',
                            data : xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    series : [
                        {
                            name: '就诊人次',
                            type:'line',
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#FFBD5C',
                                    lineStyle:{
                                        color:'#FFBD5C'
                                    }
                                }
                            },
                            data: data1
                        },
                        {
                            name:'门诊人次',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#44d4ca',
                                    lineStyle:{
                                        color:'#44d4ca'
                                    }
                                }
                            },
                            data:data2
                        },
                        {
                            name:'住院人次',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#28a9e6',
                                    lineStyle:{
                                        color:'#28a9e6'
                                    }
                                }
                            },
                            data:data3
                        }
                    ]
                };
                me.myCharts4.hideLoading();
                me.myCharts4.setOption(option);
            },
            loadChart5:function(data){
                var me = this;
                var xData=[];
                var data1=[];
                var data2=[];
                var data3=[];
                var data4=[];
                var data5=[];
                var data6=[];
                $.each(data,function (id,item) {
                    $.each(item, function (key,value) {
                        xData.push(key);
                        if($("#chart4-head .div-items.active").index()==0){
                            data1.push(me.toDecimal(value.total_rate));
                            data2.push(me.toDecimal(value.oupatient_rate));
                            data3.push(me.toDecimal(value.inpatient_rate));
                        }else{
                            data1.push(me.toDecimal(value.total_rate_sc));
                            data2.push(me.toDecimal(value.oupatient_rate_sc));
                            data3.push(me.toDecimal(value.inpatient_rate_sc));
                        }
                    });
                });
                var option = {
                    tooltip : {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data:['就诊人次', '门诊人次','住院人次']
                    },
                    grid: {
                        borderWidth:0,
                        y2: 80
                    },
                    calculable : true,
                    yAxis : [
                        {
                            type : 'value',
                            min: 0,
                            max: 100,
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
                            axisLabel: {
                                show:true,
                                formatter: '{value} %',
                                textStyle:{
                                color: '#909090',
                                fontSize:14
                            }}
                        }
                    ],
                    xAxis : [
                        {
                            type : 'category',
                            data : xData,
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            splitArea: {show:false},
                            splitLine: {show:false}
                        }
                    ],
                    series : [
                        {
                            name: '就诊人次',
                            type:'line',
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#FFBD5C',
                                    lineStyle:{
                                        color:'#FFBD5C'
                                    }
                                }
                            },
                            data: data1
                        },
                        {
                            name:'门诊人次',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#44d4ca',
                                    lineStyle:{
                                        color:'#44d4ca'
                                    }
                                }
                            },
                            data:data2
                        },
                        {
                            name:'住院人次',
                            type:'line',
//                            barGap:2,
//                            barMaxWidth:6,
                            itemStyle : {
                                normal : {
                                    barBorderRadius:[6],
                                    color:'#28a9e6',
                                    lineStyle:{
                                        color:'#28a9e6'
                                    }
                                }
                            },
                            data:data3
                        }
                    ]
                };
                me.myCharts5.hideLoading();
                me.myCharts5.setOption(option);
            },
            loadChart6:function(data){
                var colors=["#EE9A13","#F8C400","#EFEE00","#EFEE00","#1EA839","#68B92E","#9DCD17","#B5DFF8","#D7EDFB","#EDF6FD","#901D78","#96C6EA","#BA72A4","#BBB4D6","#D9C7DF","#00AA90","#00AA90","#61BBA1","#7CC5B1","#E4EC65","#E3EF8D","#E6EA00","#D5649A","#DCA89A","#D4561B","#E2AA99","#138A6A","#739C5A","#3FB3B2","#B7DCB1","#F09B4A","#59BBD8","#76C5E6","#B4DEEC","#95D0DE","#B6DEDE","#A1A6A2","#E46713","#EE9A13","#F8C400","#EFEE00","#1EA839","#68B92E","#9DCD17","#B5DFF8","#D7EDFB","#EDF6FD","#901D78","#96C6EA","#BA72A4","#BBB4D6","#D9C7DF","#00AA90","#61BBA1","#7CC5B1","#E4EC65","#E3EF8D","#EDF4CA","#E6EA00","#D5649A","#DCA89A","#D4561B","#D66543","#E2AA99","#138A6A","#418F68","#739C5A","#389688","#3FB3B2","#B7DCB1","#F09B4A","#59BBD8","#76C5E6","#B4DEEC","#95D0DE","#B6DEDE","#A1A6A2"];
                console.info(colors.length);
                var me = this;
                var list=[];
                if (data!=null&&data.length>0){
                    $("#grid").show();
                }
                var html=[];
                $.each(data,function (id,item) {
                    var obj = {};
                    obj.value = item.row;
                    obj.name = item.dataSet;
                    list.push(obj);
                   html.push('<tr>');
                   html.push('<td align="center"><div style="background:'+colors[id]+';width:20px;height:10px;margin:5px auto;"></div></td>');
                   html.push('<td>'+item.dataSet+'</td>');
                   html.push('<td>'+item.count+'</td>');
                   html.push('<td>'+item.row+'</td>');
                   html.push( '</tr>');
                });
                $("#grid tbody").html(html.join(""));
                var option = {
                    tooltip: {
                        trigger: 'item',
                        formatter: "{b}<br/> {c} ({d}%)"
                    },
                    color: colors,
                    series: [
                        {
                            type:'pie',
                            radius: ['20%', '80%'],
                            avoidLabelOverlap: false,
                            label: {
                                normal: {
                                    show: false,
                                    position: 'center'
                                }
                            },
                            labelLine: {
                                normal: {
                                    show: false
                                }
                            },
                            data:list
                        }
                    ]
                };
                me.myCharts6.hideLoading();
                me.myCharts6.setOption(option);
            },
            bindEvents: function () {
                var me = this;
                window.onresize = function () {
                    me.myCharts1.resize();
                    me.myCharts2.resize();
                    me.myCharts3.resize();
                };
                me.$searchBtn.click(function () {
                    if(me.$startDate1.val()==""){
                        parent._LIGERDIALOG.error('请选择开始日期');
                        return false;
                    }
                    if(me.$endDate1.val()==""){
                        parent._LIGERDIALOG.error('请选择结束日期');
                        return false;
                    }
                    me.getChart1();//所有指标统计结果查询,初始化查询
                });
                me.$searchBtn1.click(function () {
                    if(me.$date1.val()==""){
                        parent._LIGERDIALOG.error('请选择查询日期');
                        return false;
                    }
                    me.getChart2();//所有指标统计结果查询,初始化查询
                });
                me.$searchBtn2.click(function () {
                    if(me.$date2.val()==""){
                        parent._LIGERDIALOG.error('请选择查询日期');
                        return false;
                    }
                    me.getChart3();//所有指标统计结果查询,初始化查询
                });
                me.$searchBtn3.click(function () {
                    if(me.$startDate2.val()==""){
                        parent._LIGERDIALOG.error('请选择开始日期');
                        return false;
                    }
                    if(me.$endDate2.val()==""){
                        parent._LIGERDIALOG.error('请选择结束日期');
                        return false;
                    }
                    me.getChart4();//所有指标统计结果查询,初始化查询
                });
                me.$searchBtn4.click(function () {
                    if(me.$startDate3.val()==""){
                        parent._LIGERDIALOG.error('请选择开始日期');
                        return false;
                    }
                    if(me.$endDate3.val()==""){
                        parent._LIGERDIALOG.error('请选择结束日期');
                        return false;
                    }
                    me.getChart5();//所有指标统计结果查询,初始化查询
                });
                me.$searchBtn5.click(function () {
                    if(me.$date3.val()==""){
                        parent._LIGERDIALOG.error('请选择开始日期');
                        return false;
                    }
                    me.getChart6();//所有指标统计结果查询,初始化查询
                });
                $("#chart4-head .div-items").click(function () {
                    if(!$(this).hasClass("active")){
                        $(this).addClass("active");
                        $(this).siblings().removeClass("active");
                        me.loadChart4(list4);
                    }
                });
            },
            toZore: function (param) {
                if (param == null || typeof param == 'undefined') {
                    param = 0;
                }
                return param;
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
            },
            toDecimal:function (x) {
                var f = parseFloat(x);
                if (isNaN(f)) {
                    return;
                }
                f = Math.round(x * 100) / 100;
                return f;
            },
            getCurrentMonthFirst:function(){
                var date_ = new Date();
                var year = date_.getFullYear();
                var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                var firstdate = year + '-' + month + '-01';
                return firstdate;
            },
            getSevenDays:function(){
                var date_ = new Date();
                date_ = date_.valueOf();
                date_ = date_ - 7 * 24 * 60 * 60 * 1000
                date_ = new Date(date_);
                var year = date_.getFullYear();
                var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                var day = date_.getDate()<10?"0"+date_.getDate():date_.getDate();
                var firstdate = year + '-' + month + '-'+ day;
                return firstdate;
            },
            getCurrentDate:function(){
                var date_ = new Date();
                var year = date_.getFullYear();
                var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                var day = date_.getDate()<10?"0"+date_.getDate():date_.getDate();
                var currentDate = year + '-' + month + '-' + day;
                return currentDate;
            }
        };
        mh.init();
        window._LIGERDIALOG = $.ligerDialog;
        window._OPENDIALOG = function (url, title, width, height, parms, opts) {
            return openDialog(url, title, width, height, parms, opts)
        };
        window._UNIQDEL = function (gtGrid, findFunc, url, ids, code, idField, opration, warnMsg) {
            uniqDel(gtGrid, findFunc, url, ids, code, idField, opration, warnMsg);
        }
    });
</script>