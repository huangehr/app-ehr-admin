<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var grid = null;

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
        initPublicUrl();
        initChart();
    }

    function initWidget() {
        $('#searchSn').ligerTextBox({ width: 200 });
        $('#searchName').ligerTextBox({ width: 200 });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/fastDfs/search',
            height: '600px',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '文件编号', name: 'sn', width: '10%', isAllowHide: false, align: 'left'},
                {display: '文件名', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                {display: '地址', name: 'path', width: '33%', isAllowHide: false, align: 'left'},
                {display: '大小（KB）', name: 'size', width: '8%', isAllowHide: false, align: 'left'},
                {display: '修改时间', name: 'modifyDate', width: '12%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/fastDfs/download"><a class="label_a f-ml10" title="下载" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "fastDfs:download", row.path, row.name) + '">下载</a></sec:authorize>';
                        return html;
                    }
                }
            ],
            allowHideColumn: false,
            usePager: true
        }));
        grid.collapseAll();
        grid.adjustToWidth();
    }

    function bindEvents() {
        // 查询
        $('#btnSearch').on('click', function () {
            reloadGrid();
        });

        // 修改域名
        $('#modifyPublicUrl').on('click', function () {
            var oldUrl = $('#defaultPublicUrl').html();
            parent._LIGERDIALOG.prompt('修改下载域名', oldUrl, false, function(flag, value) {
                if(flag) {
                    $('#defaultPublicUrl').html(value);
                }
            });
        });

        // 下载
        $.subscribe('fastDfs:download', function (event, path, name) {
            var loading = parent._LIGERDIALOG.waitting("正在下载...");

            var publicUrl = $('#defaultPublicUrl').html();
            var a = document.createElement('a');
            a.href = publicUrl + '/' + path.replace(":", "/");
            a.download = name;
            $('#searchForm').append(a);
            a.click();
            $(a).remove();

            loading.close();
        });
    }

    function reloadGrid() {
        var params = {
            sn: $('#searchSn').val(),
            name: $("#searchName").val()
        };
        $.Util.reloadGrid.call(grid, '${contextRoot}/fastDfs/search', params);
    }

    function initPublicUrl() {
        dataModel.updateRemote('${contextRoot}/fastDfs/getPublicUrl', {
            success: function (data) {
                if (data.successFlg) {
                    $('#defaultPublicUrl').html(data.detailModelList[0]);
                } else {
                    parent._LIGERDIALOG.error('获取下载域名失败。');
                }
            },
            error: function () {
                parent._LIGERDIALOG.error('设置下载域名发生异常');
            }
        });
    }

    function initChart() {
        dataModel.fetchRemote('${contextRoot}/fastDfs/getServersStatus', {
            success: function(data) {
                if (data.successFlg) {
                    var totalStatus = [], serverNameList = [], serverUsedStatusList = [], serverFreeStatusList = [];
                    for(var i = 0; i < data.detailModelList.length; i++) {
                        var item = data.detailModelList[i];
                        var total = parseFloat(item.total);
                        var free = parseFloat(item.free);
                        var used = total - free;
                        if(item.server === 'all') {
                            totalStatus.push({ name: '已用空间', value: used});
                            totalStatus.push({ name: '可用空间', value: free});
                        } else {
                            serverNameList.push(item.server);
                            serverUsedStatusList.push(used);
                            serverFreeStatusList.push(free);
                        }
                    }

                    var totalChart = echarts.init(document.getElementById('total'));
                    totalChart.setOption({
                        title : {
                            text: '总体情况',
                            x:'center'
                        },
                        tooltip : {
                            trigger: 'item',
                            formatter: '{b}: {c} G'
                        },
                        series : [
                            {
                                type: 'pie',
                                radius : '55%',
                                center: ['50%', '50%'],
                                data: totalStatus
                            }
                        ]
                    });

                    var serviceListChart = echarts.init(document.getElementById('serviceList'));
                    var option = {
                        title: {
                            text: '服务器情况',
                            subtext: '总数：' + serverNameList.length,
                            x:'center'
                        },
                        legend: {
                            show: false,
                            selectedMode: false,
                            data: ['已用空间', '可用空间']
                        },
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            },
                            formatter: '{b}<br/>{a0}: {c0} G<br/>{a1}: {c1} G'
                        },
                        toolbox: {
                            show : false,
                            feature : {
                                mark : {show: true},
                                dataView : {show: true, readOnly: false},
                                restore : {show: true},
                                saveAsImage : {show: true}
                            }
                        },
                        calculable : true,
                        xAxis : [
                            {
                                type : 'category',
                                data : serverNameList
                            }
                        ],
                        yAxis : [
                            {
                                type : 'value',
                                boundaryGap: [0, 0.1]
                            }
                        ],
                        series : [
                            {
                                name:'已用空间',
                                type:'bar',
                                stack: 'sum',
                                barCategoryGap: '50%',
                                barWidth: '50',
                                itemStyle: {
                                    normal: {
                                        color: function(params) {
                                            if (params.dataIndex != -1) {
                                                var itemData = params.series.data[params.dataIndex];
                                                var rate = itemData / (serviceListChartOption.series[1].data[params.dataIndex] + itemData);
                                                if (rate >= 0.9) {
                                                    return '#CD0000';
                                                } else if (rate >= 0.7) {
                                                    return '#EEEE00';
                                                } else if (rate < 0.7) {
                                                    return '#00CD00';
                                                }
                                            }
                                        },
                                        barBorderColor: '#ccc',
                                        barBorderWidth: 1,
                                        barBorderRadius:0,
                                        label : {
                                            show: false,
                                            position: 'insideTop',
                                            formatter: function(params) {
                                                for (var i = 0, l = serviceListChartOption.xAxis[0].data.length; i < l; i++) {
                                                    if (serviceListChartOption.xAxis[0].data[i] == params.name) {
                                                        return (params.value / (serviceListChartOption.series[1].data[i] + params.value) * 100).toFixed(2) + '%';
                                                    }
                                                }
                                            }
                                        }
                                    }
                                },
                                data:serverUsedStatusList
                            },
                            {
                                name:'可用空间',
                                type:'bar',
                                stack: 'sum',
                                barWidth: '50',
                                itemStyle: {
                                    normal: {
                                        color: '#fff',
                                        barBorderColor: '#ccc',
                                        barBorderWidth: 1,
                                        barBorderRadius:0,
                                        label : {
                                            show: true,
                                            position: 'top',
                                            formatter: function(params) {
                                                for (var i = 0, l = serviceListChartOption.xAxis[0].data.length; i < l; i++) {
                                                    if (serviceListChartOption.xAxis[0].data[i] == params.name) {
                                                        if (serviceListChartOption.series[0].data[i]+params.value==0){
                                                            return "";
                                                        }else{
                                                            return '可用'+(params.value / (serviceListChartOption.series[0].data[i] + params.value) * 100).toFixed(2) + '%';
                                                        }
                                                    }
                                                }
                                            },
                                            textStyle: {
                                                color: 'black'
                                            }
                                        }
                                    }
                                },
                                data:serverFreeStatusList
                            }
                        ]
                    };
                    serviceListChart.setOption(option);
                } else {
                    parent._LIGERDIALOG.error('获取文件服务器状态数据失败');
                }
            },
            error: function() {
                parent._LIGERDIALOG.error('获取文件服务器状态数据发生异常！');
            }
        });
    }

</script>
