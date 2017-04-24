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
            <div class="m-form-control  f-ml10">
                <input type="text" id="inp_org" placeholder="请输入机构代码或机构名称" class="f-ml10" data-attr-scan="orgIdOrOrgName"/>
            </div>

            <div class="m-form-control  f-ml10">
                <input type="text" id="inp_name" placeholder="请输入姓名或身份证" class="f-ml10" data-attr-scan="nameOrIdCard"/>
            </div>

            <div class="m-form-control  f-ml10">
                <input type="text" id="inp_profileId" placeholder="请输入档案号" class="f-ml10" data-attr-scan="profileId"/>
            </div>

            <div class="m-form-control f-ml10">
                <input type="text" data-type="select" id="ipt_status" placeholder="关联状态" data-attr-scan="status">
            </div>

            <!--按钮:查询 & 新增-->
            <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                <span><spring:message code="btn.search"/></span>
            </div>


        </div>

    </div>
</div>

<!--###### 查询明细列表 ######-->
<div id="div_archiveRelative_info_grid" ></div>
</div>