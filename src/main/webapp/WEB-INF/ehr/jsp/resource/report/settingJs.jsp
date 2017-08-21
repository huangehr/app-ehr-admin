<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var supplyTree, selectedGrid;

    $(function () {
        init();
    });

    function init() {
        renderWidget();
        bindEvents();
    }

    function renderWidget() {
        supplyTree = $("#supplyTree").ligerGrid($.LigerGridEx.config({
            <%--url: '${contextRoot}/resource/reportCategory/getTreeData',--%>
            url: '${contextRoot}/develop/treedata.json',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '名称', name: 'name', width: '100%', isAllowHide: false, align: 'left'}
            ],
            height: '510',
            allowHideColumn: false,
            tree: {columnName: 'name'},
            usePager: false,
            checkbox: true
        }));
        supplyTree.collapseAll();
        supplyTree.adjustToWidth();

        selectedGrid = $("#selectedGrid").ligerGrid($.LigerGridEx.config({
            <%--url: '${contextRoot}/resource/report/search',--%>
            url: '${contextRoot}/develop/griddata.json',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '视图名称', name: 'name', width: '100%', isAllowHide: false, align: 'left'}
            ],
            height: '510',
            allowHideColumn: false,
            usePager: false
        }));
        selectedGrid.adjustToWidth();
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/resource/report/", {
                type: 'post',
                data: {data: JSON.stringify('')},
                success: function (data) {
                    if (data.successFlg) {
                        if (detailModel.id) {
                            window.closeDetailDialog('新增成功');
                        } else {
                            window.closeDetailDialog('修改成功');
                        }
                        window.reloadMasterGrid();
                    } else {
                        $.Notice.error(data.errorMsg);
                    }
                },
                error: function () {
                    $.Notice.error('保存发生异常');
                },
                complete: function () {
                    loading.close();
                }
            });
        });

        // 关闭
        $('#btnClose').click(function () {
            window.closeDetailDialog();
        });
    }

</script>