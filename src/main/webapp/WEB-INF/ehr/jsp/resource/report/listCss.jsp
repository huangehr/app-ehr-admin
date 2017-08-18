<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .m-form-inline .m-form-group .m-form-control.m-form-control-fr {
        float: right;
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