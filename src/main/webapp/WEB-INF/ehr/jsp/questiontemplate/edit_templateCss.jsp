<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    body,html,#div_wrapper{height: 100%}
    body {
        padding-bottom: 0px;
    }
    .l-text-wrapper{display: inline-block;}
    .div-wenjuan-title{height:100px;border-bottom: 1px solid #dcdcdc;margin-left: 160px}
    .div-wenjuan-name{height:50px;padding: 5px 20px;color: #909090;font-size: 14px;font-weight: bold;border-bottom: 1px solid #dcdcdc;max-height:50px;overflow:auto;}
    .div-wenjuan-instruction{height:70px;padding: 5px 20px;color: #909090;font-size: 12px;max-height:70px;overflow:auto;}
    .div-header{width: 160px;float: left;height: 100%;border:1px solid #dcdcdc;border-left: 0;background: #EDF6FA;position: fixed; left: 0px;border-top: 0;}
    .div-title{color:#323232;font-weight: bold;font-size: 14px;height: 50px;width:160px;line-height: 50px;text-align: center;border-bottom: 1px solid #dcdcdc;}
    .div-item{height: 40px;text-align: center;line-height: 40px;}
    .div-item:active{cursor: pointer}
    .div-item-title{font-size: 12px;font-weight: initial;}
    .div-right-header{width: calc(100% - 160px);height: calc(100% - 180px);margin-left: 160px; overflow: auto;}
    .div-right-empty{height: calc(100% - 100px);border-bottom: 1px solid #dcdcdc;}
    .div-right-empty .div-img{background: url(${staticRoot}/images/tishi_bg.png) no-repeat center;width: 380px;height: 140px; margin: 0 auto;position: relative;top:38%;}
    .div-btn-group{margin: 0 auto;width: 640px;padding-top: 20px;}
    .f-mr60{margin-right: 60px;}
    .f-ml5{margin-left:5px;}
    .cb-53BC4A{background: #53BC4A;}
    .cb-F0AA23{background: #F0AA23;}
    .f-dn{display: none;}
    .mr8{margin-right: 8px}
    .ml7{margin-left: 7px}
    #div-luojiSettingDialog select{width: 150px;height: 30px}
    .delete-img{background: url(${ctx}/static/develop/images/qingchu_btn.png) no-repeat;width: 25px;height: 22px;background-size: 22px;position: absolute;right: -35px;top: 3px;}
    .position-relative {
        display: inline-block;
        position: relative;
        height: 100%
    }

    #layout {
        padding: 0!important;
        margin: 0!important
    }

    #survey-side-bar {
        display: none!important
    }

    .rows1 {
        height: auto;
        float: left;
        width: 168px;
        z-index: 100;
        position: absolute
    }

    .sur-sidebar {
        width: 168px;
        height: auto;
        border: 1px solid #dbdbdb;
        background: #fff
    }

    .classify-title {
        width: 158px;
        height: 48px;
        font-size: 16px;
        line-height: 48px;
        padding: 0 0 0 10px;
        overflow: hidden;
        border-bottom: 1px solid #dbdbdb;
        cursor: pointer
    }

    .survey-title {
        width: 788px
    }

    .survey-title,#survey-tail,.survey-desc {
        background: #fff
    }

    .survey-title,.survey-desc {
        margin-bottom: 4px
    }

    #survey-tail {
        margin-top: 4px
    }

    .select-question-title {
        background: url(${ctx}/static/develop/images/side_bar_show.png) no-repeat
    }

    .common-questions-title {
        background: url(${ctx}/static/develop/images/side_bar_hide.png) no-repeat;
        border-bottom: 0
    }

    .module {
        cursor: pointer;
        height: 36px;
        text-align: left;
        line-height: 36px;
        background: url(${ctx}/static/develop/images/question_logo.png) no-repeat;
        padding-left: 50px
    }

    .module.upload {
        background: url(${ctx}/static/develop/images/template/upload.png) no-repeat;
        background-position: 18px 10px
    }

    .module.radio-img {
        background: url(${ctx}/static/develop/images/template/radio-img.png) no-repeat;
        background-position: 18px 10px
    }

    .module.checkbox-img {
        background: url(${ctx}/static/develop/images/template/checkbox-img.png) no-repeat;
        background-position: 18px 10px
    }

    .common-questions {
        border-top: 1px solid #dbdbdb
    }

    .common_question {
        cursor: pointer;
        text-align: center;
        line-height: 36px
    }

    .create-survey-nav {
        float: left
    }

    .handle-survey .survey-button {
        width: 72px;
        height: 30px;
        margin: 0 4px;
        padding: 0
    }

    .handle-survey {
        float: right;
        position: relative
    }

    .rows2 {
        margin-left: 172px;
        width: 790px;
        padding-bottom: 20px
    }

    .title-content {
        height: 48px;
        font-size: 18px;
        text-align: center;
        line-height: 48px;
        border: 1px solid #dbdbdb;
        position: relative;
        outline: 0
    }

    .desc-content {
        position: relative;
        outline: 0;
        width: 100%;
        min-height: 30px;
        line-height: 30px
    }

    #question-box {
        min-height: 276px
    }

    .question-box-init {
        line-height: 276px;
        text-align: center;
        font-size: 20px;
        color: #d0d0d0
    }

    #page-tail {
        width: 750px;
        margin: 0 5px;
        border-bottom: 1px solid #efefef;
        height: 36px;
        line-height: 36px;
        color: #999;
        text-align: right;
        padding-right: 30px
    }

    #survey-tail {
        border: 1px solid #dbdbdb
    }

    #survey-op {
        margin: 20px 0 0;
        height: 30px;
        text-align: center
    }

    #survey-op .outstanding-button {
        display: inline-block;
        margin-right: 12px
    }

    .topic-type-content {
        border: 1px solid #dbdbdb;
        margin: 10px;
        display: inline-block;
        width: calc(100% - 25px);
        background: #fff
    }

    .after-clear:after {
        clear: both;
        display: block;
        content: '';
        visibility: hidden;
        height: 0
    }

    .question-title {
        padding:10px;
        font-size: 12px;
        border-bottom: 1px solid #dcdcdc;
    }

    .question-id {
        margin-right: 10px
    }

    .question-choice {
        padding: 10px 0 10px 50px;
        font-size: 12px;
        vertical-align: middle
    }

    .question-choice .auto-height {
        height: auto
    }

    .question-choice li input {
        margin: 2px 10px 0 0
    }

    .drag-area {
        background: url(${ctx}/static/develop/images/xinzenglouji_icon.png) no-repeat;
        cursor: pointer
    }

    .question-setting{
        background: url(${ctx}/static/develop/images/paixunshezhi_icon.png) no-repeat;
        cursor: pointer
    }
    .add-choice {
        background: url(${ctx}/static/develop/images/tianjia_icon.png) no-repeat;
        cursor: pointer
    }

    .batch-add-choice {
        background: url(${ctx}/static/develop/images/piliangtianjia_icon.png) no-repeat;
        background-position: -5px 0;
        cursor: pointer
    }

    .question-instruction {
        background: url(${ctx}/static/develop/images/shuoming_icon.png) no-repeat;
        background-position: 6px 0
    }

    .question-transform {
        background: url(${ctx}/static/develop/images/zhuanhuan_icon.png) no-repeat;
        background-position: 7px 0
    }

    .question-duoxuan{
        background: url(${ctx}/static/develop/images/piliangshezhi_icon.png) no-repeat;
        background-position: 7px 0
    }

    .question-delete {
        background: url(${ctx}/static/develop/images/shanchu_icon.png) no-repeat;
        background-position: 4px 0
    }

    .question-required{
        background: url(${ctx}/static/develop/images/kaiguan01_icon.png) no-repeat;
        background-position: 4px 0
    }

    .logic-show-checkbox {
        vertical-align: top;
        margin-right: 5px
    }

    .fixed-area {
        position: fixed;
        top: 0;
        z-index: 100
    }

    .page-area {
        line-height: 36px;
        text-align: right;
        margin-right: 50px;
        color: #999
    }

    #survey-content .button {
        float: left;
        margin: 0 10px 0 0;
        text-align: center;
        padding: 0;
        cursor: pointer;
        width: 68px;
        height: 28px;
        font-size: 12px;
        line-height: 20px;
        background-color: #f1f5fd;
        border: 1px solid #b0c0e7;
        color: #2c4a93;
        box-shadow: none
    }

    .input-single {
        width: 226px;
        height: 25px;
        border: 1px solid #b0c0e7
    }

    .multi-input {
        width: 240px;
        height: 94px;
        border: 1px solid #b0c0e7;
        resize: none
    }

    .question-choice table td {
        width: 237px;
        height: 35px;
        text-align: center
    }

    .question-choice table tr td {
        border: 1px solid #b0c0e7;
        outline: 0
    }

    .operate {
        float: right;
        margin-right: 10px;
        height: 50px;
        cursor: pointer;
    }

    .operate li {
        float: left;
        margin: 0 5px 0 0;
        width: 36px;
        height: 30px;
        background-size: 30px;
    }

    .survey-hide {
        display: none
    }

    .visible-hide {
        visibility: hidden
    }

    .visible-show {
        visibility: visible
    }

    .operate-dialog,.choice-operate-dialog {
        border: 1px solid #dbdbdb;
        position: absolute!important;
        left: 800px;
        width: 320px!important;
        background: #fff;
        z-index: 1001;
        top: -20px;
        left: 210px
    }

    .dialog-title {
        height: 40px;
        line-height: 40px;
        padding-left: 16px;
        background: #f1f5fd;
        border-bottom: 1px solid #b0c0e7
    }

    .dialog-title span {
        color: #2c4a93
    }

    .question-title .qs-content {
        width:100%;
        display: inline-block;
        min-height: 30px;
        line-height: 30px;
        position: relative;
        outline: 0;
        vertical-align: middle;
        padding-left:5px;
    }

    .question-title .qs-content.edit-area-active,.question-choice .edit-area.edit-area-active{
        border: 1px solid #dcdcdc;
        background: #EDF6FA;
    }
    .question-title .qs-content:hover,.question-choice .edit-area:hover{
        background: #EDF6FA;
    }

    .question-title .qs-high-content:focus {
        min-height: 60px
    }

    .choice .edit-area {
        display: inline-block;
        width: 100%;
        min-height: 30px;
        line-height: 30px;
        position: relative;
        outline: 0;
        vertical-align: middle;
        padding-left:5px;
    }

    .edit-img {
        position: absolute!important;
        overflow: hidden;
        top: -32px;
        right: 0;
        padding-top: 5px;
        z-index: 100;
        background: #fff;
    }

    .edit-img ul {
        margin: 0;
        height: 20px
    }

    .edit-img li {
        float: left;
        width: 32px;
        height: 24px;
        margin: 0 5px;
        cursor: pointer
    }

    .handle-child-element {
        width: 20px;
        height: 17px;
        background: url(${ctx}/static/develop/images/gengduochaozuo_btn.png) no-repeat;
        background-position: 0px 0px
    }

    .remove-child-element {
        width: 20px;
        height: 20px;
        background: url(${ctx}/static/develop/images/shanchu_btn.png) no-repeat;
        background-position:0px 0px
    }

    .up-child-element {
        width: 20px;
        height: 20px;
        background: url(${ctx}/static/develop/images/shangtiao_btn.png) no-repeat;
        background-position: 0px 0px
    }

    .down-child-element {
        width: 20px;
        height: 20px;
        background: url(${ctx}/static/develop/images/xiayi_btn.png) no-repeat;
        background-position: 0px 0px
    }

    .upload-form .upload-img {
        width: 20px;
        height: 20px;
        overflow: hidden;
        filter: alpha(opacity=0);
        -moz-opacity: 0;
        -khtml-opacity: 0;
        opacity: 0;
        margin-top: -2px;
        cursor: pointer;
        vertical-align: top
    }

    .add-area {
        float: left;
        margin: 0 35px;
        height: 50px
    }

    .add-area.survey-question-upload-img-wrap {
        float: none;
        height: auto;
        vertical-align: top;
        margin-left: 35px
    }

    .survey-question-upload-img-wrap.ml35 {
        margin-left: 35px
    }

    .add-area li {
        float: left;
        margin: 0 5px 0 0;
        width: 36px;
        height: 30px;
        background-size: 30px;
        color: #0786e9
    }

    .survey-dialog {
        border: 1px solid #dbdbdb;
        position: absolute;
        left: 800px;
        background: #fff;
        z-index: 1000
    }

    .batch-choices {
        height: 100px;
        width: 270px;
        overflow: auto;
        resize: none;
        border: 1px solid #909090;
        padding: 5px;
    }

    .edit-child-element-dialog ul li {
        float: left;
        margin: 0 10px
    }

    .handle-area input {
        margin: -3px 10px 0 0
    }

    .dialog-tail {
        height: 30px;
        padding-left: 93px;
        margin-bottom: 20px
    }

    .dialog-tail .button {
        width: 64px;
        height: 30px;
        padding: 0;
        margin: 0 10px 0 0
    }

    .operate-dialog-title-content {
        width: 60px;
        display: inline-block
    }

    .dialog-content {
        min-height: 60px
    }

    .batch-add-choices-dialog {
        width: 420px
    }

    .choice-area {
        margin: 10px 16px 5px
    }

    .add-title {
        height: 40px;
        line-height: 40px;
        padding-left: 16px;
        color: #2c4a93;
        background: #f1f5fd
    }

    .add-content-tip {
        line-height: 24px;
        margin: 10px 0 4px 16px
    }

    .add-tail {
        margin: 12px 16px 20px;
        height: 30px
    }

    .add-tail .button {
        width: 64px;
        height: 30px
    }

    .edit-tip,.question-topic-remove {
        width: 320px
    }

    .matrix-choice,.radio_array_title .edit-area,.checkbox_array_title .edit-area {
        height: 100%;
        line-height: 32px;
        width: 100%
    }

    .edit-tip .dialog-content,.question-topic-remove .dialog-content {
        height: 60px;
        margin: 20px
    }

    .img-edit-size li {
        float: left;
        width: 24px;
        height: 30px;
        cursor: pointer
    }

    .img-edit-size ul {
        margin: 0;
        width: 100px;
        height: 30px;
        background: #f1f1f1
    }

    .required,.wt-required {
        color: red;font-size: 12px;
    }

    .choice-operate-dialog .dialog-content {
        margin: 16px 16px 12px;
        height: 50px
    }

    .edit-survey-wrap {
        background: #fff;
        margin: 0 auto
    }

    .choice-operate-dialog .add-other {
        margin: 0
    }

    .choice {
        position: relative;
        outline: 0;
        display: inline-block;
        width: calc(100% - 25px);
    }

    .question-choice table tr td:first-child {
        position: relative
    }

    .matrix-choice>div {
        width: 60px;
        height: 28px
    }

    .navigation {
        width: 968px;
        margin: 0 auto
    }

    #edit-survey-content {
        background: #fff;
        width: 968px;
        margin: 0 auto
    }

    #main-panel {
        border: 0!important
    }

    #content {
        background: #eee
    }

    .time-save {
        background: #fdf9cd;
        width: 150px;
        height: 40px;
        text-align: center;
        line-height: 40px
    }

    .attach-layer {
        top: 148px;
        position: absolute;
        z-index: 1;
        filter: alpha(opacity=0);
        -moz-opacity: 0;
        -khtml-opacity: 0;
        opacity: 0
    }

    .color-default {
        color: #333
    }

    .modal-backdrop {
        z-index: 101!important
    }

    .input-single {
        width: 240px
    }

    .other-content {
        margin: 5px 0 10px 20px!important
    }

    td .other-content {
        margin: 5px 0 10px 14px!important
    }

    .handle-survey {
        margin: 20px 5px 10px 0
    }

    .edit-select {
        margin: 0 10px;
        cursor: pointer;
        color: #0786e9
    }

    .handle-area .min-checkbox,.handle-area .max-checkbox {
        margin: 0 5px;
        width: 40px
    }

    .choice_show_logic_show_questions,.exclusive-option-tip {
        display: inline-block;
        color: #999;
        margin-left: 20px;
        vertical-align: middle;
        line-height: 30px
    }

    .question-title-tip {
        color: #999;
        margin-left: 36px;
        line-height: 28px;
        height: 20px;
        font-size: 12px
    }

    .choice_show_logic_show_questions_link {
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
        width: 130px;
        display: inline-block;
        vertical-align: bottom;
        color: #999
    }

    .choice_show_logic_show_questions_link:hover {
        color: #999
    }

    .question-choice table {
        width: 700px
    }

    .survey-desc {
        border: 1px solid #dbdbdb;
        margin: 4px 0;
        display: inline-block;
        width: 788px;
        background: #fff;
        padding: 20px
    }

    .error-tips {
        color: #999;
        font-size: 12px
    }

    .error {
        color: #eb3535
    }

    .dialog-button-survey {
        width: 64px!important;
        height: 30px;
        line-height: 26px;
        border-radius: 3px;
        background: #f1f5fd;
        border: 1px solid #b0c0e7;
        color: #2c4a93;
        cursor: pointer
    }

    .dialog-button-survey:hover {
        border: 1px solid #6583cc;
        background: #f1f5fd
    }

    .preview-survey .common-button {
        width: 108px;
        height: 38px;
        cursor: pointer;
        text-align: center;
        font-size: 14px;
        line-height: 35px;
        vertical-align: middle
    }

    .choice-quote-tip {
        padding: 0 0 10px 35px;
        font-size: 12px;
        color: #999
    }

    .edit-survey-navigation-tip {
        width: 100%;
        color: #f4b837;
        border-color: #f4b837;
        border-width: 2px;
        background-color: #f8ebcf;
        padding: 10px 0;
        text-align: center
    }

    #bce-main {
        z-index: inherit
    }

    .edit-survey-quota {
        position: fixed;
        height: 100%;
        width: 800px;
        top: 0;
        right: 0;
        background: #fff;
        font-size: 12px;
        z-index: 1000;
        box-shadow: -4px 0 20px #42484d;
        overflow-y: scroll
    }

    .edit-survey-quota p {
        margin: 2px 0
    }

    .edit-survey-quota-title {
        margin: 12px 18px 16px;
        border-bottom: 1px solid #eee;
        font-size: 18px;
        padding-bottom: 4px
    }

    .edit-survey-quota-new-content {
        overflow: hidden;
        padding-left: 30px
    }

    .edit-survey-quota-close {
        float: right;
        cursor: pointer
    }

    .edit-survey-quota p.edit-survey-quota-content-tip {
        padding-left: 16px;
        margin: 20px 0
    }

    .edit-survey-quota-item {
        margin: 12px 18px 16px
    }

    .edit-survey-quota-item-header {
        background-color: #f5f5f5;
        font-size: 16px;
        color: #999
    }

    .edit-survey-quota table,.edit-survey-quota table tr {
        border: 1px solid #ddd
    }

    .edit-survey-quota table td {
        padding: 8px 20px;
        overflow: hidden;
        max-width: 150px;
        word-wrap: break-word
    }

    .edit-survey-quota-item table {
        border: 1px solid #eee;
        width: 100%;
        line-height: 26px
    }

    .edit-survey-quota-new {
        padding: 12px 18px 16px;
        background-color: #f8f8f8
    }

    .edit-survey-quota-new-title {
        display: inline-block;
        float: left;
        font-size: 16px;
        margin-top: 4px;
        color: #999
    }

    .survey-quota-input-row {
        margin-bottom: 10px
    }

    .survey-quota-input-row select {
        margin: 0
    }

    .survey-quota-new-operator {
        margin: 10px 0
    }

    .edit-survey-quota .survey-quota-btn {
        height: 26px;
        width: 68px;
        line-height: 24px
    }

    .survey-quota-add {
        margin: 16px
    }

    .survey-quota-add hr {
        color: #eee;
        display: inline-block;
        width: 634px;
        top: -4px;
        margin: 0 0 0 5px;
        position: relative
    }

    .survey-quota-btn {
        height: 26px;
        line-height: 26px;
        display: inline-block;
        padding: 0 16px
    }

    #survey-quota-add-btn {
        width: 126px
    }

    .edit-survey-quota-item-choice span {
        margin: 10px 10px 10px 0;
        display: inline-block
    }

    .survey-quota-input-row select {
        margin-left: 10px
    }

    .quota-input-row {
        background-color: #fff
    }

    .quota-input-row input {
        width: 60px;
        margin: 0
    }

    .edit-survey-quota-item-operator {
        width: 20px;
        height: 20px;
        display: inline-block;
        top: 5px;
        position: relative;
        cursor: pointer;
        margin: 0 2px;
        float: right
    }


    .survey-quota-count-tip {
        position: absolute;
        top: -9px;
        left: 64px;
        width: 18px;
        height: 18px;
        background-color: #F1686A;
        display: none;
        text-align: center;
        line-height: 18px;
        color: #fff;
        font-size: 12px;
        border-radius: 9px
    }

    .quota-add-error-tip {
        color: red
    }

    .survey-quota-input-box {
        overflow-x: scroll
    }

    .choice-random-tip {
        color: #999;
        font-size: 12px;
        margin-top: 5px
    }

    .choice-logic-tip {
        font-size: 12px;
        margin-left: 12px;
        line-height: 24px;
        color: #999;
        margin-left: 20px;
        vertical-align: middle
    }

    input[type=radio],input[type=checkbox] {
        cursor: pointer;
        vertical-align: middle
    }
    #question_box{height: calc(100% - 180px); width: 100%;}
    .div-bottom{width: calc(100% - 160px);height: 80px; margin-left: 160px; border-top: 1px solid #dcdcdc;}
    .div-padding{padding: 5px 10px 5px;border-top: 1px solid #dcdcdc; margin: 0px 20px 0px;}
    .max-input-text{width: calc(100% - 25px);padding: 5px;border: 0;}
    .div-radio-img{background: url(${ctx}/static/develop/images/danxuan_btn.png) no-repeat;width: 16px;height: 16px;display: inline-block;position: absolute;top:7px;}
    .div-checkbox-img{background: url(${ctx}/static/develop/images/weigouxuan_icon.png) no-repeat;width: 16px;height: 16px;display: inline-block;position: absolute;top: 7px;}
    .question-choice  .choice .position-relative{width: calc(100% - 25px);margin-left: 20px;}
    .p10{padding:10px;}
    .div-textarea{width: calc(100% - 50px);height: 60px;padding: 5px;}
    .div-header-content{font-size: 12px;font-weight: bold;border-top: 0;}
    .preview-question-title{padding: 0px;border-bottom: 0px;margin-left: 10px;}
    .preview-question-choice{padding: 0 20px;}
    .preview-input-text{margin-left: 10px;width: 240px;padding: 5px;}
    .mrb10{margin-bottom: 10px;}
    .div-preview-content{height: 471px;overflow: auto;}
    .span-order{margin-right: 5px;}
</style>
