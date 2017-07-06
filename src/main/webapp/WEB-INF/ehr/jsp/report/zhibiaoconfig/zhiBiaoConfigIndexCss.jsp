<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/lib/bootstrap/css/bootstrap.min.css">
<style>

  .btn-group .btn{border-radius: 25px;padding: 9px 20px;}
  [data-toggle=buttons]>.btn input[type=checkbox], [data-toggle=buttons]>.btn input[type=radio], [data-toggle=buttons]>.btn-group>.btn input[type=checkbox], [data-toggle=buttons]>.btn-group>.btn input[type=radio] {
    position: absolute;
    clip: rect(0,0,0,0);
    pointer-events: none;
  }
  .btn-default:active:hover, .btn-default.active:hover, .open > .dropdown-toggle.btn-default:hover, .btn-default:active:focus, .btn-default.active:focus, .open > .dropdown-toggle.btn-default:focus, .btn-default:active.focus, .btn-default.active.focus, .open > .dropdown-toggle.btn-default.focus {
    color: #fff;
    background-color: #2E9CD2;
    border-color: #2E9CD2;
  }
  .btn-default.active, .btn-default.focus, .btn-default:active, .btn-default:focus, .btn-default:hover, .open>.dropdown-toggle.btn-default {
    color: #fff;
    background-color: #2E9CD2;
    border-color: #2E9CD2;
  }
.m-retrieve-area{border: 1px solid #D6D6D6;border-bottom: 0;}
  .f-fr{float:right !important;}
</style>
