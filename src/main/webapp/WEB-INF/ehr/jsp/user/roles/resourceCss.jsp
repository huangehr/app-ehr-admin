<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
	.body-head input{  border: 0;  font-size: 12px;  width: 120px;}
	.f-bd { border: 1px solid #D6D6D6;  overflow: auto; height: 100% }
	.f-of-hd{ overflow: hidden; }
	.f-db{display: inline-block}
	/*.div-resource-browse{ height:100%; width:890px; float:right;margin-left: 10px}*/
	.div-result-msg{width: 100%;height: auto; float: left;}
	.right-retrieve{border: 1px solid #D6D6D6;border-bottom: none }
	#div_left{    width: 240px;
        position: absolute;
        left: 0;
        top: 40px;
        border: 1px solid #D6D6D6;
        bottom: 0;}
    #div_right{position: absolute;
        right: 0;
        left: 250px;
        bottom: 0;
        top: 40px;}
    #div_tree{
        height: calc(100% - 50px);
    }
</style>

