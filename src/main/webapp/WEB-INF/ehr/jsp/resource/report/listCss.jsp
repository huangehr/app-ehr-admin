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
        float: left;
        width: 240px;
        height: 100%;
        box-sizing: border-box;
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
        float: right;
        width: 700px;
        margin-left: 10px;
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
    .btn-file-container {
        display: inline-block;
        position: relative;
    }
    .btn-file-container form {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        z-index: 999;
    }
    .btn-file-container input[type="file"] {
        width: 100%;
        height: 100%;
    }
</style>