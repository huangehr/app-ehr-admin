<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->

<div class="containBox">
    <div class="import_input">
        <div class="import_div" onclick="javascript:$.publish('urgentcommand:importSch:open',['','import'])">
            <input type="button" value="导入" >
        </div>
    </div>
    <div id="sort_grid"></div>
</div>