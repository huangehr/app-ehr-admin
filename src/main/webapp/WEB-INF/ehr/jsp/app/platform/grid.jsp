<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">平台应用</div>

<!-- ####### 页面部分 ####### -->
<div>
  <!-- ####### 查询条件部分 ####### -->
  <div id="searchForm" class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>
    <div class="m-retrieve-inner m-form-group f-mt10">
      <input type="hidden" value="1" data-attr-scan="sourceType"/>
      <sec:authorize url="/app/platform/list">
      <div class="m-form-control">
        <input type="text" id="ipt_search" placeholder="请输入应用名称" class="f-ml10" data-attr-scan="name"/>
      </div>

      <div class="m-form-control f-ml10">
        <input type="text" id="ipt_search_type"  placeholder="请选择应用类型" data-type="select" data-attr-scan="catalog">
      </div>
      </sec:authorize>
    </div>
  </div>

  <!--###### 查询明细列表 ######-->
  <div id="gtGrid" >

  </div>
</div>


