<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2016/4/20
  Time: 14:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%--家庭关系页--%>
<div class="f-pr">

  <div >
    <div class="switch f-tac f-h50">
      <button id="btn_members" class="btn btn-primary f-mt10">家庭成员</button>
      <button id="btn_group" class="btn f-mt10">家庭群</button>
    </div>

    <%--家庭成员列表--%>
    <div id="div_home_relationship" data-role-form style="height: 573px;">
    </div>

    <div id="div_home_group" data-role-form  style="height: 573px;display: none;">
    </div>

    <input type="hidden" id="hd_url" value="${contextRoot}"/>
    <input type="hidden" id="hd_id" value="${id}"/>
  </div>
</div>