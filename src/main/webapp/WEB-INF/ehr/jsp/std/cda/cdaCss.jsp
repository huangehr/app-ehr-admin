<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/19
  Time: 10:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>

    input, #cdaVersion {
        font-family: Microsoft YaHei;
        font-size: 10px;
        height: 30px;
        width: 240px;
    }

    .l-text {
        width: 242px;
    }

    .image-create {
        margin-left: 340px;
        margin-top: -25px;
        width: 22px;
        height: 22px;
        background: url(${staticRoot}/images/add_btn.png);
    }

    .image-create:hover {
        margin-left: 340px;
        margin-top: -25px;
        width: 22px;
        height: 22px;
        background: url(${staticRoot}/images/add_btn_pre.png);
    }

    .image-modify {
        width: 22px;
        height: 22px;
        background: url(${staticRoot}/images/Modify_btn_pre.png);
    }

    .image-delete {
        width: 22px;
        height: 22px;
        margin-top: -22px;
        background: url(${staticRoot}/images/Delete_btn_pre.png);
    }

    .font_right {
        text-align: right;
    }

    .li-tree {
        height: 22px;
        line-height: 22px;
    }
    .btn_hide{
        display: inline-block;
        margin-bottom: 0;
        font-weight: normal;
        text-align: center;
        vertical-align: middle;
        -ms-touch-action: manipulation;
        touch-action: manipulation;
        cursor: pointer;
        background-image: none;
        border: 1px solid transparent;
        white-space: nowrap;
        padding: 6px 12px;
        font-size: 12px;
        line-height: 1.42857143;
        border-radius: 4px;
        -webkit-user-select: none;
        color:#a8a8a8;
        background: url(${staticRoot}/images/app/hui_btn.png);
    }

    .edit_delete{
        display: inline-block;
        width: 40px;
        height: 40px;
        cursor: pointer;
        background: url(${staticRoot}/images/app/shanchu_btn.png) center no-repeat;
    }
    .s-con{
        display: inline-block;
        overflow: hidden;
        height: 45px;
        position: relative;
    }
    .s-con .l-text{
        margin-top: 0!important;
        margin-left: 10px!important;
    }
    .s-con .btn{
        margin-top: 0!important;
    }
    .s-con .btn#btn_add_element{
        margin-right: 10px!important;
    }
    #div_right{
        margin-left: 10px;
        position: absolute;
        left: 328px;
        right: 10px;
        top: 50px;
        bottom: 9px;
    }
</style>
