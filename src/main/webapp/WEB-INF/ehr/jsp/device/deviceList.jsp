<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true"><spring:message code="title.app.manage"/></div>
<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" >
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-mb10">
                <input type="text" id="device_name" placeholder="请输入设备名称" class="f-ml10" data-attr-scan="deviceName"/>
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <input type="text"  id="device_type"  data-type="select" placeholder="请选择设备代号" data-attr-scan="deviceType">
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <input type="text" id="org_code" data-type="select" placeholder="请选择归属机构" data-attr-scan="orgCode">
            </div>
            <div class="m-form-control f-mb10">
                <input type="text" id="device_model" placeholder="请输入设备型号" class="f-ml10" data-attr-scan="deviceModel"/>
            </div>
            <div class="m-form-control f-ml10 f-mb10">
                <!--按钮:查询 & 新增-->
					<div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-mr10" >
						<span><spring:message code="btn.search"/></span>
					</div>
            </div>
            <div class="m-form-control m-form-control-fr">
					<div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
						<span ><spring:message code="btn.create"/></span>
					</div>
                    <div id="btn_import" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                        <span >导入</span>
                    </div>
            </div>
        </div>
    </div>

    <!--###### 查询明细列表 ######-->
    <div id="div_device_grid" ></div>
</div>