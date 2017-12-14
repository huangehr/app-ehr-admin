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
//        initChart();
    }

    function initWidget() {
        $('#searchSn').ligerTextBox({ width: 200 });
        $('#searchName').ligerTextBox({ width: 200 });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/fastDfs/search',
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

        // 下载
        $.subscribe('fastDfs:download', function (event, path, name) {
            var loading = $.ligerDialog.waitting("正在下载...");
            dataModel.updateRemote('${contextRoot}/fastDfs/download', {
                data: {path: path},
                success: function (data) {
                    if (data.successFlg) {
                        var a = document.createElement('a');
                        a.href = data.obj;
                        a.download = name;
                        $('#searchForm').append(a);
                        a.click();
                        $(a).remove();
                    } else {
                        $.Notice.error(data.errorMsg);
                    }
                },
                error: function () {
                    $.Notice.error('下载发生异常');
                },
                complete: function () {
                    loading.close();
                }
            });
        });
    }

    function initChart() {
        // 缓存分类内存比率统计
        dataModel.fetchRemote('${contextRoot}/redis/cache/statistics/getCategoryMemory', {
            success: function(data) {
                if (data.successFlg) {
                    var categoryMemoryRateChart = echarts.init(document.getElementById('categoryMemoryRate'));
                    categoryMemoryRateChart.setOption({
                        title : {
                            text: '缓存分类的Redis内存占比',
                            subtext: '单位：字节（bytes）',
                            x:'center'
                        },
                        tooltip : {
                            trigger: 'item',
                            formatter: "{b} : {c} ({d}%)"
                        },
                        /*legend: {
                            type: 'scroll',
                            orient: 'vertical',
                            right: 10,
                            top: 20,
                            bottom: 20,
                            data: data.obj.categoryNameList
                        },*/
                        series : [
                            {
                                type: 'pie',
                                radius : '55%',
                                center: ['50%', '60%'],
                                data: data.obj.categoryMemoryList,
                                itemStyle: {
                                    emphasis: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    });
                } else {
                    $.Notice.error(data.errorMsg);
                }
            },
            error: function() {
                $.Notice.error('加载分类内存占比图表数据发生异常！');
            }
        });

        // 缓存个数统计
        dataModel.fetchRemote('${contextRoot}/redis/cache/statistics/getCategoryKeys', {
            success: function(data) {
                if (data.successFlg) {
                    var cacheKeysChart = echarts.init(document.getElementById('cacheKeys'));
                    cacheKeysChart.setOption({
                        title: {
                            text: '分类缓存数量',
                            x:'center'
                        },
                        color: ['#3398DB'],
                        tooltip : {
                            trigger: 'axis',
                            axisPointer : {
                                type : 'shadow'
                            }
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis : [
                            {
                                type : 'category',
                                data : data.obj.categoryNameList,
                                axisTick: {
                                    alignWithLabel: true
                                }
                            }
                        ],
                        yAxis : [
                            {
                                type : 'value'
                            }
                        ],
                        series : [
                            {
                                name:'缓存数量',
                                type:'bar',
                                barWidth: '60%',
                                data: data.obj.categoryNumList
                            }
                        ]
                    });
                } else {
                    $.Notice.error(data.errorMsg);
                }
            },
            error: function() {
                $.Notice.error('加载缓存数量图表数据发生异常！');
            }
        });
    }

    function reloadGrid() {
        var params = {
            sn: $('#searchSn').val(),
            name: $("#searchName").val()
        };
        $.Util.reloadGrid.call(grid, '${contextRoot}/fastDfs/search', params);
    }

</script>
