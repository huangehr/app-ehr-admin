<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
	.body-head input{  border: 0;  font-size: 12px;  width: 120px;}
	.f-bd { border: 1px solid #D6D6D6;  overflow: auto; height: 100% }
	.f-of-hd{ overflow: hidden; }
	.f-db{display: inline-block}
	.div-resource-browse{ height:100%; width:890px; float:right;margin-left: 10px}
	.div-result-msg{width: 100%;height: auto; float: left;}
	.right-retrieve{border: 1px solid #D6D6D6;border-bottom: none }
    #div_wrapper{height: calc(100% - 30px)}
    #div_content{height:calc(100% - 10px)}
    #div_left{width:240px;float: left;height: 100%}
    #div_right{width: calc(100% - 250px);float: right}
    #div_tree{height: calc(100% - 50px)}
</style>

