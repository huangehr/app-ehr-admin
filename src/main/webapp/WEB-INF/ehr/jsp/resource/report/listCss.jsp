<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .container {
        width: 100%;
        height: 710px;
        padding: 0;
        position: relative;
    }
    #gridWrapper, #treeWrapper {
        border: 1px solid #D6D6D6;
    }
    #treeWrapper {
        width: 240px;
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        padding: 0 10px 5px 10px;
    }
    #treeWrapper .l-tree li .l-body {
        width: auto;
    }
    #treeWrapper .l-tree .l-body span {
        line-height: 22px;
    }
    #treeContainer {
        background-color: inherit;
        padding-bottom: 10px;
    }
    #gridWrapper {
        position: absolute;
        left: 250px;
        top: 0;
        bottom: 0;
        right: 0;
    }
    #gridWrapper .m-form-group {
        height: 40px;
        padding: 0 10px;
        border-bottom: 1px solid #D6D6D6;
    }
    #grid {
        border: none;
    }
    .m-form-group .m-form-control.m-form-control-fr {
        float: right;
    }
</style>