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
        <div class="sel-top sel-l-top">
            <div class="f-fl">
                选择机构:
            </div>
            <div class="f-fl m5">
                <input type="text" id="inp_org_search" placeholder="请输入机构名称" class="f-ml10 inp_org_com_search"/>
            </div>
        </div>
        <div class="sel-bottom">
            <div id="orgTree"></div>
        </div>
    </div>
    <div class="sel-con sel-r">
        <div>
            <div class="sel-top sel-r-top">选择部门(科室)</div>
            <div class="sel-bottom-half">
                <div id="deptTree"></div>
            </div>
        </div>
        <div>
            <div class="sel-top sel-r-top" style="border-top: 1px solid #ccc;">选择职务</div>
            <div class="sel-bottom-half">
                <div id="titleTree"></div>
            </div>
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
<script type="text/html" id="treeAddressNodeTmp1">
    <li treedataindex="{{index}}" outlinelevel="{{level}}" id="{{id}}" data-pid="{{pid}}" class="l-first l-last l-onlychild ">
        <div class="l-body">
</script>
<script type="text/html" id="treeAddressNodeTmp2">
    <div class="l-box l-expandable-close"></div>
    <div class="l-box l-tree-icon l-tree-icon-folder-open"></div>
    <span title="{{name}}">{{name}}</span>
    </div>
    </li>
</script>
<script type="text/html" id="treeAddressChildNodeTmp1">
    <li treedataindex="{{index}}" outlinelevel="{{level}}" id="{{id}}" class="">
        <div class="l-body">
</script>
<script type="text/html" id="treeAddressChildNodeTmp2">
            <div class="l-box l-note"></div>
            <div class="l-box l-checkbox l-checkbox-unchecked"></div>
            <div class="l-box l-tree-icon l-tree-icon-leaf "></div>
            <span title="{{fullName}}">{{fullName}}</span>
        </div>
    </li>
</script>