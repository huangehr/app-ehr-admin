<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var chartData = null;
            var recordCount = 10;//一页显示几条数据
            var currentIndex = 0;//第一页
            var isInit = true;//是否是初始化加载

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
                    self.$startDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                            if(value){
                                self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
                            }
                    }});
                    self.$endDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                        if(value){
                            self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
                        }
                    }});
                    self.$startDate.ligerDateEditor("setValue",$("#inp_startTime").val());
                    self.$endDate.ligerDateEditor("setValue",$("#inp_endTime").val());
                    $(".div-title").html($("#inp_orgName").val());
                    self.$element.show();
                    self.$element.attrScan();
                    self.bindEvents();
                    self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
                },
                getQcOverAllIntegrity:function(){
                    var self = this;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcOverAllOrgIntegrity', {
                        data: {location: $("#inp_location").val(),orgCode:$("#inp_orgCode").val(),startTime:self.$startDate.val(),endTime:self.$endDate.val()},
                        success: function (data) {
                            if(data.successFlg){
                                var list = data.detailModelList;
                                var activeIndex = 0;
                                for(var i=0;i<list.length;i++){
                                    var item =  $(".div-item").eq(i);
                                    if($("#inp_quotaId").val()==list[i].quotaId && isInit){
                                        activeIndex = i;
                                        isInit = false;
                                    }
                                    item.attr("data-quotaId",list[i].quotaId).attr("data-index",i);
                                    item.find("span").html(list[i].value);
                                    item.find(".div-item-count").html(list[i].realNum+"/"+list[i].totalNum);
                                }
                                if($(".div-head").find(".div-item.active").length>0){
                                    activeIndex = $(".div-head").find(".div-item.active").attr("data-index");
                                }
                                $(".div-head").find(".div-item").eq(activeIndex).trigger("click");
                            }
                        }
                    });
                },
                bindEvents: function () {
                    var self = this;

                    $(".div-head").on("click",".div-item",function(){
                        var quotaId = $(this).attr("data-quotaId");
                        $(".div-head").find(".div-item").removeClass("active");
                        $(this).addClass("active");
                        debugger
                        self.getChartData(quotaId);//趋势分析 -按区域列表查询,按日初始化查询
                    });
                    //左切换
                    $(".div-zuoqiehuan").on("click",function(){
                        if(currentIndex==0){
                            $.Notice.success('暂无更多数据');
                            return false;
                        }
                        currentIndex--;
                        self.drawChart(chartData.eventTimeData[currentIndex] ,chartData.valueData[currentIndex],chartData.anData[currentIndex],chartData.momData[currentIndex]);
                    });
                    //右切换
                    $(".div-youqiehuan").on("click",function(){
                        if(currentIndex==(Object.keys(chartData.eventTimeData).length-1)){
                            $.Notice.success('暂无更多数据');
                            return false;
                        }
                        currentIndex++;
                        self.drawChart(chartData.eventTimeData[currentIndex] ,chartData.valueData[currentIndex],chartData.anData[currentIndex],chartData.momData[currentIndex]);
                    });

                    $(".div-organization-content").on("click",".div-organization .div-hospital-item",function(){
                        $.Notice.waitting('加载中...');
                    })
                },
                getChartData:function(quotaId){
                    debugger
                    var self = retrieve;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcQuotaOrgIntegrity', {
                        data: {orgCode:$("#inp_orgCode").val(),quotaId:quotaId,startTime:self.$startDate.val(),endTime:self.$endDate.val()},
                        success: function (data) {
                            if(data.successFlg){
                                var list = data.detailModelList;
                                var eventTimeList = [];
                                var valueList = [];
                                var anList = [];
                                var momList = [];
                                var eventTimeData = [],valueData = [],anData = [],momData = [];
                                for(var i=0;i<list.length;i++){
                                    var item = list[i];
                                    eventTimeList.push(item.eventTime.substring(5,11));
                                    valueList.push(item.value.replace("%",""));
                                    anList.push(item.an.replace("%",""));
                                    momList.push(item.mom.replace("%",""));
                                }
                                if(eventTimeList.length>0){
                                     eventTimeData = _.groupBy(eventTimeList,function(item,i){return Math.floor(i/recordCount)});
                                     valueData = _.groupBy(valueList,function(item,i){return Math.floor(i/recordCount)});
                                     anData = _.groupBy(anList,function(item,i){return Math.floor(i/recordCount)});
                                     momData = _.groupBy(momList,function(item,i){return Math.floor(i/recordCount)});
                                    self.drawChart(eventTimeData[currentIndex] ,valueData[currentIndex],anData[currentIndex],momData[currentIndex]);
                                }else{
                                    self.drawChart([],[],[],[]);
                                }
                                chartData = {eventTimeData:eventTimeData,valueData:valueData,anData:anData,momData:momData};

                            }
                        }
                    });
                },
                drawChart: function(eventTimeList,valueList,anList,momList){
                    var myChart = echarts.init(document.getElementById("chart-main"));
                    var option = {
                        tooltip : {
                            trigger: 'axis',
                            formatter: function (data) {
                                var res = "";
                                for(var i=0;i<data.length;i++){
                                    if(i==0) res += data[i].name+"<br/>";
                                    res+=data[i].series.name+" : "+data[i].value+ '%<br/>';
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
                            data : eventTimeList,
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
                                splitNumber: 10,
                                max:100,
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
                                max:100,
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
                                            show: true, position: 'insideTop',
                                            formatter: function (data) {
                                                return data.value + '%';
                                            }
                                        }
                                    }
                                },
                                data:valueList
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
                                                return data.value + '%';
                                            }
                                        }
                                    }
                                },
                                data: anList
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
                                                return data.value + '%';
                                            }
                                        }
                                    }
                                },
                                data: momList
                            }


                        ]
                    };

                    myChart.setOption(option);

                },
                getCurrentMonthFirst:function(){
                    var date_ = new Date();
                    var year = date_.getFullYear();
                    var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                    var firstdate = year + '-' + month + '-01';
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

            /* *************************** 页面功能 **************************** */
            pageInit();

        });
    })(jQuery, window);

</script>
<script type="text/javascript" src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>