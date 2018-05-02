<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    body, html, #div_wrapper {
        height: 100%;overflow: hidden;
    }
    .div-radio-img {
        background: url(${staticRoot}/images/danxuan_btn.png) no-repeat;
        width: 16px;
        height: 16px;
        position: absolute;
        left: 50%;
        margin-left: -145px;
        top: 0px;
    }
    .div-radio-img.active{
        background: url(${staticRoot}/images/danxuan_pre.png) no-repeat;
    }
    .div-checkbox-img{
        background: url(${staticRoot}/images/weigouxuan_icon.png) no-repeat;
        width: 16px;
        height: 16px;
        display: inline-block;
    }
    .div-checkbox-img.active{
        background: url(${staticRoot}/images/yigouxuan_icon.png) no-repeat;
    }
    .f-inline-block{display: inline-block;}
    .f-pr{position: relative;}
    .f-mt20{margin-top: 20px;}
    .f-mt160{margin-top: 160px;}
    .div-bottom{height: 50%;position: relative;top: 55%;}
    .div-prev,.div-next{height: 50%;border-bottom: 1px solid #dcdcdc;text-align: center;width: 100%;position: absolute;top: 0;}
    .div-prev .position-relative{display: inline-block;position: relative;height: 100%;margin-left: -176px;top: 2px;}
    .div-combox{position: absolute; left: 100px;top: -13px;}
    .f-tac{text-align: center}
    .f-dn{display: none;}
    #div-form{width: 500px;position: absolute;top: 50%;margin-top: -102px;left: 50%;margin-left: -250px;}
    .div-next .position-relative{display: inline-block;position: relative;top: -3px;}
    .div-textarea{height: 148px; border: 1px solid #dcdcdc;padding:5px;}
    .div-label{top: 7px;display: inline-block;}
</style>