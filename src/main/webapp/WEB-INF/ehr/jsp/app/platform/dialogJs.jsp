<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/app/platform/modify",
            existence: "${contextRoot}/app/platform/existence",
            orgCombo: "${contextRoot}/organization/orgCodes"
        }
        var model = ${model};
        var mode = '${mode}';
        var orgCombo;
        var initForm = function () {
            var vo = [
                {type: 'text', id: 'inp_app_name'},
                {type: 'text', id: 'inp_app_id'},
                {type: 'text', id: 'inp_app_code'},
                {type: 'text', id: 'inp_app_secret', opts:{readonly: true}},
                {type: 'select', id: 'inp_dialog_catalog', dictId: 1},
                {type: 'text', id: 'inp_url', opts:{height:60}},
                {type: 'text', id: 'inp_description', opts:{height:100}}
            ];

            initFormFields(vo);
            orgCombo = $('#inp_org_code').customCombo(
                    urls.orgCombo, {filters: "activityFlag=1;"}, undefined, undefined, false, {selectBoxHeight: 280, valueField: 'id'});
        };

        var initBtn = function () {
            var $form =  $("#infoForm");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='inp_app_code' && val!=model.code){
                    return uniqValid(urls.existence, "code="+val+" g1;sourceType=1", "该平台应用代码已存在！");
                }
            });

            $('#btn_save').click(function () {
                $form.attrScan();
                var model = $form.Fields.getValues();
                saveForm({url: urls.update, $form: $form, parms: model, validator: validator});
            });

            $('#btn_cancel').click(function () {
                closeDialog();
            });
        };

        var init = function () {
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));

            orgCombo.setValueText(model.org, model.orgName);
            if(mode=='view'){
                $('#infoForm').addClass('m-form-readonly');
                $('#btn_save').hide();
            }
        }();
    })(jQuery, window);
</script>