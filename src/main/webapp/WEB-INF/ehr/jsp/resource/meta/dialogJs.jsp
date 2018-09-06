<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>

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
                {type: 'radio', id: 'dataSource'},
                {type: 'radio', id: 'gender'},
                {type: 'text', id: 'ipt_description', opts:{height:100}}
            ];

            initFormFields(vo);
            dictCombo = $('#ipt_dict_id').customCombo(
                    urls.dictCombo, {}, function (id, name) {
                        if(this.grid){
                            var dictVal = this.grid.getSelectedRow();
                            if(dictVal)
                                $('#dictCode').val(dictVal.code);
                        }
                    }, undefined, false, {selectBoxHeight: 280, valueField: 'id'});
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
                saveDForm({url: urls.update, $form: $form, modelName: 'metadata', validator: validator});
            });

            $('#btn_cancel').click(function () {
                closeDialog();
            });
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
        var init = function () {
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
            if (model.dataSource == 1 || !model.dataSource) {
                $('input[name="dataSource"]').eq(0).liger().setValue('true');
            }
            if (model.dataSource == 2) {
                $('input[name="dataSource"]').eq(1).liger().setValue('true');
            }

            dictCombo.setValueText(model.dictId, model.dictName);
        }();
    })(jQuery, window);
</script>