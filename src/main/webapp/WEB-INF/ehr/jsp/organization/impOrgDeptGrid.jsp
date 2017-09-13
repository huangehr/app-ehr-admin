<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">机构&部门</div>

<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">

  <!-- ####### 查询条件部分 ####### -->
  <div id="searchForm" class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>
    <div id="sf-bar" class="m-retrieve-inner m-form-group f-mt10">

      <%--//新增成功功能暂时不用--%>
      <%--<div class="switch f-tac" style="float: left; margin-left: 10px">--%>
        <%--<button id="switch_err" class="btn  btn-primary">错误数据</button>--%>
        <%--<button id="switch_true" class="btn ">正确数据</button>--%>
      <%--</div>--%>

    </div>
  </div>

  <!--###### 查询明细列表 ######-->
  <div id="gridForm" data-role-form>
    <div id="impGrid" style="margin: 0 10px;">

    </div>
  </div>

  <iframe id="downLoadIfm" style="display: none" src=""></iframe>
</div>


