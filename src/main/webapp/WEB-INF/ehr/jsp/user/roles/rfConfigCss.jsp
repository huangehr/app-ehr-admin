<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/21
  Time: 15:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .rf-main{
        width: 100%;
        height: 100%;
        position: relative;
    }
    .rf-con{
        width: 255px;
        height: 413px;
        margin-top: 10px;
        border: 1px solid #ccc;
        overflow: hidden;
    }
    .rf-left{
        margin-left: 10px;
        float: left;
    }
    .rf-right{
        margin-right: 10px;
        float: right;
    }
    .rf-tit{
        height: 39px;
        border-bottom: 1px solid #ccc;
        padding-left: 10px;
    }

    .rf-tit input{

    }
    .l-tit{
        padding-top: 4px;
    }
    .r-tit{
        line-height: 39px;
    }
    .rf-tree{

    }
    #saveBtn{
        position: absolute;
        bottom: 10px;
        right: 10px;
    }
    .arrow{
        width: 20px;
        height: 40px;
        background: url(${contextRoot}/develop/images/zhixiang_icon.png) center no-repeat;
        position: absolute;
        top: 180px;
        left: 285px;
    }
    .l-body span{
        line-height: 22px;
        height: 22px;
    }
</style>