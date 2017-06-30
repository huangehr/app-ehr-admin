<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>

    .f-h785 { height: 785px;  width: 100%  }
    .f-bd { border: 1px solid #D6D6D6;  overflow: auto;  height: 100%  }
    .f-w270 { width: 270px;  }
    .f-of-hd { overflow: hidden;  }
    .f-w18 { width: 18%  }
    .dis-none { display: none  }
    .div-resource-browse { height: 100%;  width: 100%;  float: right;  border: 1px solid #D6D6D6;  }
    .sp-back-add-img {
        background: url(${staticRoot}/images/app/add_btn.png);
        float: left;
        width: 60px;
        height: 30px;
        cursor: pointer;
        margin: 0;
        background-repeat: no-repeat;
        background-position: 35px 6px;
    }
    .sp-back-del-img {
        background: url(${staticRoot}/images/app/Close_btn_pre01.png);
        float: left;
        width: 60px;
        height: 30px;
        cursor: pointer;
        background-repeat: no-repeat;
        background-position: 35px 0;
    }
    .f-w90 { width: 90%; }
    .f-w100 { width: 100%; }
    .f-mt6 {margin-top: 6px;}
    .div-result-msg { border: 1px solid #D6D6D6;  width: 100%;  height: auto;  float: left;  }
    .f-mr279 { margin-right: 279px;  }
    .f-pr0 { width: 238px; padding-right: 0;  }
    .f-ds { display: none; }
    .f-ml-20 { margin-left: 5%; }
    .f-ml30 { margin-left: 30px; }
    .div-resource-view-title{ width:100%;height:30px;margin: 25px 0 30px 0; }
    .sp-search-width{ width: 5%;margin-left: 1%;}
    .f-ml15{ margin-left: 15%; }
    .f-mw{ width: 100px; }
    .l-panel-bar{margin-bottom: 45px !important;}
</style>

