<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/25
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/Scripts/setJs.js"></script>
<script >
  $(function(){
    set.attr.init();
    var staged = $.Util.getUrlQueryString('staged');
    if(staged=='false'){
        set.attr.set_form_input.attr("disabled","disabled").css("background-color","#ffffff");
        set.attr.set_form_select.attr("disabled","disabled").css("background-color","#ffffff");
        $("#txt_description").attr("disabled","disabled").css("background-color","#ffffff");
        set.attr.set_form.find(".l-trigger").remove();
    }
  });
</script>
