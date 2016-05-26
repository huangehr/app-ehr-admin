<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/resource/meta/update"
        }
        var model = ${model};
        var mode = '${mode}';
        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_std_code'},
                {type: 'select', id: 'ipt_domain', dictId: 41},
                {type: 'text', id: 'ipt_meta_code', opts: {readonly: mode=='modify'}},
                {type: 'text', id: 'ipt_meta_name'},
                {type: 'select', id: 'ipt_column_type', dictId: 40},
                {type: 'text', id: 'ipt_dict_code'},
                {type: 'radio', id: 'gender'},
                {type: 'text', id: 'ipt_description', opts:{height:100}}
            ];

            initFormFields(vo);
        };

        var initBtn = function () {
            var $form =  $("#infoForm");
            var validator = initValidate($form, function (elm) {
                debugger
            });

            $('#btn_save').click(function () {
                saveForm({url: urls.update, $form: $form, modelName: 'metadata', validator: validator});
            });

            $('#btn_cancel').click(function () {
                parent.closeDialog();
            });
        };

        var init = function () {
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
        }();
    })(jQuery, window);
</script>