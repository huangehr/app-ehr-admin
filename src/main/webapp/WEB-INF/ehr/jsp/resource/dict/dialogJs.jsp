<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>

<script type="text/javascript">

    (function ($, win) {

        var urls = {
            update: "${contextRoot}/resource/dict/update",
            existence: "${contextRoot}/resource/dict/existence"
        }
        var model = ${model};
        var mode = '${mode}';
        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_code', opts: {readonly: mode=='modify'}},
                {type: 'text', id: 'ipt_name'},
                {type: 'text', id: 'ipt_description', opts:{height:100}}
            ];

            initFormFields(vo);
        };

        function saveDForm(opts){
            var $form = opts.$form;
            var validator = opts.validator;

            if(!validator){
                validator = initValidate($form);
            }
            if(!validator.validate())
                return;

            var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
            var parms = opts.parms;
            if(!parms){
                $form.attrScan();
                var model = $form.Fields.getValues();
                var id = model.id || '';
                if(opts.notIncluded){
                    var tmp = opts.notIncluded.split(',');
                    for(var i=0; i< tmp.length; i++){
                        model[tmp[i]] = undefined;
                    }
                }
                parms = {model: JSON.stringify(model), modelName: opts.modelName ? opts.modelName : '', id: id  }
            }
            var dataModel = $.DataModel.init();
            dataModel.createRemote(opts.url, {
                data: parms,
                success: function (data) {
                    waittingDialog.close();
                    if (data.successFlg) {
                        if(opts.onSuccess)
                            opts.onSuccess(data);
                        else
                            closeDialog("保存成功!", data);
                    } else {
                        if (data.errorMsg)
                            _LIGERDIALOG.error(data.errorMsg);
                        else
                            _LIGERDIALOG.error('出错了！');
                    }
                },
                error: function () {
                    waittingDialog.close();
                }
            });
        }
        var initBtn = function () {
            var $form = $("#infoForm");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='ipt_code' && val!=model.code){
                    return uniqValid(urls.existence, "code="+val+";", "字典编码已存在！");
                }
            });

            $('#btn_save').click(function () {
                saveDForm({url: urls.update, $form: $form, validator: validator});
            });

            $('#btn_cancel').click(function () {
                closeDialog();
            });
        };

        var init = function () {
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
        }();
    })(jQuery, window);
</script>