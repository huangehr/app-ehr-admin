<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/1/24 0024
  Time: 下午 4:27
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/routine/animate.min.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/routine/style.min862f.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/routine/bootstrapStyle/bootstrapStyle.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/browser/lib/bootstrap/bootstrap-table.min.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/routine/bootstrap.min14ed.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/layer/skin/layer.css" />
<link rel="stylesheet" type="text/css"
      href="${contextRoot}/develop/lib/plugin/layui/css/layui.css" />
<style>
    body{
        background: none;
    }
    .aq-main{
        height: 100%;
        position: relative;
        overflow: hidden;
    }
    .aq-top{
        background: #fff;
        margin-bottom: 10px;
    }
    .aq-top,.aq-bottom{
        padding: 10px;
    }
    .aq-bottom{
        width: 100%;
        background: #fff;
        position: absolute;
        top: 126px;
        left: 0;
        bottom: 0;
    }
    .aq-tit{
        font-size: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid #e8edec;
    }
    .aq-tit-one{
        color: #30a9de;
    }
    .aq-tit-two{
        color: #aebaba;
    }
    .aq-btns{
        padding: 20px 0 10px 0;
        position: relative;
    }
    .aq-btn{
        width: 110px;
        height: 34px;
        line-height: 34px;
        text-align: center;
        font-size: 14px;
        background: #30a9de;
        color: #fff;
        display: inline-block;
        -webkit-border-radius:2px;
        -moz-border-radius:2px;
        border-radius:2px;
        margin-right: 20px;
        cursor: pointer;
        position: relative;
    }
    .sel-btn,.aq-defaule,.show-set-btn{
        float: right;
        margin: 0;
        background: #fff;
        color: #323232;
        border: 1px solid #e8edec;
        text-align: inherit;
        padding-left: 26px;
    }
    .show-set-btn{
        float: inherit;
        padding-left: 14px;
        vertical-align: top;
    }
    .icon-d{
        width: 15px;
        height: 15px;
        display: block;
        background: url(${staticRoot}/images/_icon_xiala.png) center no-repeat;
        position: absolute;
        top: 10px;
        right: 14px;
    }
    .sel-btn.active .icon-d,.show-set-btn.active .icon-d{
        top: 8px;
        background: url(${staticRoot}/images/icon_shangla.png) center no-repeat;
    }
    .sel-con{
        width: 100%;
        height: 470px;
        position: absolute;
        top: 115px;
        background: #fff;
        left: 0;
        z-index: 10;
        border: 1px solid #e8edec;
        padding: 20px 20px 74px 20px;
        overflow: hidden;
        display: none;
    }
    .sel-body{
        position: absolute;
        left: 20px;
        top: 20px;
        right: 20px;
        bottom: 94px;
        overflow-x: hidden;
        overflow-y: auto;

    }
    .sel-item{
        margin-bottom: 10px;
    }
    .sel-item label{
        width: 155px;
        display: inline-block;
        vertical-align: middle;
        margin: 0;
        font-size: 14px;
        font-weight: 400;
        margin-right: 15px;
        text-align: right;
    }
    .item-sel{
        display: inline-block;
        vertical-align: middle;
        margin-right: 20px;
    }
    .sel-btns{
        padding: 20px;
        position: absolute;
        left: 0;
        bottom: 0;
        right: 0;
        text-align: right;
        background: #fff;
        border-top: 1px solid #e8edec;
    }
    .aq-defaule{
        text-align: center;
        padding: 0;
    }
    .item-sel-nor{
        width: 100px;
    }
    .sel-set-body{
        width: 100%;
        /*height: 350px;*/
        /*position: absolute;*/
        /*left: 0;*/
        /*top: 115px;*/
        z-index: 10;
        background: #fff;
        /*border: 1px solid #e8edec;*/
        padding: 12px;
        color: #323232;
        /*display: none;*/
    }
    .set-set-item{
        margin: 10px 0 20px 0;
        position: relative;
    }
    .set-label{
        position: absolute;
        left: 0;
        top: 0;
        user-select: none;
    }
    .set-list{
        width: 100%;
        padding-left: 140px;
        min-height: 24px;
    }
    .c-box{
        width: 24px;
        height: 24px;
        display: inline-block;
        vertical-align: middle;
        background: url(${staticRoot}/images/icon_quxiao.png) center no-repeat;
    }
    .set-icon-time,.set-icon-text{
        width: 21px;
        height: 21px;
        display: inline-block;
        vertical-align: middle;
        margin: 0 12px 0 10px;
    }
    .set-icon-time{
        background: url(${staticRoot}/images/icon_shijian.png) center no-repeat;
    }
    .set-icon-text{
        background: url(${staticRoot}/images/icon_zi.png) center no-repeat;
    }
    .label-text{
        font-size: 14px;
        font-weight: 600;
        vertical-align: middle;
    }
    .item-text{
        margin-left: 5px;
        vertical-align: middle;
    }
    .check-list{
        max-height: 100px;
        overflow: auto;
    }
    .check-list li{display: inline-block;margin-right: 15px;margin-bottom: 10px ;user-select:
            none;}
    .c-box.checked{background: url(${staticRoot}/images/icon_xuanze.png) center no-repeat}
</style>
