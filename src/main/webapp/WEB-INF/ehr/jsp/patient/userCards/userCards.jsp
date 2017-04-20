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
                <input type="text" id="inp_cardNo" placeholder="请输入卡号" class="f-ml10" data-attr-scan="cardNo"/>
            </div>

            <div class="m-form-control">
                <input type="text" id="inp_name" placeholder="请输入持卡人姓名" class="f-ml10" data-attr-scan="name"/>
            </div>

            <div class="m-form-control f-ml10">
                <input type="text" data-type="select" id="ipt_auditStatus" placeholder="审核状态" data-attr-scan="auditStatus">
            </div>

            <!--按钮:查询 & 新增-->
            <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                <span><spring:message code="btn.search"/></span>
            </div>

            <div class="m-form-control m-form-control-fr">
                <sec:authorize url="/patient/UserCardsAuditInfo">
                    <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                        <span ><spring:message code="btn.create"/></span>
                    </div>
                </sec:authorize>
            </div>
        </div>

    </div>
</div>

<!--###### 查询明细列表 ######-->
<div id="div_userCards_info_grid" ></div>
</div>