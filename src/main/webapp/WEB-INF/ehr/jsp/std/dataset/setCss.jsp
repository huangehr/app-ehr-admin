<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/25
  Time: 10:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

  .image-create{
    width: 22px;
    height: 22px;
      margin-left:60px;
    background: url(${staticRoot}/images/add_btn.png);
  }

  .image-create:hover{
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/add_btn_pre.png);
  }
  .image-modify{
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/Modify_btn_pre.png);
  }
  .image-delete{
    width: 22px;
    height: 22px;
    margin-top: -22px;
    background: url(${staticRoot}/images/Delete_btn_pre.png);
  }
    .l-trigger-icon{
        vertical-align: initial;
    }
  .font_right{
    text-align: right;
  }
.s-con{
    display: inline-block;
    overflow: hidden;
    height: 45px;
    position: relative;
    padding-top: 10px;
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
    #div_left{
        width: 400px;
        float: left;
        position: absolute;
        top: 38px;
        left: 0;
        bottom: 0;
    }
    #div_right{
        position: absolute;
        top: 38px;
        left: 410px;
        right: 0;
        bottom: 0;
    }
    .top-div div{
        display: inline-block;
        vertical-align: middle;
    }
</style>