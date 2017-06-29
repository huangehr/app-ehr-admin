<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .btm-btns{position: absolute;bottom: 0;right: 0;}
    .tab-con{position: absolute;left: 0;right: 0;top: 50px;bottom: 0;}
    /*div.tab-con-info{padding-bottom: 60px}*/
    .l-dialog-body{position: relative;overflow: hidden}
    .card-l-item{padding: 0 10px;margin-bottom: 10px}
    .card-l-item div{height:30px;line-height:30px;position:relative;padding: 0 10px;border-width: 1px 1px 0 1px;border-style: solid;border-color: #ccc;background: #f1f1f1;}
    .card-l-item div span {display: block}
    .card-l-item div a {position: absolute;right: 0;top: 0}
    .card-l-item ul{width: 100%;}
    .card-l-item ul li{display: inline-block;width: 49%;height:30px;line-height:30px;padding: 0 10px;}
    .first-ul{border-width: 1px 1px 0 1px;border-style: solid;border-color: #ccc}
    .last-ul{border-width: 0 1px 1px 1px;border-style: solid;border-color: #ccc}
    .grid_delete{height: 30px;}
    .data-null{margin-top: 90px;position: relative}
    .null-page{width: 260px;height: 163px;background: url("${contextRoot}/develop/images/shujukong_bg.png") no-repeat center;margin: 0 auto;}
    .data-null span {width:100%;display:block;text-align: center;padding: 15px;font-size: 16px;color: #999;}
</style>
<div class="pop_tab">
    <ul class="tab-list">
        <li class="cur" id="btn_basic">基础属性</li>
        <li id="card_info">就诊卡信息</li>
        <li id="user_jur" style="display: none;">角色授权</li>
        <%--<li id="btn_card" >卡管理</li>--%>
        <%--<li id="btn_archive" >档案管理</li>--%>
        <%--<li id="btn_home_relation" >家庭关系</li>--%>

    </ul>
</div>
<!--######人口基本管理 > 人口基本信息对话框模板页######-->
<div id="div_patient_info_form" data-role-form class="tab-con m-form-inline m-form-readonly f-mt20 f-pr">
    <div id="div_patient_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
        <!--用来存放item-->
        <div id="div_file_list" class="uploader-list" data-attr-scan></div>
    </div>
    <div class="m-form-group">
        <label>姓名：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_realName" class="required useTitle" data-attr-scan="name"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>身份证号：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_idCardNo" class="required useTitle " data-attr-scan="idCardNo"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>性别：</label>

        <div class="u-checkbox-wrap m-form-control">
            <input type="radio" value="1" name="gender" data-attr-scan>男
            <input type="radio" value="2" name="gender" data-attr-scan>女
        </div>
    </div>
    <div class="m-form-group ">
        <label>民族：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_patientNation" data-type="select"  class="required useTitle" data-attr-scan="nation"/>
        </div>
    </div>
    <div class="m-form-group ">
        <label>籍贯：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_patientNativePlace" class="required useTitle" data-attr-scan="nativePlace"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>婚姻状况：</label>

        <div class="m-form-control">
            <input type="text" id="inp_select_patientMartialStatus" data-type="select" data-attr-scan="martialStatus">
        </div>
    </div>
    <div class="m-form-group">
        <label>出生日期：</label>

        <div class="m-form-control">
            <input type="text" id="inp_patientBirthday" class="validate-date l-text-field validate-date"  placeholder="输入日期 格式(2016-04-15)"
                   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="birthday"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>户籍地址：</label>

        <div class="l-text-wrapper m-form-control" id="div_birthPlaceTitle" title="">
            <input type="text" id="inp_birthPlace" class="required useTitle f-toe" data-attr-scan="birthPlaceFull"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>家庭地址：</label>

        <div class="l-text-wrapper m-form-control" id="div_homeAddressTitle" title="">
            <input type="text" id="inp_homeAddress" class="required useTitle f-toe" data-attr-scan="homeAddressFull"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>工作地址：</label>

        <div class="l-text-wrapper m-form-control" id="div_workAddressTitle" title="">
            <input type="text" id="inp_workAddress" class="required useTitle f-toe" data-attr-scan="workAddressFull"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>户籍性质：</label>

        <div class="u-checkbox-wrap m-form-control">
            <input type="radio" value="temp" name="residenceType" data-attr-scan>农村
            <input type="radio" value="usual" name="residenceType" data-attr-scan>非农村
        </div>
    </div>
    <div class="m-form-group">
        <label>联系方式：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_patientTel" class="required useTitle" data-attr-scan="telephoneNo"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>邮箱：</label>

        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_patientEmail" class="required useTitle" data-attr-scan="email"/>
        </div>
    </div>
    <%--<div id="div_patient_img_upload" class="u-upload alone f-ib f-tac f-vam" data-alone-file=true>--%>
        <%--<div id="div_file_list" class="uploader-list"></div>--%>
    <%--</div>--%>
</div>



<%--new add--%>
<%--就诊卡信息--%>
<div class="tab-con m-form-inline" style="display: none">
    <div class="tab-con-info">
        <ul id="doctorCardList">
            <%--就诊卡列表--%>
        </ul>
    </div>
</div>

<%--new add--%>
<%--角色授权--%>
<div class="tab-con m-form-inline" style="display: none;width: 600px;height: 420px;margin-left: 10px;">
    <div class="tab-con-info div-appRole-grid-scrollbar" style="width: 260px;height: 470px;border:1px solid #dcdcdc;display: inline-block;">
        <%--树--%>
        <div id="div_resource_browse_tree"></div>
    </div>
    <div style="width: 20px;display: inline-block;">
        <div style="background: url(${staticRoot}/images/zhixiang_icon.png) no-repeat;width: 20px;height: 40px;padding-top: 220px;margin-left: 2px;"></div>
    </div>
    <div class="div-appRole-grid-scrollbar" id="div_checked_data" style="width: 260px;height: 470px;border:1px solid #dcdcdc;display: inline-block;background: #fff;">
        <div class="h-40 div-header-content">
            <div class="div-header">角色</div>
            <%--<div class="div-opera-header">操作</div>--%>
        </div>
        <%--<div class="h-40 div-item">--%>
        <%--<div class="div-main-content" title="信息共享交换平台">信息共享交换平台</div>--%>
        <%--<div class="div-delete-content"><a class="grid_delete" href="#" title="删除"></a></div>--%>
        <%--</div>--%>
    </div>
</div>


<!--######卡管理 > 卡信息对话框模板页######-->
<div id="div_card_info" data-role-form class="m-form-inline">
    <div class="f-pr u-bd f-mt20">
        <div class="f-pa f-w70 f-wtl">
            已关联卡
        </div>
        <div class="f-mt30">
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_cardType" placeholder="类型" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_card_search" placeholder="卡号"/>
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam  f-ml50" id="div_search">
                <span>搜索</span>
            </div>

            <div id="div_card_info_form" data-role-form class="f-mt10">

                <!--卡基本信息 -->
                <div id="div_card_basicMsg" class="u-card-basicMsg m-form-inline m-form-readonly">
                    <div class="m-form-group">
                        <label>类型：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardType" class="required useTitle" data-attr-scan="cardType"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>卡号：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardNo" class="required useTitle" data-attr-scan="number"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>持有人姓名：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_HolderName" class="required useTitle"
                                   data-attr-scan="ownerName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>发行地：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_issueAddress" class="required useTitle" data-attr-scan="local"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>发行机构：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_issueOrg" class="required useTitle" data-attr-scan="releaseOrgName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>关联时间：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_addDate" class="required useTitle" data-attr-scan="createDate"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>状态：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardStatus" class="required useTitle"
                                   data-attr-scan="statusName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>说明：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardExplain" class="required useTitle"
                                   data-attr-scan="description"/>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!--######档案管理 > 档案信息对话框模板页######-->
<div id="div_archive_info" data-role-form class="m-form-inline" >
    <div class="f-pr u-bd f-mt20">
        <div class="f-pa f-w88 f-wtl">
            已关联档案
        </div>
        <div class="f-mt20">
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_start" placeholder="时间" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_end" placeholder="时间" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl f-mt10 f-w240">
                <input type="text" id="inp_select_archiveOrg" placeholder="就诊机构" data-type="select" data-attr-scan="">
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam  f-ml166 f-mt10" id="div_search_archive">
                <span>搜索</span>
            </div>

            <div id="div_archive_info_form" data-role-form class="f-mt10">

            </div>
        </div>
    </div>
</div>
<div id="div_home_relation" data-role-form class="m-form-inline">

</div>