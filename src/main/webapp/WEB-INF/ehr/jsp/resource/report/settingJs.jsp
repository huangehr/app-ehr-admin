<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var supplyTree, selectedGrid;
    var id = '${id}';

    $(function () {
        init();
    });

    function init() {
        renderWidget();
        bindEvents();
    }

    function renderWidget() {
        supplyTree = $("#supplyTree").ligerTree({
            url: '${contextRoot}/resource/report/getViewsTreeData',
            checkbox: true,
            textFieldName: 'name',
            idFieldName: 'id',
            isExpand: false,
            slide: false,
            onCheck: treeNodeCheck
        });

        selectedGrid = $("#selectedGrid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resource/report/getSelectedViews',
            <%--url: '${contextRoot}/develop/griddata.json',--%>
            columns: [
                {display: '主键', name: 'id', hide: true},
                {display: '资源报表ID', name: 'reportId', hide: true},
                {display: '视图ID', name: 'resourceId', hide: true},
                {display: '视图名称', name: 'resourceName', width: '100%', isAllowHide: false, align: 'left'}
            ],
            height: '510',
            allowHideColumn: false,
            usePager: false,
            onSelectRow: function(rowdata, rowid, rowobj) {
                debugger;
                var rowDataTran = makeGridRowData(rowdata);
                selectedGrid.deleteRow(rowdata);
            }
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

    // 左侧视图树：选择事件
    function treeNodeCheck(node, check) {
        debugger;
        console.log(node);
        var rowData = makeGridRowData(node.data);
        if(check) {
            if(node.data.children) {
                traverseChildren(node.data.children, 'add');
            } else if(!node.data.realCategory) { // 判断是否是视图节点
                selectedGrid.addRow(rowData);
            }
        } else {
            if(node.data.children) {
                traverseChildren(node.data.children, 'delete');
            } else if(!node.data.realCategory) { // 判断是否是视图节点
                selectedGrid.deleteRow(rowData);
            }
        }
    }

    // 遍历选择节点的所有子节点，并添加到右侧列表，或从右侧列表移除
    function traverseChildren(children, flag) {
        $.each(children, function (i, child) {
            if(child.children) {
                traverseChildren(child.children, flag);
            } else if(!child.realCategory) { // 判断是否是视图节点
                var rowData = makeGridRowData(child);
                if(flag === 'add') {
                    selectedGrid.addRow(rowData);
                } else if(flag === 'delete') {
                    selectedGrid.deleteRow(rowData);
                }
            }
        });
    }

    // 生成右侧列表行数据
    function makeGridRowData(data) {
        return {
            id: data.id,
            reportId: id,
            resourceId: data.id,
            resourceName: data.name
        };
    }

</script>