<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
  .m-form-inline .m-form-group label{ width: 110px;}
  .m-form-inline .m-form-group { padding-bottom: 5px; }
  .u-upload-img{ position: absolute; left: 400px; }
  /*.f-tac{ margin-top: -760px; margin-left: 400px; }*/
  .f-ml160{ margin-left:160px; }
  .f-ml60{ margin-left: 60px; }

  .pane-attribute-toolbar{
    display: block;
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 50px;
    padding: 6px 0 4px;
    background-color: #fff;
    /*border-top: 1px solid #ccc;*/
    text-align: left;
  }
  .save-toolbar{
	  margin-left: 160px;
  }
  .l-dialog-body {
    overflow: auto;
  }
  .l-tree .l-body span,.l-tree .l-over span{line-height:26px !important;}
  .listree{ display: block; width: 72%;; float: left;margin: 0 0 0 110px;}
  .listree li{display: inline; float: left; padding: 0 5px;  height: 26px;line-height: 26px; border: 1px #2D9BD2 solid;margin: 10px 10px 0 0; position: relative;}
  .listree li a{ border-radius: 50%;position: absolute;right: -10px;top: -10px;width: 20px; background: #2D9BD2;height: 20px; color: #fff;text-align: center;line-height: 20px;font-size: 14px;opacity: 0.6;}
  .pane-attribute-toolbar{position:unset }

  .file {
    position: relative;
    display: inline-block;
    background: #D0EEFF;
    background: rgb(255, 255, 255);
    border: 1px solid #99D3F5;
    border-radius: 4px;
    padding: 4px 12px;
    overflow: hidden;
    color: #1E88C7;
    text-decoration: none;
    text-indent: 0;
    line-height: 20px;
    width: 180px;
  }
  .file input {
    position: absolute;
    font-size: 100px;
    right: 10px;
    top: 0;
    /*opacity: 0;*/
  }
  .file:hover {
    background: #AADFFD;
    border-color: #78C3F3;
    color: #004974;
    text-decoration: none;
  }

  .uploadBtn{
    position: relative;
    display: inline-block;
    background: #D0EEFF;
    border: 1px solid #99D3F5;
    border-radius: 4px;
    padding: 4px 12px;
    overflow: hidden;
    color: #1E88C7;
    text-decoration: none;
    text-indent: 0;
    line-height: 20px;
  }


</style>