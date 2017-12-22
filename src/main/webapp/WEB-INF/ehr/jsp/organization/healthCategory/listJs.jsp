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
    }

    function initWidget() {
        $('#searchContent').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid();
            }
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/org/healthCategory/search',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '卫生机构类别名称', name: 'name', width: '40%', isAllowHide: false, align: 'left'},
                {display: '卫生机构类别编码', name: 'code', width: '20%', isAllowHide: false, align: 'left'},
                {display: '备注', name: 'remark', width: '30%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', width: '10%', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/org/healthCategory/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "org:healthCategory:detail", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/org/healthCategory/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "org:healthCategory:delete", row.id) + '"></a></sec:authorize>';
                        return html;
                    }
                }
            ],
            allowHideColumn: false,
            tree: {columnName: 'name'},
            usePager: false
        }));
        grid.collapseAll();
        grid.adjustToWidth();
    }

    function bindEvents() {
        // 新增/修改
        $.subscribe('org:healthCategory:detail', function (event, id, mode) {
            var title = '新增卫生机构类别';
            if (mode == 'modify') {
                title = '修改卫生机构类别';
            }
            detailDialog = $.ligerDialog.open({
                height: 460,
                width: 480,
                title: title,
                url: '${contextRoot}/org/healthCategory/detail',
                urlParms: {
                    id: id,
                    mode: mode
                },
                opener: true,
                load: true
            });
        });

        // 删除
        $.subscribe('org:healthCategory:delete', function (event, id) {
            $.Notice.confirm('确认要删除所选数据及其子数据吗？', function (r) {
                if (r) {
                    var loading = $.ligerDialog.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/org/healthCategory/delete', {
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

    function reloadGrid() {
        var params = {searchContent: $('#searchContent').val()};
        $.Util.reloadGrid.call(grid, '${contextRoot}/org/healthCategory/search', params);
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
