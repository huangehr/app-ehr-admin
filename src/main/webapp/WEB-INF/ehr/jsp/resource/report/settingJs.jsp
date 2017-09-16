<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>

<script>
    var dataModel = $.DataModel.init();
    var supplyTree, selectedGrid;
    var id = '${id}';

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
    }

    function initWidget() {
        $('#settingTreeContainer').mCustomScrollbar({ axis: "y"});

        $('#settingSearchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                supplyTree.s_search($('#settingSearchNm').val());
            }
        });

        supplyTree = $("#supplyTree").ligerSearchTree({
            url: '${contextRoot}/resource/report/getViewsTreeData',
            urlParms: {reportId: id},
            checkbox: true,
            textFieldName: 'name',
            idFieldName: 'id',
            isExpand: false,
            slide: false,
            onCheck: treeNodeCheck
        });

        selectedGrid = $("#selectedGrid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resource/report/getSelectedViews',
            urlParms: {reportId: id},
            columns: [
                {display: '主键', name: 'id', hide: true},
                {display: '资源报表ID', name: 'reportId', hide: true},
                {display: '视图ID', name: 'resourceId', hide: true}, // getGridRowid() 会用到[视图ID]grid行顺序
                {display: '视图名称', name: 'resourceName', width: '100%', isAllowHide: false, align: 'left'}
            ],
            height: '530',
            allowHideColumn: false,
            usePager: false
        }));
        selectedGrid.adjustToWidth();
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/resource/report/saveSetting", {
                type: 'post',
                data: {
                    reportId : id,
                    data: JSON.stringify(selectedGrid.getData())
                },
                success: function (data) {
                    if (data.successFlg) {
                        $.Notice.success('保存成功');
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

    // region 添加/移除资源视图
    // 左侧视图树：选择事件
    function treeNodeCheck(node, check) {
        var rowData = makeGridRowData(node.data);
        if(check) {
            if(node.data.children) {
                traverseChildren(node.data.children, 'add');
            } else if(!node.data.realCategory && !getGridRowid(rowData.resourceId)) { // 判断是否是视图节点
                selectedGrid.addRow(rowData);
            }
        } else {
            if(node.data.children) {
                traverseChildren(node.data.children, 'delete');
            } else if(!node.data.realCategory) { // 判断是否是视图节点
                selectedGrid.deleteRow(getGridRowid(rowData.resourceId));
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
                if(flag === 'add' && !getGridRowid(rowData.resourceId)) {
                    selectedGrid.addRow(rowData);
                } else if(flag === 'delete') {
                    selectedGrid.deleteRow(getGridRowid(rowData.resourceId));
                }
            }
        });
    }

    // 生成右侧列表行数据
    function makeGridRowData(data) {
        return {
            reportId: id,
            resourceId: data.id,
            resourceName: data.name
        };
    }

    // 根据视图ID遍历右侧grid行，获取对应行的rowid
    function getGridRowid(resourceId) {
        var tdDomId = $('#selectedGrid .l-grid-body-table tr td:nth-child(3) [title=' + resourceId + ']').closest('td').attr('id');
        if(tdDomId) {
            return tdDomId.split('|')[2] || '';
        } else {
            return '';
        }
    }
    // endregion 添加/移除视图

</script>