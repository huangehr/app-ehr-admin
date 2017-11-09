<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>

<script>
    var supplyTree;
    var id = '${id}';

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
    }

    function initWidget() {
        $('#settingTreeContainer').mCustomScrollbar({
            axis: "y"
        });

        $('#settingSearchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                supplyTree.s_search($('#settingSearchNm').val());
            }
        });

        supplyTree = $("#supplyTree").ligerSearchTree({
            url: '${contextRoot}/resource/report/getViewsTreeData',
            urlParms: {reportId: id},
            checkbox: false,
            textFieldName: 'name',
            idFieldName: 'id',
            isExpand: false,
            slide: false,
            onSelect: function (obj) {
                if(!!!obj.data.children) {
                    var id = obj.data.id,
                        name = obj.data.name;
                    $.ligerDialog.confirm('确认选择“' + name + '”视图吗？',function(yes){
                        if (yes) {
                            closeselViewDialog('', id);
                        }
                    })
                }
            }
        });
    }
    function bindEvents() {
        // 关闭
        $('#btnClose').click(function () {
            closeselViewDialog();
        });
    }
</script>