<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<link rel="stylesheet" href="${contextRoot}/develop/common/flod.css">
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true">机构管理</div>

<!-- ####### 页面部分 ####### -->
<div id="div_wrapper">
    <!--<div class="alert-warning">
        <i class="icon-warring"></i>
        <p>说明：双击列表单行，可查看机构详情。</p>
    </div>-->
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-mb10">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入代码或名称" class="f-ml10" data-attr-scan="searchParm"/>
            </div>

            <div class="m-form-control f-ml10">
                <!--下拉框-->
                <input type="text" id="inp_orgArea" placeholder="请选择地区" data-type="comboSelect" data-attr-scan="location">
            </div>
            <div class="m-form-control f-ml10">
                <!--按钮:查询 & 新增-->
                <sec:authorize url="/organization/searchOrgs">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>

    <!--######机构信息表######-->
    <div id="div_org_info_grid">

    </div>
</div>