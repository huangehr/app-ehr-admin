<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="elasticInfoDialogCss.jsp" %>
<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <form id ="uploadForm" enctype="multipart/form-data">
            <div class="m-form-group">
                <label>myIndex：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="myIndex" value="${indexNm}" class="ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>/>
                </div>
            </div>

            <div class="m-form-group">
                <label>myType：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="myType" value="${indexType}" class="ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>/>
                </div>
            </div>

            <div class="m-form-group">
                <label>Id：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="inp_id" class="ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/>/>
                </div>
            </div>

            <div class="m-form-group">
                <label>quotaCode：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="quotaCode" class="ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="quotaCode"/>
                </div>
            </div>
            <div class="m-form-group ">
                <label>quotaName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="quotaName" class="useTitle ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="quotaName"/>
                </div>
            </div>

            <div class="m-form-group ">
                <label>result：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="result" class="useTitle ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="result"/>
                </div>
            </div>

            <div class="m-form-group">
                <label>town：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="town" class="useTitle ajax"  data-attr-scan="town">
                </div>
            </div>

            <div class="m-form-group">
                <label>townName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="townName" class="useTitle ajax"  data-attr-scan="townName">
                </div>
            </div>

            <div class="m-form-group">
                <label>org：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="org" class="useTitle ajax"  data-attr-scan="org">
                </div>
            </div>

            <div class="m-form-group">
                <label>orgName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="orgName" class="useTitle ajax"  data-attr-scan="orgName">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey1：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey1" class="useTitle ajax"  data-attr-scan="slaveKey1">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey1Name：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey1Name" class="useTitle ajax"  data-attr-scan="slaveKey1Name">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey2：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey2" class="useTitle ajax"  data-attr-scan="slaveKey2">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey2Name：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey2Name" class="useTitle ajax"  data-attr-scan="slaveKey2Name">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey3：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey3" class="useTitle ajax"  data-attr-scan="slaveKey3">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey3Name：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey3Name" class="useTitle ajax"  data-attr-scan="slaveKey3Name">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey4：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey4" class="useTitle ajax"  data-attr-scan="slaveKey4">
                </div>
            </div>

            <div class="m-form-group">
                <label>slaveKey4Name：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="slaveKey4Name" class="useTitle ajax"  data-attr-scan="slaveKey4Name">
                </div>
            </div>

            <div class="m-form-group">
                <label>economic：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="economic" class="useTitle ajax"  data-attr-scan="economic">
                </div>
            </div>

            <div class="m-form-group">
                <label>economicName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="economicName" class="useTitle ajax"  data-attr-scan="economicName">
                </div>
            </div>

            <div class="m-form-group">
                <label>level：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="level" class="useTitle ajax"  data-attr-scan="level">
                </div>
            </div>

            <div class="m-form-group">
                <label>levelName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="levelName" class="useTitle ajax"  data-attr-scan="levelName">
                </div>
            </div>

            <div class="m-form-group">
                <label>orgHealthCategoryPid：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="orgHealthCategoryPid" class="useTitle ajax"  data-attr-scan="orgHealthCategoryPid">
                </div>
            </div>

            <div class="m-form-group">
                <label>orgHealthCategoryId：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="orgHealthCategoryId" class="useTitle ajax"  data-attr-scan="orgHealthCategoryId">
                </div>
            </div>

            <div class="m-form-group">
                <label>orgHealthCategoryName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="orgHealthCategoryName" class="useTitle ajax"  data-attr-scan="orgHealthCategoryName">
                </div>
            </div>

            <div class="m-form-group">
                <label>orgHealthCategoryCode：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="orgHealthCategoryCode" class="useTitle ajax"  data-attr-scan="orgHealthCategoryCode">
                </div>
            </div>

            <div class="m-form-group">
                <label>quotaDate：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="quotaDate" class="useTitle ajax"  data-attr-scan="quotaDate">
                </div>
            </div>

            <div class="m-form-group">
                <label>year：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="year" class="useTitle ajax"  data-attr-scan="year">
                </div>
            </div>

            <div class="m-form-group">
                <label>yearName：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="yearName" class="useTitle ajax"  data-attr-scan="yearName">
                </div>
            </div>

            <div class="m-form-group">
                <label>areaLevel：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="areaLevel" class="useTitle ajax"  data-attr-scan="areaLevel">
                </div>
            </div>

            <div class="m-form-group">
                <label>createTime：</label>

                <div class="l-text-wrapper m-form-control">
                    <input type="text" id="createTime" class="useTitle ajax"  data-attr-scan="createTime">
                </div>
            </div>

        </form>
    </div>

    <div class="m-form-control pane-attribute-toolbar" style="text-align: right;">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
</div>

<input type="hidden" id="execTime">


<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="elasticInfoDialogJs.jsp" %>

