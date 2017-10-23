<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/common/reset.css">
<link rel="stylesheet" href="${staticRoot}/lib/bootstrap/css/bootstrap.css">
<link rel="stylesheet" href="${staticRoot}/common/font-awesome.css">
<link rel="stylesheet" href="${staticRoot}/common/function.css">
<link rel="stylesheet" href="${staticRoot}/common/unit.css">
<link rel="stylesheet" href="${staticRoot}/common/skin.css">
<link rel="stylesheet" href="${staticRoot}/common/cyc-menu.css">
<link rel="stylesheet" href="${staticRoot}/common/cyc-linkage.css">

<link rel="stylesheet" href="${staticRoot}/lib/plugin/tips/tips.css">
<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/Aqua/css/ligerui-all.css">
<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/Gray2014/css/all.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/scrollbar/jquery.mCustomScrollbar.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/combo/comboDropdown.css">

<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/custom/css/all.css">
<link rel="stylesheet" href="${staticRoot}/common/cover.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/combo/comboDropdown.css">

<div class="query-main">
    <%--按钮组--%>
    <div class="query-btns">
        <div class="query-change">
            <div class="chang-btn cb-right active">档案数据</div>
            <div class="chang-btn cb-left">指标统计</div>
        </div>
        <div class="screen-con">
            <div class="sc-btn">展开筛选<i class="iconn-xiala"></i></div>
        </div>
        <ui class="single-btns">
            <sec:authorize url="Ehr_InteQuery_Query"><li class="single-btn query-con">查询</li> </sec:authorize>
            <sec:authorize url="Ehr_InteQuery_CreateView"><li class="single-btn gen-view">生成视图</li></sec:authorize>
            <sec:authorize url="Ehr_InteQuery_export"><li class="single-btn out-exc">导出</li></sec:authorize>
        </ui>
    </div>

    <%--树--%>
    <div class="query-tree">
        <div class="m-form-control ser-con">
            <input type="text" id="searchInp" placeholder="请输入名称">
        </div>
        <div class="tree-con-zhcx">
            <div id="divLeftTree" style="padding: 10px;"></div>
        </div>
    </div>

    <%--查询条件&表格--%>
    <div class="query-conc">
        <%--查询条件--%>
        <div class="select-con" style="display: none">

            <div class="pub-sel">
                <%--固定条件--%>
            </div>

            <div class="sel-item time" data-parent-code="event_date">
                <span class="sel-lab">时间: </span>
                <ul class="con-list">
                    <li class="con-item ci-inp">
                        <input type="text" id="startDate">
                    </li>
                    <li class="con-item ci-inp">
                        <input type="text" id="endDate">
                    </li>
                </ul>
            </div>

            <div class="sel-more">
                <%--动态条件--%>
            </div>

        </div>
        <%--表格--%>
        <div>
            <div id="divResourceInfoGrid"></div>
            <div id="zbGrid" style="display: none"></div>
        </div>
    </div>
</div>

<script type="text/html" id="selTmp">
    <div class="sel-item" data-parent-code="{{pCode}}" data-code-list="">
        <span class="sel-lab">{{label}}: </span>
        <ul class="con-list">
            {{content}}
        </ul>
        <div class="show-more">
            <div class="sc-btn sw-w">更多<i class="iconn-xiala"></i></div>
        </div>
    </div>
</script>

<script type="text/html" id="selDateTmp">
    <div class="sel-item time" data-parent-code="{{code}}">
        <span class="sel-lab">{{label}}: </span>
        <ul class="con-list">
            {{content}}
        </ul>
    </div>
</script>

<script src="${staticRoot}/lib/jquery/jquery-1.9.1.js"></script>
<script src="${staticRoot}/module/cookie.js"></script>
<script src="${staticRoot}/module/util.js"></script>
<script src="${staticRoot}/module/juicer.js"></script>
<script src="${staticRoot}/module/pubsub.js"></script>
<script src="${staticRoot}/module/sessionOut.js"></script>
<script src="${staticRoot}/module/ajax.js"></script>
<script src="${staticRoot}/module/baseObject.js"></script>
<script src="${staticRoot}/module/dataModel.js"></script>
<script src="${staticRoot}/module/pinyin.js"></script>
<script src="${staticRoot}/lib/plugin/formEx/attrscan.js"></script>
<script src="${staticRoot}/lib/plugin/formEx/readonly.js"></script>
<script src="${staticRoot}/lib/bootstrap/js/bootstrap.js"></script>
<script src="${staticRoot}/lib/ligerui/core/base.js"></script>

<script src="${staticRoot}/lib/plugin/tips/tips.js"></script>
<script src="${staticRoot}/lib/plugin/validate/jValidate.js"></script>
<script src="${staticRoot}/lib/plugin/validation/jquery.validate.min.js"></script>
<script src="${staticRoot}/lib/plugin/validation/jquery.metadata.js"></script>
<script src="${staticRoot}/lib/plugin/validation/messages_cn.js"></script>

<script src="${staticRoot}/lib/ligerui/plugins/ligerLayout.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDrag.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerResizable.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDialog.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerGrid.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerTree.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerButton.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerCheckBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerCheckBoxList.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerComboBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerListBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerTextBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDateEditor.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerForm.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/customTree.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerRadio.js"></script>

<script src="${staticRoot}/lib/plugin/notice/topNotice.js"></script>
<script src="${staticRoot}/lib/plugin/combo/addressDropdown.js"></script>

<script src="${staticRoot}/lib/plugin/scrollbar/jquery.mousewheel.min.js"></script>
<script src="${staticRoot}/lib/plugin/scrollbar/jquery.mCustomScrollbar.js"></script>

<script src="${staticRoot}/lib/ligerui/custom/ligerGridEx.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/customCombo.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-menu.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-linkage.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-big.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>








