<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div id="div_info_form" data-role-form class="m-form-inline f-mt20 f-pb10" style="overflow:auto">
    <input data-attr-scan="id" hidden="hidden"/>
    <%--保存初始数据------%>

    <div class="m-form-group">
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_id"  class="useTitle max-length-50 validate-special-char" data-attr-scan="rid"/>
            <input type="text" id="inp_name" class="useTitle max-length-50 validate-special-char"  data-attr-scan="name"/>
        </div>
    </div>


</div>
