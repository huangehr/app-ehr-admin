
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true"><spring:message code="title.template.manage"/></div>

<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" >


    <!-- ####### 查询条件部分 ####### -->
    <div id="headerArea" class="m-retrieve-area f-dn f-pr m-form-inline" data-role-form>

        <div class="f-fr version" >
            <input type="text" data-type="select" id="inp_searchVersion" data-attr-scan="version">
        </div>

        <div style="height: 40px" >

            <div id="conditionArea" class="f-mr10" align="right" style="display: none">
                <div class="body-head f-h40" align="left">
                    <a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/organization/initial');"  class="f-fwb">返回上一层 </a>
                    <input id="adapter_plan_id" value='${adapterPlanId}' hidden="none" />
                    <span class="f-ml20">机构类型：</span><input class="f-fwb f-mt10" readonly id="h_org_type"/>
                    <span class="f-ml20">机构代码：</span><input class="f-mt10" readonly id="h_org_code"/>
                    <span class="f-ml20">机构全称：</span><input class="f-mt10" readonly id="h_org_name"/>
                </div>
            </div>

            <div class="m-form-control" id="div-searchNm" style="float: left">
                <a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/organization/initial');"  class="f-fwb hidden" id="a-back">返回上一层 </a>
                <!--输入框带查询-->
                <input type="text" id="inp_searchOrgName" placeholder="请输入模板或医疗机构" class="f-ml10 " data-attr-scan="orgName"/>
            </div>

            <sec:authorize url="/template/update">
            <div class="m-form-control m-form-control-fr f-ml10" style="float: right;">
                <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" onclick="javascript:$.publish('tpl:tplInfo:open',['','new'])" >
                    <span><spring:message code="btn.create"/></span>
                </div>
            </div>
            </sec:authorize>

        </div>
    </div>

    <!--###### 查询明细列表 ######-->
    <div id="div_tpl_info_grid" >

    </div>

    <div id="div_user_img_upload" class="f-dn" >
        <div id="div_file_picker" class="f-mt10">选择文件</div>
    </div>
</div>