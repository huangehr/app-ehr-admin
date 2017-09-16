<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .query-main{
        position: relative;
    }
    .query-btns{
        width: 100%;
        height: 70px;
        line-height: 70px;
        display: inline-block;
        position: relative;
        border: 1px solid #e1e1e1;
    }
    .query-change{
        width: 160px;
        height: 32px;
        line-height: 30px;
        display: inline-block;
        position: absolute;
        left: 50%;
        top: 50%;
        -webkit-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -ms-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%);
        border: 1px solid #e1e1e1;
        -webkit-border-radius: 30px;
        -moz-border-radius: 30px;
        border-radius: 30px;
    }
    .chang-btn{
        width: 80px;
        height: 32px;
        line-height: 32px;
        position: absolute;
        /*display: inline-block;*/
        text-align: center;
        -webkit-border-radius: 30px;
        -moz-border-radius: 30px;
        border-radius: 30px;
        top: -1px;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        cursor: pointer;
    }
    .cb-left{
        right: 0;
    }
    .cb-right{
        left: 0;
    }
    .chang-btn.active{
        background: #3094d5;
        color: #fff;
    }
    .single-btns{
        float: right;
    }
    .single-btn{
        width: 82px;
        height: 30px;
        display: inline-block;
        text-align: center;
        line-height: 30px;
        font-size: 12px;
        color: #fff;
        margin-right: 20px;
        -webkit-border-radius: 2px;
        -moz-border-radius: 2px;
        border-radius: 2px;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        cursor: pointer;
    }
    .query-con{
        background: #45d16f;
    }
    .gen-view{
        background: #ffbd5c;
    }
    .out-exc{
        background: #0c93e4;
    }
    .screen-con{
        width: 100%;
        padding: 10px 0;
        overflow: hidden;
    }
    .sc-btn{
        width: 88px;
        height: 32px;
        position: relative;
        float: right;
        padding-left: 10px;
        border: 1px solid #e1e1e1;
        background: #f9f9f9;
        line-height: 30px;
        cursor: pointer;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
    }
    .icon-xiala{
        width: 13px;
        height: 5px;
        display: inline-block;
        position: absolute;
        top: 50%;
        right: 10px;
        -webkit-transform: translateY(-50%);
        -moz-transform: translateY(-50%);
        -ms-transform: translateY(-50%);
        -o-transform: translateY(-50%);
        transform: translateY(-50%);
        background: url(${staticRoot}/images/icon_xiala.png) no-repeat center center;
    }
    .sc-btn.show .icon-xiala{
        top: 44%;
        -webkit-transform: rotate(180deg);
        -moz-transform: rotate(180deg);
        -ms-transform: rotate(180deg);
        -o-transform: rotate(180deg);
        transform: rotate(180deg);
    }
    .query-tree{
        width: 287px;
        position: absolute;
        left: 0;
        top: 134px;
        bottom: 0;
        border: 1px solid #e1e1e1;
        overflow: hidden;
    }
    .ser-con{
        padding: 10px 0 10px 20px;
        border-bottom: 1px solid #e1e1e1;
    }
    .query-conc{
        position: absolute;
        left: 307px;
        top: 134px;
        right: 0;
        bottom: 0;
        /*border: 1px solid #e1e1e1;*/
        background: none;
        overflow: auto;
    }
    .select-con{
        padding-top: 20px;
        border: 1px solid #e1e1e1;
        margin-bottom: 20px;
    }
    .sel-item{
        width: 100%;
        position: relative;

        list-style-type: none;
        display: -moz-box;
        display: -webkit-box;
        display: -ms-flexbox;
        display: -webkit-flex;
        display: flex;
        -moz-box-align: center;
        -webkit-box-align: center;
        -ms-flex-align: center;
        -webkit-align-items: center;
        align-items: center;
        -moz-box-pack: center;
        -webkit-box-pack: center;
        -ms-flex-pack: center;
        -webkit-justify-content: center;
        /*for ie9*/

        justify-content: center;
        margin: 0 auto 0;
        display: table;
    }
    .sel-lab{
        height:26px;
        display: inline-block;
        padding-left: 23px;
        line-height: 26px;
        white-space: nowrap;
        vertical-align: top;
        /*position: absolute;*/
        /*left: 0;*/
        /*top: 0;*/

        display: table-cell;
    }
    .con-list{
        /*padding: 0 85px 0 100px;*/
        height: 30px;
        overflow: hidden;
        display: block;
        /*max-height: 109px;*/
    }
    .show-more{
        display: table-cell;
        white-space: nowrap;
        padding: 0 30px;
        vertical-align: top;
    }
    .con-item{
        height:30px;
        line-height: 28px;
        display: inline-block;
        width: 138px;
        text-align: center;
        margin-left: 15px;
        margin-right: 7px;
        margin-bottom: 10px;
        cursor: pointer;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .con-item.active{
        border: 1px solid #0c93e4;
        background: #f6fcff;
        color: #0c93e4;
    }
    .sw-w{
        width: 66px;
        height: 26px;
        display: none;
        line-height: 24px;
    }
    .ci-inp{
        width: auto;
    }
    .tree-con{
        height: 100%;

    }
    #divLeftTree{
        /*height: 100%;*/
    }
    .l-tree .l-body span{
        height: 22px;
        line-height: 22px;
    }
    .tree-con-zhcx{
        height: 610px;
        overflow: auto;
    }
    .l-panel td{
        height: 40px;
        line-height: 40px;
    }
</style>

