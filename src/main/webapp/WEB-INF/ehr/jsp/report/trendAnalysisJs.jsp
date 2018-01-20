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
            var location = "350200";

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }
//添加碎片
            function appendNav(str, url, data) {
                $('#navLink').append('<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
            }
            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $startDate:$("#inp_start_date"),
                $endDate:$("#inp_end_date"),
                $addDetail: $('#btn_detail'),
                $location: $('#inp_orgArea'),
                $searchBtn: $('#btn_search'),
                init: function () {
                    var self = this;
                    self.$startDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
//                            if(value){
//                                self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
//                            }
                    }});
                    self.$endDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
//                        if(value){
//                            self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
//                        }
                    }});
                    self.$startDate.ligerDateEditor("setValue",self.getCurrentMonthFirst());
                    self.$endDate.ligerDateEditor("setValue",self.getCurrentDate());
                    self.$location.addressDropdown({
                        tabsData: [
                            {
                                name: '省份',
                                code: 'id',
                                value: 'name',
                                url: '${contextRoot}/address/getParent',
                                params: {level: '1'}
                            },
                            {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                            {name: '县区', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'}
                        ],
                        placeholder:"请选择地区"
                    });
                    self.$element.show();
                    self.$element.attrScan();
                   setTimeout(function(){
                       self.$element.Fields.location.setValue(["江西省", "上饶市", "", ""]);
                   },500);
                    self.bindEvents();
                    self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
                },
                getQcOverAllIntegrity:function(){
                    var self = this;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcOverAllIntegrity', {
                        data: {location: location,startTime:self.$startDate.val(),endTime:self.$endDate.val()},
                        success: function (data) {
                            if(data.successFlg){
                                var list = data.detailModelList;
                                for(var i=0;i<list.length;i++){
                                    var item =  $(".div-item").eq(i);
                                    item.attr("data-quotaId",list[i].quotaId).attr("data-index",i);;
                                    item.find("span").html(list[i].value);
                                    item.find(".div-item-count").html(list[i].realNum+"/"+list[i].totalNum);
                                }
                                var activeIndex = 0;
                                if($(".div-head").find(".div-item.active").length>0){
                                    activeIndex = $(".div-head").find(".div-item.active").attr("data-index");
                                }
                                $(".div-head").find(".div-item").eq(activeIndex).trigger("click");
                            }else{
                                $(".div-head").find(".div-item").each(function(index,ele){
                                    $(ele).find("span").html("0.00%");
                                    $(ele).find(".div-item-count").html("0/0");
                                })
                                self.drawChart([],[],[],[]);
                                $(".div-organization-content").html("");
                                chartData = null;
                            }
                        }
                    });
                },
                bindEvents: function () {
                    var self = this;
                    self.$searchBtn.click(function () {
                        if(self.$startDate.val()==""){
                            parent._LIGERDIALOG.error('请选择查询的开始时间');
                            return false;
                        }
                        if(self.$endDate.val()==""){
                            parent._LIGERDIALOG.error('请选择查询的结束时间');
                            return false;
                        }
                        var orgAddress = retrieve.$element.Fields.location.getValue();
                        var orgName = orgAddress.names.toString().replace(/,/g,'');
                        if(orgName==""){
                            parent._LIGERDIALOG.error('请选择地区');
                            return false;
//                            orgName = "福建省厦门市";
//                            location = "350200";
//                            self.$element.Fields.location.setValue(["福建省", "厦门市", "", ""]);
                        }else{
                            var keysArr = orgAddress.keys;
                            var namesArr = orgAddress.names;
                            for (var i = keysArr.length - 1;  i >0; i--) {
                                if (keysArr[i] === "") {
                                    keysArr.splice(i, 1);
                                    namesArr.splice(i, 1);
                                }
                            }
                            location = orgAddress.keys[orgAddress.keys.length-1];
                        }
                        $(".span-location").html(orgName);
                        self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
                    });

                    //趋势分析详情
                    retrieve.$addDetail.click(function () {
                        if(self.$startDate.val()==""){
                            parent._LIGERDIALOG.error('请选择查询的开始时间');
                            return false;
                        }
                        if(self.$endDate.val()==""){
                            parent._LIGERDIALOG.error('请选择查询的结束时间');
                            return false;
                        }
                        var orgAddress = retrieve.$element.Fields.location.getValue();
                        var orgName = orgAddress.names.toString().replace(/,/g,'');
                        if(orgName==""){
                            parent._LIGERDIALOG.error('请选择地区');
                            return false;
                        }
                        var url = '${contextRoot}/report/analysisList?location='+location+'&orgName='+$(".span-location").html()+'&startTime='+self.$startDate.val()+'&endTime='+self.$endDate.val();
                        if($("#inp_thirdParty").val()=="true"){//第三方跳转过来的
                            url = '${contextRoot}/report/outAnalysisList?location='+location+'&orgName='+$(".span-location").html()+'&startTime='+self.$startDate.val()+'&endTime='+self.$endDate.val();
                        }
                        appendNav('趋势分析详情', url, '');

//                        $("div[data-content-page]").load(url);
                    });

                    $(document).on('click', '.go-back', function () {
                        win.location.reload();
                    });
                    $(".div-head").on("click",".div-item",function(){
                        var quotaId = $(this).attr("data-quotaId");
                        $(".div-head").find(".div-item").removeClass("active");
                        $(this).addClass("active");
                        self.getChartData(quotaId);//趋势分析 -按区域列表查询,按日初始化查询
                        self.getQcQuotaByLocation(quotaId);//根据地区、期间查询各机构某项指标的值
                    });
                    //左切换
                    $(".div-zuoqiehuan").on("click",function(){
                        if(currentIndex==0 || chartData==null){
                            parent._LIGERDIALOG.success('暂无更多数据');
                            return false;
                        }
                        currentIndex--;
                        self.drawChart(chartData.eventTimeData[currentIndex] ,chartData.valueData[currentIndex],chartData.anData[currentIndex],chartData.momData[currentIndex]);
                    });
                    //右切换
                    $(".div-youqiehuan").on("click",function(){
                        if((chartData!=null && currentIndex==(Object.keys(chartData.eventTimeData).length-1)) || chartData==null){
                            parent._LIGERDIALOG.success('暂无更多数据');
                            return false;
                        }
                        currentIndex++;
                        self.drawChart(chartData.eventTimeData[currentIndex] ,chartData.valueData[currentIndex],chartData.anData[currentIndex],chartData.momData[currentIndex]);
                    });

                    $(".div-organization-content").on("click",".div-organization .div-hospital-item",function(){
                        var quotaId = $(".div-head").find(".div-item.active").attr("data-quotaId");
                        var orgCode = $(this).closest(".div-organization").attr("data-orgCode");
                        var orgName = $(".span-location").html()+$(this).closest(".div-organization").attr("data-orgName");
                        var url = '${contextRoot}/report/trendAnalysisDetail?location='+location+'&orgCode='+orgCode+'&orgName='+orgName+'&quotaId='+quotaId+'&startTime='+self.$startDate.val()+'&endTime='+self.$endDate.val();
                        $("#contentPage").load(url);
                    })
                },
                getChartData:function(quotaId){
                    var self = retrieve;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcQuotaIntegrity', {
                        data: {location: location,quotaId:quotaId,startTime:self.$startDate.val(),endTime:self.$endDate.val()},
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
                getQcQuotaByLocation:function(quotaId){
                    var self = retrieve;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcQuotaByLocation', {
                        data: {location: location,quotaId:quotaId,startTime:self.$startDate.val(),endTime:self.$endDate.val()},
                        success: function (data) {
                            if(data.successFlg) {
                                var list = data.detailModelList;
                                var resultStr = "";
                                for(var i=0;i<list.length;i++){
                                    var item = list[i];
                                    resultStr +='<div class="f-ml20 div-organization f-mb20" data-orgCode="'+item.orgCode+'" data-orgName="'+item.orgName+'">'+
                                                    '<div class="div-hospital-name">'+
                                                         '<p>'+item.orgName+'</p>'+
                                                    '</div>'+
                                                    '<div class="div-hospital-item">'+
                                                        '<div class="l-gq-bg" style="width: '+item.value+';"></div>'+
                                                        '<div class="l-gq-value">'+item.value+'('+item.realNum+'/'+item.totalNum+')</div>'+
                                                    '</div>'+
                                                '</div>';
                                }
                                $(".div-organization-content").html(resultStr);
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
                    window.onresize = myChart.resize;
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