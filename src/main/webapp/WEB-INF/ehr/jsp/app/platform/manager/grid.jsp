 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">字典</div>

<!-- ####### 页面部分 ####### -->
<div id="div_wrapper">
    <div id="grid_content" style="width: 100%">
        <!--   属性菜单 -->
        <div id="div_left">
            <div id="treeMenuWrap">
                <div id="treeMenu"></div>
            </div>
        </div>

        <!--   列表   -->
        <div id="div_right">
            <div id="rightGrid" style="height: 100%"></div>
        </div>
    </div>
</div>


