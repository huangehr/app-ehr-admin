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
	.m-form-inline div{font-size: 15px}

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
