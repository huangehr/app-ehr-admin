<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/resource/meta/update",
            existence: "${contextRoot}/resource/meta/existence",
            dictCombo: "${contextRoot}/resource/dict/searchCombo"
        }
        var model = ${model};
        var mode = '${mode}';
        var dictCombo;
        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_std_code'},
                {type: 'select', id: 'ipt_domain', dictId: 31},
                {type: 'text', id: 'ipt_meta_code', opts: {readonly: mode=='modify'}},
                {type: 'text', id: 'ipt_meta_name'},
                {type: 'select', id: 'ipt_column_type', dictId: 30},
                {type: 'radio', id: 'gender'},
                {type: 'text', id: 'ipt_description', opts:{height:100}}
            ];

            initFormFields(vo);
            dictCombo = $('#ipt_dict_id').customCombo(
                    urls.dictCombo, {}, undefined, undefined, false, {selectBoxHeight: 280});
        };

        var initBtn = function () {
            var $form =  $("#infoForm");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='ipt_meta_code' && val!=model.id){
                    return uniqValid(urls.existence, "id="+val+" g1", "该资源标准编码已存在（包含已失效数据）！");
                }
                else if(field=='ipt_std_code' && val!=model.stdCode){
                    return uniqValid(urls.existence, "stdCode="+val+" g1;valid=1", "该内部标识符已存在！");
                }
            });

            $('#btn_save').click(function () {
                var dictVal = dictCombo.getLigerComboBox().grid.getSelectedRow();
                if(dictVal)
                    $('#dictCode').val(dictVal.code);

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

            dictCombo.setValueText(model.dictCode, model.dictName);
        }();
    })(jQuery, window);
</script>