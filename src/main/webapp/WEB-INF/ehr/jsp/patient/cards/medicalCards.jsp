<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>
    .m-form-inline .m-form-group .m-form-control.m-form-control-fr {
        float: right;
    }
</style>


<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true"><spring:message code="title.app.manage"/></div>
<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" >
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10">
            <div class="m-form-control">
                <input type="text" id="inp_search" placeholder="请输入卡号" class="f-ml10" data-attr-scan="searchNm"/>
            </div>

            <div class="m-form-control f-ml10">
                <input type="text" data-type="select" id="ipt_status" placeholder="状态" data-attr-scan="status">
            </div>

            <!--按钮:查询 & 新增-->
            <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                <span><spring:message code="btn.search"/></span>
            </div>

            <sec:authorize url="/ehr/template">
                <a href="<%=request.getContextPath()%>/template/MCardsImportTpl.xls" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr10"
                   style="">
                    下载模版
                </a>
            </sec:authorize>

            <sec:authorize url="/medicalCards/import">
                <div id="upd" class="f-fr f-mr10" style="overflow: hidden; width: 84px; position: relative"></div>
            </sec:authorize>

            <sec:authorize url="/app/patient/MedicalCardsInfo">
                <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                    <span ><spring:message code="btn.create"/></span>
                </div>
            </sec:authorize>

        </div>

    </div>
</div>

<!--###### 查询明细列表 ######-->
<div id="div_medicalCards_info_grid" ></div>
</div>