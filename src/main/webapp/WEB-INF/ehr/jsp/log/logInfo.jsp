<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/16
  Time: 19:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
    <div class="m-form-group">
        <label>系统名称<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential f-pr0">
            <input type="text" id="inp_category" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="categoryId" />
        </div>
    </div>
</div>
