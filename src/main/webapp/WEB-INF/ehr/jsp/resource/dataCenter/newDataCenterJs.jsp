<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script>
    var int = [
        '${contextRoot}/resourceCenter/getPatientArchiveCount',//居民建档数
        '${contextRoot}/resourceCenter/getMedicalResourcesCount',//医疗资源建档数
        '${contextRoot}/resourceCenter/getHealthArchiveCount',//健康档案建档数
        '${contextRoot}/resourceCenter/getElectronicCasesCount',//电子病例建档数
        '${contextRoot}/resourceCenter/getHealthCardBindingAmount',//健康卡绑定量
        '${contextRoot}/resourceCenter/getNewSituation',//新增情况
        '${contextRoot}/resourceCenter/getOrgArchives',//医疗机构建档分布
        '${contextRoot}/resourceCenter/getMedicalStaffDistribution',//医疗人员分布
        '${contextRoot}/resourceCenter/getMedicalStaffRatio',//医护人员比例
        '${contextRoot}/resourceCenter/getCumulativeIntegration',//累计整合档案数
        '${contextRoot}/resourceCenter/gteTotallyToBeIntegrated',//累计待整合档案数
        '${contextRoot}/resourceCenter/getArchiveSource',//档案来源分布情况
        '${contextRoot}/resourceCenter/getArchiveDistribution',//健康档案分布情况
        '${contextRoot}/resourceCenter/getStorageAnalysis',//健康档案入库情况分析
        '${contextRoot}/resourceCenter/getElectronicMedicalSource',//电子病例来源分布情况
        '${contextRoot}/resourceCenter/getElectronicMedicalOrgDistributed',//电子病历采集医院分布
        '${contextRoot}/resourceCenter/getElectronicMedicalDeptDistributed',//电子病历采集科室分布
        '${contextRoot}/resourceCenter/getElectronicMedicalAcquisitionSituation',//电子病历采集采集情况
        '${contextRoot}/resourceCenter/getInfoDistribution'//全员人口个案库 - 信息分布
    ];
    var chartArr = [
        document.getElementById('charts1'),
        document.getElementById('charts2'),
        document.getElementById('charts3'),
        document.getElementById('charts4'),
        document.getElementById('charts5'),
        document.getElementById('charts6'),
        document.getElementById('charts7'),
        document.getElementById('charts8'),
        document.getElementById('charts9'),
        document.getElementById('charts10'),
        document.getElementById('charts11'),
        document.getElementById('charts12'),
        document.getElementById('charts13')
    ];
    var echartsArr = [];
    var reqFun = function (url, data, cb) {
        return $.ajax({
            url: url,
            data: data || {},
//            async: false,
            type: 'GET',
            dataType: 'json',
            success: function (res) {
                cb && cb.call(this, res);
            },
            error: function () {
                console.log('error');
            }
        })
    };
    var newVM = avalon.define({
        $id: 'dataCenter',
        byNum: 0,
        mbNum: 0,
        jzNum: 0,
        zzNum: 0,
        ljzhNum: 0,
        ljdzhNum: 0,
        getData: function () {
            var me = this;
            $.when(reqFun(int[0], null,//居民建档数
                function (res) {
                    if (res.successFlg) {
                        me.byNum = res.obj;
                    }
                }
            ),reqFun(int[1], null,//医疗资源建档数
                function (res) {
                    if (res.successFlg) {
                        me.mbNum = res.obj;
                    }
                }
            ),reqFun(int[2], null,//健康档案建档数
                    function (res) {
                        if (res.successFlg) {
                            me.jzNum = res.obj;
                        }
                    }
            ),reqFun(int[3], null,//电子病例建档数
                    function (res) {
                        if (res.successFlg) {
                            me.zzNum = res.obj;
                        }
                    }
            )).done(function () {
                $.when(reqFun(int[4], null,//健康卡绑定量
                    function (res) {
                        if (res.successFlg) {
                            var option = {
                                tooltip : {
                                    trigger: 'item',
                                    formatter: "{a} <br/>{b} : {c} ({d}%)",
                                    position: function (point, params, dom, rect, size) {
                                        // 固定在顶部
                                        return [point[0], '10%'];
                                    }
                                },
                                title: {
                                    text: '健康卡绑定量\n\n' + res.detailModelList[0].dataModels[0].value,
                                    subtext: '',
                                    x: 'center',
                                    y: 'center',
                                    textStyle: {
                                        fontSize: 16,
                                        fontWeight: 'bolder',
                                        color: '#333'
                                    },
                                },
                                color: ['#ff88be','#56c5fc'],
                                series: [
                                    {
                                        name: '健康卡绑定情况',
                                        type: 'pie',
                                        selectedMode: 'single',
                                        radius: [80, 100],
                                        center: ['50%', '50%'],
                                        x: 'left',
                                        hoverAnimation: true,
                                        silent: true,
                                        itemStyle: {
                                            normal: {
                                                label: {
                                                    show: false
                                                },
                                                position: 'center',
                                                labelLine: {
                                                    show: false
                                                }
                                            }
                                        },
                                        data: res.detailModelList[0].dataModels
                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[0]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                ),reqFun(int[18], null,//人口个案信息分布
                    function (res) {
                        if (res.successFlg) {
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
//                                    formatter: function (params){
//                                        return params[0]['1'] + '（岁）：\n\n' + params[0]['2'] + '（人）';
//                                    }
                                },
                                grid: {
                                    x: 80,
                                    x2: 40,
                                    y: 30,
                                    y2: 30,
                                    borderWidth:0
                                },
                                color: ['#56c5fc'],
                                xAxis : [
                                    {
                                        type : 'category',
                                        name: "x",
                                        splitLine:{
                                            show:false
                                        },
                                        axisTick:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
                                        data : res.detailModelList[0].xData,
//                                        axisLabel: {
//                                            rotate: -40,
//                                            interval: 0,
//                                            show:true,
//                                            textStyle:{
//                                                color: '#909090',
//                                                fontSize:14,
//                                            }
//                                        }
                                    }
                                ],
                                yAxis : [
                                    {
                                        type : 'value',
                                        name : 'y',
                                        splitLine:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
//                                            axisLabel : {
//                                                formatter: '{value} ml'
//                                            }
                                    }
                                ],
                                series : [{
                                    name: '人口个案信息分布',
                                    type:'bar',
                                    barMaxWidth:25,
                                    data: res.detailModelList[0].yData
                                }]
                            };
                            var myChart = echarts.init(chartArr[1]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                ),reqFun(int[5], null,//新增情况
                    function (res) {
                        if (res.successFlg) {
                            var option = {
                                tooltip: {
                                    trigger: "item",
                                    formatter: "{a} <br/>{b} : {c}"
                                },
                                xAxis: [
                                    {
                                        type: "category",
                                        name: "x",
                                        data: res.detailModelList[0].xData,
                                        boundaryGap:false,
                                        splitLine: {show: false},
                                        axisTick:{show:false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                        axisLabel: {
//                                            rotate:40,
//                                            interval:0,
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
//                                            show:true,
                                            textStyle:{
                                                color: '#909090',
                                                fontSize:14,
                                            }
                                        }
                                    }
                                ],
                                yAxis: [
                                    {
                                        type: "value",
                                        name: "y",
                                        splitLine:{
                                            show:true,
                                            lineStyle: {
                                                color: '#e8edec',
                                                width: 1,
                                                type: 'dashed'
                                            }
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
                                    }
                                ],
                                color: ['#56c5fc'],
                                grid: {
                                    x: 100,
                                    x2: 40,
                                    y: 30,
                                    y2: 80,
                                    borderWidth:0
                                },
                                calculable: true,
                                series: [
                                    {
                                        name: res.detailModelList[0].name,
                                        type: "line",
                                        data: res.detailModelList[0].yData

                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[2]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                ),reqFun(int[6], null,//医疗机构建档分布
                    function (res) {
                        if (res.successFlg) {
                            var legendArr = [],
                                data = [];
                            $.each(res.detailModelList, function (k, o) {
                                legendArr.push(o.name);
                                data.push({
                                    name: o.name,
                                    type:'bar',
                                    data: o.yData
                                })
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
                                },
                                legend: {
                                    y : 'bottom',
                                    data: legendArr
                                },
                                color: ['#43baff','#70ecf8','#ff88be','#fed327','#49d2db'],
                                grid: {
                                    x: 80,
                                    x2: 40,
                                    y: 20,
                                    y2: 90,
                                    borderWidth:0
                                },
                                xAxis : [
                                    {
                                        type : 'category',
                                        name: "x",
                                        splitLine:{
                                            show:false
                                        },
                                        axisTick:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
                                        data : res.detailModelList[0].xData,
                                        axisLabel: {
                                            rotate: -40,
                                            interval: 0,
                                            show:true,
                                            textStyle:{
                                                color: '#909090',
                                                fontSize:14,
                                            }
                                        }
                                    }
                                ],
                                yAxis : [
                                    {
                                        type : 'value',
                                        name : 'y',
                                        splitLine:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
//                                        axisLabel : {
//                                            formatter: '{value} ml'
//                                        }
                                    }
                                ],
                                series : data
                            }
                        }
                        var myChart = echarts.init(chartArr[3]);
                        myChart.setOption(option);
                        echartsArr.push(myChart);
                    }
                ),reqFun(int[7], null,//医疗人员分布
                        function (res) {
                            if (res.successFlg) {
                                var data = [];
                                $.each(res.detailModelList, function (k, o) {
                                    data.push({
                                        name: o.name,
                                        type:'bar',
                                        barMaxWidth:25,
                                        data: o.yData
                                    })
                                });
                                var option =  {
                                    tooltip : {
                                        trigger: 'axis',
                                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                        }
                                    },
                                    color: ['#56c5fc','#1cd2bb'],
                                    grid: {
                                        x: 80,
                                        x2: 40,
                                        y: 30,
                                        y2: 40,
                                        borderWidth:0
                                    },
                                    xAxis : [
                                        {
                                            type : 'category',
                                            name: "x",
                                            splitLine:{
                                                show:false
                                            },
                                            axisTick:{
                                                show:false
                                            },
                                            axisLine:{
                                                lineStyle:{
                                                    color:'#333',
                                                    width:1
                                                }
                                            },
                                            data : res.detailModelList[0].xData
                                        }
                                    ],
                                    yAxis : [
                                        {
                                            type : 'value',
                                            name : 'y',
                                            splitLine:{
                                                show:false
                                            },
                                            axisLine:{
                                                lineStyle:{
                                                    color:'#333',
                                                    width:1
                                                }
                                            },
//                                            axisLabel : {
//                                                formatter: '{value} ml'
//                                            }
                                        }
                                    ],
                                    series : data
                                };
                                var myChart = echarts.init(chartArr[4]);
                                myChart.setOption(option);
                                echartsArr.push(myChart);
                            }
                        }
                ),reqFun(int[8], null,//医护人员比例
                        function (res) {
                            if (res.successFlg) {
                                var legendArr = [],
                                        data = [];
                                $.each(res.obj.dataModels, function (k, o) {
                                    legendArr.push(o.name);
                                    data.push(o);
                                });
                                var option ={
                                    tooltip : {
                                        trigger: 'item',
                                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                                    },
                                    legend: {
                                        orient: 'vertical',
                                        x: '75%',
                                        y: 'center',
                                        data: legendArr
                                    },
                                    color: ['#43baff','#70ecf8','#ff88be'],
                                    series : [
                                        {
                                            name: '医护人员比例',
                                            type: 'pie',
                                            radius : '55%',
                                            center: ['40%', '50%'],
                                            data: data,
                                            itemStyle: {
                                                normal : {
                                                    label : {
                                                        show : false
                                                    },
                                                    labelLine : {
                                                        show : false
                                                    }
                                                },
                                                emphasis: {
                                                    shadowBlur: 10,
                                                    shadowOffsetX: 0,
                                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                                }
                                            }
                                        }
                                    ]
                                };
                                var myChart = echarts.init(chartArr[5]);
                                myChart.setOption(option);
                                echartsArr.push(myChart);
                            }
                        }
                ),reqFun(int[11], null,//档案来源分布情况
                        function (res) {
                            if (res.successFlg) {
                                var legendArr = [],
                                        data = [];
                                $.each(res.detailModelList[0].dataModels, function (k, o) {
                                    legendArr.push(o.name);
                                    data.push(o);
                                });
                                var option ={
                                    tooltip : {
                                        trigger: 'item',
                                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                                    },
                                    legend: {
                                        orient: 'vertical',
                                        x: '70%',
                                        y: 'center',
                                        data: legendArr
                                    },
                                    color: ['#56c5fc','#fed327','#ff88be'],
                                    series : [
                                        {
                                            name: '档案来源分布情况',
                                            type: 'pie',
                                            radius : '55%',
                                            center: ['40%', '50%'],
                                            data: data,
                                            itemStyle: {
                                                normal : {
                                                    label : {
                                                        show : false
                                                    },
                                                    labelLine : {
                                                        show : false
                                                    }
                                                },
                                                emphasis: {
                                                    shadowBlur: 10,
                                                    shadowOffsetX: 0,
                                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                                }
                                            }
                                        }
                                    ]
                                };
                                var myChart = echarts.init(chartArr[6]);
                                myChart.setOption(option);
                                echartsArr.push(myChart);
                            }
                        }
                ),reqFun(int[9], null,//累计整合档案数
                    function (res) {
                        if (res.successFlg) {
                            me.ljzhNum = res.obj;
                        }
                    }
                ),reqFun(int[10], null,//累计待整合档案数
                        function (res) {
                            if (res.successFlg) {
                                me.ljdzhNum = res.obj;
                            }
                        }
                ),reqFun(int[12], null,//健康档案分布情况
                    function (res) {
                        if (res.successFlg) {
                            var legendArr = [],
                                    data = [];
                            $.each(res.detailModelList, function (k, o) {
                                legendArr.push(o.name);
                                data.push({
                                    name: o.name,
                                    type:'bar',
                                    barMaxWidth:25,
                                    stack:"sum",
                                    data: o.yData
                                })
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
//                                    formatter: function (params){
//                                        return params[0]['1'] + '（岁）：\n\n' + params[0]['2'] + '（人）';
//                                    }
                                },
                                legend: {
                                    y : 'bottom',
                                    data: legendArr
                                },
                                color: ['#56c5fc','#ff88be'],
                                grid: {
                                    x: 80,
                                    x2: 50,
                                    y: 30,
                                    y2: 70,
                                    borderWidth:0
                                },
                                xAxis : [
                                    {
                                        type : 'category',
                                        name: "x（岁）",
                                        splitLine:{
                                            show:false
                                        },
                                        axisTick:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
                                        data : res.detailModelList[0].xData,
                                        axisLabel: {
//                                            rotate: -40,
//                                            interval: 0,
                                            show:true,
                                            textStyle:{
                                                color: '#909090',
                                                fontSize:14,
                                            }
                                        }
                                    }
                                ],
                                yAxis : [
                                    {
                                        type : 'value',
                                        name : 'y',
                                        splitLine:{
                                            show:false
                                        },
                                        axisLine:{
                                            lineStyle:{
                                                color:'#333',
                                                width:1
                                            }
                                        },
//                                            axisLabel : {
//                                                formatter: '{value} ml'
//                                            }
                                    }
                                ],
                                series : data
                            };
                            var myChart = echarts.init(chartArr[7]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                )
                ,reqFun(int[13], null,//健康档案入库情况分析
                    function (res) {
                        if (res.successFlg) {
                            var legendArr = [],
                                    data = [];
                            $.each(res.detailModelList, function (k, o) {
                                legendArr.push(o.name);
                                data.push({
                                    name: o.name,
                                    type:'bar',
                                    data: o.yData
                                })
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
                                },
                                legend: {
                                    y : '90%',
                                    data: legendArr
                                },
                                color: ['#56c5fc','#ff88be'],
                                grid: {
                                    x: 80,
                                    x2: 40,
                                    y: 20,
                                    y2: 100,
                                    borderWidth:0
                                },
                                xAxis : [
                                    {
                                        type : 'category',
                                        name: "x",
                                        axisTick:{show:false},
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                        data : res.detailModelList[0].xData,
                                        axisLabel: {
//                                            rotate: 45,
//                                            interval: 0,
//                                            show:true,
                                            textStyle:{
                                                color: '#909090',
                                                fontSize:14,
                                            }
                                        }
                                    }
                                ],
                                yAxis : [
                                    {
                                        type : 'value',
                                        name : 'y',
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
//                                        axisLabel : {
//                                            formatter: '{value} ml'
//                                        }
                                    }
                                ],
                                series : data
                            }
                            var myChart = echarts.init(chartArr[8]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                )
                ,reqFun(int[14], null,//电子病历来源分布情况
                    function (res) {
                        if (res.successFlg) {
                            var legendArr = [],
                                    data = [];
                            $.each(res.detailModelList[0].dataModels, function (k, o) {
                                legendArr.push(o.name);
                                data.push(o);
                            });
                            var option ={
                                tooltip : {
                                    trigger: 'item',
                                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                                },
                                legend: {
                                    orient: 'vertical',
                                    x: '72%',
                                    y: 'center',
                                    data: legendArr
                                },
                                color: ['#56c5fc','#ff88be','#fed327','#49d2db'],
                                series : [
                                    {
                                        name: '电子病历来源分布情况',
                                        type: 'pie',
                                        radius : '55%',
                                        center: ['40%', '50%'],
                                        data: data,
                                        itemStyle: {
                                            normal : {
                                                label : {
                                                    show : false
                                                },
                                                labelLine : {
                                                    show : false
                                                }
                                            },
                                            emphasis: {
                                                shadowBlur: 10,
                                                shadowOffsetX: 0,
                                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                                            }
                                        }
                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[9]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                )
                ,reqFun(int[15], null,//电子病历采集医院分布
                    function (res) {
                        if (res.successFlg) {
                            var yData = [], data = [];
                            $.each(res.obj, function (k, o) {
                                yData.push(k);
                                data.push(o);
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
                                },
                                xAxis : [
                                    {
                                        type : 'value',
                                        boundaryGap : [0, 0.01],
                                        show: false,
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                    }
                                ],
                                dataZoom: {
                                    show: true,
                                    realtime: true,
                                    x: 10,
                                    fillerColor: '#bcbcbc',
                                    handleColor: '#bcbcbc',
                                    dataBackgroundColor: '#eee',
                                    orient:'vertical',
                                    showDetail: false,
//                                    height: 200,
                                    width: 10,
                                    start: 0,
                                    end: 90
                                },
                                color: ['#56c5fc'],
                                grid: {
                                    x: 150,
                                    x2: 30,
                                    y: 10,
                                    y2: 20,
                                    borderWidth:0
                                },
                                yAxis : [
                                    {
                                        type : 'category',
                                        data : yData,
                                        axisTick:{show:false},
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                        axisLabel :{
                                             formatter : function (value)
                                             {
                                                 var valueTxt = '';
                                                 if (value.length > 8) {
                                                        valueTxt = value.substring(0, 9) + '...';
                                                 }
                                                  else {
                                                          valueTxt = value;
                                                      }
                                                  return valueTxt ;
                                              }
                                        }
                                    }
                                ],
                                series : [
                                    {
                                        name:'电子病历采集医院分布',
                                        type:'bar',
                                        data: data,
                                        barMaxWidth:25,
                                        itemStyle: {normal: {
                                            label : {show: true, position: 'right'}
                                        }},
                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[10]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                )
                ,reqFun(int[16], null,//电子病历采集科室分布
                    function (res) {
                        if (res.successFlg) {
                            var yData = [], data = [];
                            $.each(res.obj, function (k, o) {
                                yData.push(k);
                                data.push(o);
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
                                },
                                xAxis : [
                                    {
                                        type : 'value',
                                        boundaryGap : [0, 0.01],
                                        show: false,
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                        axisLabel :{
                                            interval:0
                                        }
                                    }
                                ],
                                color: ['#56c5fc'],
                                dataZoom: {
                                    show: true,
                                    realtime: true,
                                    x: 10,
                                    fillerColor: '#bcbcbc',
                                    handleColor: '#bcbcbc',
                                    dataBackgroundColor: '#eee',
                                    orient:'vertical',
                                    showDetail: false,
//                                    height: 200,
                                    width: 10,
                                    start: 0,
                                    end: 20
                                },
                                grid: {
                                    x: 150,
                                    x2: 80,
                                    y: 10,
                                    y2: 20,
                                    borderWidth:0
                                },
                                yAxis : [
                                    {
                                        type : 'category',
                                        data : yData,
                                        axisTick:{show:false},
                                        splitLine: {show: false},
                                        axisLabel :{
                                            interval:0
                                        },
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1},
                                            axisLabel :{
                                                formatter : function (value)
                                                {
                                                    var valueTxt = '';
                                                    if (value.length > 8) {
                                                        valueTxt = value.substring(0, 9) + '...';
                                                    }
                                                    else {
                                                        valueTxt = value;
                                                    }
                                                    return valueTxt ;
                                                }
                                            }
                                        },
                                    }
                                ],
                                series : [
                                    {
                                        name:'电子病历采集科室分布',
                                        type:'bar',
                                        data: data,
                                        barMaxWidth:25,
                                        itemStyle: {normal: {
                                            label : {show: true, position: 'right'}
                                        }},
                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[11]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                ),reqFun(int[17], null,//电子病历采集采集情况
                    function (res) {
                        if (res.successFlg) {
                            var xData = [], data1 = [], data2 = [];
                            $.each(res.detailModelList[0], function (k, o) {
                                xData.push(k);
                                data1.push(o)
                            });
                            $.each(res.detailModelList[1], function (k, o) {
                                data2.push(o)
                            });
                            var option = {
                                tooltip : {
                                    trigger: 'axis',
                                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                                    }
                                },
                                calculable : true,
                                color: ['#56c5fc','#ff88be'],
                                grid: {
                                    x: 80,
                                    x2: 30,
                                    y: 30,
                                    y2: 100,
                                    borderWidth:0
                                },
                                xAxis : [
                                    {
                                        type : 'category',
                                        name: 'x',
                                        data : xData,
                                        axisTick:{show:false},
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                        axisLabel: {
//                                            rotate: 90,
//                                            interval: 0,
//                                            show:true,
                                            textStyle:{
                                                color: '#909090',
                                                fontSize:14,
                                            }
                                        }
                                    }
                                ],
                                yAxis : [
                                    {
                                        name: 'y',
                                        type : 'value',
                                        splitLine: {show: false},
                                        axisLine:{
                                            lineStyle:{color:'#333', width:1}
                                        },
                                    }
                                ],
                                series : [
                                    {
                                        name:'门诊病历',
                                        type:'bar',
                                        barMaxWidth:25,
                                        stack:"sum",
                                        data: data1
                                    },
                                    {
                                        name:'住院病历',
                                        stack:"sum",
                                        barMaxWidth:25,
                                        type:'bar',
                                        data: data2
                                    }
                                ]
                            };
                            var myChart = echarts.init(chartArr[12]);
                            myChart.setOption(option);
                            echartsArr.push(myChart);
                        }
                    }
                ));
            })
        }
    });
    newVM.$watch('onReady', function(){
        newVM.getData();
    });
    $(window).on('resize',function () {
        if (st) {
            clearTimeout(st);
        }
        var st = setTimeout(function () {
            $.each(echartsArr, function (k, o) {
                if (o.resize) {
                    o.resize();
                }
            })
        }, 100);
    });
    var pos={"div1":$("#div1").offset().top-165,"div2":$("#div2").offset().top-165,"div3":$("#div3").offset().top-165,"div4":$("#div4").offset().top-165};
    $(".smooth").click(function(){
        debugger
        var id = $(this).attr("data-id");
        for(var p in pos){
            if(p==id){
                console.log(id+" "+pos[p])
                $("#contentPage").animate({scrollTop: pos[p]}, 1000);
            }
        }
        return false;
    });
</script>