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
</style>
