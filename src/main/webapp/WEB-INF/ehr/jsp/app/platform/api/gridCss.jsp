<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

    .image-create{
        display: inline-block;
        margin-left: -4px;
        margin-top: 10px;
        width: 20px;
        height: 30px;
        background: url(${staticRoot}/images/tianjia_btn.png) no-repeat;
    }

    .image-create:hover{
        cursor: pointer;
        background: url(${staticRoot}/images/tianjia_pre.png) no-repeat;
    }

    .retrieve-border{
        display:block;
        border: 1px solid #D6D6D6;
        border-bottom: 0px
    }

    .l-tree .l-tree-text-height{
        height: 22px;
        line-height: 22px;
    }
    .l-tree span{
        height: 22px;
        line-height: 22px;
    }
    .body-head input{
        border: 0;
        font-size: 12px;
        width: 120px;
    }
    .back{
        border-right: 1px solid #d3d3d3;
    }

    .l-grid-row-hide{display: none !important}

    .row-icon{
        width: 20px;
        height: 20px;
        float: left;
        margin-top: 10px;
        margin-right: 10px;
        margin-left: 5px;
    }
</style>