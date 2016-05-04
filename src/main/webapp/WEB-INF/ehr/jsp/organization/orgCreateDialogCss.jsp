<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    #dialog_tags { height: 100px; }
    .update-footer{right: 10px;bottom: 0;}
    .m-combo-dropdown>.m-input-box{ margin-top: -1px;margin-left: -1px }
    .m-combo-dropdown .u-dropdown-icon{ margin-top: -1px;margin-right: -1px }
	.u-select-tab a{line-height:13px;  }
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
	.save-toolbar{ margin-left: 360px; }
	.u-border{ border-top:1px dashed #cccccc;margin-top: 10px; margin-bottom: 16px;}
	.u-bd{ border: 1px solid #c8c8c8;height: 100px;margin-left: 10px;margin-right: 10px; }
	.f-wtl{ width:40px;top: -10px;left: 10px;background: #fff;text-align: center; }
	.div-aptitude-manager{ margin-top: 40px;width: 70px; }
	.u-upload{ margin-top: -40px; margin-left: 80px;}
	.u-upload .uploader-list { width: 70px;  height: 70px; background:url("");border:1px solid #c8c8c8; }
	.u-image-btn{ bottom: 55px; margin-top: 6px; }
	.webuploader-pick-hover{ background: url(${staticRoot}/images/app/add_hui.png)}
	.webuploader-pick{ background: url(${staticRoot}/images/app/add_hui.png);width: 22px;height: 22px;  padding-top: 0;  padding-bottom: 0;  padding-right: 0;  padding-left: 0;}

</style>
