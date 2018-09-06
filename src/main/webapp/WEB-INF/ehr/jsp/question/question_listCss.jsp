<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .div-pldelete-btn{
        cursor: pointer;
        position: relative;
        text-align: center;
        color: #FFF;
        font-weight: bold;
        line-height: 30px;
        border: none;
        border-radius: 3px;
        background: #2D9BD2;
        width: 90px;
        height: 30px;
        overflow: hidden;
        position: relative;
        display: inline-block;
    }

    .div-pldelete-btn.active{
        background: red;
    }

    .div-pldelete-btn.active:active {
        cursor: pointer;
    }
    .div-add-btn{
        cursor: pointer;
        position: relative;
        text-align: center;
        color: #FFF;
        font-weight: bold;
        line-height: 30px;
        border: none;
        border-radius: 3px;
        background: #2D9BD2;
        width: 90px;
        height: 30px;
        overflow: hidden;
        position: relative;
        display: inline-block;
    }

    .div-add-btn:active {
        cursor: pointer;
    }
    .div-btn-text{
        font-size: 12px;
        position: absolute;
        font-size: 12px;
        position: absolute;
        right: 18px;
    }
</style>