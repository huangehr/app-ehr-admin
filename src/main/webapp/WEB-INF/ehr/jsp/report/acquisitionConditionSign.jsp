<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2018/1/11
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<style>
    /*html,body,iframe,#signinCon{width: 100%;height: 100%}*/
    /*iframe{border: none;position: absolute;top: 0;left: 0;right: 0;bottom: 0;}*/
    .tips-con{margin-top: 130px;}
    .tips-con img{width: 300px;height:300px;display:block;margin: 0 auto}
    .tips-con p{text-align: center;padding: 20px;font-size: 20px;font-weight: 600;color: #ccc;}
</style>

<div id="signinCon">
    <div class="tips-con">
        <img src="${staticRoot}/images/loding.gif">
        <p>加载中...</p>
    </div>
</div>