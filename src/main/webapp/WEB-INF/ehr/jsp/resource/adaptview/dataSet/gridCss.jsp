<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

  input,#cdaVersion {
    font-family: SimSun;
    font-size: 14px;
    height: 30px;
    width: 240px;
  }

  .image-create{
    margin-left:20px;
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/add_btn.png);
  }

  .image-create:hover{
    cursor: pointer;
    margin-left:20px;
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

  .font_right{
    text-align: right;
  }


  .description{
    height: 180px;
    width: 240px;
  }
  .condition input,
  .condition select{
    font-family: SimSun;
    font-size: 12px;
    height: 30px;
    width: 240px;
  }
  .condition button {
    width: 84px;
  }
  .body-head {
    border-bottom: 1px solid #ccc
  }
  .body-head input{
    border: 0;
    font-size: 12px;
    width: 120px;
  }
  .back{
    border-right: 1px solid #d3d3d3;
  }

  #div_relation_grid  .l-text-wrapper{
    margin:5px;
    position: relative;
  }
  #div_relation_grid  .l-trigger .l-trigger-icon{
    background:url(${staticRoot}/lib/ligerui/skins/Aqua/images/icon/icon-down.gif) no-repeat 50% 50% transparent;
  }

  #div_relation_grid  .l-trigger.l-trigger-cancel .l-trigger-icon{
    background:url(${staticRoot}/lib/ligerui/skins/Aqua/images/icon-unselect.gif) no-repeat 50% 50% transparent;
  }

  #div_relation_grid .l-text{
    border-left: none;
    border-right: none;
    border: 0px solid #ffffff;
  }
</style>
