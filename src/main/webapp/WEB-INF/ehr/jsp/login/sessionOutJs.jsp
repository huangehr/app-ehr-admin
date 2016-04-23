<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    top.window.$.ligerDialog.alert("您太久没操作，请重新登录！", "提示", "warn", function(){
        top.location.href = $.Context.PATH + "/login";
    }, null);
</script>