<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<style>
  #btn_add,#btn_del{
    position: inherit;
  }
</style>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">适配方案管理</div>

<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">
  <!-- ####### 查询条件部分 ####### -->
  <div class="m-retrieve-area f-dn f-pr m-form-inline condition" data-role-form>
    <div class="m-form-group f-mt10">
      <div class="m-form-control f-mb10">
        <!--输入框-->
        <input type="text" id="ipt_search" placeholder="请输入方案代码或名称" class="f-ml10" data-attr-scan="searchNm"/>
      </div>
      <div class="m-form-control f-ml10 f-mb10">
        <!--类别-->
        <input type="text" id="ipt_search_type"  placeholder="请选择方案类别" data-type="select" data-attr-scan="searchType">
      </div>
      <div class="m-form-control f-ml10 f-mb10">
        <!--映射机构-->
        <input type="text" id="ipt_search_org"  placeholder="请选择采集机构" data-type="select" data-attr-scan="searchOrg">
      </div>
      <div class="m-form-control m-form-control-fr f-ml10 f-mb10">
        <!--按钮:搜索-->
        <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
          <span>搜索</span>
        </div>
      </div>

      <sec:authorize url="/adapter/delete">
        <div class="m-form-control f-mb10" style="float: right;margin-left: 10px">
          <!--按钮:批量删除-->
          <div id="btn_del" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
            <span><spring:message code="btn.multi.delete"/></span>
          </div>
        </div>
      </sec:authorize>

      <sec:authorize url="/adapter/update">
      <div class="m-form-control m-form-control-fr f-mb10" style="float: right">
        <!--按钮:新增-->
        <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
          <span><spring:message code="btn.create"/></span>
        </div>
      </div>
      </sec:authorize>


    </div>
  </div>

  <!--###### 查询明细列表 ######-->
  <div id="div_adapter_info_grid" >

  </div>
</div>


