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
        set.elementAttr.element_form.addClass("m-form-readonly");
        //set.elementAttr.element_form.find("input").addClass("l-text-field");
      },200);
    }
  });
</script>
