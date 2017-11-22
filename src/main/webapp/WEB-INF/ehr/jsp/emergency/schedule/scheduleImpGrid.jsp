<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">卫生人员</div>

<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">

  <!-- ####### 查询条件部分 ####### -->
  <div id="searchForm" class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>
    <div id="sf-bar" class="m-retrieve-inner m-form-group f-mt10">
    </div>
  </div>
  <!--###### 查询明细列表 ######-->
  <div id="gridForm" data-role-form>
    <div id="impGrid" >

    </div>
  </div>

  <iframe id="downLoadIfm" style="display: none" src=""></iframe>
</div>


