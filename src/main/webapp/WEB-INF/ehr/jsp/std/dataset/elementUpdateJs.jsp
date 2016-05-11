<%@ page import="java.util.Date" %>
<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/26
  Time: 14:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/Scripts/setJs.js?tim=<%=new Date()%>"></script>
<script >
  $(function(){
    set.elementAttr.init();
    var staged = $.Util.getUrlQueryString('staged');
    if(staged=='false'){
      setTimeout(function(){
        set.elementAttr.element_form_input.attr("disabled","disabled").css("background-color","#ffffff");
        set.elementAttr.element_form_select.attr("disabled","disabled").css("background-color","#ffffff");
        $("#metaDataDefinition,#datatype_txt").attr("disabled","disabled").css("background-color","#ffffff");
        set.elementAttr.element_form.find(".l-trigger").css("display","none");
        set.elementAttr.element_form.find(".l-trigger-cancel").remove();
        set.elementAttr.element_form.find(".l-text-trigger-cancel").remove();
      },200);
    }
  });
</script>
