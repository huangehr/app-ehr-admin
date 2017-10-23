<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/10/10
  Time: 10:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div class="sel-o-d">
    <div class="sel-con sel-l">
        <div class="sel-top sel-l-top">选择机构</div>
        <div class="sel-bottom">
            <div id="orgTree"></div>
        </div>
    </div>
    <div class="sel-con sel-r">
        <div class="sel-top sel-r-top">选择部门</div>
        <div class="sel-bottom">
            <div id="deptTree"></div>
        </div>
    </div>
    <div class="sel-btns">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" style="margin-left: 120px;" id="selSaveBtn">
            <span>确定</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="selCloseBtn">
            <span>关闭</span>
        </div>
    </div>
</div>

<script type="text/html" id="treeNodeTmp">
    <li treedataindex="{{index}}" outlinelevel="1" id="{{id}}" class="l-first l-last l-onlychild ">
        <div class="l-body">
            <div class="l-box l-expandable-open"></div>
            <div class="l-box l-checkbox l-checkbox-unchecked"></div>
            <div class="l-box l-tree-icon l-tree-icon-folder-open"></div>
            <span title="{{name}}">{{name}}</span>
        </div>
        {{childCon}}
    </li>
</script>
<script type="text/html" id="treeChildNodeTmp">
    <li treedataindex="{{index}}" outlinelevel="2" id="{{id}}" class="">
        <div class="l-body">
            <div class="l-box"></div>
            <div class="l-box l-note"></div>
            <div class="l-box l-checkbox l-checkbox-unchecked"></div>
            <div class="l-box l-tree-icon l-tree-icon-leaf "></div>
            <span title="{{name}}">{{name}}</span>
        </div>
    </li>
</script>