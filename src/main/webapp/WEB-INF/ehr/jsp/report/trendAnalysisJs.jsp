<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var adapterGrid = null;
            var adapterDataSet = null;
            var adapterType = 21;
            var searchOrg;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $startDate:$("#inp_start_date"),
                $endDate:$("#inp_end_date"),
                $addDetail: $('#btn_detail'),
                init: function () {
                    var self = this;
                    self.$startDate.ligerDateEditor({format: "yyyy-MM-dd"});
                    self.$endDate.ligerDateEditor({format: "yyyy-MM-dd"});
                    self.$element.show();
                    self.$element.attrScan();
                    self.bindEvents();
                    self.drawChart();
                },
                bindEvents: function () {
                    var self = this;
                    //趋势分析详情
                    retrieve.$addDetail.click(function () {
                        var url = '${contextRoot}/report/analysisList';
                        $("#contentPage").load(url);
                    });
                },
                drawChart: function(){
                    var myChart = echarts.init(document.getElementById("chart-main"));
                    var option = {
                        tooltip : {
                            trigger: 'axis',
                            formatter: function (data) {
                                var res = "";
                                for(var i=0;i<data.length;i++){
                                    if(i==0) res += data[i].name+"<br/>";
                                    res+=data[i].series.name+" : "+data[i].value;
                                    if(data[i].series.name=="同比" || data[i].series.name=="环比"){
                                        res+= '%';
                                    }
                                    res+="<br/>";
                                }
                                return res;
                            }
                        },
                        legend: {
                            x: 'center',
                            y: 'bottom',
                            data:['整体数量','同比','环比']
                        },
                        calculable : true,
                        grid: {x:60,y: 30,borderWidth:0},
                        xAxis : {
                            data : ['4月1日','4月2日','4月3日','4月4日','4月5日','4月6日','4月7日','4月8日','4月9日','4月10日'],
                            axisLine : {    // 轴线
                                show: true,
                                lineStyle: {
                                    color: '#dcdcdc',
                                    width: 1
                                }
                            },
                            axisTick: {show:false},
                            axisLabel: {show:true},
                            splitArea: {show:false},
                            splitLine: {show:true}
                        },
                        yAxis : [
                            {
                                type : 'value',
                                position: 'left',
                                boundaryGap: [0,0.1],
                                axisLine : {    // 轴线
                                    show: false
                                },
                                axisTick : {    // 轴标记
                                    show:false
                                },
                                axisLabel : {
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
                                splitArea : {
                                    show: true,
                                    areaStyle:{
                                        color:['rgba(255,255,255,0.3)','rgba(255,255,255,0.3)']
                                    }
                                }
                            },
                            {
                                type : 'value',
                                splitNumber: 10,
                                axisLabel : {
                                    show: false,
                                    formatter: function (value) {
                                        return value + '%'
                                    }
                                },
                                axisLine : {    // 轴线
                                    show: false
                                },
                                splitLine : {
                                    show: false
                                },
                                splitArea : {
                                    show: true,
                                    areaStyle:{
                                        color:['rgba(255,255,255,0.3)','rgba(255,255,255,0.3)']
                                    }
                                }
                            }
                        ],
                        series : [
                            {
                                name:'整体数量',
                                type:'bar',
                                itemStyle: {
                                    normal: {
                                        color: '#4DB2EE',
                                        label : {
                                            show: true, position: 'insideTop'
                                        }
                                    }
                                },
                                data:[320,332, 301, 334, 790, 330, 320,790, 330, 320]
                            },
                            {
                                name:'同比',
                                type: 'line',
                                yAxisIndex: 1,
                                itemStyle: {
                                    normal: {
                                        color: '#83C44E',
                                        label : {
                                            show: false, position: 'top',
                                            formatter: function (data) {
                                                return data.value + '%'
                                            }
                                        }
                                    }
                                },
                                data: [50, 37.5, 62.5, 100, 70, 60, 50, 70, 60, 50]
                            },
                            {
                                name:'环比',
                                type: 'line',
                                yAxisIndex: 1,
                                itemStyle: {
                                    normal: {
                                        color: '#ED5050',
                                        label : {
                                            show: false, position: 'left',
                                            formatter: function (data) {
                                                return data.value + '%'
                                            }
                                        }
                                    }
                                },
                                data: [60, 47.5, 72.5, 100, 80, 70, 60, 70, 60, 50]
                            }


                        ]
                    };

                    myChart.setOption(option);

                }
            };

            /* *************************** 页面功能 **************************** */
            pageInit();

        });
    })(jQuery, window);

</script>