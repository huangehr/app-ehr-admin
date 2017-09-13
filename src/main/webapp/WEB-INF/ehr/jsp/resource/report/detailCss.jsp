<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .pane-attribute-toolbar{
        display: block;
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 50px;
        padding: 6px 0 4px;
        background-color: #fff;
        border-top: 1px solid #ccc;
        text-align: right;
    }
    .close-toolbar{
        margin-right: 20px;
    }
    input{
        height: 28px;
        width: 240px;
    }
    .btn-btn-container {
        position: relative;
    }
    .btn-file-container input[type=file] {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        opacity: 0;
        z-index: 999;
    }
</style>