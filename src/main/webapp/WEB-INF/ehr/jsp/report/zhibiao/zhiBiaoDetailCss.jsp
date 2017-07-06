<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

  .image-create{
    margin-left:20px;
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/add_btn.png) no-repeat;
  }

  .image-create:hover{
    cursor: pointer;
    margin-left:20px;
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/add_btn_pre.png) no-repeat;
  }
  .image-modify{
    width: 22px;
    height: 22px;
    background: url(${staticRoot}/images/Modify_btn_pre.png) no-repeat;
  }
  .image-delete{
    width: 22px;
    height: 22px;
    margin-top: -22px;
    background: url(${staticRoot}/images/Delete_btn_pre.png) no-repeat;
  }

  .font_right{
    text-align: right;
  }

  .u-btn-small{width: 100px !important;margin-top: 0px;height: 30px}
  .pop_tab {
    height: 36px;
    line-height: 36px;
    background: url(${staticRoot}/images/sub_bg_01.png) #d4e7f0 repeat-x left bottom;
    padding-left: 2px;
    border-top: 1px solid #cacaca;
    position: absolute;
    left: -10px;
    top: -11px;
    width: 775px;
  }

  .pop_tab li.cur {
    background: #fff;
    font-weight: bold;
    border-left: 1px solid #cacaca;
    border-right: 1px solid #cacaca;
  }
  .pop_tab li {
    cursor: default;
  }
  .pop_tab li {
    font-size: 12px;
    color: #000;
    float: left;
    padding: 0 14px;
  }

  .btn:hover, .btn:focus, .btn.focus{color:#fff !important;}
  #div_main_relation,#div_slave_relation{float: right;margin-right: 16px;width: calc(65% - 20px);height: 441px;border: 1px solid #DFDFDF;overflow: auto;overflow-x: hidden;}
  .h-40{height:40px;}
  .div-header{width: 23%;height: 40px;text-align: center;line-height: 40px;background: #EDF6FA;font-weight: bold;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;}
  .div-opera-header{width: 8%;height: 40px;text-align: center;line-height: 40px;background: #EDF6FA;font-weight: bold;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;}
  .div-main-content{width: 23%;height: 40px;text-align: center;line-height: 40px;border-bottom: 1px solid #DFDFDF;border-right: 1px solid #DFDFDF;float: left;font-size: 12px;overflow: hidden;}
  .div-main-content input{width: calc(100% - 10px);height: 30px;line-height: 30px;padding: 3px;margin: 0 5px;}
  .div-delete-content{width: 8%; height: 40px; border-bottom: 1px solid #DFDFDF; border-right: 1px solid #DFDFDF;float: left;}
</style>
