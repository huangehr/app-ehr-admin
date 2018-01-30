<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    body{
        overflow: scroll!important;
    }
    .l-dialog{
        position: absolute;
        top: 40px !important;
    }
    .containBox {
        width: 600px;
        /*height: 830px;*/
    }

    /*.div_title {*/
        /*color: #30A9DE;*/
        /*font-size: 16px;*/
        /*padding-top: 30px;*/
        /*padding-left: 60px;*/
        /*background-position: 1374px 20px;*/
    /*}*/

    .base_info {
        padding-left: 130px;
        height: auto;
    }

    .main_info {
        padding-bottom: 20px;
        border-bottom: 2px solid #EDF0F0;
    }
    .main_info>a{
        text-decoration: none;
        color: #333333
    }

    .main_info_kid {
        padding-top: 20px;
    }

    .main_info_kid>div {
        padding: 7px 20px;
    }

    .particular>span:nth-of-type(2) {
        margin-left: 70px;
    }

    .basis>div:first-child {
        padding-top: 15px;
    }
    .sex{
        width: 135px;
    }
    .edio_btn {
        width: 250px;
        margin: 30px auto;
        position: relative;
        right: 80px;
    }

    .edio_btn>input {
        width: 110px;
        height: 34px;
    }

    .edio_btn input:nth-of-type(1) {
        background: #30A9DE;
        color: #FFFFFF;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
    }

    .edio_btn>input:nth-of-type(2) {
        background: #FFFFFF;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
        margin-left: 20px;
    }
</style>

