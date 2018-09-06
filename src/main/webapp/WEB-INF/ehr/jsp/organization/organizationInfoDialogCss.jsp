<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

    .m-form-inline .m-form-group label{ width: 100px;}
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
	.pane-attribute-toolbar{ display: block;  position: absolute;  bottom: 0;  left: 0;  width: 100%;  height: 50px;  padding: 6px 0 4px;  background-color: #fff; text-align: right;  }
    .div-aptitude-manager-show{ margin-top: 40px;width: 100px; }
    .u-image-btn{ bottom: 55px; margin-top: 6px; }
    .f-ml130{ margin-left: 130px; bottom: 40px; }
    .lbl-public-key{top: 30px; right: 7px;}
    .f-w70 { width: 70px }
    .f-h70{ height: 70px }
    .f-w400 { width:400px; }
    .f-mt-20{ margin-top: -20px; }
    .m-combo-tab.f-dn.on { top: 28px;  bottom: 35px;  border-bottom: 1px #ddd solid;}
    #filelist .file-panel{ height: 30px !important;}
    .m-form-readonly textarea{pointer-events: auto}


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
	.m-form-inline .m-form-group{
		padding-bottom: 0 !important;
	}
	.m-form-inline div{
		font-size: 12px !important;
	}
	.list-tit{
		margin: 15px 10px 10px 10px !important;
	}
	.one-text-b{
		width: 395px;
	    padding: 10px;
	    border-width: 1px;
	    border-style: solid;
	    border-color: rgb(208, 208, 208);
	    border-image: initial;
    }
    .f-w395{width: 395px;}
    .l-text-field{width: 138px;}
    .clear{clear: both;}
    .f-w507{width: 507px;}
    #uploader .statusBar{border: none !important; position: absolute !important; top: -58px; right: 50px; width: 121px; height: 40px;}
    .list-title{padding: 0 0 10px 30px; font-size: 16px; font-weight: 600; border-bottom: 1px solid #ccc; color: #777;height: 50px;line-height: 50px;margin: 10px 10px 0 10px;}
    .u-select-title{width:146px;}
    #uploader .statusBar .btns{
        line-height: 30px !important;
    }
    #uploader .statusBar .btns .webuploader-pick{
        background: #D0EEFF !important;
        border: 1px solid #99D3F5 !important;
        color: #1E88C7 !important;
    }
    .is-null{
        width: 100%;
        line-height: 80px;
        display: block;
        position: absolute;
        text-align: center;
    }
</style>
