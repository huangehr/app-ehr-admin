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
        $('#searchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid();
            }
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resource/reportCategory/getTreeData',
            columns: [
                {display: 'ID', name: 'id', width: '0.1%', hide: true},
                {display: '名称', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                {display: '编码', name: 'code', width: '20%', isAllowHide: false, align: 'left'},
                {display: '备注', name: 'remark', width: '25%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/resource/reportCategory/appCongig"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "resource:reportCategoryAppConfig:open", row.id,"modify") + '">应用配置</a></sec:authorize>';
                        html += '<sec:authorize url="/resource/reportCategory/edit"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "resource:reportCategory:open", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/resource/reportCategory/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:reportCategory:delete", row.id) + '"></a></sec:authorize>';
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
        $.subscribe('resource:reportCategoryAppConfig:open', function (event, id, mode) {
            var title = '报表分类>应用授权';
            detailDialog = parent._LIGERDIALOG.open({
                height: 600,
                width: 800,
                title: title,
                urlParms:{
                    id:id,
                    dialogType:mode,
                },
                url: '${contextRoot}/resource/reportCategory/appConfig',
                isHidden: false,
                load: true
            })
        });

        $.subscribe('resource:reportCategory:open', function (event, id, mode) {
            var title = '新增资源报表分类';
            if (mode == 'modify') {
                title = '修改资源报表分类';
            }
            detailDialog = parent._LIGERDIALOG.open({
                height: 500,
                width: 480,
                title: title,
                url: '${contextRoot}/resource/reportCategory/detail',
                urlParms: {
                    id: id,
                    mode: mode
                },
                opener: true,
                load: true
            });
        });

        $.subscribe('resource:reportCategory:delete', function (event, id) {
            parent._LIGERDIALOG.confirm('确认要删除所选数据及其子数据吗？', function (r) {
                if (r) {
                    var loading = parent._LIGERDIALOG.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/resource/reportCategory/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                parent._LIGERDIALOG.success('删除成功！');
                                reloadGrid();
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            parent._LIGERDIALOG.error('删除发生异常');
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
        var params = {codeName: $('#searchNm').val()};
        $.Util.reloadGrid.call(grid, '${contextRoot}/resource/reportCategory/getTreeData', params);
    }

    /*-- 与 Dialog 页面间回调的函数 --*/
    window.parent.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.parent.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && parent._LIGERDIALOG.success(msg);
    };

</script>
