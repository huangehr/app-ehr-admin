<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .f-p10{
        background: #EEF3FA !important;
        overflow: scroll;
    }

    .inlineBloock{
        display: inline-block;
    }
    .div_Top{
        padding-top: 30px;
        padding-bottom:20px;
        padding-left: 10px;
        background: #ffffff;
        position: relative;
    }
    .sm_box{
        width: 5px;
        height: 20px;
        background: #00b7ee;
    }
    .standbyText{
        position: relative;
        top:-5px;
        left: 10px;
    }
    .addBtn{
        position: absolute;
        top: 10px;
        right: 10px;
        width: 88px;
        height: 34px;
        background: #2D9BD2;
        line-height: 34px;
        color: #fff;
        text-align: center;
        border-radius: 3px;
        cursor: pointer;
    }
    .div_Bottom{
        height: 180px;
        margin-top: 20px;
        padding-top: 15px;
        padding-left: 10px;
        padding-right: 10px;
        background: #ffffff;
    }
    .contain_save{
        height: 100px;
        background: #f1f5f7;
        margin-top: 20px;
    }

    .sm_contain_save{
        padding-top:20px;
        padding-left: 20px;
    }
    .sm_contain_save>input:nth-of-type(1){
        height: 28px;
        border: none;
        width: 300px;
    }
    .sm_contain_save>input:nth-of-type(2){
        margin-left: 20px;
        height: 34px;
        width: 90px;
        text-align: center;
        color: #ffffff;
        background:#30A9DE ;
        border: none;
        border-radius: 3px;
    }
    .sm_contain_text{
        padding-left: 20px;
        padding-top: 10px;
        font-size: 12px;
        color: #B2B4B4;
    }
    /*样式重置*/

    .l-frozen .l-grid2 .l-grid-body {
        overflow-y: scroll!important;
    }
</style>