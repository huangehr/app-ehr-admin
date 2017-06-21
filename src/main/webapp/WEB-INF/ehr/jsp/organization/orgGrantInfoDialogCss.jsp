<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

	.f-mw100{ width:100%; }
	.f-mw50{ width:48%;}
	.f-ds1{ border: 1px solid #D6D6D6; }
	.f-mh26{ height: 26px }
	.div-jigou{background: url(${staticRoot}/images/jigou_btn_pre.png) no-repeat;width: 148px;height: 44px;position: absolute;top: 12px;left: 168px;}
	.div-jigou.active{background: url(${staticRoot}/images/jigou_btn.png) no-repeat;}
	.div-quyu{background: url(${staticRoot}/images/quyu_btn.png) no-repeat;width: 148px;height: 44px;margin-right: 10px;margin-left: 10px;position: absolute;top: 12px;}
	.div-quyu.active{background: url(${staticRoot}/images/quyu_pre.png) no-repeat;}
	.div-jigou:hover,.div-jigou:active{background: url(${staticRoot}/images/jigou_btn.png) no-repeat;}
	.div-quyu:hover,.div-quyu:active{background: url(${staticRoot}/images/quyu_pre.png) no-repeat;}


</style>