<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<link rel="stylesheet" href="${contextRoot}/develop/common/flod.css">
<style>
    .i-text{
        width: 87px;
        height: 30px;
        line-height: 30px;
        padding-right: 17px;
        color: #555555;
        padding-left: 5px;
        vertical-align: middle;
        border: 1px solid #ccc;
    }
    .uploadBtn{
        position: relative;
        vertical-align: middle;
        overflow: hidden;
    }
    .uploadBtn .file{
        width: 50px;
        height: 30px;
        position: absolute;
        top: 0;
        left: 0;
        opacity: 0;
        z-index: 999;
    }
    .l-dialog-tc-inner{
        height: inherit;
        line-height: inherit;
    }
    .l-dialog-winbtns{
        top: 8px
    }
</style>
<div class="content-main">
    <!--######机构管理页面 > 机构信息对话框模板页######-->
    <div id="div_organization_info_form" class="m-form-inline" data-role-form="">
        <input data-attr-scan="id" hidden="hidden"/>
        <h3 class="list-title">基本信息</h3>
        <ul class="list-item f-mt10">
            <li>
                <div class="m-form-group m-form-readonly">
                    <label><spring:message code="lbl.org.code"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="org_code" data-attr-scan="orgCode"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.org.fullName"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="full_name" class="required useTitle max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="fullName"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>医院类型<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="hosType" data-type="select"   data-attr-scan="hosTypeId"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>医院归属<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="ascriptionType" data-type="select"   data-attr-scan="ascriptionType"/>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="list-item">
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.org.shortName"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="short_name" class="required useTitle max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="shortName"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.org.type"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="org_type" data-type="select" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgType"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>医院等级<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="levelId" data-type="select"  class="useTitle"  data-attr-scan="levelId"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>医院法人<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="legalPerson" class=" useTitle"    data-attr-scan="legalPerson"/>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="list-item">
            <li>
                <div class="m-form-group">
                    <label>联系人<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="admin" class="useTitle max-length-50 validate-special-char"  data-attr-scan="admin"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>联系方式<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="tel" class="required useTitle validate-mobile-and-phone"  required-title=<spring:message code="lbl.must.input"/> validate-mobile-and-phone-title="请输入正确的手机号码或固话"  data-attr-scan="tel"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>上级医院ID<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="parentHosId"  data-type="select"  class="useTitle ajax"
                               placeholder="请选择上级医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>中西医标识<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="zxy" data-type="select"  class="useTitle"    data-attr-scan="zxy"/>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="list-item">
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.local"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="location"  class="required useTitle  max-length-500 validate-special-char validate-org-length" validate-org-length-title="地址至少选择到市一级" data-type="comboSelect"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="location"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>交通路线</label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="traffic" class="useTitle max-length-20 validate-special-char"
                               data-attr-scan="traffic"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.join.mode"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control essential">
                        <input type="text" id="settled_way" data-type="select"  data-attr-scan="settledWay">
                    </div>
                </div>
            </li>
            <li>
                <form  id ="uploadForm" enctype="multipart/form-data">
                    <div class="m-form-group">
                        <label>医院LOGO</label>
                        <div class="l-text-wrapper m-form-control ">
                            <div id="logoImage"></div>
                            <input type="text" class="i-text" id="logoUrl" data-attr-scan="logoUrl" readonly="readonly" />
                            <div class="uploadBtn">上传
                                <input type="file" id="logoUrlButton" name="logoFileUrl" class="file" value="" />
                            </div>
                        </div>
                    </div>
                </form>
            </li>
        </ul>
        <ul class="list-item f-fl f-w507">
            <li>
                <div class="m-form-group">
                    <label>纬度</label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="lat" class="useTitle max-length-100 validate-special-char"
                               data-attr-scan="lat"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label>经度</label>
                    <div class="l-text-wrapper m-form-control ">
                        <input type="text" id="ing" class="useTitle max-length-20 validate-special-char"
                               data-attr-scan="ing"/>
                    </div>
                </div>
            </li>
            <li>
                <div class="m-form-group">
                    <label><spring:message code="lbl.tip"/><spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control">
                        <textarea id="tags" class="max-length-100 validate-special-char one-text-b" placeholder="多个标签，请用分号隔开" data-attr-scan="tags"/>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="list-item f-fl f-w507">
            <li>
                <div class="m-form-group">
                    <label>医院简介<spring:message code="spe.colon"/></label>
                    <div class="l-text-wrapper m-form-control ">
                        <textarea type="text" id="introduction" class="description  max-length-256 validate-special-char"    data-attr-scan="introduction" ></textarea>
                    </div>
                </div>
            </li>
        </ul>
        <ul class="clear"></ul>
        <div>
            <div>
                <h3 class="list-title">资质信息</h3>
                <div class="list-con">
                    <ul class="list-item">
                        <li class="li-width f-pr">
                            <div id="uploader" style="margin-right: 10px;">
                                <input id="mime" type="hidden" value="org"/>
                                <input id="objectId" type="hidden" value=""/>
                                <input id="purpose" type="hidden" value="org"/>
                                <div class="queueList">
                                    <div id="dndArea" class="placeholder">
                                        <div id="filePicker"></div>
                                        <p>或将照片拖到这里，单次最多可选300张</p>
                                    </div>
                                    <ul id="filelist" class="filelist"></ul>
                                </div>
                                <div class="statusBar f-pa" style="display:none;">
                                    <div class="progress">
                                        <span class="text">0%</span>
                                        <span class="percentage"></span>
                                    </div><div class="info" style=""></div>
                                    <div class="btns">
                                        <div id="filePicker2"></div><div class="uploadBtn">开始上传</div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div>
            <h3 class="list-title">公钥管理</h3>
            <div class="list-con">
                <ul class="list-item">
                    <li>
                        <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-ml100 u-btn-pk-color f-mt10 f-mb10" id="div_publicKey">
                            <span>公钥管理</span>
                        </div>
                    </li>
                </ul>
                <ul class="list-item">
                    <li>
                        <div class="m-form-group" hidden="hidden" id="div_publicKey_validTime">
                            <label>有效时间<spring:message code="spe.colon"/></label>
                            <div class="l-text-wrapper m-form-control">
                                <input type="text" class="required useTitle o-input" data-attr-scan="validTime"/>
                            </div>
                        </div>
                    </li>
                    <li>
                        <div class="m-form-group" hidden="hidden" id="div_publicKey_startTime">
                            <label>生成时间<spring:message code="spe.colon"/></label>
                            <div class="l-text-wrapper m-form-control">
                                <input type="text" class="required useTitle o-input" data-attr-scan="startTime"/>
                            </div>
                        </div>
                    </li>
                </ul>
                <ul class="list-item">
                    <li>
                        <div class="m-form-group" hidden="hidden" id="div_publicKeyMessage">
                            <label class="lbl-public-key">公钥信息<spring:message code="spe.colon"/></label>
                            <div class="l-text-wrapper m-form-control">
                                <textarea type="text" class="required useTitle u-public-key-msg o-textarea" data-attr-scan="publicKey" readonly="readonly"></textarea>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>

        <div id="div_public_manage" class="u-public-manage">
            <div class="l-button u-btn u-btn-small u-btn-cancel f-ib f-vam u-btn-color f-mb10" id="div_allot_publicKey">
                <span>分配公钥</span>
            </div>
            <textarea class="txt-public-content" id="txt_publicKey_message" data-attr-scan="publicKey"></textarea><br>
            <label class="f-fl">有效时间:</label><label id="lbl_publicKey_validTime" class="f-fl"></label><br>
            <label class="f-ml-t">生成时间:</label><label id="lbl_publicKey_startTime" class="f-mb"></label><br>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-t30" id="div_affirm_btn">
                <span>关闭</span>
            </div>
        </div>

    </div>
</div>
<div class="m-form-control pane-attribute-toolbar" id="div_footer">
    <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mr10" id="div_update_btn">
        <span><spring:message code="btn.save"/></span>
    </div>
    <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="btn_cancel">
        <span><spring:message code="btn.close"/></span>
    </div>
</div>
