<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/app/api/update",
            existence: "${contextRoot}/app/api/existence",
            apiEdit: "${contextRoot}/app/api/edit",
            list: "${contextRoot}/app/api/list",
            appCombo: "${contextRoot}/app/platform/list"
        }
        var model = ${model};
        var mode = '${mode}';
        var extParms = parent.getEditParms();//其他信息
        var hasChildType;
        var getChild = function (){
            if(mode=='modify' || mode=='view' || extParms.upType==-1)
                return;
            $.ajax({
                url: urls.list,
                async: false,
                data:{page: 1, rows: 1, filters: "parentId="+ extParms.upId},
                success: function (data) {
                    data = eval('('+ data +')');
                    if(!data.successFlg){
                        $.Notice.error("数据请求错误，请刷新页面或联系管理员！");
                        throw new Error("数据请求错误，请刷新页面或联系管理员！");
                        return;
                    }
                    if(data.detailModelList.length>0){
                        hasChildType = data.detailModelList[0].type;
                    }
                },
                error: function () {
                    $.Notice.error("链接请求错误，请刷新页面或联系管理员！");
                    throw new Error("链接请求错误，请刷新页面或联系管理员！");
                }
            })
        }();

        var $form =  $("#infoForm");
        var validator;
        function initValidation(){
            validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='ipt_api_name' && val!=model.name){
                    return uniqValid4List(urls.existence, "name="+val+" g1;parentId="+ model.parentId, "该应用代码已存在！");
                }
            });

        }

        var appCombo;
        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_api_description', opts: {height: 100}},
                {type: 'select', id: 'ipt_api_type', dictId: 46, opts: {disabled: mode=='modify', onSuccess: function (data) {
                        if(mode=='new'){
                            var newData = [];
                            switch (parseInt(extParms.upType)){
                                case -1: $.each(data, function (i, v) {if(v.code==2) newData.push(v);}); break;
                                case 0: ;
                                case 2: $.each(data, function (i, v) {
                                    if(!hasChildType){if(v.code==0 || v.code==1) newData.push(v);}
                                    else if(hasChildType==v.code) newData.push(v);
                                }); break;
                                default: newData = data;
                            }
                            this.setData(newData);
                            this.selectItemByIndex(0);
                        }
                    }, onSelected: function (v, t) {
                        var version = $('#ipt_api_version').ligerGetTextBoxManager();
                        var protocol = $('#ipt_api_protocol').ligerGetCheckBoxManager();
                        var method = $('#ipt_api_method').ligerGetCheckBoxManager();
                        var methodName = $('#ipt_api_methodName').ligerGetTextBoxManager();
                        if(v==1){
                                $('.apiProto').addClass("essential").find('input').addClass('required');
                                version.setEnabled(true);
                                protocol.setEnabled(true);
                                method.setEnabled(true);
                                methodName.setEnabled(true);
                        } else{
                            $('.apiProto').removeClass("essential").find('input').removeClass('required');
                            version.setDisabled(true);
                            protocol.setDisabled(true);
                            method.setDisabled(true);
                            methodName.setDisabled(true);
                            version.setValue('');
                            protocol.setValue('');
                            method.setValue('');
                            methodName.setValue('');
                        }
                        validator.reset();
                    }
                }},
                {type: 'select', id: 'ipt_api_openLevel', dictId: 40, opts:{initVal: mode=='new'? '1': undefined}},
                {type: 'select', id: 'ipt_api_auditLevel', dictId: 41, opts:{initVal: mode=='new'? '1': undefined}},
                {type: 'select', id: 'ipt_api_activityType', dictId: 43},
                {type: 'text', id: 'ipt_api_version'},
                {type: 'select', id: 'ipt_api_protocol', dictId: 44},
                {type: 'select', id: 'ipt_api_method', dictId: 45},
                {type: 'text', id: 'ipt_api_methodName'}
            ];

            if(extParms.upType==-1 || model.type==2)
                appCombo = $('#ipt_api_name').customCombo(
                        urls.appCombo, {fields: 'id,name', filters: 'sourceType=1'}, function (id, name) {
                            if(mode=='new')
                                $('#ipt_api_name').blur();
                            if(appCombo.getLigerComboBox().getSelected())
                                $('#appId').val(appCombo.getLigerComboBox().getSelected().id);
                        }, undefined, false, {selectBoxHeight: 280, valueField: 'name', disabled: mode=='modify',
                            conditionSearchClick: function(g){
                                var searchParm = g.rules.length > 0 ? g.rules[0].value : '';
                                var parms = g.grid.get("parms");
                                parms.filters = 'sourceType=1;';
                                if(searchParm)
                                    parms.filters += 'name?'+searchParm+' g1';
                                g.grid.set({
                                    parms: parms,
                                    newPage: 1
                                });
                                g.grid.reload();
                            }});
            else
                vo.push({type: 'text', id: 'ipt_api_name'});
            initFormFields(vo);
        };

        var initBtn = function () {
            initValidation();
            $('#btn_save').click(function () {
                saveForm({url: urls.update, $form: $form, modelName: 'model', validator: validator,
                    onSuccess: function (data) {
                        if(data.obj.type==1){
                            $.Notice.confirm("保存成功，是否继续编辑接口详细信息？", function (y) {
                                if(y){
                                    var url = urls.apiEdit + '?treePid=1&treeId=11&mode=modify';
                                    parent.closeDialog();
                                    $("#contentPage").empty();
                                    $("#contentPage").load(url, data.obj);
                                }else
                                    parent.closeDialog(undefined, data);
                            })
                        }else
                            parent.closeDialog("保存成功!", data);
                    }});
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
            if(mode=='modify' && appCombo){
                appCombo.setValueText(model.appId, model.name);
            }else if(mode=='view'){
                $('#infoForm').addClass('m-form-readonly');
                $('#btn_save').hide();
            }
        }();

    })(jQuery, window);
</script>