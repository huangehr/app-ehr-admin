<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    html,body{height: 100%;width:100%;overflow: hidden;}
    .u-nav-breadcrumb { height: 40px; line-height: 40px; }
    .f-bd { border: 1px solid #D6D6D6;  overflow: auto;  height: 100%  }
    .f-w270 { width: 270px;  }
    .f-of-hd { overflow: hidden;  }
    .f-w18 { width: 18%  }
    .dis-none { display: none  }
    .div-resource-browse { height: calc(100% - 50px) !important;  width: 100%;  float: right;  border: 1px solid #D6D6D6;  }
    .sp-back-add-img {background: url(${staticRoot}/images/app/add_btn.png);float: left;width: 30px;height: 30px;cursor: pointer;margin: 0;background-repeat: no-repeat;margin-right: 40px;}
    .sp-back-del-img {background: url(${staticRoot}/images/app/Close_btn_pre01.png);float: left;width: 60px;height: 30px;cursor: pointer;background-repeat: no-repeat;background-position: 35px 0;}
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
    .l-grid-hd-cell-inner{line-height: 40px;}
    .search-top{padding: 10px 0;}
    .div-search-height{position: relative;}
    .div_resource_browse_msg > div> div{min-height: 100%}
    .div-result-msg{border:none}
    #ddSeach{height: 35px;line-height: 35px;padding: 0 44px 0 10px;position: relative;background: #fff;border: 1px solid #ccc;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;cursor: pointer}
    #ddSeach:after{content: ' ';width: 1px;height: 100%;display: block;background: #ccc;position: absolute;top:0;right: 35px;}
    .dd-icon{width: 20px;height: 20px;display: block;position: absolute;top: 8px;right: 7px;background: url(${staticRoot}/images/d.png) no-repeat center ;background-size: contain;}
    .sj-icon,.sj-sj-icon{width:0;height:0;  border-width:0 10px 10px;border-style:solid;position: absolute}
    .sj-icon{border-color:transparent transparent #ccc;bottom: 2px;right: -3px;z-index: 999}
    .sj-sj-icon{border-color:transparent transparent #fff;bottom: -11px;right: -10px}
    .pop-s-con{width: 760px;padding: 10px;position: absolute;right: -280px;top: 8px;background: #fff;border: 1px solid #ccc;padding-bottom: 55px;z-index: 998;overflow: auto}
    .pop-btns{position: absolute;bottom: 10px;right: 10px;z-index: 999}
    .inp-text{display: inline-block;vertical-align: middle;    font-size: 12px;}
    .inp-label{width: 95px;vertical-align: middle;text-align: right;font-size: 12px;padding-right: 10px;margin-bottom: 0}
    .clear-s{font-size: 0}
    .pop-main{display:none;width: 10px;height: 10px;left: 81px;right: 0;position: absolute}
    .tab-main{font-size: 0}
    .tab-item{width:149px;height:40px;display: inline-block;text-align:center;line-height: 40px; font-size: 13px;border-bottom: 1px solid #ccc;cursor: pointer;}
    /*.tab-con{padding: 10px;}*/
    .tab-item.active{background: #ccc;color: #fff}
</style>

