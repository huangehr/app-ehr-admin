<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

    .m-form-inline .m-form-group label{ width: 130px;}
    .u-public-manage{ text-align: center; margin:3px; display:none; }
    .u-btn-color{ background: #4bb941; }
    .txt-public-content{ width:389px; height: 120px; }
    .u-border{ border-top:1px dashed #cccccc; height:1px; margin-top: -10px; }
    .save-f-ml150{ margin-left: 150px; margin-top: 50px; margin-bottom: 20px; }
    .cancel-f-ml91{ top: 20px; margin-left: 91px; }
    .u-f-mt5{ border: 0; margin-top: 5px; }
    .u-public-key-msg{width: 430px; height: 90px; border: 0;margin-top: 5px}
    .f-mb{ margin-bottom: 0;position: absolute; left: 90px}
    .f-ml-t{ position: absolute;  left: 10px; }
    .f-t30{ position: relative;  top: 30px;  left: -130px; }
    .u-bd{ border: 1px solid #c8c8c8;height: auto;margin-left: 10px;margin-right: 10px; margin-bottom: 10px; }
    .u-bd .m-form-group{padding-bottom: 0;}
    .f-wtl{ width:40px;top: -10px;left: 10px;background: #fff;text-align: center; }
    .m-combo-dropdown>.m-input-box{ margin-top: -1px;margin-left: -1px }
    .m-combo-dropdown .u-dropdown-icon{ margin-top: -1px;margin-right: -1px }
	.u-select-tab a{line-height:13px;  }
	.pane-attribute-toolbar{ display: block;  position: absolute;  bottom: 0;  left: 0;  width: 100%;  height: 50px;  padding: 6px 0 4px;  background-color: #fff; text-align: left;  }
	.save-toolbar{  margin-left: 360px;  }
    .div-aptitude-manager-show{ margin-top: 40px;width: 100px; }
    .u-upload{ margin-top: -40px; margin-left: 90px;margin-bottom: 16px;}
    .u-upload .uploader-list { width: 70px;  height: 70px; background:url("");border:1px solid #c8c8c8; }
    .u-image-btn{ bottom: 55px; margin-top: 6px; }
    .webuploader-pick-hover{ background: url(${staticRoot}/images/app/add_hui.png)}
    .webuploader-pick{ background: url(${staticRoot}/images/app/add_hui.png);width: 22px;height: 22px;  padding-top: 0;  padding-bottom: 0;  padding-right: 0;  padding-left: 0;}
    .f-ml130{ margin-left: 130px; bottom: 40px; }
    .lbl-public-key{top: 30px; right: 7px;}
    .f-w70 { width: 70px }
    .f-h70{ height: 70px }
    .f-w400 { width:400px; }
    .f-mt-20{ margin-top: -20px; }
    .m-combo-tab.f-dn.on { top: 28px;  bottom: 35px;  border-bottom: 1px #ddd solid;}

</style>