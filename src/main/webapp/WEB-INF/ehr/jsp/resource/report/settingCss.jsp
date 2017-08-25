<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .wrapper {
        position: absolute;
        width: 100%;
        height: 100%;
        padding: 20px 20px 70px 20px;
        text-align: center;
    }
    .wrapper .left-items, .wrapper .right-items {
        border: 1px solid #D6D6D6;
        height: inherit;
        width: 45%;
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
        padding: 10px;
    }
    #settingTreeContainer {
        height: 490px;
        background-color: inherit;
        padding-bottom: 10px;
    }
    #settingTreeContainer .mCustomScrollBox,
    #settingTreeContainer .mCSB_container {
        min-height: 490px;
    }
    #supplyTree.l-tree span {
        line-height: 22px;
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
    input {
        height: 28px;
        width: 240px;
    }
</style>