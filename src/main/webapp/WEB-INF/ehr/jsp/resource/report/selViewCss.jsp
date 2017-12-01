<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .wrapper {
        position: absolute;
        width: 100%;
        height: 100%;
        padding: 0 20px 70px 20px;
        text-align: center;
    }
    .wrapper .left-items, .wrapper .right-items {
        border: 1px solid #D6D6D6;
        height: inherit;
        width: 100%;
        display: inline-block;
        text-align: left;
    }
    .wrapper .left-items {
        float: left;
    }
    .wrapper .right-items {
        float: right;
    }
    .wrapper .arrow {
        position: relative;
        top: 42%;
        background: url(${staticRoot}/images/zhixiang_icon.png) center no-repeat;
        height: 30px;
        width: 30px;
        display: inline-block;
    }
    .wrapper .header {
        padding: 10px;
        height: 50px;
        line-height: 30px;
        border-bottom: 1px solid #D6D6D6;
    }
    .wrapper .content {
        /*padding: 10px;*/
        width: 324px !important;
        height: 467px;
        overflow-y: auto;
    }
    #settingTreeContainer {
        height: 467px;
        background-color: inherit;
        padding-bottom: 10px;
        overflow: hidden;
    }
    #settingTreeContainer .mCustomScrollBox,
    #settingTreeContainer .mCSB_container {
        min-height: 490px;
    }
    #supplyTree.l-tree span {
        line-height: 22px;
    }
    #selectedGrid {
        border: none;
    }
    .pane-attribute-toolbar {
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
    .close-toolbar {
        margin-right: 20px;
    }
    /*input {*/
        /*height: 28px;*/
        /*width: 240px;*/
    /*}*/
    /*input{*/
        /*width: inherit;*/
        /*height: inherit;*/
    /*}*/
    .v-h-left {
        width: 100%;
        text-align: center;
    }
    .v-h-con {
        display: inline-block;
    }
    .c-h-l-r {
        margin-right: 50px;
    }
    .c-h-l-r input, .c-h-r-r input {
        margin: 0 5px;
        vertical-align: middle;
    }
    .c-h-l-r span, .c-h-r-r span {
        vertical-align: middle;
    }
    .c-h-l-r input, .c-h-r-r input {
        margin: 0 5px;
        vertical-align: middle;
    }
</style>