<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        var urls = {
            update: "${contextRoot}/rolesResource/grant/saveMeta"
        }
        var model = ${model};
        var mode = '${mode}';
        var validator;

        var initForm = function () {
            var vo = [
                {type: 'select', id: 'ipt_logic', dictId: 34, opts: {width: 100,
                    onSelected: function (v, t) {
                        initInputFields();
                    },
                    onSuccess: function (data) {
                        for(var i in data){
                            if(data[i].value=='介于')
                                data[i].code = '<>';
                            else if(data[i].value=='不介于')
                                data[i].code = '><';
                        }
                        this.setData(data);
                        initInputFields();
                    }}}
            ];
            initFormFields(vo);
        };

        function initInputFields(){
            var logic = $('#ipt_logic').ligerGetComboBoxManager().getValue();
            var vo = [];
            if(model.dictEntries && model.dictEntries.length>0){
                if(logic == '<>' || logic == '><'){
                    createIptHtml(2, "select");
                    vo = [
                        {type: 'select', id: 'content1', opts: {width: 150, data: model.dictEntries, textField: 'name',}},
                        {type: 'select', id: 'content2', opts: {width: 150, data: model.dictEntries, textField: 'name'}}
                    ];
                }else if(logic == 'IN'){
                    createIptHtml(1, "select");
                    vo = [{type: 'select', id: 'content', opts: {width: 330, data: model.dictEntries, textField: 'name', isMultiSelect: true, split: ','}}];
                }else {
                    createIptHtml(1, "select");
                    vo = [{type: 'select', id: 'content', opts: {width: 330, data: model.dictEntries, textField: 'name'}}];
                }
            }
            else{
                var colunmType =  model.metaColunmType;
                var clz= '', placeholder= '';
                if(colunmType=='DT'){
                    type = "datetime"; clz= "validate-date-custom"; placeholder= "时间:2015-01-01 12:00:01";
                }else if(colunmType=='D'){
                    type = "date"; clz= "validate-date"; placeholder= "时间:2015-01-01";
                }else if(colunmType=='N'){
                    type = "text"; clz= "validate-integer"; placeholder= "请输入数字";
                }else if(colunmType=='L'){
                    type = "text"; clz= "validate-only-0-1"; placeholder= "0为false, 1为true";
                }else {
                    type = "text"; clz= ""; placeholder= logic=="IN"?"多个请用,隔开" : "";
                }
                if(logic == '<>' || logic == '><'){
                    createIptHtml(2, "text", clz, placeholder);
                    vo = [
                        {type: type, id: 'content1', opts: {width: 150}},
                        {type: type, id: 'content2', opts: {width: 150}}
                    ];
                }else {
                    createIptHtml(1, "text", clz, placeholder);
                    vo = [{type: type, id: 'content', opts: {width: 330}}];
                }
            }
            initFormFields(vo);
            $('#content').ligerGetComboBoxManager()
            validator = initValidate($("#infoForm"));
        }


        var defaultIptHtml = '<div class="l-text-wrapper m-form-control f-ml10">' +
                '<input type="$iptType" id="$id" data-type="select" class="required $clz" required-title="<spring:message code="lbl.must.input"/>"'   +
                ' data-attr-scan="$scanId" placeholder="$placeholder">' +
                '</div>';
        function createIptHtml(type, iptType, clz, placeholder){
            var html = "";
            if(type==1){
                html = fillFields("content", iptType, clz, placeholder);
            }else{
                html = fillFields("content1", iptType, clz, placeholder);
                html += '<div class="l-text-wrapper m-form-control f-ml10" style="padding-top: 8px">与</div>';
                html += fillFields("content2", iptType, clz, placeholder);
            }
            var $iptWrap = $('#iptWrap');
            $iptWrap.empty();
            $iptWrap.append(html);
        }

        function fillFields(id, iptType, clz, placeholder){
            return defaultIptHtml.replace("$id", id).replace("$scanId", id).replace("$iptType", iptType).replace("$clz", clz || '')
                    .replace("$placeholder", placeholder || '');
        }

        var initBtn = function () {
            var $form = $("#infoForm");

            $('#btn_save').click(function () {
                if(!validator.validate()) return;
                $form.attrScan();
                var logicName = $('#ipt_logic').val(), conditionName = "", dimension = [];
                var iptModel = $form.Fields.getValues();
                if(iptModel['content1']){
                    conditionName = logicName + " " + $('#content1').val() +" 与 "+ $('#content2').val();
                    if(iptModel.logic == '<>'){
                        dimension.push({"andOr":" AND ","field":iptModel.metaId,"condition":" > ","value":iptModel['content1'], "conditionName": conditionName});
                        dimension.push({"andOr":" AND ","field":iptModel.metaId,"condition":" < ","value":iptModel['content2']});
                    }else if(iptModel.logic == '><'){
                        dimension.push({"andOr":" OR ","field":iptModel.metaId,"condition":" < ","value":iptModel['content1'], "conditionName": conditionName});
                        dimension.push({"andOr":" OR ","field":iptModel.metaId,"condition":" > ","value":iptModel['content2']});
                    }
                } else{
                    conditionName = logicName + " " + $('#content').val();
                    dimension.push({"andOr":" AND ","field":iptModel.metaId,"condition":" "+ iptModel.logic +" ","value":iptModel['content'], "conditionName": conditionName});
                }

                var params = {dimensionValue: JSON.stringify(dimension), id: model.id, rolesResourceId: model.rolesResourceId, resourceMetadataName: model.resourceMetadataName,
                    resourceMetadataId: model.resourceMetadataId, rolesId: model.rolesId, dimensionId: model.dimensionId, valid: model.valid};
                saveForm({url: urls.update, parms: {model: JSON.stringify(params)}, $form: $form, validator: validator});
            });

            $('#btn_cancel').click(function () {
                parent.closeDialog();
            });
        };

        function checkInit(){
            if(!model.resourceMetadataName){
                $.Notice.error("数据加载失败！", function () {
                    parent.closeDialog();
                });
            }
        }

        var init = function () {
            checkInit();
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
            $('#metaName').html(model.resourceMetadataName || "");
        }();
    })(jQuery, window);
</script>