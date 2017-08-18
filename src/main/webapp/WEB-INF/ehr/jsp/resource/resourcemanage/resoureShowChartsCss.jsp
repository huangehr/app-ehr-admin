<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .charts-main{
        width: 100%;
        height: 100%;
        padding: 10px;
    }
    .tab-list{
        font-size: 0;
        height: 40px;
        overflow-x: auto;
        overflow-y: hidden;
        white-space: nowrap;
    }
    .tab-item{
        width: 80px;
        height: 40px;
        line-height: 40px;
        text-align: center;
        display: inline-block;
        font-size: 12px;
        cursor: pointer;
    }
    .tab-item.active{
        border:1px solid #ccc;
        border-bottom:none;
    }
    .tab-con{
        height: calc(100% - 40px);
        border:1px solid #ccc;
        padding: 10px;
    }
    .charts-main .mCSB_scrollTools.mCSB_scrollTools_horizontal{
        height: 8px !important;
    }
</style>