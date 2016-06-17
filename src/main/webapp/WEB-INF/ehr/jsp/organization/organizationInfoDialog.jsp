<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######机构管理页面 > 机构信息对话框模板页######-->
<div id="div_organization_info_form" class="m-form-inline" data-role-form="" style="overflow:auto">
    <div class="m-form-group f-mt20 m-form-readonly">
        <label><spring:message code="lbl.org.code"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="org_code" class=" f-w240"  data-attr-scan="orgCode"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.org.fullName"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="full_name" class="required useTitle f-w240 max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="fullName"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.org.shortName"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="short_name" class="required useTitle f-w240 max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="shortName"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.local"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="location"  class="required useTitle f-w240 max-length-500 validate-special-char validate-org-length" validate-org-length-title="地址至少选择到市一级" data-type="comboSelect"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="location"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.join.mode"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="settled_way"  class="required" data-type="select"  data-attr-scan="settledWay">
        </div>
    </div>
    <div class="m-form-group">
        <label>联系人<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="admin" class="useTitle f-w240 max-length-50 validate-special-char"  data-attr-scan="admin"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>联系方式<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="tel" class="required useTitle validate-mobile-and-phone f-w240"  required-title=<spring:message code="lbl.must.input"/> validate-mobile-and-phone-title="请输入正确的手机号码或固话"  data-attr-scan="tel"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.org.type"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="org_type" class="required f-w240" data-type="select" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgType"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.tip"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="tags" class="f-w240 max-length-100 validate-special-char" placeholder="多个标签，请用分号隔开" data-attr-scan="tags"/>
        </div>
    </div>
    <div>
        <div class="f-pr u-bd">
            <div class="f-pa f-w20 f-wtl">
                高级
            </div>
            <div class="div-aptitude-manager" style="width:550px;height:320px;margin-top:20px;">
                &nbsp;资质管理:
                <div id="uploader" style="width:550px;overflow-y: auto;overflow-x: hidden;height: 260px;">
                    <input id="mime" type="hidden" value="org"/>
                    <input id="objectId" type="hidden" value=""/>
                    <input id="purpose" type="hidden" value="org"/>
                    <div class="queueList" style="width:535px;">
                        <div id="dndArea" class="placeholder">
                            <div id="filePicker"></div>
                            <p>或将照片拖到这里，单次最多可选300张</p>
                        </div>
                        <ul id="filelist" class="filelist"></ul>
                    </div>

                    <div class="statusBar" style="display:none;">
                        <div class="progress">
                            <span class="text">0%</span>
                            <span class="percentage"></span>
                        </div><div class="info" style=""></div>
                        <div class="btns">
                            <div id="filePicker2"></div><div class="uploadBtn">开始上传</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="m-form-group f-h100" hidden="hidden" id="div_publicKeyMessage">
                <label class="lbl-public-key">公钥信息:</label>
                <div class="l-text-wrapper m-form-control f-ml130">
                    <textarea type="text" class="required useTitle u-public-key-msg f-w400" data-attr-scan="publicKey"
                              readonly="readonly"></textarea>
                </div>
            </div>
            <div class="m-form-group f-h50" hidden="hidden" id="div_publicKey_validTime">
                <label class="f-mt-20">有效时间：</label>
                <div class="l-text-wrapper m-form-control f-mt-20">
                    <input type="text" class="required useTitle u-f-mt5"
                           data-attr-scan="validTime"/>
                </div>
            </div>
            <div class="m-form-group" hidden="hidden" id="div_publicKey_startTime">
                <label>生成时间：</label>
                <div class="l-text-wrapper m-form-control">
                    <input type="text" class="required useTitle u-f-mt5"
                           data-attr-scan="startTime"/>
                </div>
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-ml100 u-btn-pk-color f-mt10 f-mb10" id="div_publicKey">
                <span>公钥管理</span>
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
	<div class="m-form-control pane-attribute-toolbar" id="div_footer">
		<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_update_btn">
			<span><spring:message code="btn.save"/></span>
		</div>
		<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="btn_cancel">
			<span><spring:message code="btn.close"/></span>
		</div>
	</div>

</div>

