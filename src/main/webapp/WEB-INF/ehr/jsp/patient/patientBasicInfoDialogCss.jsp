<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
  .m-form-inline .m-form-group label{ width: 110px;float: left; }
  .m-form-inline .m-form-group{padding-bottom: 0;}
  .u-upload-img{ position: absolute; left: 400px; }
  .u-card-basicMsg{ width:416px; height: 280px; margin:3px; display:none; }
  .u-bd{ border: 1px solid #c8c8c8;height: auto;margin-left: 10px;margin-right: 10px; }
  .f-wtl{ top: -10px;left: 10px;background: #fff;text-align: center; }
  .f-pr{ position: relative; }
  .f-t-30{ top: -30px; left: 400px; }
  .f-bc{background-color: #fff;}
  .card-dialog td div{font-size: 12px}
  .card-dialog  div span{font-size: 12px}
  .f-w88{ width: 88px; }
  .f-ml166{ margin-left: 166px;}
  .f-w120{ width: 120px;}
  .f-h110{ height: 110px }
  .pop_tab {
    height: 36px;
    line-height: 36px;
    background: url(${staticRoot}/images/sub_bg_01.png) #d4e7f0 repeat-x left bottom;
    padding-left: 2px;
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
</style>