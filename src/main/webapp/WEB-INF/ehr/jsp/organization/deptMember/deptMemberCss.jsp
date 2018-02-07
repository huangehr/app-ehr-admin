<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
	.body-head input{  border: 0;  font-size: 12px;  width: 120px;}
	.f-bd { border: 1px solid #D6D6D6;  overflow: auto; height: 100% }
	.f-of-hd{ overflow: hidden; }
	.f-db{display: inline-block}
	.tree_type{overflow: auto;}
	.f-w230{width: 230px;}
	.contentH{height:780px }
	#div_right{position: absolute;top: 40px;right: 0;left: 250px;bottom: 0}
	.div_resource_browse_tree{width:890px; float:right;margin-left: 10px}
	.div-result-msg{width: 100%;height: auto; float: left;}
	.right-retrieve{border: 1px solid #D6D6D6;border-bottom: none;padding: 10px;}
    #div_left{width: 240px; position: absolute;left: 0;top: 40px;bottom: 0;border: 1px solid #D6D6D6;}
    #div_tree{height: calc(100% - 30px)}
    .cancel-btn{
        margin-left:12px;
        padding:0px 0px;
        width: 98px !important;
        background: #B9C8D2;
        color: #FFF;
        font-weight: bold;
        border: none;
        height: 35px;
        line-height: 35px;}
    .cancel-btn:hover{
        background: #A5B9C8;
        color: #FFF;
    }
    .sure-btn{
        padding:0px 0px;
        width: 98px !important;
        background: #2D9BD2;
        color: #FFF;
        font-weight: bold;
        border: none;
        height: 35px;
        line-height: 35px;
    }
    .sure-btn:hover{
        background: #0082BE;
        color: #FFF;
    }
</style>

