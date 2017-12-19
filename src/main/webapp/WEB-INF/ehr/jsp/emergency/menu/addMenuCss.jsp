<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .inlinebBlock{
        display: inline-block;
    }
    .flex{
        display: flex;
    }
    .close_Dialogue {
        height: 24px;
        width: 24px;
        position: absolute;
        top: 10px;
        right: 10px;
    }

    .base_Info {
        padding: 20px 24px 30px 24px;
        position: relative;
    }

    .base_Info>p {
        height: 50px;
        color: #323232;
        line-height: 50px;
        font-size: 14px;
        font-weight: bold;
        border-bottom: 1px solid #E8ECEB;
    }
    #license_Plate_input{
        margin-left: 30px;
        height: 26px;
        border: 1px solid #E8ECEB;
    }
    .license_plate_number>label:nth-of-type(2){
        margin-left: 50px;
    }
    input[type=radio]{
        margin-left: 15px;
    }
    .personnel_phone>input{
        height: 26px;
        border: 1px solid #E8ECEB;
        margin-left: 30px;
    }
    .Ascription>input{
        height: 26px;
        border: 1px solid #E8ECEB;
        margin-left: 30px;
    }
    .area>input{
        height: 26px;
        border: 1px solid #E8ECEB;
        margin-left: 30px;
    }
    .divInput{
        width: 300px;
        /*margin-top: 50px;*/
        /*position: relative;*/
        /*left: 100px;*/
        margin: 40px auto;
    }
    /*样式重置*/
    .l-text {
        width: 240px;
        height: 30px;
        line-height: 30px;
        margin-left: 30px;
    }
    .operation{
        position: absolute;
        top: 345px;
        width: 220px;
        transform: translateX(121px);
    }
    .operation input{
        width: 88px;
        height: 34px;
        font-size: 14px;
        margin-left: 10px;
    }
    .operation input:nth-of-type(1){
        background: #30A9DE;
        color: #FFFFFF;
        border: none;
        border-radius: 3px;
    }
    .operation input:nth-of-type(2){
        background: #FFFFFF;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
    }
    /*样式重置*/
    .l-text-wrapper{
        position: relative;
        top:5px;
    }
    .u-upload .uploader-list {
        width: 100px;
        height: 100px;
        background: none;
        position: absolute;
    }
</style>