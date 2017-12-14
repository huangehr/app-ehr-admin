<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .inlinebBlock {
        display: inline-block;
    }

    .flex {
        display: flex;
    }

    .new_Dialogue {
        width: 600px;
        height: 330px;
        border: 1px solid;
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
        background: url(img/icon_guanbi.png) no-repeat;
        background-size: contain;
    }

    .base_Info {
        height: 234px;
        padding: 28px 20px;
    }
    .base_Info>div{
        border-bottom: none;
    }
    .import_record>span{
        text-align: center;
        line-height: 50px;
        font-size: 16px;
    }
    .import_record>span:nth-of-type(1){
        height: 100%;
        width: 119px;
        background: #f1f5f7;
        border-right:: 1px solid #E8ECEB;
    }
    .import_record>span:nth-of-type(2){
        height: 100%;
        width: 425px;

    }
    .base_Info> div:nth-of-type(4){
        border-bottom: 1px solid #E8ECEB;
    }
    .import_record{
        width: 550px;
        height:50px ;
        border: 1px solid #E8ECEB;
    }
    .deult{
        color: #F95F60;
    }
</style>

<div class="new_Dialogue">
    <div class="title_Bk">
        <div class="inlinebBlock addCar">导入结果</div>
        <div class=" inlinebBlock close_Dialogue"></div>
    </div>
    <div class="base_Info">
        <div class="import_record">
            <span class="import_titlt inlinebBlock">导入记录</span>
            <span class="import_add inlinebBlock">120</span>
        </div>
        <div class="import_record">
            <span class="import_titlt inlinebBlock">新增记录</span>
            <span class="import_add inlinebBlock">91</span>
        </div>
        <div class="import_record">
            <span class="import_titlt inlinebBlock">修改记录</span>
            <span class="import_add inlinebBlock">65</span>
        </div>
        <div class="import_record">
            <span class="import_titlt inlinebBlock deult">失败</span>
            <span class="import_add inlinebBlock deult">0</span>
        </div>
    </div>
</div>