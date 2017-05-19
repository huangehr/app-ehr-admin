<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .l-layout-content{overflow: auto;}
    #btn_detail{ background: #4DB2EE; width: 98px !important; height: 34px; line-height: 34px;}
    .m-form-inline .m-form-group label{ width: 110px;float: left; }
    .m-form-inline .m-form-group{padding-bottom: 0;}
    .m-form-inline .m-form-group .m-form-control.m-form-control-fr{float: right}
    .div-title{margin: 10px 0px 20px;text-align: center;font-size: 20px;color: #666666;}
    .div-head{height: 168px;margin: 20px 0px;}
    .div-items{width: 40%;height: 100%;float: left;border: 1px solid #dddddd;}
    .div-item-title{height: 40px;width: 100%;text-align: center;background: #f3f3f3;line-height: 40px;border-bottom:1px solid #dddddd;color:#bbbbbb;}
    .div-item-content{width: 100%;height: 128px;text-align: center}
    .div-item{width: 33%;height: 100%;border-right: 1px solid #dddddd;float:left;}
    .div-item:last-child{border-right:0;}
    .div-item.active{border: 2px solid #4DB2EE;}
    .div-items  .div-item-content img{width: 30px;height: 30px;margin: 10px 5px;}
    .div-items  .div-item-content span{font-size: 1.6vw;vertical-align:middle;font-weight: bold;}
    .div-items  .div-item-content .div-item-type, .div-items  .div-item-content .div-item-count{text-align: center;padding-top: 10px;font-size: 16px;color: #666666;}
    .div-qsfx{color:#666666;margin:30px 20px;font-size: 16px;}
    .div-group{height: 34px;border:1px solid #dddddd;width: 212px;position: absolute;right: 20px;top: 20px;}
    .div-group .div-btn{width: 70px;height: 32px;float: left;background: #fff;color: #000;text-align: center;line-height: 32px;border-right: 1px solid #dddddd;}
    .div-group .div-btn:last-child{border-right: 0}
    .div-group .div-btn.active{background: #4DB2EE;color: #ffffff;}
    .div-analysis-title{height: 60px;line-height:60px;border: #dddddd solid 1px;border-bottom: none;}
    .div-analysis-title .title{margin-left: 20px;}
    .div-analysis-title .tips{margin-right: 160px;color: red;}
    .div-analysis-title .icon{margin-right: 20px;margin-top: 16px;}
    #table_analysis{width: 100% !important;}
</style>