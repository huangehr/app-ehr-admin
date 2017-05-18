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
    .div-items  .div-item-content img{width: 42px;height: 42px;margin: 5px;}
    .div-items  .div-item-content span{font-size: 30px;vertical-align:middle;font-weight: bold;}
    .div-items  .div-item-content .div-item-type, .div-items  .div-item-content .div-item-count{text-align: center;padding-top: 10px;font-size: 16px;color: #666666;}
    .div-qsfx{color:#666666;margin:30px 20px;font-size: 16px;}
    .div-group{height: 34px;border:1px solid #dddddd;width: 212px;position: absolute;right: 20px;top: 20px;}
    .div-group .div-btn{width: 70px;height: 32px;float: left;background: #fff;color: #000;text-align: center;line-height: 32px;border-right: 1px solid #dddddd;}
    .div-group .div-btn:last-child{border-right: 0}
    .div-group .div-btn.active{background: #4DB2EE;color: #ffffff;}
    .div-hospital-name{width: 100px;height: 100px;position: relative;border-radius: 100px;text-align: center;border:1px solid #dddddd;font-size: 15px; font-weight: bold;padding: 15px;display: -webkit-box;overflow: hidden;text-overflow: ellipsis;-webkit-box-orient: vertical;-webkit-line-clamp: 3;}
    .div-hospital-name p{position: relative;top:50%;transform:translateY(-50%);overflow: hidden;}
    .div-hospital-item{width: 70%;height: 40px;border:1px solid #dddddd; position: absolute; left: 120px;top: 30px;}
    .l-gq-bg{position: relative;height: 39px;background-color: #4DB2EE; z-index: 1;}
    .l-gq-value{position: relative;top: -70%;left: 5px;color: #fff;z-index: 2;font-size: 14px;}
    .div-chart-content{height:345px;border:1px solid #dddddd;border-left: 0;border-right:0;position: relative;}
    .div-zuoqiehuan{background: url(${staticRoot}/images/zuoqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;left: 0px;top: 45%;z-index: 20;}
    .div-zuoqiehuan:active,.div-zuoqiehuan:hover{background: url(${staticRoot}/images/zuoqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    .div-youqiehuan{background: url(${staticRoot}/images/youqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;right: 20px;top: 45%;z-index: 20;}
    .div-youqiehuan:active,.div-youqiehuan:hover{background: url(${staticRoot}/images/youqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    #chart-main{width: 100%;height: 250px;position: relative;z-index: 10;}
    .div-organization{position: relative;}
</style>