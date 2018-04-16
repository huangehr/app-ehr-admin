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

    body{
        background: url(${staticRoot}/images/diwen_bg_img.png) center no-repeat;
        background-position: bottom right;
        background-color: #fff;
    }
    ul,li{
        list-style: none;
    }
    li{
        display: inline-block;
    }
    .dc-main{
        width: 100%;
        height: 100%;
        overflow: auto;
        position: relative;
    }
    .qp-icon{
        width: 16px;
        height: 16px;
        background: url(${staticRoot}/images/zhankai_icon.png) center no-repeat;
        position: absolute;
        top: 15px;
        right: 25px;
        cursor: pointer;
    }
    .dc-body{
        height: 100%;
        min-width: 1710px;
        min-height: 942px;
        position: relative;
    }
    .dc-left,.dc-right{
        position: absolute;
        top: 0;
        bottom: 0;
        overflow: hidden;
    }
    .dc-left{
        width: 60%;
        left: 0;
        color: #323232;
    }
    .dc-right{
        width: 40%;
        right: 0;
        padding-right: 120px;
        padding-top: 20px;
        color: #323232;
    }
    .dc-big-circle,.dc-little-circle,.dc-little-circle1{
        width: 940px;
        height: 940px;
        /*border:1px dashed #3fb1fa;*/
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        position: absolute;
        left: -150px;
        bottom: -77px;
    }
    .dc-little-circle1{
        border:1px dashed #3fb1fa;
    }
    .dc-big-circle{
        z-index: 5;
    }
    .dc-circle-item{
        width: 100px;
        height: 100px;
        cursor: pointer;
        text-align: center;
        line-height: 100px;
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
        width: 110px;
        height: 110px;
        display: none;
        position: absolute;
        left: -6px;
        top: -6px;
        -webkit-border-radius:100%;
        -moz-border-radius:100%;
        border-radius:100%;
        border:1px dashed #3fb1fa;
    }
    .dc-circle-item:hover:before{
        display: block;
        -webkit-animation: run 5s linear;
        -moz-animation: run 5s linear;
        animation: run 5s linear;
        -webkit-animation-iteration-count: infinite;
        -moz-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
    }
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
        width: 160px;
        height: 160px;
        position: absolute;
        left: -31px;
        top: -31px;
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
        box-shadow: 1px 1px 30px #3fb1fa; /* 阴影效果 */
        z-index: 1;
    }
    .dc-circle-item.item-two:after{
        box-shadow: 1px 1px 30px #49d2dc; /* 阴影效果 */
    }
    .dc-circle-item.item-three:after{
        box-shadow: 1px 1px 30px #907bf4; /* 阴影效果 */
    }
    .dc-circle-item.item-four:after{
        box-shadow: 1px 1px 30px #2075d4; /* 阴影效果 */
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
        left: 289px;
        top: -31px;
        color: #2eaafa;
    }
    .item-two{
        left: 629px;
        border: 1px solid #49d2dc;
        color: #49d2dc;
    }
    .item-three{
        left: 853px;
        top: 243px;
        border: 1px solid #907bf4;
        color: #907bf4;
    }
    .item-four{
        left: 864px;
        top: 563px;
        border: 1px solid #2075d4;
        color: #2075d4;
    }
    .dc-little-circle{
        border: none;
    }
    .dc-img,.dc-img1{
        position: absolute;
        /*opacity: 0;*/
        display: none;
        left: -1px;
        top: -3px;
        transition: All 1s ease-in;
        -webkit-transition: All 1s ease-in;
        -moz-transition: All 1s ease-in;
        -o-transition: All 1s ease-in;
    }
    .dc-circle-item:hover .dc-img,.dc-circle-item:hover .dc-img1{
        /*opacity: 1;*/
        display: block;
    }
    .dc-icon0.active{
        display: block;
        left: 129px;
        top: 447px;
    }
    .dc-icon1.active{
        display: block;
        left: -211px;
        top: 416px;
    }
    .dc-icon2.active{
        display: block;
        left: -435px;
        top: 173px;
    }
    .dc-icon3.active{
        display: block;
        left: -446px;
        top: -147px;
    }
    .dc-label{
        width: 100px;
        height: 100px;
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
        left: 100px;
        width: 100px;
    }
    .dc-info-circle{
        width: 501px;
        height: 500px;
        position: absolute;
        left: 50%;
        top: 50%;
        margin-top:-250px;
        margin-left:-250px;
        background: url(${staticRoot}/images/ty.png) center no-repeat;
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
        width: 100px;
        height: 100px;
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
    .dc-icon.active{
        opacity: 0;
    }
    .item-info{
        margin-left: 113px;
        margin-top: -142px;
        width: 302px;
    }
    .itme-tit{
        padding-bottom: 8px;
        font-size: 30px;
        border-bottom: 1px solid #323232;
    }
    .item-con{
        position: relative;
        padding-top: 10px;
        font-size: 16px;
    }
    .itme-tit,.item-con{
        color: #323232;
        text-align: center;
    }
    .item-con:before{
        content: ' ';
        width: 26px;
        height: 10px;
        position: absolute;
        left: -19px;
        top: 7px;
        border-top: 1px solid #323232;
        -webkit-transform: rotate(-45deg);
        -moz-transform: rotate(-45deg);
        -ms-transform: rotate(-45deg);
        -o-transform: rotate(-45deg);
        transform: rotate(-45deg);
    }

    .container {
        position: absolute;
        width: 18px;
        height: 18px;
        left: 331px;
        top: 10px;
    }
    /* 保持大小不变的小圆点 */
    .dot {
        position: absolute;
        width: 18px;
        height: 18px;
        left: 0;
        top: 0;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        border-radius: 50%;
        background-color:#04ffff; /* 实心圆 ，如果没有这个就是一个小圆圈 */
        z-index: 2;
    }
    /* 产生动画（向外扩散变大）的圆圈 第一个圆 */
    .pulse {
        position: absolute;
        width: 30px;
        height: 30px;
        left: -6px;
        top: -6px;
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
        box-shadow: 1px 1px 30px #04ffff; /* 阴影效果 */
    }
    .dc-r-titO{
        font-size: 24px;
        font-weight: 600;
        padding-bottom: 20px;
        position: relative;
    }
    .dc-r-titO:after{
        content: ' ';
        width: 446px;
        height: 1px;
        position: absolute;
        right: 0;
        bottom: 20px;
        border-bottom: 1px solid #ebebeb;
    }
    .dc-r-con{
        text-indent: 2em;
        font-size: 16px;
        line-height: 30px;
        padding-bottom: 30px;
    }
    .dc-r-titT{
        font-size: 20px;
        font-weight: 600;
        border-left: 4px solid #2eaafa;
        padding-left: 16px;
        margin: 20px 0;
    }
    .dc-bz{
        width: 100%;
        text-align: center;
        padding-left: 0;
        font-size: 0;
    }
    .dc-bz-item{
        width: 160px;
        height: 160px;
        margin: 0 7px;
        -webkit-border-radius:12px;
        -moz-border-radius:12px;
        border-radius:12px;
        overflow: hidden;
        border:1px solid #fff;
        position: relative;
    }
    .dc-bz-icon{
        width: 80px;
        height: 80px;
        margin: 0 auto;
        margin-top: 10px;
        margin-bottom: 6px;
    }
    .ptbz-icon{
        background: url(${staticRoot}/images/pingtaibiaozhun_icon.png) center no-repeat;
    }
    .ccpt-icon{
        background: url(${staticRoot}/images/chucunbiaozhun_icon.png) center no-repeat;
    }
    .sjzd-icon{
        background: url(${staticRoot}/images/shujuzidian_icon.png) center no-repeat;
    }
    .dc-dz-tit{
        font-size: 16px;
        color: #666;

    }
    .dc-dz-num,.dc-dz-info{
        height: 40px;
        line-height: 40px;
        font-size: 20px;
        margin-top: 3px;
    }
    .dc-dz-num{
        font-size: 20px;
    }
    .dc-dz-info{
        /*display: none;*/
        width: 100%;
        background-color: #2eaafa;
        color: #fff;
        font-size: 16px;
        position: absolute;
        left: 0;
        bottom: -40px;
        transition: All 0.2s linear;
        -webkit-transition: All 0.2s linear;
        -moz-transition: All 0.2s linear;
        -o-transition: All 0.2s linear;
        -webkit-border-radius: 0 0 12px 12px;
        -moz-border-radius: 0 0 12px 12px;
        border-radius: 0 0 12px 12px;
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
    }
    .dc-cj-left{
        width: 190px;
        height: 160px;
        display: inline-block;
        text-align: center;
        border-right: 1px solid #ebebeb;
    }
    .dc-cj-icon{
        width: 52px;
        height: 52px;
        background: url(${staticRoot}/images/caijizongliang_icon.png) center no-repeat;
        margin: 0 auto;
        margin-top: 20px;
        margin-bottom: 20px;
    }
    .dc-cj-tit{
        font-size: 16px;
        color: #666;
    }
    .dc-cj-num{
        font-size: 24px;

    }
    .dc-cj-right{
        /*width: 372px;*/
        height: 160px;
        float: right;
        display: inline-block;
        position: absolute;
        left: 191px;
        right: 0;
        top: 0;
        bottom: 0;
    }
    .dc-yzczb{
        border: 1px solid #ebebeb;
    }
    .dc-cj:hover,.dc-cc:hover,.dc-ksh:hover,.dc-yzczb:hover{
        cursor: pointer;
        border:1px solid #2eaafa;
    }
    .dc-cc{
        height: 140px;
        text-align: center;
        border: 1px solid #ebebeb;
        padding-left: 0;
        font-size: 0;
    }
    .dc-cc-item{
        width: 140px;
        height: 140px;
        border-left: 1px solid #ebebeb;
    }
    .dc-cc-item:first-child{
        border-left: none;
    }
    .dc-cc-icon{
        width: 52px;
        height: 52px;
        margin: 0 auto;
        margin-top: 20px;
        margin-bottom: 10px;
    }
    .dc-cc-tit{
        font-size: 16px;
        color: #666;
    }
    .dc-cc-num{
        font-size: 20px;
    }
    .jm-icon{
        background: url(${staticRoot}/images/jumingjiandang_icon.png) center no-repeat;
    }
    .yl-icon{
        background: url(${staticRoot}/images/yiliaoziyuan_icon.png) center no-repeat;
    }
    .jk-icon{
        background: url(${staticRoot}/images/jiankangdanan_icon.png) center no-repeat;
    }
    .dz-icon{
        background: url(${staticRoot}/images/dianzibingli_icon.png) center no-repeat;
    }
    .dc-zb-top{
        width: 100%;
        height: 80px;
        text-align: center;
        border-bottom: 1px solid #ebebeb;
        padding-top: 12px;
    }
    .dc-zb-icon{
        display: inline-block;
        width: 52px;
        height: 52px;
        background: url(${staticRoot}/images/zibiaozhongshu_icon.png) center no-repeat;
        vertical-align: middle;
    }
    .dc-zb-con{
        display: inline-block;
        text-align: left;
        vertical-align: middle;
        padding-left: 30px;
    }
    .dc-zb-lab{
        font-size: 16px;
        color: #999;
    }
    .dc-zb-num{
        font-size: 24px;
    }
    .dc-zb-bottom{
        width: 100%;
        height: 160px;
        /*border: 1px solid #ebebeb;*/
        border-top: none;
    }
    .dc-ksh{
        width: 100%;
        height: 160px;
        border: 1px solid #ebebeb;
        position: relative;
    }
    .dc-ksh-left{
        width: 190px;
        height: 158px;
        display: inline-block;
        vertical-align: middle;
        border-right: 1px solid #ebebeb;
        text-align: center;
    }
    .dc-ksh-icon{
        width: 52px;
        height: 52px;
        margin: 0 auto;
        margin-top: 20px;
        margin-bottom: 15px;
        background: url(${staticRoot}/images/shituzongshu_icon.png) center no-repeat;
    }
    .dc-ksh-tit{
        font-size: 16px;
        color: #999;
    }
    .sc-ksh-num{
        padding-top: 5px;
        font-size: 24px;
    }
    .dc-ksh-right{
        height: 158px;
        display: inline-block;
        vertical-align: middle;
        position: absolute;
        left: 191px;
        top: 0;
        right: 0;
        bottom:0;
    }
    .zybb-icon{
        background: url(${staticRoot}/images/baobiaozongshu_icon.png) center no-repeat;
    }
    .dc-fj-item{
        width: 100%;
        height: 100px;
        margin-bottom: 20px;
        display: block;
        color: #323232;
        -webkit-border-radius:9px;
        -moz-border-radius:9px;
        border-radius:9px;
        border:1px solid #fff;
    }
    .dc-fj-item:hover{
        color: #323232;
        border:1px solid #2eaafa;
    }
    .dc-fj-left{
        width: 160px;
        height: 100px;
    }
    .dc-fj-icon{
        width: 80px;
        height: 80px;
        margin: 0 auto;
        margin-top: 9px;
    }
    .dc-fj-info{
        width: 398px;
        padding-right: 20px;
    }
    .dc-fj-left,.dc-fj-info{
        display: inline-block;
        vertical-align: middle;
    }
    .dc-fj-tit{
        font-size: 16px;
        font-weight: 600;
    }
    .dc-fj-con{
        font-size: 14px;
        padding-top: 6px;
    }
    .jgsq-icon{
        background: url(${staticRoot}/images/shujushouquan_icon.png) center no-repeat;
    }
    .yysq-icon{
        background: url(${staticRoot}/images/yingyongshouquan_icon.png) center no-repeat;
    }
    .jssq-icon{
        background: url(${staticRoot}/images/jiaosheshouquan_icon.png) center no-repeat;
    }
    .dc-item-info{
        position: absolute;
        left: 0;
        top: 20px;
        right: 120px;
        display: none;
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
            top: 60px;
        }
        50% {
            opacity: 0.5;
            top: 40px;
        }
        100%{
            opacity: 1;
            top: 20px;
        }
    }
    @keyframes fadeInDown1 {
        0% {
            opacity: 1;
            top: 20px;
        }
        50% {
            opacity: 0.5;
            top: 40px;
        }
        100%{
            opacity: 0;
            top: 60px;
            display: none;
        }
    }
</style>
