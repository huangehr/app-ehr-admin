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
            '${contextRoot}/resourcesStatistics/stasticReport/getArchivesInc'
        ];

        var mh = {
            rtLen: 0,
            $el1: document.getElementById("chart1"),
            $el2: document.getElementById("chart2"),
            $el3: document.getElementById("chart3"),
            $startDate:$("#inp_start_date"),
            $endDate:$("#inp_end_date"),
            $date:$("#date"),
            $searchBtn: $('#btn_search'),
            $search: $('#search'),
            $orgCode: $('#orgCode'),
            myCharts1: null,
            myCharts2: null,
            myCharts3: null,
            init: function () {
                var me = this;
                var url = '${contextRoot}/deptMember/getHospitalList';
                this.$orgCode.customCombo(url);
                me.$startDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$endDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$date.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
                me.$startDate.ligerDateEditor("setValue",me.getSevenDays());
                me.$endDate.ligerDateEditor("setValue",me.getCurrentDate());
                me.$date.ligerDateEditor("setValue",me.getCurrentDate());
                Promise.all([
                    me.getChart1(),
                    me.getChart2(me.getCurrentDate()),
                    me.getChart3()
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
                this.getData(pi[0], {startDate: me.$startDate.val(),endDate:me.$endDate.val()}, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart1(dataList);
                    }
                });
            },
            getChart2: function (date) {
                var me = this;
                me.myCharts2 = echarts.init(me.$el2);
                me.myCharts2.showLoading();
                this.getData(pi[1], {date:date}, function (res) {
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
                this.getData(pi[2], {date: me.$date.val(),orgCode:  $("#orgCode").ligerGetComboBoxManager().getValue() }, function (res) {
                    if (res.successFlg) {
                        var dataList = res.detailModelList;
                        me.loadChart3(dataList);
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
                            data1.push(me.toZore(item2.num1));
                            data2.push(me.toZore(item2.num2));
                            data3.push(item2.num3);
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
                        }
                    ]
                };
                me.myCharts1.on('click', function(param) {
                    me.getChart2(param.name);
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
            bindEvents: function () {
                var me = this;
                window.onresize = function () {
                    me.myCharts1.resize();
                    me.myCharts2.resize();
                    me.myCharts3.resize();
                };
                me.$searchBtn.click(function () {
                    if(me.$startDate.val()==""){
                        parent._LIGERDIALOG.error('请选择开始日期');
                        return false;
                    }
                    if(me.$endDate.val()==""){
                        parent._LIGERDIALOG.error('请选择结束日期');
                        return false;
                    }
                    me.getChart1();//所有指标统计结果查询,初始化查询
                });
                me.$search.click(function () {
                    if(me.$date.val()==""){
                        parent._LIGERDIALOG.error('请选择查询日期');
                        return false;
                    }
                    me.getChart3();//所有指标统计结果查询,初始化查询
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