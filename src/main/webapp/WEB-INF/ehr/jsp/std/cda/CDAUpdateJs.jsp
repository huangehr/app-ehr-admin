<%@ page import="java.util.Date" %>
<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/20
  Time: 17:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%--<script type="text/javascript" charset="utf-8" src="${contextRoot}/develop/lib/ueditor/ueditor.config.js"></script>--%>
<%--<script type="text/javascript" charset="utf-8" src="${contextRoot}/develop/lib/ueditor/ueditor.all.js"></script>--%>
<%--<script type="text/javascript" charset="utf-8" src="${contextRoot}/develop/lib/ueditor/editor_api.js"></script>--%>

<script type="text/javascript" charset="utf-8" src="${contextRoot}/develop/lib/editor/kindeditor.js"></script>
<script src="${contextRoot}/develop/Scripts/cdaRelationship.js"></script>
<script src="${contextRoot}/develop/Scripts/cdaJs.js?tim=<%=new Date()%>"></script>
<script >
  $(function(){

    $("#hd_user").val('${User.id}');
    cda.attr.init();
  });
</script>
