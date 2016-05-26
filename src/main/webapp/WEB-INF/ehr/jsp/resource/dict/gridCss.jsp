<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .image-create{
        /*margin-left:20px;*/
        width: 22px;
        height: 22px;
        background: url(${staticRoot}/images/add_btn.png) no-repeat;
    }

    .image-create:hover{
        cursor: pointer;
        /*margin-left:20px;*/
        width: 22px;
        height: 22px;
        background: url(${staticRoot}/images/add_btn_pre.png) no-repeat;
    }

    .retrieve-border{
        display:block;
        border: 1px solid #D6D6D6;
        border-bottom: 0px
    }
</style>