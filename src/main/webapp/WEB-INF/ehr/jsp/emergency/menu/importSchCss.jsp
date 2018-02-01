<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    body{
        margin: 0px !important;
    }
    .inlinebBlock {
        display: inline-block;
    }

    .flex {
        display: flex;
    }

    .new_Dialogue {
        width: 500px;
        height: 330px;
    }

    .title_Bk {
        padding: 10px;
        height: 40px;
        background: #29A2DB;
        position: relative;
        text-align: left;
        font-size: 14px;
        font-weight: bold;
        color: #ffffff;
    }

    .close_Dialogue {
        height: 24px;
        width: 24px;
        position: absolute;
        top: 10px;
        right: 10px;
        background-size: contain;
    }

    .base_Info {
        position: relative;
    }

    .div_info {
        height: 40px;
        background: #ffecc3;
        color: #ff8282;
    }

    .sigh {
        height: 16px;
        background: url(${staticRoot}/images/icon_jinshi-.png) no-repeat;
        background-size: contain;
        background-position: 70px 0px;
        text-align: center;
        font-size: 14px;
        position: relative;
        top: 10px;
        line-height: 16px;
    }

    .div_year {
        margin-top: 20px;
        padding-left: 20px;
    }

    .div_imfo {
        margin-top: 20px;
        padding-left: 20px;
    }

    .div_imfo input:nth-of-type(1) {
        width: 280px;
        border: 1px solid #E8ECEB;
        margin-left: 20px;
        height: 28px;
        background: #FFFFFF;
    }

    .div_imfo .bigbox {
        background: #FFFFFF;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
        display: inline-block;
        position: relative;
        top: 20px;
        left: 10px;
        text-align: center;
    }

    .div_download {
        color: #2aa2db;
        font-size: 16px;
        margin-top: 16px;
        padding-left: 108px;
        cursor: pointer;
    }

    .div_btn {
        width: 250px;
        margin: 64px auto;
        display: flex;
    }

    .div_btn>input {
        width: 110px;
        height: 30px;

    }

    .div_btn div:nth-of-type(1) {
        width: 95px;
        height: 34px;
        text-align: center;
        line-height: 34px;
        display: inline-block;
        background: #30A9DE;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
        position: relative;
    }

    .div_btn div:nth-of-type(2) {
        width: 100px;
        height: 34px;
        line-height: 34px;
        display: inline-block;
        background: #FFFFFF;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
        margin-left: 20px;
        text-align: center;
    }
    /*样式重置*/
    .webuploader-pick {
        position: relative;
        display: inline-block;
        cursor: pointer;
        background: #00b7ee;
        padding: 5px 5px;
        color: #fff;
        text-align: center;
        border-radius: 3px;
        overflow: hidden;
    }
    #div_doctor_img_upload{
        position: relative;
        top: -5px;
    }

</style>