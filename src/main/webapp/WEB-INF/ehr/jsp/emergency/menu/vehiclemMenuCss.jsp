<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .inlinebBlock{
        display: inline-block;
    }
    .flex{
        display: flex;
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
    .head_portrait{
        position: absolute;
        top: 100px;
    }
    .head_Text,.head_Img,.head_Explain{
        height: 100px;
    }
    .head_Text{
        font-size: 14px;
        height: 100px;
        line-height: 100px;
        font-weight: bold;
    }
    .head_Img{
        margin-left: 30px;
        width: 100px;
        background: #E6E6E6;
        position: relative;
        background: url(${staticRoot}/images/jiuhuche.jpg) no-repeat;
        background-size: contain;
    }
    #div_file_picker{
        width: 100%;
        height: 100%;

    }
    .webuploader-pick{
        width: 100%;
        height: 100%;
        background: url(${staticRoot}/images/icon_jiahao.png) no-repeat center;
    }
    .head_Explain{
        width: 250px;
        margin-left: 20px;
        color: #909090;
        font-size: 12px;
    }
    .license_plate_number{
        font-size: 14px;
        position: absolute;
        top: 195px;
    }
    #license_Plate_input{
        text-align: center;
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
    .personnel_phone{
        font-size: 14px;
        position: absolute;
        top: 265px;
    }
    .deviceCoding{
        font-size: 14px;
        position: absolute;
        top: 230px;
    }
    .deviceCoding>input{
        text-align: center;
        height: 26px;
        border: 1px solid #E8ECEB;
        margin-left: 30px;
    }
    .personnel_phone>input{
        text-align: center;
        height: 26px;
        border: 1px solid #E8ECEB;
        margin-left: 30px;
    }
    .Ascription{
        font-size: 14px;
        position: absolute;
        top: 290px;
    }
    .Ascription>div{
        width: 380px;
        height: 28px;
        display: inline-block;
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
    .m-form-control.essential:after {
        display: block;
        content: '*';
        color: #FF0000;
        position: absolute;
        top: 0;
        right: 90px;
        height: 30px;
        line-height: 34px;
    }
</style>