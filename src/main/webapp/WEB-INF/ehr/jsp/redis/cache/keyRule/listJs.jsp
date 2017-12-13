<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var detailDialog = null;
    var grid = null;

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
        initChart();
    }

    function initWidget() {
        $('#searchContent').ligerTextBox({ width: 200 });
        $("#searchCategoryCode").ligerComboBox({
            ajaxType: 'get',
            url: "${contextRoot}/redis/cache/category/searchNoPage",
            dataParmName: 'detailModelList',
            valueField: 'code',
            textField: 'name'
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/redis/cache/keyRule/search',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '缓存Key规则名称', name: 'name', width: '15%', isAllowHide: false, align: 'left'},
                {display: '缓存Key规则编码', name: 'code', width: '15%', isAllowHide: false, align: 'left'},
                {display: '缓存分类', name: 'categoryName', width: '15%', isAllowHide: false, align: 'left'},
                {display: 'Key规则表达式', name: 'expression', width: '20%', isAllowHide: false, align: 'left'},
                {display: '备注', name: 'remark', width: '15%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/redis/cache/keyRule/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "redis:cache:keyRule:detail", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/redis/cache/keyRule/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:cache:keyRule:delete", row.id) + '"></a></sec:authorize>';
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

        // 新增/修改
        $.subscribe('redis:cache:keyRule:detail', function (event, id, mode) {
            var title = '新增缓存Key规则';
            if (mode == 'modify') {
                title = '修改缓存Key规则';
            }
            detailDialog = $.ligerDialog.open({
                height: 490,
                width: 480,
                title: title,
                url: '${contextRoot}/redis/cache/keyRule/detail',
                urlParms: {
                    id: id
                },
                opener: true,
                load: true
            });
        });

        // 删除
        $.subscribe('redis:cache:keyRule:delete', function (event, id) {
            $.Notice.confirm('删除后不能通过该缓存Key规则操作缓存，确认要删除吗？', function (r) {
                if (r) {
                    var loading = $.ligerDialog.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/redis/cache/keyRule/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                $.Notice.success('删除成功！');
                                reloadGrid();
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            $.Notice.error('删除发生异常');
                        },
                        complete: function () {
                            loading.close();
                        }
                    });
                }
            })
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
            searchContent: $('#searchContent').val(),
            categoryCode: $("#searchCategoryCode").ligerComboBox().getValue()
        };
        $.Util.reloadGrid.call(grid, '${contextRoot}/redis/cache/keyRule/search', params);
    }

    /*-- 与明细 Dialog 页面间回调的函数 --*/
    window.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && $.Notice.success(msg);
    };

</script>
