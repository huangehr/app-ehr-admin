<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script>
    $(function () {
        var showSharts = {
            $tabList: $('.tab-list'),
            chartsMain: document.getElementById('chartsMain'),
            optionsArr: [],
            init: function () {
                this.loadData();
                this.bindEvnt();
            },
            loadData: function () {
                var me = this;
                var option0 = {
                    title: {
                        text: "对数轴示例",
                        x: "center"
                    },
                    tooltip: {
                        trigger: "item",
                        formatter: "{a} <br/>{b} : {c}"
                    },
                    legend: {
                        x: 'left',
                        data: ["2的指数", "3的指数"]
                    },
                    xAxis: [
                        {
                            type: "category",
                            name: "x",
                            splitLine: {show: false},
                            data: ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
                        }
                    ],
                    yAxis: [
                        {
                            type: "log",
                            name: "y"
                        }
                    ],
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {
                                show: true
                            },
                            dataView: {
                                show: true,
                                readOnly: true
                            },
                            restore: {
                                show: true
                            },
                            saveAsImage: {
                                show: true
                            }
                        }
                    },
                    calculable: true,
                    series: [
                        {
                            name: "3的指数",
                            type: "line",
                            data: [1, 3, 9, 27, 81, 247, 741, 2223, 6669]

                        },
                        {
                            name: "2的指数",
                            type: "line",
                            data: [1, 2, 4, 8, 16, 32, 64, 128, 256]

                        }
                    ]
                };
                var option1 = {
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b}: {c} ({d}%)"
                    },
                    legend: {
                        orient: 'vertical',
                        x: 'left',
                        data:['直接访问','邮件营销','联盟广告','视频广告','搜索引擎']
                    },
                    series: [
                        {
                            name:'访问来源',
                            type:'pie',
                            radius: ['50%', '70%'],
                            avoidLabelOverlap: false,
                            label: {
                                normal: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    show: true,
                                    textStyle: {
                                        fontSize: '30',
                                        fontWeight: 'bold'
                                    }
                                }
                            },
                            labelLine: {
                                normal: {
                                    show: false
                                }
                            },
                            data:[
                                {value:335, name:'直接访问'},
                                {value:310, name:'邮件营销'},
                                {value:234, name:'联盟广告'},
                                {value:135, name:'视频广告'},
                                {value:1548, name:'搜索引擎'}
                            ]
                        }
                    ]
                };

                var dataAxis = ['点', '击', '柱', '子', '或', '者', '两', '指', '在', '触', '屏', '上', '滑', '动', '能', '够', '自', '动', '缩', '放'];
                var data = [220, 182, 191, 234, 290, 330, 310, 123, 442, 321, 90, 149, 210, 122, 133, 334, 198, 123, 125, 220];
                var yMax = 500;
                var dataShadow = [];

                var dataShadow = [];

                for (var i = 0; i < data.length; i++) {
                    dataShadow.push(yMax);
                }

                var option2 = {
                    title: {
                        text: '特性示例：渐变色 阴影 点击缩放',
                        subtext: 'Feature Sample: Gradient Color, Shadow, Click Zoom'
                    },
                    xAxis: {
                        data: dataAxis,
                        axisLabel: {
                            inside: true,
                            textStyle: {
                                color: '#fff'
                            }
                        },
                        axisTick: {
                            show: false
                        },
                        axisLine: {
                            show: false
                        },
                        z: 10
                    },
                    yAxis: {
                        axisLine: {
                            show: false
                        },
                        axisTick: {
                            show: false
                        },
                        axisLabel: {
                            textStyle: {
                                color: '#999'
                            }
                        }
                    },
                    dataZoom: [
                        {
                            type: 'inside'
                        }
                    ],
                    series: [
                        { // For shadow
                            type: 'bar',
                            itemStyle: {
                                normal: {color: 'rgba(0,0,0,0.05)'}
                            },
                            barGap:'-100%',
                            barCategoryGap:'40%',
                            data: dataShadow,
                            animation: false
                        },
                        {
                            type: 'bar',
                            itemStyle: {
                                normal: {
                                    color: new echarts.graphic.LinearGradient(
                                            0, 0, 0, 1,
                                            [
                                                {offset: 0, color: '#83bff6'},
                                                {offset: 0.5, color: '#188df0'},
                                                {offset: 1, color: '#188df0'}
                                            ]
                                    )
                                },
                                emphasis: {
                                    color: new echarts.graphic.LinearGradient(
                                            0, 0, 0, 1,
                                            [
                                                {offset: 0, color: '#2378f7'},
                                                {offset: 0.7, color: '#2378f7'},
                                                {offset: 1, color: '#83bff6'}
                                            ]
                                    )
                                }
                            },
                            data: data
                        }
                    ]
                };
                me.optionsArr.push(option0);
                me.optionsArr.push(option1);
                me.optionsArr.push(option2);
                me.initCharts(me.optionsArr[0]);
            },
            initCharts: function (opt) {
                var me = this;
                var myChart = echarts.init(me.chartsMain);
                myChart.setOption(opt);
            },
            bindEvnt: function () {
                var me = this;
                me.$tabList.on('click', '.tab-item', function () {
                    var index = $(this).index();
                    $(this).addClass('active').siblings().removeClass('active');
                    me.initCharts(me.optionsArr[index]);
                });
            }
        }
        showSharts.init();
    });
</script>