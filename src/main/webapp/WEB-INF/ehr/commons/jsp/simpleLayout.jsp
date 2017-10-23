<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    $.extend({
        Context: {
            PATH: '${contextRoot}',
            STATIC_PATH: '${staticRoot}'
        }
    })
</script>
<tiles:insertAttribute name="pageCss" ignore="true"/>
<tiles:insertAttribute name="contentPage" ignore="true"/>
<tiles:insertAttribute name="pageJs" ignore="true"/>