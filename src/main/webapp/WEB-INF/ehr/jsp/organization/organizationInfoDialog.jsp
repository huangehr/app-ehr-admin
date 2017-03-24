<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######机构管理页面 > 机构信息对话框模板页######-->
<div id="div_organization_info_form" class="m-form-inline" data-role-form="" style="overflow:auto">
    <input data-attr-scan="id" hidden="hidden"/>

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
        <label>交通路线</label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="traffic" class="useTitle f-w240 max-length-20 validate-special-char"
                   data-attr-scan="traffic"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>经度</label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="ing" class="useTitle f-w240 max-length-20 validate-special-char"
                   data-attr-scan="ing"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>纬度</label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="lat" class="useTitle f-w240 max-length-100 validate-special-char"
                   data-attr-scan="lat"/>
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

    <!-- 医院关系信息    -->

    <div class="m-form-group">
        <label>医院类型<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="hosType" data-type="select"  class="f-w240 "  data-attr-scan="hosTypeId"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>医院归属<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="ascriptionType" data-type="select"  class="f-w240"   data-attr-scan="ascriptionType"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>医院联系电话<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="phone" class="useTitle f-w240 max-length-20 "  data-attr-scan="phone"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>医院简介<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <textarea type="text" id="introduction" class="f-w240 description  max-length-256 validate-special-char"    data-attr-scan="introduction" ></textarea>
        </div>
    </div>
    <div class="m-form-group">
        <label>医院等级<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="levelId" data-type="select"  class="useTitle  f-w240"  data-attr-scan="levelId"/>
        </div>
    </div>

    <div class="m-form-group">
        <label>医院法人<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="legalPerson" class=" useTitle  f-w240"    data-attr-scan="legalPerson"/>
        </div>
    </div>

    <form  id ="uploadForm" enctype="multipart/form-data">
        <div class="m-form-group">
            <label>医院LOGO</label>
            <div class="l-text-wrapper m-form-control ">
                <input type="hidden"   data-attr-scan="logoUrl" >
                <%--<img src="${contextRoot}/authentication/showImage?imgPath" id="logoImage" />--%>
                <div id="logoImage"></div>
                <input type="file" id="logoUrl" name="logoFileUrl" class="file" >
                <input type="button" value="上传" id="logoUrlButton" class="uploadBtn"  />
            </div>
        </div>
    </form>

    <div class="m-form-group">
        <label>上级医院ID<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="parentHosId" class="useTitle  f-w240"    data-attr-scan="parentHosId"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>中西医标识<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="zxy" class=" useTitle  f-w240"    data-attr-scan="zxy"/>
        </div>
    </div>
    <!--     -->

    <div class="m-form-group">
        <label><spring:message code="lbl.tip"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <textarea id="tags" class="f-w240 max-length-100 validate-special-char" placeholder="多个标签，请用分号隔开" data-attr-scan="tags"/>
        </div>
    </div>
    <div>
        <div class="f-pr u-bd" >
            <div class="f-pa f-w20 f-wtl" >
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

            <div class="m-form-group f-h100" hidden="hidden" id="div_publicKeyMessage" style="margin: 0 0 10px 10px;" >
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

