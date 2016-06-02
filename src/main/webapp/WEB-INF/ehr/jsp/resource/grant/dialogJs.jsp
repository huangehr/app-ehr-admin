<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        var urls = {
            update: "${contextRoot}/resource/grant/saveMeta"
        }
        var model = ${model};
        var mode = '${mode}';
        var data = [{code: "1", value: "1"}, {code: "2", value: "2"}, {code: "3", value: "3"}];
        var validator;

        var initForm = function () {
            var vo = [
                {type: 'select', id: 'ipt_logic', dictId: 34, opts: {width: 100,
                    onSelected: function (v, t) {
                        initInputFields();
                    },
                    onSuccess: function (data) {
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
                var model = $form.Fields.getValues();
                if(model['content1']){
                    conditionName = logicName + " " + $('#content1').val() +" 与 "+ $('#content2').val();
                    if(model.logic == '<>'){
                        dimension.push({"andOr":" AND ","field":model.metaId,"condition":" > ","value":model['content1'], "conditionName": conditionName});
                        dimension.push({"andOr":" AND ","field":model.metaId,"condition":" < ","value":model['content2']});
                    }else if(model.logic == '><'){
                        dimension.push({"andOr":" OR ","field":model.metaId,"condition":" < ","value":model['content1'], "conditionName": conditionName});
                        dimension.push({"andOr":" OR ","field":model.metaId,"condition":" > ","value":model['content2']});
                    }
                } else{
                    conditionName = logicName + " " + $('#content').val();
                    dimension.push({"andOr":" AND ","field":model.metaId,"condition":" "+ model.logic +" ","value":model['content'], "conditionName": conditionName});
                }

                var params = {dimension: JSON.stringify(dimension), id: model.id};
                saveForm({url: urls.update, parms: params, $form: $form, validator: validator});
            });

            $('#btn_cancel').click(function () {
                parent.closeDialog();
            });
        };

        var init = function () {
            initForm();
            initBtn();
            fillForm(model, $('#infoForm'));
            $('#metaName').html(model.resourceMetadataName || "");
        }();
    })(jQuery, window);
</script>