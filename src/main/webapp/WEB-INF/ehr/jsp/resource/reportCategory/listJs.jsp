<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<%--<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>--%>

<script>
    var detailDialog = null;
    var grid = null;

    $(function () {
        init();
    });

    function init() {
        $('#searchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid(1);
            }
        });

        if (grid) {
            reloadGrid(1);
        } else {
            grid = $("#grid").ligerGrid($.LigerGridEx.config({
                url: '${contextRoot}/resource/reportCategory/getTreeData',
                parms: {name: ""},
                columns: [
                    {display: 'ID', name: 'id', hide: true},
                    {display: '名称', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                    {display: '编码', name: 'code', width: '20%', isAllowHide: false, align: 'left'},
                    {display: '备注', name: 'remark', width: '25%', isAllowHide: false, align: 'left'},
                    {
                        display: '操作', name: 'operator', width: '35%', align: 'center',
                        render: function (row) {
                            var html = '';
                            html += '<sec:authorize url="/resource/reportCategory/edit"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "resource:reportCategory:open", row.id, 'modify') + '"></a></sec:authorize>';
                            html += '<sec:authorize url="/resource/reportCategory/delete"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:reportCategory:delete", row.id) + '"></a></sec:authorize>';
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

            bindEvents();
        }
    }

    function bindEvents() {
        $.subscribe('resource:reportCategory:open', function (event, id, mode) {
            var title = '';
            if (mode == 'modify') {
                title = '修改资源报表分类';
            } else {
                title = '新增资源报表分类';
            }
            detailDialog = $.ligerDialog.open({
                height: 450,
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
            $.Notice.confirm('确认要删除所选数据？', function (r) {
                if (r) {
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote('${contextRoot}/resource/reportCategory/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                $.Notice.success('删除成功！');
                                reloadGrid($.Util.checkCurPage.call(grid, 1));
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    });
                }
            })
        });
    }

    function reloadGrid(curPage) {
        var params = {name: $('#searchNm').val()};
        $.Util.reloadGrid.call(grid, '${contextRoot}/resource/reportCategory/getTreeData', params, curPage);
    }

    /**** 与 Dialog 页面间回调的函数 ****/
    window.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && $.Notice.success(msg);
    };

</script>
