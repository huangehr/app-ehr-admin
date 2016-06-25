<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
	.body-head input{  border: 0;  font-size: 12px;  width: 120px;}
	.f-db{display: inline-block}
	.f-b0{border: 0px}
	#div_content{width: 500px;height: 420px;margin: 0 auto}
	#div_left{width: 49%;height: 330px;float: left;}
	#div_right{width:49%;height: 330px;float: right;}
	.div_image_large{
		position: fixed; top:0px;  width: 500px;height:600px; padding: 10px; margin:0px auto; text-align: center;
		overflow: hidden; z-index: 9990; display: none;}
	.div_image{height:220px;width: 180px;border: 1px solid #CCCCCC;margin: 0px auto;background-color: #CCCCCC}
</style>

