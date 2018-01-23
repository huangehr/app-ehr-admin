<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2018/1/9
  Time: 9:17
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    ul,li{
        list-style: none;
    }
    .iq-body{
        height: 100%;
        position: relative;
        overflow: hidden;
    }
    .iq-top{
        height: 60px;
        text-align: center;
        border-bottom: 1px solid #e8edec;
        padding-top: 9px;
    }

    .check-tab{
        display: inline-block;
        margin: 0;
        font-weight: 600;
        font-size: 0;
        background: #30a9de;
        border-radius: 21px;
        overflow: hidden;
        padding: 1px;
    }

    .check-tab li{
        width: 90px;
        height: 28px;
        display: inline-block;
        text-align: center;
        line-height: 28px;
        background: #fff;
        font-size: 14px;
        color: #30a9de;
        cursor: pointer;
    }
    .check-tab li:first-child{
        -webkit-border-radius:30px 0 0 30px;
        -moz-border-radius:30px 0 0 30px;
        border-radius:30px 0 0 30px;
    }
    .check-tab li:last-child{
        -webkit-border-radius: 0 30px 30px 0;
        -moz-border-radius: 0 30px 30px 0;
        border-radius: 0 30px 30px 0;
    }
    .check-tab li.active{
        background: #30a9de;
        color: #fff;
    }
    .iq-main{
        /*display: none;*/
        position: absolute;
        left: 0;
        top: 62px;
        bottom: 0;
        right: 0;
        overflow: auto;
    }
    .iq-left{
        width: 290px;
        position: absolute;
        top:0;
        left: 0;
        bottom: 0;
    }
    .pub-tit{
        padding: 20px 0;
        font-size: 16px;
        font-weight: 600;
        position: relative;
    }
    .pub-tit span{
        display: inline-block;
        border-left: 4px solid #30a9de;
        padding-left: 18px;
    }
    .iq-type{

    }
    .iq-type-check{
        display: inline-block;
        margin: 0;
        padding: 0;
        font-size: 0;
    }
    .iq-type-check li{
        width: 60px;
        display: inline-block;
        padding: 6px 0;
        text-align: center;
        font-size: 14px;
        color: #aebaba;
        cursor: pointer;
    }
    .iq-type-check li:first-child{
        margin-left: 5px;
        margin-right: 20px;
    }
    .iq-type-check li.active{
        font-weight: 600;
        color: #30a9de;
        border-bottom: 2px solid #30a9de;
    }
    .iq-l-search{
        width: 112px;
        height: 28px;
        display: inline-block;
        border:1px solid #e8edec;
        padding-right: 28px;
        position: relative;
        margin-left: 24px;
    }
    .iq-l-search input{
        width: 100%;
        height: 100%;
        border: 0;
        line-height: 26px;
        padding: 0 2px;
    }
    .iq-l-search a{
        width: 28px;
        height: 26px;
        background: url(${staticRoot}/images/icon-sousuo3.png) center no-repeat;
        display: inline-block;
        position: absolute;
        top: 0;
        right: 0;
        cursor: pointer;
    }
    .iq-right{
        position: absolute;
        left: 310px;
        top: 0;
        right: 0;
        bottom: 0;
    }
    .iq-tree-con{
        position: absolute;
        width: 100%;
        left: 0;
        top: 100px;
        bottom: 0;
        border: 1px solid #e8edec;
        overflow: auto;
    }
    .iq-table-con{
        position: absolute;
        left: 0;
        top: 62px;
        right: 0;
        bottom: 0;
        /*border: 1px solid #e8edec;*/
    }
    .iq-char-list{
        border-bottom: 1px solid #e8edec;
    }
    .iq-char-item{
        width: calc((100% - 220px)/5);
        display: inline-block;
        border: 1px solid #e8edec;
        margin-left: 20px;
        margin-right: 20px;
        padding: 10px;
        margin-bottom: 20px;
        position: relative;
        cursor: pointer;
    }
    .iq-char-item img{
        width: 100%;
    }
    .img-tit{
        padding: 14px 0 0 20px;
        margin: 0;
        height: 60px;
        word-break: keep-all;
        font-size: 16px;
        color: #323232;
        overflow: hidden;
        margin-right: 10px;
        text-overflow: ellipsis;
    }
    .iq-main.active{
        display: block;
    }
    .iq-char-item:hover .iq-close{
        display: block;
    }
    .iq-close{
        display: none;
        width: 30px;
        height: 30px;
        position: absolute;
        top: 0;
        right: 0;
        z-index: 10;
        background: url("${staticRoot}/images/icon_X.png") center no-repeat;
    }
    .del-btn{
        width: 18px;
        height: 19px;
        display: block;
        margin: 0 auto;
        background: url("${staticRoot}/images/icon_shanchu.gif") center no-repeat;
    }
    .sel-btn{
        width: 110px;
        height: 34px;
        line-height: 34px;
        background: #30a9de;
        color: #fff;
        font-size: 14px;
        text-align: center;
        position: absolute;
        top: 14px;
        right: 10px;
        cursor: pointer;
        -webkit-border-radius:2px;
        -moz-border-radius:2px;
        border-radius:2px;
    }
    .load-more{
        text-align: center;
        padding: 10px 0;
        font-size: 14px;
        color: #909090;
        cursor: pointer;
    }
    .icon-load{
        width: 20px;
        height: 20px;
        display: inline-block;
        background: url("${staticRoot}/images/loading-2.gif") center no-repeat;
        vertical-align: middle;
        margin-right: 13px;
        background-size: cover;
    }
    .load-con{
        vertical-align: middle;
    }

</style>