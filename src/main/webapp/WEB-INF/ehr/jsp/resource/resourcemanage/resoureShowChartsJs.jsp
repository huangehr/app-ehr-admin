<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script>
    $(function () {
        var obj = ${resultStr},
            chartsTitArr = [],
            optsArr = [];
        console.log(obj);
        if (obj && obj.length > 0) {
            for (var i = 0, len = obj.length; i < len; i++) {
                var opt = {};
                try {
                    opt = obj[i].option ? JSON.parse(obj[i].option) : {};
                } catch (e) {
                    console.log(e.message);
                }
                optsArr.push(opt);
                chartsTitArr.push(obj[i].title);
            }
        }
        var showSharts = {
            $tabList: $('.tab-list'),
            chartsMain: document.getElementById('chartsMain'),
            optionsArr: [],
            index: 0,
            init: function () {
                var html = '';
                for (var j = 0, leng = chartsTitArr.length; j < leng; j++) {
                    var cN = j == 0 ? 'active' : '';
                    html += '<li class="tab-item '+ cN +'">' + chartsTitArr[j] + '</li>';
                }
                this.$tabList.append(html);
                this.$tabList.mCustomScrollbar({
                    axis: "x"
                });
                this.loadData();
                this.bindEvnt();
            },
            initCharts: function () {
                var me = this,
                    myChart = echarts.init(me.chartsMain),
                    options = optsArr[me.index];
//                    options = me.optionsArr[me.index];
                if(options) {
                    try {
                        myChart.setOption(options);
                    } catch (e) {
                        console.log(e.message);
                    }
                }
            },
            bindEvnt: function () {
                var me = this;
                me.$tabList.on('click', '.tab-item', function () {
                    var index = $(this).index();
                    $(this).addClass('active').siblings().removeClass('active');
                    me.index = index;
                    me.initCharts();
                });
            },
            loadData: function () {
                var me = this;
                //折线\曲线图
                var option0 = {
                    title: {
                        text: '折线图堆叠',//大标题
                        x:'center',
                        subtext: '纯属虚构'//小标题
                    },
                    tooltip: {
                        trigger: 'axis'
                    },
                    toolbox: {//工具栏
                        show : true,//是否显示工具栏组件。
                        feature : {//各工具配置项
                            dataView : {show: true, readOnly: false},//数据视图
                            magicType : {//动态（视图）类型切换
                                show: true,
                                type: ['pie', 'funnel']
                            },
                            restore : {show: true},//配置项还原。
                            saveAsImage : {show: true}//保存成图片
                        }
                    },
//                    legend: {//图例组件
//                        orient: 'vertical',
//                        left: 'right',
//                        data:['邮件营销','联盟广告']
//                    },
                    grid: {
//                        top: '1%',//图形顶部的距离 （默认不添加该属性）
                        left: '3%',//图形左侧的距离
                        right: '4%',//图形右侧的距离
                        bottom: '3%',//图形底部的距离
                        containLabel: true
                    },
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: ['周一','周二','周三','周四','周五','周六','周日']
                    },
                    yAxis: {
                        type: 'value',
                        name: '（人）'//单位
                    },
                    series: [
                        {
                            name:'邮件营销',
                            type:'line',
                            smooth: true,//true:曲线，false:折线；默认false
                            stack: '总量',
                            data:[120, 132, 101, 134, 90, 230, 210]
                        },
                        {
                            name:'联盟广告',
                            type:'line',
                            stack: '总量',
                            data:[220, 182, 191, 234, 290, 330, 310]
                        }
                    ]
                };
                //饼状图
                var option1 = {
                    title : {
                        text: '某站点用户访问来源',//大标题
                        x:'center',//标题显示位置
                        subtext: '纯属虚构'//小标题
                    },
                    tooltip : {//提示框组件
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} ({d}%)"//可以是字符串或函数
                    },
                    toolbox: {//工具栏
                        show : true,//是否显示工具栏组件。
                        feature : {//各工具配置项
                            dataView : {show: true, readOnly: false},//数据视图
                            magicType : {//动态（视图）类型切换
                                show: true,
                                type: ['pie', 'funnel']
                            },
                            restore : {show: true},//配置项还原。
                            saveAsImage : {show: true}//保存成图片
                        }
                    },
                    grid: {
//                        top: '1%',//图形顶部的距离 （默认不添加该属性）
                        left: '3%',//图形左侧的距离
                        right: '4%',//图形右侧的距离
                        bottom: '3%',//图形底部的距离
                        containLabel: true
                    },
//                    legend: {//图例组件
//                        orient: 'vertical',
//                        left: 'left',
//                        data: ['直接访问','邮件营销','联盟广告','视频广告','搜索引擎']
//                    },
                    series : [
                        {
                            name: '访问来源',
                            type: 'pie',
                            radius : '55%',
                            center: ['50%', '60%'],
                            data:[
                                {value:335, name:'直接访问'},
                                {value:310, name:'邮件营销'},
                                {value:234, name:'联盟广告'},
                                {value:135, name:'视频广告'},
                                {value:1548, name:'搜索引擎'}
                            ],
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                };
                //柱状图
                var option2 =  {
                    title : {
                        text: '某站点用户访问来源',//大标题
                        x:'center',
                        subtext: '纯属虚构'//小标题
                    },
//                    legend: {//图例组件
//                        data: ['直接访问','邮件营销'],
//                        orient: 'vertical',
//                        left: 'left'
//                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效 ：鼠标悬浮在柱状图的样式设置
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    toolbox: {//工具栏
                        show : true,//是否显示工具栏组件。
                        feature : {//各工具配置项
                            dataView : {show: true, readOnly: false},//数据视图
                            magicType : {//动态（视图）类型切换
                                show: true,
                                type: ['pie', 'funnel']
                            },
                            restore : {show: true},//配置项还原。
                            saveAsImage : {show: true}//保存成图片
                        }
                    },
                    grid: {
//                        top: '1%',//图形顶部的距离 （默认不添加该属性）
                        left: '3%',//图形左侧的距离
                        right: '4%',//图形右侧的距离
                        bottom: '3%',//图形底部的距离
                        containLabel: true
                    },
                    xAxis: [{
                        type: 'category',
                        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],//X轴坐标
                        splitLine: {
                            show: false
                        }
                    }],
                    yAxis: [{
                        type: 'value',
                        name: '（人）'//单位
                    }],
                    series: [{
                        clickable: true,
                        itemStyle : {
                            normal: {
                                label : {
                                    show: true,
                                    position: 'top'
                                },
//                                color: '#3398DB'//柱子的颜色
                            }
                        },
                        barWidth: 20,
                        name: '直接访问',
                        type: 'bar',
                        data: [10, 52, 200, 334, 390, 330, 220]
                    },{
                        clickable: true,
                        itemStyle : {
                            normal: {
                                label : {
                                    show: true,
                                    position: 'top'
                                },
//                                color: '#3398DB'//柱子的颜色
                            }
                        },
                        barWidth: 20,
                        name: '邮件营销',
                        type: 'bar',
                        data: [20, 32, 100, 534, 790, 320, 120]
                    }]
                };
                me.optionsArr.push(option0);
                me.optionsArr.push(option1);
                me.optionsArr.push(option2);
                me.initCharts();
            }
        }
        showSharts.init();
    });
</script>