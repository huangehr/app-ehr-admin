<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/11/1
  Time: 9:45
  To change this template use File | Settings | File Templates.
--%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    body {background-color: #f1f3f6;}
    body,html{height: 100%}
    .mCSB_inside > .mCSB_container{margin: 0}
    .c-h-100{height: 100%;}
    .c-w-100{width: 100%;}
    .c-w-40{width:40%;}
    .c-w-50{width:50%;}
    .c-w-60{width:60%;}
    .yj-tit{font-size: 18px;color:#333333;vertical-align: middle}
    .if-jkda{width: 20px;height: 20px;display: inline-block;background: url(${staticRoot}/images/icon_jiankangdangan.png) center no-repeat;vertical-align: middle;margin-right: 10px;margin-left: 16px;}
    .div-jkda{width: 100%;height: 345px;background: #ffffff;border: 1px solid #e1e1e1;margin-top: 20px}
    .div-jkda-header{height: 60px;line-height: 60px;}
    .div-jkda-content{width: calc(25.35% - 26px);height: 268px;border:1px solid #e1e1e1;margin-left: 16px;float: left;position: relative;}
    .bar-a{
        display: inline-block;
        width: 16px;
        height: 16px;
        position: relative;
        top: 3px;
        margin-right: 4px;
        vertical-align: bottom;
    }
    .cb-42d16f{background:#42d16f}
    .cb-ffbd5c{background:#ffbd5c}
    .cb-5bc9f4{background: #5bc9f4}
    .cb-9a9cf4{background: #9a9cf4}
    .cb-d08dff{background: #d08dff}
    .c-42d16f{color:#42d16f}
    .c-ffbd5c{color:#ffbd5c}
    .c-5bc9f4{color:#5bc9f4}
    .c-9a9cf4{color: #9a9cf4}
    .c-d08dff{color: #d08dff}
    .div-ljjbrs{position: absolute;width: 50px;height: 50px;background: url(${staticRoot}/images/icon_jibingrenshu.png) center no-repeat;top: 20px;right: 30px;}
    .div-ljjzrs{position: absolute;width: 41px;height: 63px;background: url(${staticRoot}/images/icon_jiuzhenrenshu.png) center no-repeat;top: 20px;right: 30px;}

    .if-dzbl{width: 20px;height: 20px;display: inline-block;background: url(${staticRoot}/images/icon_dianzibingli.png) center no-repeat;vertical-align: middle;margin-right: 10px;margin-left: 16px;}
    .if-smtz{width: 20px;height: 20px;display: inline-block;background: url(${staticRoot}/images/icon_shengmingtizhen.png) center no-repeat;vertical-align: middle;margin-right: 10px;margin-left: 16px;}
    .div-smtz1{width: 360px;height: 160px;display: inline-block;background: url(${staticRoot}/images/icon_juxing1.png) center no-repeat;}
    .div-shebeishu-img{width: 50px;height: 50px;display: inline-block;background: url(${staticRoot}/images/icon_shebeishu.png) center no-repeat;position: absolute;top:20px;right: 30px;}
    .div-smtz2{width: 360px;height: 160px;display: inline-block;background: url(${staticRoot}/images/icon_juxing2.png) center no-repeat;}
    .div-xuetangshu-img{width: 50px;height: 50px;display: inline-block;background: url(${staticRoot}/images/icon_xuetangshu.png) center no-repeat;position: absolute;top:20px;right: 30px;}
    .div-smtz3{width: 360px;height: 160px;display: inline-block;background: url(${staticRoot}/images/icon_juxing3.png) center no-repeat;}
    .div-xinlv-img{width: 50px;height: 50px;display: inline-block;background: url(${staticRoot}/images/icon_xinlv.png) center no-repeat;position: absolute;top:20px;right: 30px;}
    .div-smtz4{width: 360px;height: 160px;display: inline-block;background: url(${staticRoot}/images/icon_juxing4.png) center no-repeat;}
    .div-xueyashu-img{width: 50px;height: 50px;display: inline-block;background: url(${staticRoot}/images/icon_xueyashu.png) center no-repeat;position: absolute;top:20px;right: 30px;}
    .if-qyrkgak{width: 20px;height: 20px;display: inline-block;background: url(${staticRoot}/images/icon_quanyuanrenkougeanku.png) center no-repeat;vertical-align: middle;margin-right: 10px;margin-left: 16px;}
    .if-ylzyk{width: 20px;height: 20px;display: inline-block;background: url(${staticRoot}/images/icon_yiliaoziyuanku.png) center no-repeat;vertical-align: middle;margin-right: 10px;margin-left: 16px;}

    .div-chart{position: relative;z-index: 10;float:left;height: 174px;}
    .div-instruction{position: absolute;z-index: 20;left: 50%;width: 80px;height:50px;margin-left: -40px;top:50%;margin-top: -25px;}
    .div-jkda-amount{color:#333;font-size: 20px;font-weight: bold;text-align: center;}
    .div-jkda-title{color:#333;font-size: 12px;text-align: center;}
    .div-bottom-instruction{float:left;font-size: 12px;height: 50px;}
    .f-mb10{margin-bottom: 10px;}
    .f-pl30{padding-left: 30px;}
    .f-pr30{padding-right: 30px;}
    .f-ml30{margin-left: 30px;}
    .f-mr30{margin-right: 30px;}
    .f-mb30{margin-bottom: 30px;}
    .f-mb20{margin-bottom: 20px;}
    .f-ml20{margin-left: 20px;}
    .div-smtz{margin-top: 20px;height: 270px;background: #ffffff;border: 1px solid #e1e1e1;}
    .div-smtz-content{width: calc(25% - 15px);margin-left: 15px;border-radius: 5px;margin-top: 20px;position: relative;}
    .div-smtz-amount-title{font-size: 18px;color: #ffffff;;padding: 20px 0px 10px 30px;}
    .div-smtz-day-add{font-size: 16px;color:#ffffff;padding: 0px 0px 15px 30px;}
    .div-smtz-amount{color:#ffffff;margin: 0px 10px 0px 30px;font-size: 40px;}
    .c-fff{color:#fff;}
    .f-fs20{font-size:20px;}
    .div-qyrkgak{/*margin-top: 20px;*/height: 1150px;background: #ffffff;border: 1px solid #e1e1e1;}
    .div-qyrkgak-chart1{height: 350px;width: calc(30% - 21px);display: inline-block;position: relative;}
    #div_jkda_chart6{width: 60%;height: 100%;margin-right: 20%;margin-left: 20%;}
    #div_jkda_chart7{height: 350px;width: 40%;display: inline-block;}
    .div-chuizhi-xian{height: 250px;width: 1px;background: #e1e1e1;display: inline-block;margin-bottom: 75px;margin-right: 20px;}
    .div-chart8-content{height: 350px;width: calc(30% - 21px);display: inline-block;}
    .c-pr{position: relative;}
    .c-fl{float:left;}
    .f-index10{index:10}
    .f-fs12{font-size:12px;}
    .f-pt135{padding-top:135px;}
    .div-dzbl{margin-top: 20px;height: 410px;background: #ffffff;border: 1px solid #e1e1e1;}
    #div_jkda_chart4{height: 350px;width: 69%;display: inline-block;}
    .div-dzbl-content{height: 350px;width: calc(30% - 21px);display: inline-block;}
    .div-ylzyk{margin-top: 20px;height: 454px;background: #ffffff;border: 1px solid #e1e1e1;}
    #div_jkda_chart9{height: 400px;width: 75%;float: left;}
    .div-ylzyk-content{height: 300px;width: calc(25% - 20px);float: left;padding-top: 56px;}
    .div-ylzyk-header{border:1px solid #e1e1e1;height: 230px;width: 260px;float: right;}
    .div-ylzyk-title{height: 50px;line-height: 50px;padding-left: 20px;font-size: 18px;color: #0c93e4;}
    .c-border-top{border-top: 1px solid #e1e1e1;}
    .f-pt22{padding-top: 22px;}
    .f-fs16{font-size:16px;}
    .c-fwb{font-weight: bold;}
    .c-333{color:#333;}
    .f-pt35{padding-top: 35px;}
    .c-44d4ca{color:#44d4ca;}
    .c-ffbd5c{color: #ffbd5c;}
    .c-28a9e6{color:#28a9e6;}
    .f-dn{display: none;}
    .l-layout-content{overflow: auto;}
    #btn_detail{ background: #4DB2EE; width: 98px !important; height: 34px; line-height: 34px;}
    .m-form-inline .m-form-group label{ width: 110px;float: left; }
    .m-form-inline .m-form-group{padding-bottom: 0;}
    .m-form-inline .m-form-group .m-form-control.m-form-control-fr{float: right}
    .div-title{margin: 10px 0px 20px;text-align: center;font-size: 20px;color: #666666;}
    .div-head{height: 169px;margin: 20px 0px;}
    .div-items{width: 48%;height: 100%;float: left;border: 1px solid #dddddd;cursor:pointer;}
    .div-items.active{border: 2px solid #4DB2EE;}
    .div-item-title{height: 40px;width: 100%;text-align: center;background: #f3f3f3;line-height: 40px;border-bottom:1px solid #dddddd;color:#bbbbbb;}
    .div-item-content{width: 100%;height: 128px;text-align: center}
    .div-item{width: 33%;height: 100%;border-right: 1px solid #dddddd;float:left;}
    .div-item:last-child{border-right:0;}
    .div-item.active{border: 2px solid #4DB2EE;}
    .div-items  .div-item-content img{width: 30px;height: 30px;margin: 10px 5px;}
    .div-items  .div-item-content span{font-size: 25px;vertical-align:middle;font-weight: bold;}
    .div-items  .div-item-content .div-item-type, .div-items  .div-item-content .div-item-count{text-align: center;padding-top: 10px;font-size: 16px;color: #666666;}
    .div-qsfx{color:#666666;margin:30px 20px;font-size: 16px;}
    .div-group{height: 34px;border:1px solid #dddddd;width: 212px;position: absolute;right: 20px;top: 20px;}
    .div-group .div-btn{width: 70px;height: 32px;float: left;background: #fff;color: #000;text-align: center;line-height: 32px;border-right: 1px solid #dddddd;}
    .div-group .div-btn:last-child{border-right: 0}
    .div-group .div-btn.active{background: #4DB2EE;color: #ffffff;}
    .div-hospital-name{width: 100px;height: 100px;position: relative;border-radius: 100px;text-align: center;border:1px solid #dddddd;font-size: 15px; font-weight: bold;padding: 15px;display: -webkit-box;overflow: hidden;text-overflow: ellipsis;-webkit-box-orient: vertical;-webkit-line-clamp: 3;}
    .div-hospital-name p{position: relative;top:50%;transform:translateY(-50%);overflow: hidden;}
    .div-hospital-item{width: 70%;height: 40px;border:1px solid #dddddd; position: absolute; left: 120px;top: 30px;}
    .l-gq-bg{position: relative;height: 39px;background-color: #4DB2EE; z-index: 1;}
    .l-gq-value{position: relative;top: -70%;left: 5px;color: #fff;z-index: 2;font-size: 14px;}
    .div-chart-content{height:345px;border:1px solid #dddddd;border-left: 0;border-right:0;position: relative;}
    .div-zuoqiehuan{background: url(${staticRoot}/images/zuoqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;left: 0px;top: 45%;z-index: 20;}
    .div-zuoqiehuan:active,.div-zuoqiehuan:hover{background: url(${staticRoot}/images/zuoqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    .div-youqiehuan{background: url(${staticRoot}/images/youqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;right: 20px;top: 45%;z-index: 20;}
    .div-youqiehuan:active,.div-youqiehuan:hover{background: url(${staticRoot}/images/youqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    #chart-main{width: 100%;height: 250px;position: relative;z-index: 10;}
    .div-organization{position: relative;}
    .f-dn{display: none;}
    .l-layout-content{overflow: auto;}
    #btn_detail{ background: #4DB2EE; width: 98px !important; height: 34px; line-height: 34px;}
    .m-form-inline .m-form-group label{ width: 110px;float: left; }
    .m-form-inline .m-form-group{padding-bottom: 0;}
    .m-form-inline .m-form-group .m-form-control.m-form-control-fr{float: right}
    .div-title{margin: 10px 0px 20px;text-align: center;font-size: 20px;color: #666666;}
    .div-head{height: 168px;margin: 20px 0px;}
    .div-item-title{height: 40px;width: 100%;text-align: center;background: #f3f3f3;line-height: 40px;border-bottom:1px solid #dddddd;color:#bbbbbb;}
    .div-item{width: 33.33%;height: 100%;border-right: 1px solid #dddddd;float:left;}
    .div-item:last-child{border-right:0;}
    .div-item.active{border: 2px solid #4DB2EE;}
    .div-items  .div-item-content img{width: 30px;height: 30px;margin: 10px 5px;}
    .div-items  .div-item-content span{font-size: 25px;vertical-align:middle;font-weight: bold;}
    .div-items  .div-item-content .div-item-type, .div-items  .div-item-content .div-item-count{text-align: center;padding-top: 10px;font-size: 16px;color: #666666;}
    .div-qsfx{color:#666666;margin:30px 20px;font-size: 16px;}
    .div-group{height: 34px;border:1px solid #dddddd;width: 212px;position: absolute;right: 20px;top: 20px;}
    .div-group .div-btn{width: 70px;height: 32px;float: left;background: #fff;color: #000;text-align: center;line-height: 32px;border-right: 1px solid #dddddd;}
    .div-group .div-btn:last-child{border-right: 0}
    .div-group .div-btn.active{background: #4DB2EE;color: #ffffff;}
    .div-hospital-name{width: 100px;height: 100px;position: relative;border-radius: 100px;text-align: center;border:1px solid #dddddd;font-size: 15px; font-weight: bold;padding: 15px;display: -webkit-box;overflow: hidden;text-overflow: ellipsis;-webkit-box-orient: vertical;-webkit-line-clamp: 3;}
    .div-hospital-name p{position: relative;top:50%;transform:translateY(-50%);overflow: hidden;}
    .div-hospital-item{width: 70%;height: 40px;border:1px solid #dddddd; position: absolute; left: 120px;top: 30px;}
    .l-gq-bg{position: relative;height: 39px;background-color: #4DB2EE; z-index: 1;}
    .l-gq-value{position: relative;top: -70%;left: 5px;color: #fff;z-index: 2;font-size: 14px;}
    .div-chart-content{height:345px;border:1px solid #dddddd;border-left: 0;border-right:0;position: relative;}
    .div-zuoqiehuan{background: url(${staticRoot}/images/zuoqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;left: 0px;top: 45%;z-index: 20;}
    .div-zuoqiehuan:active,.div-zuoqiehuan:hover{background: url(${staticRoot}/images/zuoqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    .div-youqiehuan{background: url(${staticRoot}/images/youqiehuan_btn.png) no-repeat;width: 40px;height: 40px;position: absolute;right: 20px;top: 45%;z-index: 20;}
    .div-youqiehuan:active,.div-youqiehuan:hover{background: url(${staticRoot}/images/youqiehuan_btn_pre.png) no-repeat;cursor: pointer}
    #chart-main{width: 100%;height: 250px;position: relative;z-index: 10;}
    .div-organization{position: relative;}
    #grid {
        border-collapse: collapse;
        table-layout:fixed;
        width: 100%;
        border: 1px solid #d5d5d5;
    }

    #grid tbody tr:nth-child(odd) {
        background-color: #fff;
    }

    #grid tr{
        border-bottom: 1px solid #ececec;
        background-color: #f7f7f7;
    }
    #grid td {
        border: 1px solid #ddd;
        padding:8px 6px;
        font-size: 12px;
        word-wrap: break-word;
    }

    #grid th {
        border: 1px solid #ddd;
        padding:8px 6px;
        font-size: 12px;
        font-weight: bold;
    }
    .hr-tit-con {
        font-size: 14px;
        font-weight: 600;
        padding-left: 16px;
    }
    .c-title {
        padding-left: 20px;
        border-left: 4px solid #30a9de;
    }
</style>