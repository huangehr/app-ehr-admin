<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/app/feature/update",
            existence: "${contextRoot}/app/feature/existence"
        }
        var model = ${model};
        var mode = '${mode}';
        var extParms = parent.getEditParms();//其他信息

        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_af_name', opts: {readonly: mode=='modify', disabled: mode=='modify'}},
                {type: 'text', id: 'ipt_af_code'},
                {type: 'select', id: 'ipt_af_type', dictId: 39, opts: {disabled: mode=='modify',
                    onSuccess: function (data) {
                        if(mode=='new'){
                            var newData = [];
                            switch (parseInt(extParms.upType)){
                                case 0: $.each(data, function (i, v) {if(v.code==1) newData.push(v);}); break;
                                case 1: $.each(data, function (i, v) {if(v.code==1 || v.code==2) newData.push(v);}); break;
                                case 2: $.each(data, function (i, v) {if(v.code==3) newData.push(v);}); break;
                                default: newData = data;
                            }
                            this.setData(newData);
                            this.selectItemByIndex(0);
                        }
                    }
                }},
                {type: 'select', id: 'ipt_af_open', dictId: 40, opts: {initVal: '1'}},
                {type: 'select', id: 'ipt_af_audit', dictId: 41, opts: {initVal: '1'}},
                {type: 'text', id: 'ipt_af_icon_url'},
                {type: 'text', id: 'ipt_af_url', opts:{height:60}},
                {type: 'text', id: 'ipt_af_description', opts:{height:100}}
            ];
            initFormFields(vo);
        };

        var initBtn = function () {
            var $form =  $("#infoForm");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                var type = $('#ipt_af_type').ligerGetComboBoxManager().getValue();
                if(field=='ipt_af_name' && val!=model.name)
                    return uniqValid(urls.existence, "name="+val+" g1;type="+type+";appId="+model.appId, "该类型下名称已存在！");
                else if(field=='ipt_af_code' && val!=model.code)
                    return uniqValid(urls.existence, "code="+val+" g1;type="+type+";appId="+model.appId, "该类型下编码已存在！");
            });

            $('#btn_save').click(function () {
                saveForm({url: urls.update, $form: $form, modelName: 'model', validator: validator});
            });

            $('#btn_cancel').click(function () {
                parent.closeDialog();
            });
        };

        var init = function () {
            if(mode=='new'){
                model.parentId = extParms.upId;
                model.appId = extParms.appId;
            }
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
            if(mode=='view'){
                $('#infoForm').addClass('m-form-readonly');
                $('#btn_save').hide();
            }
        }();

    })(jQuery, window);
</script>