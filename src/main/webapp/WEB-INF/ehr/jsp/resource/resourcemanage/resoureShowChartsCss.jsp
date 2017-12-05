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
        position: relative;
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
    .go-back:focus{
        color: #333;
    }
    .con-t-con{
        position: relative;
    }
    .up-con{
        position: absolute;
    }
    .drill-list{
        position: absolute;
        top: 6px;
        transform: translateX(-50%);
        left: 50%;
        z-index: 10;
        font-size: 0;
        border: 1px solid #bebebe;
        cursor: pointer;
    }
    .dirll-item{
        /* width: 85px; */
        height: 25px;
        text-align: center;
        line-height: 25px;
        display: inline-block;
        position: relative;
        font-size: 14px;
        vertical-align: middle;
        user-select: none;
        padding: 0 11px;
    }
    .dimension-list{
        position: absolute;
        left: 0;
        top: 25px;
        font-size: 0;
        border: 1px solid #bebebe;
    }
    .dimension-item{
        min-width: 84px;
        height: 25px;
        line-height: 25px;
        background: #fff;
        font-size: 12px;
        color: #333;
        text-align: left;
        padding: 0 10px;
        overflow: hidden;
        word-break: keep-all;
    }
    .dimension-item:hover{
        background: #f5f5f5;
    }
    .triangle{
        width: 0;
        height: 0;
        display: inline-block;
        margin-right: 5px;
    }
    #dirllUp,#dirllDown{
        background: #ccc;
        color: #fff;
    }
    #dimensionName{
        min-width: 85px;
        background: #fff;
        color: #ccc;
        /*padding: 0 10px;*/
        /*overflow: hidden;*/
        word-break: keep-all;
    }
    .up-triangle{
        border-right: 6px solid transparent;
        border-bottom: 7px solid #fff;
        border-left: 6px solid transparent;
    }
    .down-triangle{
        border-top: 7px solid #fff;
        border-right: 6px solid transparent;
        border-left: 6px solid transparent;
    }
    .hover-show{
        width: max-content;
        color: #fff;
        background-color: #f0ad4e;
        border-color: #eea236;
        padding: 0 10px;
        position: absolute;
        left: 50%;
        top: 30px;
        font-size: 12px;
        display: none;
    }
    #dirllUp .hover-show,#dirllDown .hover-show{
        color: #d9534f;
        background-color: #f2dede;
    }
    .dirll-item.active .hover-show{
        color: #fff !important;
        background-color: #f0ad4e !important;
    }
    .dirll-item.active .hover-show.active{
        display: none;
    }
    .dirll-item:hover .hover-show{
        display: block;
    }
    #chart{
        margin-top: 45px;
    }
    .dirll-item.active{
        background: #2D9BD2 !important;
    }
</style>