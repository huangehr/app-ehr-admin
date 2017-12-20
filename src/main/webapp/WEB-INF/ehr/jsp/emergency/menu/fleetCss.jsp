<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    /*#div_main_content{*/
        /*overflow: auto !important;*/
    /*}*/
    .u-btn-small{width: 100px !important;margin-top: 0px;height: 30px}
    .btn-group .btn{border-radius: 25px;padding: 9px 20px;}
    [data-toggle=buttons]>.btn input[type=checkbox], [data-toggle=buttons]>.btn input[type=radio], [data-toggle=buttons]>.btn-group>.btn input[type=checkbox], [data-toggle=buttons]>.btn-group>.btn input[type=radio] {
        position: absolute;
        clip: rect(0,0,0,0);
        pointer-events: none;
    }
    .btn-default:active:hover, .btn-default.active:hover, .open > .dropdown-toggle.btn-default:hover, .btn-default:active:focus, .btn-default.active:focus, .open > .dropdown-toggle.btn-default:focus, .btn-default:active.focus, .btn-default.active.focus, .open > .dropdown-toggle.btn-default.focus {
        color: #fff;
        background-color: #2E9CD2;
        border-color: #2E9CD2;
    }
    .btn-default.active, .btn-default.focus, .btn-default:active, .btn-default:focus, .btn-default:hover, .open>.dropdown-toggle.btn-default {
        color: #fff;
        background-color: #2E9CD2;
        border-color: #2E9CD2;
    }
    .label_a{line-height: 40px;}
    .f-fr{float:right !important;}
    #div_relLoad_data{
        width: auto;
        height: auto;
        border: 1px solid #EBEEEE;
        overflow-y: scroll;
    }
    #div_relLoad_data >ul{
        height:auto;
    }
    #div_relLoad_data >ul>li{
        width: 480px;
        height: 230px;
        border: 1px solid #EEF1F0;
        float: left;
        margin: 20px 40px 40px 20px;
    }
    .info{
        width: 100%;
        padding: 20px;
        display: flex;
        position: relative;
    }
    .backroundImg{
        width: 140px;
        height: 140px;
        background: url(${staticRoot}/images/jiuhuche.jpg) no-repeat;
        /*background-size: 140px 140px;*/
        background-size: contain;
    }
    .boxText{
        margin-left: 30px;
    }
    .change{
        width: 21px;
        height: 21px;
        position: absolute;
        right:10px;
        top:10px;
        background: url(${staticRoot}/images/icon_bianji.png) no-repeat;
        background-size: contain;
    }
    .boxText>p{
        margin-top: 10px;
    }
    .boxText>p:nth-of-type(1){
        font-size: 16px;
        font-weight: bold;
        color: #323232;
        margin-top: 0;
    }
    .inlineBlock{
        display: inline-block;
    }
    .edit{
        height: 50px;
        background: #F1F5F8;
        position: relative;
    }
    .be_On_change{
       position: absolute;
        top: 10px;
        right: 128px;
        width: 88px;
        height:34px;
        background: #35afe1;
        color: #ffffff;
   }
    .be_On_duty:hover{
        color: #ffffff !important;
    }
    .delete{
        position: absolute;
        top: 10px;
        right: 20px;
        width:88px ;
        height:34px;
        background: #ffffff;
        color: #FE4B4A;
        border: 1px solid #D2D2D2;
    }
    .delete:hover{
        color: #FE4B4A !important;

    }
    /*分页样式*/
    .fydiv{width: 320px;text-align: center;height: 30px;margin: 10px auto; position: absolute;right: 40px }
    .fenye{text-align: center;height: 30px;margin: 0 auto;}
    .fenye li{float: left;border:1px solid #6CBFB7;height: 26px;line-height: 26px;margin-right: 10px;}
    .fenye li:hover{background-color: #f1f1f1;}
    .fenye li a{text-decoration: none;color:#6CBFB7; display: block; }
    .prev{width: 66px;}
    .next{width: 66px;}
    .numb{width: 26px;}
    .choose{border:1px solid #357973!important;}
    .choose a{color: #357973!important;}

    #contentPage{
        overflow: scroll !important;
        padding-bottom: 100px;
    }
</style>
