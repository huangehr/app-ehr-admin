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
        width: 500px;
        height: 170px;
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
        height: 130px;
        position: relative;
        padding: 0px 25px;
    }

    .download_title {
        padding-top: 50px;
        color: #909090;
        font-size: 14px;
    }

    .speed {
        margin-top: 20px;
        height: 10px;
        border-radius: 20px;
        background: #F1F5F6;
    }

    .sm_speed {
        width: 50%;
        background: #31AADF;
        height: 100%;
        border-radius: 20px;
    }
</style>

<div class="new_Dialogue">
    <div class="title_Bk">
        <div class="inlinebBlock addCar">导入进度</div>
        <div class=" inlinebBlock close_Dialogue"></div>
    </div>
    <div class="base_Info">
        <div class="download_title">上饶市第五医院救护车排班表.doc</div>
        <div class="speed">
            <div class="sm_speed"></div>
        </div>
    </div>
</div>