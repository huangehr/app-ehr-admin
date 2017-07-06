<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
  .m-form-inline .m-form-group label{ width: 110px;float: left; }
  .m-form-inline .m-form-group{padding-bottom: 0;}
  .u-upload-img{ position: absolute; left: 400px; }
  .u-border{ border-top:1px dashed #cccccc; height:1px; margin-top: -10px; }
  .f-wtl{ top: -10px;left: 10px;background: #fff;text-align: center; }
  .u-bd{ border: 1px solid #c8c8c8;height: auto;margin-left: 10px;margin-right: 10px;margin-bottom: 10px; }
  .pane-attribute-toolbar{  display: block; width: 100%;  height: 50px;  padding: 6px 0 4px;  background-color: #fff;  text-align: right;  }
  .close-toolbar{  margin-right: 20px;  }
  .f-w88{ width: 88px; }
  .f-h110{ height: 110px }
  .pop_tab {
    height: 36px;
    line-height: 36px;
    background: url(${staticRoot}/images/sub_bg_01.png) #d4e7f0 repeat-x left bottom;
    padding-left: 2px;
  }

  .pop_tab li.cur {
    background: #fff;
    font-weight: bold;
    border-left: 1px solid #cacaca;
    border-right: 1px solid #cacaca;
  }
  .pop_tab li {
    cursor: default;
  }
  .pop_tab li {
    font-size: 12px;
    color: #000;
    float: left;
    padding: 0 14px;
  }
  .divIntervalOption {
    display: none;
    padding-top: 10px;
  }
  .divIntervalOption .l-text {
    float: left;
  }
  .divIntervalOption .label-left {
    float: left;
    padding-left: 4px;
    padding-right: 4px;
    height: 30px;
    line-height: 30px;
  }
  .divIntervalOption .m-form-group{margin-bottom: 10px;}
  #divIntervalOption4 .label-left{line-height: 20px;}
  #divIntervalOption4 .l-text{margin-top: -4px;}
  .f-h50{height: 50px;}
</style>