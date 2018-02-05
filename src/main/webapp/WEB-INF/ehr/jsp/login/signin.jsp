<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    html,body,iframe,#signinCon{width: 100%;height: 100%}
    iframe{border: none;position: absolute;top: 0;left: 0;right: 0;bottom: 0;}
    .tips-con{margin-top: 130px;}
    .tips-con img{display:block;margin: 0 auto;width: 300px;height: 290px}
    .tips-con p{text-align: center;padding: 20px;font-size: 20px;font-weight: 600;color: #ccc;padding-top: 150px}
</style>

<div id="signinCon">
    <div class="tips-con">
        <%--<img src="${staticRoot}/images/timg.png">--%>
        <p>加载中...</p>
    </div>
</div>