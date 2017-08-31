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
        overflow: hidden;
        padding: 0 10px;
    }
    .tab-item a{
        width: 100%;
        display: inline-block;
        overflow: hidden;
        color: #333;
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
    .con-tab{
        height: 50px;
        position: relative;
    }
    .con-t-t{
        width: 160px;
        height: 32px;
        line-height: 30px;
        display: inline-block;
        position: absolute;
        left: 50%;
        top: 50%;
        -webkit-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -ms-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%);
        border: 1px solid #e1e1e1;
        -webkit-border-radius: 30px;
        -moz-border-radius: 30px;
        border-radius: 30px;
        background: #fff;
    }
    .con-t-i{
        width: 80px;
        height: 32px;
        line-height: 32px;
        position: absolute;
        /* display: inline-block; */
        text-align: center;
        -webkit-border-radius: 30px;
        -moz-border-radius: 30px;
        border-radius: 30px;
        top: -1px;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        cursor: pointer;
    }
    .con-t-i.active{
        background: #3094d5;
        color: #fff;
    }
    .c-t-lef{
        left: 0;
    }
    .c-t-right{
        right: 0;
    }
    .condition{
        height: 30px;
        line-height: 30px;
        position: relative;
        text-align: right;
        border-bottom:1px solid #ccc;
        margin-bottom: 10px;
    }
    .un-show{
        display: none;
    }
    .go-back{
        position: absolute;
        left: 0;
        height: 30px;
        line-height: 30px;
        color: #333;
    }
    .go-back:active{
        color: #333;
    }
</style>