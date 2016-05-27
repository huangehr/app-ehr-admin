<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/resource/dict/entry/update",
            existence: "${contextRoot}/resource/dict/entry/existence"
        }

        var model = ${model};
        model.dictCode = parent.getSelectDictId();
        var mode = '${mode}';

        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_code', opts: {readonly: mode=='modify'}},
                {type: 'text', id: 'ipt_name'},
                {type: 'text', id: 'ipt_description', opts: {height: 100}}
            ];

            initFormFields(vo);
        };

        var initBtn = function () {
            var $form = $("#infoForm");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='ipt_code' && val!=model.code){
                    return uniqValid(urls.existence, "code="+val+";dictCode="+ model.dictCode, "值域编码已存在！");
                }
            });

            $('#btn_save').click(function () {
                saveForm({url: urls.update, $form: $form, validator: validator});
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