<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<style>
    .i-text{
        width: 185px;
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
</style>

<!--######机构管理页面 > 机构信息对话框模板页######-->
<div id="div_organization_info_form" data-role-form="" class="m-form-inline f-mt20" data-role-form
     style="overflow:auto">
    <div class="m-form-group">
        <label><spring:message code="lbl.org.code"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="org_code"
                   class="required useTitle ajax validate-space validate-org-code f-w240 max-length-20" required-title=
                   <spring:message code="lbl.must.input"/> data-attr-scan="orgCode"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.org.fullName"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="full_name" class="required useTitle f-w240 max-length-100 validate-special-char"
                   required-title=
                   <spring:message code="lbl.must.input"/> data-attr-scan="fullName"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.org.shortName"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="short_name" class="required useTitle f-w240 max-length-100 validate-special-char"
                   required-title=
                   <spring:message code="lbl.must.input"/> data-attr-scan="shortName"/>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.local"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="location" class="required useTitle f-w240 validate-special-char validate-org-length"
                   data-type="comboSelect" required-title=<spring:message code="lbl.must.input"/> validate-org-length-title="地址至少选择到市一级" data-attr-scan="location" maxlength="200"/>
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
            <input type="text" id="settled_way" class="required" data-type="select" data-attr-scan="settledWay">
        </div>
    </div>

    <div class="m-form-group">
        <label>联系人<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="admin" class="useTitle f-w240 max-length-50 validate-special-char"
                   data-attr-scan="admin"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>联系方式<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="tel" class="required useTitle  validate-mobile-and-phone f-w240" required-title=
            <spring:message code="lbl.must.input"/> validate-mobile-and-phone-title="请输入正确的手机号码或固话"
                   data-attr-scan="tel"/>
        </div>
    </div>
    <div class="m-form-group">
        <label><spring:message code="lbl.org.type"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="org_type" class=" f-w240 required" data-type="select" data-attr-scan="orgType"/>
        </div>
        <spring:message code="spe.colon"/>
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
                <%--<input type="hidden" id="logoUrl"  data-attr-scan="logoUrl" >--%>
                <%--<input type="file"  name="logoFileUrl" class="file" >--%>
                <%--<input type="button" value="上传" id="logoUrlButton" class="uploadBtn"  />--%>
                <input type="text" class="i-text" id="logoUrl" data-attr-scan="logoUrl" readonly="readonly" />
                <div class="uploadBtn">上传
                    <input type="file" id="logoUrlButton" name="logoFileUrl" class="file" value="" />
                </div>
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
        <div class="m-form-control ">
            <textarea id="dialog_tags" class="f-w240 max-length-100 validate-special-char" placeholder="多个标签，请用分号隔开"
                      data-attr-scan="tags" maxlength="500"></textarea>
        </div>
    </div>


    <div>
        <div class="f-pr u-bd" style="height: 380px;">
            <div class="f-pa f-w20 f-wtl">
                高级
            </div>
            <div class="div-aptitude-manager" style="width:550px;height:320px;margin-top:20px;">
                &nbsp;资质管理:
                <div id="uploader" style="width:550px;overflow-y: auto;overflow-x: hidden;height: 260px;">
                    <input id="mime" type="hidden" value="org"/>
                    <input id="objectId" type="hidden" value="10254555-1"/>
                    <input id="purpose" type="hidden" value="org"/>
                    <div class="queueList" style="width:530px;">
                        <div id="dndArea" class="placeholder">
                            <div id="filePicker"></div>
                            <p>或将照片拖到这里，单次最多可选300张</p>
                        </div>
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
        </div>
    </div>


    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_update_btn">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="btn_cancel">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>
</div>