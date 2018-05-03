<%--
  Created by IntelliJ IDEA.
  User: 黄仁伟
  Date: 2018/3/28
  Time: 15:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>
    html{
        /*font-size: 128px;*/
    }
    body{
        background: url(${staticRoot}/images/diwen_bg_img.png) center no-repeat;
        background-position: bottom right;
        background-color: #fff;
    }
    ul,li{
        list-style: none;
    }
    .width-50{
        width: 50%;
    }
    .ui-grid { display: -webkit-box; display: box; }
    .ui-grid-middle { -webkit-box-pack: center; -webkit-box-align: center; box-pack: center; box-align: center; }
    .ui-grid-vertical { -webkit-box-orient: vertical; box-orient: vertical; }
    .ui-grid-label { -webkit-box-flex: 0; box-flex: 0; width: 100px; font-weight: 600; }
    .ui-col-0 { -webkit-box-flex: 0; box-flex: 0; }
    .ui-col-1 { -webkit-box-flex: 1; box-flex: 1; }
    .ui-col-2 { -webkit-box-flex: 2; box-flex: 2; }
    .ui-col-3 { -webkit-box-flex: 3; box-flex: 3; }
    .ui-col-4 { -webkit-box-flex: 4; box-flex: 3; }
    .ui-col-5 { -webkit-box-flex: 5; box-flex: 5; }
    .ui-col-6 { -webkit-box-flex: 6; box-flex: 6; }
    .dc-main{
        width: 100%;
        height: 100%;
        overflow: auto;
        position: relative;
    }
    .qp-icon{
        width: 0.083rem;
        height: 0.083rem;
        background: url(${staticRoot}/images/zhankai_icon.png) center no-repeat;
        position: absolute;
        top: 0.078rem;
        right: 0.13rem;
        cursor: pointer;
    }
    .dc-body{
        height: 100%;
        width: 100%;
        /*min-height: 4.9rem;*/
        /*position: relative;*/
        display: -webkit-box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
    }
    .dc-left,.dc-right{
        /*position: absolute;*/
        /*top: 0;*/
        /*bottom: 0;*/
        /*overflow: hidden;*/
        -webkit-box-flex: 0;
        height: 100%;
        position: relative;
    }
    .dc-left{
        width: 60%;
        /*left: 0;*/
        color: #323232;

    }
    .dc-right{
        width: 40%;
        /*right: 0;*/
        /*padding-right: 0.625rem;*/
        /*padding-top: 0.1rem;*/
        color: #323232;
    }
    .dc-big-circle,.dc-little-circle,.dc-little-circle1{
        width: 4.8rem;
        height: 4.8rem;
        /*border:1px dashed #3fb1fa;*/
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        position: absolute;
        left: -0.78rem;
        top: 0.34rem;
    }
    .dc-little-circle1{
        border:1px dashed #3fb1fa;
    }
    .dc-big-circle{
        z-index: 5;
    }
    .dc-circle-item{
        width: 0.52rem;
        height: 0.52rem;
        cursor: pointer;
        text-align: center;
        line-height: 0.52rem;
        border: 1px solid #2eaafa;
        position: absolute;
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        background: #fff;
        z-index: 5;
    }
    .dc-circle-item:before{
        content: ' ';
        width: 0.57rem;
        height: 0.57rem;
        display: none;
        position: absolute;
        left: -0.03rem;
        top: -0.03rem;
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        border:1px dashed #3fb1fa;
    }
    .dc-circle-item.loaded:before,
    .dc-circle-item:hover:before{
        display: block;
        -webkit-animation: run 5s linear;
        -moz-animation: run 5s linear;
        animation: run 5s linear;
        -webkit-animation-iteration-count: infinite;
        -moz-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
    }
    /*.dc-circle-item:hover{*/
        /*z-index: -1;*/
    /*}*/
    .dc-circle-item.item-two:before{
        border:1px dashed #49d2dc;
    }
    .dc-circle-item.item-three:before{
        border:1px dashed #907bf4;
    }
    .dc-circle-item.item-four:before{
        border:1px dashed #2075d4;
    }
    .dc-circle-item.active:after{
        content: ' ';
        width: 0.83rem;
        height: 0.83rem;
        position: absolute;
        left: -0.16rem;
        top: -0.16rem;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        border-radius: 50%;
        opacity: 0;
        -webkit-animation: warn1 2s linear;
        -moz-animation: warn1 2s linear;
        animation: warn1 2s linear;
        -webkit-animation-iteration-count: infinite;
        -moz-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
        box-shadow: 1px 1px 0.16rem #3fb1fa; /* 阴影效果 */
        z-index: 1;
    }
    .dc-circle-item.item-two:after{
        box-shadow: 1px 1px 0.16rem #49d2dc; /* 阴影效果 */
    }
    .dc-circle-item.item-three:after{
        box-shadow: 1px 1px 0.16rem #907bf4; /* 阴影效果 */
    }
    .dc-circle-item.item-four:after{
        box-shadow: 1px 1px 0.16rem #2075d4; /* 阴影效果 */
    }

    .dc-little-circle{
        -webkit-animation: run 20s linear;
        -moz-animation: run 20s linear;
        animation: run 20s linear;
        -webkit-animation-iteration-count: 1;
        -moz-animation-iteration-count: 1;
        animation-iteration-count: 1;
    }
    .item-one{
        left: 1.5rem;
        top: -0.16rem;
        color: #2eaafa;
    }
    .item-one:hover{
        opacity: 1;
    }
    .item-two{
        left: 3.28rem;
        top: 0;
        /*border: 1px solid #49d2dc;*/
        color: #49d2dc;
    }
    .item-three{
        left: 4.35rem;
        top: 1.27rem;
        /*border: 1px solid #907bf4;*/
        color: #907bf4;
    }
    .item-four{
        left: 4.4rem;
        top: 2.93rem;
        /*border: 1px solid #2075d4;*/
        color: #2075d4;
    }
    .dc-little-circle{
        border: none;
    }
    .dc-img,.dc-img1{
        position: absolute;
        width: 0.52rem;
        height: 0.52rem;
        object-fit: contain;
        display: block;
        opacity: 0;

        transition-property: left,top;
        transition-duration: 1s;
        -moz-transition-property: left,top; /* Firefox 4 */
        -moz-transition-duration: 1s; /* Firefox 4 */
        -webkit-transition-property: left,top; /* Safari and Chrome */
        -webkit-transition-duration: 1s; /* Safari and Chrome */
        -o-transition-property: left,top; /* Opera */
        -o-transition-duration: 1s; /* Opera */
        transition-timing-function: ease-in;
        -moz-transition-timing-function: ease-in; /* Firefox 4 */
        -webkit-transition-timing-function: ease-in; /* Safari 和 Chrome */
        -o-transition-timing-function: ease-in; /* Opera */
    }
    .dc-img>img,.dc-img1>img {
        width: 100%;
        height: 100%;
        display: inherit;
    }
    .dc-circle-item:hover .dc-img,.dc-circle-item:hover .dc-img1{
        opacity: 1;
        /*display: block;*/
    }
    .dc-icon0.active,
    .dc-icon1.active,
    .dc-icon2.active,
    .dc-icon3.active{
        opacity: 1;
        left: 2.15rem;
        top: 2.15rem;
    }
    .dc-label{
        font-size: 0.083rem;
        width: 0.52rem;
        height: 0.52rem;
        text-align: center;
        position: absolute;
        left: 0;
        top: 0;
        transition: All 0.4s ease-in-out;
        -webkit-transition: All 0.4s ease-in-out;
        -moz-transition: All 0.4s ease-in-out;
        -o-transition: All 0.4s ease-in-out;
    }
    .dc-circle-item:hover .dc-label{
        left: 0.52rem;
        width: 0.52rem;
    }
    .dc-info-circle{
        width: 2.6rem;
        height: 2.6rem;
        position: absolute;
        left: 50%;
        top: 50%;
        margin-top:-1.3rem;
        margin-left:-1.3rem;
        background: url(${staticRoot}/images/ty.png) center no-repeat;
        background-size: 2.6rem 2.6rem;
        transition: All 0.5s linear;
        -webkit-transition: All 0.5s linear;
        -moz-transition: All 0.5s linear;
        -o-transition: All 0.5s linear;
    }
    .dc-info-circle.active{
        /*-webkit-animation: narrow 2s linear;*/
        /*-moz-animation: narrow 2s linear;*/
        /*animation: narrow 2s linear;*/
        /*-webkit-animation-iteration-count: 1;*/
        /*-moz-animation-iteration-count: 1;*/
        /*animation-iteration-count: 1;*/

        opacity: 0;
        transform: scale(0.2);
        -webkit-transform: scale(0.2);
    }

    .dc-icon{
        width: 0.52rem;
        height: 0.52rem;
        object-fit: contain;
        position: absolute;
        left: 50%;
        top: 50%;
        -webkit-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -ms-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%);
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        /*border: 1px solid #ccc;*/
        opacity: 1;
        transition: All 1s linear;
        -webkit-transition: All 1s linear;
        -moz-transition: All 1s linear;
        -o-transition: All 1s linear;
    }
    .dc-icon>img{
        width: 100%;
        height: 100%;
    }
    .dc-icon.active{
        opacity: 0;
    }
    .item-info{
        margin-left: 1.59rem;
        margin-top: 0.74rem;
        width: 1.30rem;
        /*position： relative;*/
    }
    .item-tit{
        /*position: absolute;*/
        /*left: 0;*/
        padding-bottom: 0.042rem;
        font-size: 0.16rem;
        border-bottom: 1px solid #323232;
    }
    .item-con{
        position: relative;
        padding-top: 0.052rem;
        font-size: 0.083rem;
    }
    .item-tit,.item-con{
        color: #323232;
        text-align: center;
    }
    .item-con:before{
        content: ' ';
        width: 0.14rem;
        height: 0.055rem;
        position: absolute;
        left: -0.1rem;
        top: 0.036rem;
        border-top: 1px solid #323232;
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -ms-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    .container {
        position: absolute;
        width: 0.0938rem;
        height: 0.0938rem;
        left: 1.72rem;
        top: 0.052rem;
    }
    /* 保持大小不变的小圆点 */
    .dot {
        position: absolute;
        width: 0.0938rem;
        height: 0.0938rem;
        left: -0.002rem;
        top: -0.01rem;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        border-radius: 50%;
        background-color:#04ffff; /* 实心圆 ，如果没有这个就是一个小圆圈 */
        z-index: 2;
    }
    /* 产生动画（向外扩散变大）的圆圈 第一个圆 */
    .pulse {
        position: absolute;
        width: 0.156rem;
        height: 0.156rem;
        left: -0.031rem;
        top: -0.031rem;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        border-radius: 50%;
        z-index: 1;
        opacity: 0;
        -webkit-animation: warn 2s ease-out;
        -moz-animation: warn 2s ease-out;
        animation: warn 2s ease-out;
        -webkit-animation-iteration-count: infinite;
        -moz-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
        box-shadow: 1px 1px 0.156rem #04ffff; /* 阴影效果 */
    }
    .dc-r-titO{
        font-size: 0.125rem;
        font-weight: 600;
        padding-bottom: 0.1rem;
        position: relative;
    }
    .dc-r-titO:after{
        content: ' ';
        width: 100%;
        height: 1px;
        position: absolute;
        left: 0;
        bottom: 0;
        /*border-bottom: 1px solid #ebebeb;*/
        background-color: #ebebeb;
    }
    .dc-r-con{
        text-indent: 2em;
        font-size: 0.083rem;
        line-height: 1.5;
        padding: 0.052rem 0;
    }
    .dc-r-titT{
        font-size: 0.1rem;
        font-weight: 600;
        border-left: 4px solid #2eaafa;
        padding-left: 0.083rem;
        margin: 0.1rem 0;
    }
    .dc-bz{
        width: 100%;
        text-align: center;
        padding-left: 0;
        font-size: 0;
    }
    .dc-bz-item{
        width: 0.83rem;
        height: 0.83rem;
        margin: 0 0.036rem;
        -webkit-border-radius:0.0625rem;
        -moz-border-radius:0.0625rem;
        border-radius:0.0625rem;
        overflow: hidden;
        border:1px solid #fff;
        position: relative;
    }
    .dc-bz-icon{
        width: 0.417rem;
        height: 0.417rem;
        margin: 0 auto;
        margin-top: 0.052rem;
        margin-bottom: 0.03125rem;
    }
    .ptbz-icon{
        background: url(${staticRoot}/images/pingtaibiaozhun_icon.png) center no-repeat;
        background-size: 100% 100%;
    }
    .ccpt-icon{
        background: url(${staticRoot}/images/chucunbiaozhun_icon.png) center no-repeat;
        background-size: 100% 100%;
    }
    .sjzd-icon{
        background: url(${staticRoot}/images/shujuzidian_icon.png) center no-repeat;
        background-size: 100% 100%;
    }
    .dc-dz-tit{
        font-size: 0.083rem;
        color: #666;
        text-align: center;
    }
    .dc-dz-num,.dc-dz-info{
        height: 0.208rem;
        line-height: 0.208rem;
        font-size: 0.1rem;
        margin-top: 0.0156rem;
    }
    .dc-dz-num{
        font-size: 0.1rem;
    }
    .dc-dz-info{
        /*display: none;*/
        width: 100%;
        background-color: #2eaafa;
        color: #fff;
        font-size: 0.083rem;
        position: absolute;
        left: 0;
        bottom: -0.208rem;
        transition: All 0.2s linear;
        -webkit-transition: All 0.2s linear;
        -moz-transition: All 0.2s linear;
        -o-transition: All 0.2s linear;
        -webkit-border-radius: 0 0 0.625rem 0.625rem;
        -moz-border-radius: 0 0 0.625rem 0.625rem;
        border-radius: 0 0 0.625rem 0.625rem;
    }
    .dc-dz-info:hover{
        color: #fff;
    }
    .dc-bz-item:hover{
        border:1px solid #2eaafa;
    }
    .dc-bz-item:hover .dc-dz-info{
        display: block;
        bottom: -1px;
    }
    .dc-bz-item:hover .dc-dz-num{
        display: none;
    }
    .dc-cj{
        position: relative;
        border: 1px solid #ebebeb;
        display: -webkit-box;
        display: box;
        -webkit-box-pack: center;
        -webkit-box-align: center;
        box-pack: center;
        box-align: center;
    }
    .dc-cj-left{
        -webkit-box-flex: 0;
        box-flex: 0;
        padding: 0.078rem 0.15rem;
        text-align: center;
    }
    .dc-cj-icon{
        width: 0.27rem;
        height: 0.27rem;
        background: url(${staticRoot}/images/caijizongliang_icon.png) center no-repeat;
        background-size: 0.27rem 0.27rem;
        margin: 0 auto;
    }
    .dc-cj-tit{
        font-size: 0.083rem;
        color: #666;
        margin-top: 0.1rem;
    }
    .dc-cj-num{
        font-size: 0.125rem;
        margin-top: 0.052rem;
    }
    .dc-cj-right{
        -webkit-box-flex: 1;
        box-flex: 1;
        border-left: 1px solid #ebebeb;
    }
    .dc-cj-right .chart-div{
        height: 0.99rem;
    }
    .dc-yzczb{
        border: 1px solid #ebebeb;
    }
    .dc-cj:hover,.dc-cc:hover,.dc-ksh:hover,.dc-yzczb:hover{
        cursor: pointer;
        border:1px solid #2eaafa;
    }
    .dc-cc{
        /*height: 0.73rem;*/
        text-align: center;
        border: 1px solid #ebebeb;
        /*padding-left: 0;*/
        /*font-size: 0;*/
    }
    .dc-cc-item{
        /*width: 0.73rem;*/
        /*height: 0.73rem;*/
        border-left: 1px solid #ebebeb;
        padding: 0 0 0.052rem;
    }
    .dc-cc-item:first-child{
        border-left: none;
    }
    .dc-cc-icon{
        width: 0.271rem;
        height: 0.271rem;
        margin: 0 auto;
        margin-top: 0.1rem;
        margin-bottom: 0.052rem;
    }
    .dc-cc-tit{
        font-size: 0.083rem;
        color: #666;
    }
    .dc-cc-num{
        font-size: 0.1rem;
        margin-top: 0.026rem;
    }
    .jm-icon{
        background: url(${staticRoot}/images/jumingjiandang_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .yl-icon{
        background: url(${staticRoot}/images/yiliaoziyuan_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .jk-icon{
        background: url(${staticRoot}/images/jiankangdanan_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .dz-icon{
        background: url(${staticRoot}/images/dianzibingli_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .dc-zb{
        border: 1px solid #ebebeb;
    }
    .dc-zb-top{
        width: 100%;
        height: 0.417rem;
        text-align: center;
        border-bottom: 1px solid #ebebeb;
        padding-top: 0.0625rem;
    }
    .dc-zb-icon{
        width: 0.271rem;
        height: 0.271rem;
        background: url(${staticRoot}/images/zibiaozhongshu_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
        display: inline-block;
    }
    .dc-zb-con{
        display: inline-block;
        /*text-align: left;*/
        /*vertical-align: middle;*/
        padding-left: 0.156rem;
    }
    .dc-zb-lab{
        font-size: 0.083rem;
        color: #999;
    }
    .dc-zb-num{
        font-size: 0.125rem;
    }
    .dc-zb-bottom{
        width: 100%;
        /*height: 0.83rem;*/
        /*border: 1px solid #ebebeb;*/
        border-top: none;
    }
    .dc-zb-bottom .chart-div{
        width: 100%;
        height: 1.8rem;
    }
    .dc-ksh{
        width: 100%;
        /*height: 0.83rem;*/
        border: 1px solid #ebebeb;
        /*position: relative;*/
    }
    .dc-ksh-left{
        /*width: 0.99rem;*/
        /*height: 0.83rem;*/
        /*display: inline-block;*/
        /*vertical-align: middle;*/
        /*border-right: 1px solid #ebebeb;*/
        text-align: center;
        padding: 0.078rem 0.15rem;
    }
    .dc-ksh-icon{
        width: 0.271rem;
        height: 0.271rem;
        margin: 0 auto;
        margin-top: 0.1rem;
        margin-bottom: 0.078rem;
        background: url(${staticRoot}/images/shituzongshu_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .dc-ksh-tit{
        font-size: 0.083rem;
        color: #999;
    }
    .sc-ksh-num{
        padding-top: 0.026rem;
        font-size: 0.125rem;
    }
    .dc-ksh-right{
        border-left: 1px solid #ebebeb;
        /*height: 0.823rem;*/
        /*display: inline-block;*/
        /*vertical-align: middle;*/
        /*position: absolute;*/
        /*left: 0.99rem;*/
        /*top: 0;*/
        /*right: 0;*/
        /*bottom:0;*/
    }
    .dc-ksh-right .chart-div{
        width: 100%;
        height: 1.5rem;
    }
    .zybb-icon{
        background: url(${staticRoot}/images/baobiaozongshu_icon.png) center no-repeat;
        background-size: 0.271rem 0.271rem;
    }
    .dc-fj-item{
        width: 100%;
        height: 0.52rem;
        margin-bottom: 0.1rem;
        display: block;
        color: #323232;
        -webkit-border-radius:0.047rem;
        -moz-border-radius:0.047rem;
        border-radius:0.047rem;
        border:1px solid #fff;
    }
    .dc-fj-item:hover{
        color: #323232;
        border:1px solid #2eaafa;
    }
    .dc-fj-left{
        width: 0.83rem;
        height: 0.52rem;
    }
    .dc-fj-icon{
        width: 0.417rem;
        height: 0.417rem;
        margin: 0 auto;
        margin-top: 0.047rem;
    }
    .dc-fj-info{
        width: 2.07rem;
        padding-right: 0.1rem;
    }
    .dc-fj-left,.dc-fj-info{
        display: inline-block;
        vertical-align: middle;
    }
    .dc-fj-tit{
        font-size: 0.083rem;
        font-weight: 600;
    }
    .dc-fj-con{
        font-size: 0.073rem;
        padding-top: 0.03125rem;
    }
    .jgsq-icon{
        background: url(${staticRoot}/images/shujushouquan_icon.png) center no-repeat;
        background-size: 0.417rem 0.417rem;
    }
    .yysq-icon{
        background: url(${staticRoot}/images/yingyongshouquan_icon.png) center no-repeat;
        background-size: 0.417rem 0.417rem;
    }
    .jssq-icon{
        background: url(${staticRoot}/images/jiaosheshouquan_icon.png) center no-repeat;
        background-size: 0.417rem 0.417rem;
    }
    .dc-item-info{
        display: none;
        padding: 0 0.1rem 0 0;
        margin-top: 0.3rem;
    }
    .dc-item-info.fadeInUp{
        display: block;
        -webkit-animation: fadeInUp 0.5s linear;
        -moz-animation: fadeInUp 0.5s linear;
        animation: fadeInUp 0.5s linear;
        -webkit-animation-iteration-count: 1;
        -moz-animation-iteration-count: 1;
        animation-iteration-count: 1;
    }
    .dc-item-info.fadeInDown1{
        display: block;
        -webkit-animation: fadeInDown1 1s linear;
        -moz-animation: fadeInDown1 1s linear;
        animation: fadeInDown1 1s linear;
        -webkit-animation-iteration-count: 1;
        -moz-animation-iteration-count: 1;
        animation-iteration-count: 1;
    }
    .fadeLeftIn{
        /*display: inline-block;*/
        -webkit-animation: fadeLeftIn 1s linear;
        -moz-animation: fadeLeftIn 1s linear;
        animation: fadeLeftIn 1s linear;
        -webkit-animation-iteration-count: 1;
        -moz-animation-iteration-count: 1;
        animation-iteration-count: 1;
    }
    .fadeLeftIn2{
        display: block;
        -webkit-animation: fadeLeftIn 1.5s linear;
        -moz-animation: fadeLeftIn 1.5s linear;
        animation: fadeLeftIn 1.5s linear;
        -webkit-animation-iteration-count: 1;
        -moz-animation-iteration-count: 1;
        animation-iteration-count: 1;
    }
    a:active, a:visited, a:focus {
        color: #323232;
    }
    @keyframes run {
        0% {
            -webkit-transform: rotate(0deg);
            -moz-transform: rotate(0deg);
            -ms-transform: rotate(0deg);
            -o-transform: rotate(0deg);
            transform: rotate(0deg);
            -webkit-transform-origin:center center;
            -moz-transform-origin:center center;
            -ms-transform-origin:center center;
            -o-transform-origin:center center;
            transform-origin:center center;
        }

        100% {
            -webkit-transform: rotate(360deg);
            -moz-transform: rotate(360deg);
            -ms-transform: rotate(360deg);
            -o-transform: rotate(360deg);
            transform: rotate(360deg);
            -webkit-transform-origin:center center;
            -moz-transform-origin:center center;
            -ms-transform-origin:center center;
            -o-transform-origin:center center;
            transform-origin:center center;
        }
    }

    @keyframes warn {
        0% {
            transform: scale(0.3);
            -webkit-transform: scale(0.3);
            opacity: 0.0;
        }

        25% {
            transform: scale(0.3);
            -webkit-transform: scale(0.3);
            opacity: 0.1;
        }

        50% {
            transform: scale(0.5);
            -webkit-transform: scale(0.5);
            opacity: 0.3;
        }

        75% {
            transform: scale(0.8);
            -webkit-transform: scale(0.8);
            opacity: 0.5;
        }

        100% {
            transform: scale(1);
            -webkit-transform: scale(1);
            opacity: 0.0;
        }
    }
    @keyframes warn1 {
        0% {
            transform: scale(0.3);
            -webkit-transform: scale(0.3);
            opacity: 0.0;
        }

        25% {
            transform: scale(0.3);
            -webkit-transform: scale(0.3);
            opacity: 0.1;
        }

        50% {
            transform: scale(0.5);
            -webkit-transform: scale(0.5);
            opacity: 0;
        }

        75% {
            transform: scale(0.7);
            -webkit-transform: scale(0.7);
            opacity: 0.7
        }

        100% {
            transform: scale(1);
            -webkit-transform: scale(1);
            opacity: 0.0;
        }
    }
    @keyframes narrow {
        0% {
            opacity: 1;
            transform: scale(1);
            -webkit-transform: scale(1);
        }
        80%{
            opacity: 0;
            transform: scale(0.2);
            -webkit-transform: scale(0.2);
        }
    }
    @keyframes fadeInUp {
        0% {
            opacity: 0;
            top: 0.3125rem;
        }
        50% {
            opacity: 0.5;
            top: 0.208rem;
        }
        100%{
            opacity: 1;
            top: 0.1rem;
        }
    }
    @keyframes fadeInDown1 {
        0% {
            opacity: 1;
            top: 0.1rem;
        }
        50% {
            opacity: 0.5;
            top: 0.208rem;
        }
        100%{
            opacity: 0;
            top: 0.3125rem;
            display: none;
        }
    }
    @keyframes fadeLeftIn {
        0% {
            opacity: 1;
            margin-left: 0
        }
        50% {
            opacity: 0.5;
            margin-left: 0.8rem
        }
        100%{
            opacity: 0;
            margin-left: 1.59rem;
        }
    }
</style>
