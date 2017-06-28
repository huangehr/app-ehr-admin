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
  .m-nav-tree .l-tree li .l-body, .m-nav-tree .l-tree .l-box, .m-nav-tree .l-tree a, .l-tree span, .m-nav-tree .l-tree .l-selected span{
    height: 22px;
    line-height: 22px;
  }
  .h-40{height:40px;}
  .div-header{width: 70%;height: 40px;text-align: center;line-height: 40px;background: #EDF6FA;font-weight: bold;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;}
  .div-opera-header{width: 30%;height: 40px;text-align: center;line-height: 40px;background: #EDF6FA;font-weight: bold;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;}
  .div-main-content{width: 70%;height: 40px;text-align: center;line-height: 40px;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;font-size: 12px;overflow: hidden;}
  .div-delete-content{width: 30%; height: 40px; border-bottom: 1px solid #DFDFDF; border-right: 1px solid #DFDFDF;float: left;text-align: center;  padding-top: 5px;}

</style>