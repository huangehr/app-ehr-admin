<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/webuploader.js"></script>
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/webuploader.css" />
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/style.css" />
<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var weiduInfo = null;
        var DataSourceId =  75;//数据源字典id
        var DimensionStatusId =  74;//维度状态
        // 表单校验工具类
        var jValidation = $.jValidation;
        var initCode = "";
        var initName = "";

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            weiduInfo.init();
        }
        /* *************************** 模块初始化 ***************************** */
        weiduInfo = {
            $form: $("#div_weidu_info_form"),
            $inpCode: $("#inp_code"),
            $inpName: $('#inp_name'),
            $inpType: $('#inp_type'),
            $inpStatus: $('#inp_status'),
            $inpIntroduction: $('#inp_introduction'),
            $updateBtn:$("#div_update_btn"),
            $cancelBtn:$("#div_cancel_btn"),
            $weiDuId:$("#inp_weiDuId"),
            init: function () {
                this.initForm();
                this.bindEvents();
                if(this.$weiDuId.val()!="" && this.$weiDuId.val()!=undefined){//修改
                    this.getTjDimensionMainByID();
                    $("#inp_code").closest(".m-form-group").addClass("m-form-readonly");
                }
            },
            initForm: function () {
                this.$inpCode.ligerTextBox({width: 240});
                this.$inpName.ligerTextBox({width: 240});
                this.$inpIntroduction.ligerTextBox({width: 240,height:104,padding:10});
                this.initDDL(DataSourceId,this.$inpType,"");
                this.initDDL(DimensionStatusId,this.$inpStatus,"");
                this.$form.attrScan();
            },
            getTjDimensionMainByID:function(){
                var self = this;
                var dataModel = $.DataModel.init();
                dataModel.fetchRemote("${contextRoot}/tjDataSource/getTjDataSourceById", {
                    data: {id:parseInt(self.$weiDuId.val())},
                    async: false,
                    success: function (data) {
                        if(data){
                            initCode = data.code;
                            initName = data.name;
                            self.$inpCode.val(data.code);
                            self.$inpName.val(data.name);
                            self.$inpIntroduction.val(data.remark);
                            self.initDDL(DataSourceId,self.$inpType,data.type);
                            self.initDDL(DimensionStatusId,self.$inpStatus,data.status);
                            self.$form.attrScan();
                        }
                    }
                });
            },
            initDDL: function (dictId, target,initValue) {
                var self = this;
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField:'value',
                    onSuccess: function () {
                    }
                });
                target.ligerGetComboBoxManager().setValue(initValue);
            },
            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    if(Util.isStrEquals($(elm).attr('id'),'inp_code')){
                        var result = new jValidation.ajax.Result();
                        var code = self.$inpCode.val();
                        if(code==initCode){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDataSource/hasExistsCode", {
                            data: {code:code},
                            async: false,
                            success: function (data) {
                                if (!data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("编码已存在");
                                }
                            }
                        });
                        return result;
                    }
                    if(Util.isStrEquals($(elm).attr('id'),'inp_name')){
                        var result = new jValidation.ajax.Result();
                        var name = self.$inpName.val();
                        if(name==initName){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDataSource/hasExistsName", {
                            data: {name:name},
                            async: false,
                            success: function (data) {
                                if (!data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("名称已存在");
                                }
                            }
                        });
                        return result;
                    }
                }});

                self.$updateBtn.click(function(){
                    if(validator.validate()){
                        var values = self.$form.Fields.getValues();
                        if(self.$weiDuId.val()!="" && self.$weiDuId.val()!=undefined){//修改
                            values.id = parseInt(self.$weiDuId.val());
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDataSource/updateTjDataSource", {
                            data: {tjDataSourceModelJsonData:JSON.stringify(values)},
                            async: false,
                            success: function (data) {
                                if (data.successFlg) {
                                   closeAddWeiduInfoDialog(function () {
                                        if(self.$weiDuId.val()!="" && self.$weiDuId.val()!=undefined){//修改
                                            $.Notice.success('修改成功');
                                        }else{
                                           $.Notice.success('新增成功');
                                        }
                                    });
                                } else {
                                    window.top.$.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else {
                        return;
                    }
                })

                self.$cancelBtn.click(function(){
                    closeDialog();
                })

            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();
    })(jQuery, window);
</script>

