<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/9/19
  Time: 14:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%--<link rel="stylesheet" href="${contextRoot}/develop/lib/zTree/css/zTreeStyle/zTreeStyle.css">--%>
<link rel="stylesheet" href="${contextRoot}/develop/lib/zTree/css/metroStyle/metroStyle.css">
<style>
    .body-head input{  border: 0;  font-size: 12px;  width: 120px;}
    .f-bd { border: 1px solid #D6D6D6;  overflow: auto; height: 100% }
    .f-of-hd{ overflow: hidden; }
    .f-db{display: inline-block}
    .tree_type{overflow: auto;}
    .f-w230{width: 230px;}
    #div_left{
        width: 240px;
        position: absolute;
        top: 55px;
        left: 0;
        bottom: 0;
        border: 1px solid #D6D6D6;
    }
    #div_right{position: absolute;
        left: 250px;
        right: 0;
        top: 55px;
        bottom: 0;}
    .div_resource_browse_tree{width:890px; float:right;margin-left: 10px}
    .div-result-msg{width: 100%;height: auto; float: left;}
    .right-retrieve{border: 1px solid #D6D6D6;border-bottom: none }
    #div_content{position: relative}
    .v-header{/*overflow: hidden;*/padding-bottom: 10px;height: 55px;}
    .v-h-left{width: 240px;text-align: center;}
    .v-h-con{display: inline-block}
    .c-h-right{}
    .c-h-l-r{margin-right: 50px;}
    .c-h-r-r{}
    .c-h-l-r input,.c-h-r-r input{margin:0 5px;vertical-align: middle}
    .c-h-l-r span,.c-h-r-r span{vertical-align: middle}


    #ddSeach{height: 35px;line-height: 35px;padding: 0 44px 0 10px;position: relative;background: #fff;border: 1px solid #ccc;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;cursor: pointer}
    #ddSeach:after{content: ' ';width: 1px;height: 100%;display: block;background: #ccc;position: absolute;top:0;right: 35px;}
    .dd-icon{width: 20px;height: 20px;display: block;position: absolute;top: 8px;right: 7px;background: url(${staticRoot}/images/d.png) no-repeat center ;background-size: contain;}
    .sj-icon,.sj-sj-icon{width:0;height:0;  border-width:0 10px 10px;border-style:solid;position: absolute}
    .sj-icon{border-color:transparent transparent #ccc;bottom: 2px;right: -3px;z-index: 999}
    .sj-sj-icon{border-color:transparent transparent #fff;bottom: -11px;right: -10px}
    .pop-s-con{width: 871px;padding: 10px;position: absolute;right: -25px;top: 8px;background: #fff;border: 1px solid #ccc;padding-bottom: 55px;z-index: 998;overflow: auto}
    .pop-btns{position: absolute;bottom: 10px;right: 10px;z-index: 999}
    .inp-text{display: inline-block;vertical-align: middle;    font-size: 12px;}
    .inp-label{width: 160px;vertical-align: middle;text-align: right;font-size: 12px;padding-right: 10px;margin-bottom: 0}
    .clear-s{font-size: 0}
    .pop-main{display:none;width: 10px;height: 10px;left: 81px;right: 0;position: absolute}

    .l-frozen .l-grid2 .l-grid-body{
        height: auto!important;
    }
    .mCSB_container_wrapper > .mCSB_container{
        padding-right: 0;
    }
    .mCSB_container_wrapper{
        margin-right: 0;
    }
    .nr-con{
        width: 100%;
        height: 100%;
        position: absolute;
        left: 0;
        right: 0;
        bottom: 0;
        top: 0;
        background: #fff;
    }
    .u-btn-small{
        height: 35px;
        line-height: 35px;
    }
</style>