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
        var DimensionMainId =  72;//主维度字典id
        var DimensionSlaveId = 73;//从维度字典id
        var DimensionStatusId =  74;//维度状态
        // 表单校验工具类
        var jValidation = $.jValidation;

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
            },
            initForm: function () {
                this.$inpCode.ligerTextBox({width: 240});
                this.$inpName.ligerTextBox({width: 240});
                this.$inpIntroduction.ligerTextBox({width: 240,height:104,padding:10});
                this.initDDL(DimensionMainId,this.$inpType);
                this.initDDL(DimensionStatusId,this.$inpStatus);
                this.$form.attrScan();
            },
            initDDL: function (dictId, target) {
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
            },
            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                   debugger
                    if(Util.isStrEquals($(elm).attr('id'),'inp_code')){
                        var result = new jValidation.ajax.Result();
                        var code = self.$inpCode.val();
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDimensionMain/isCodeExists", {
                            data: {code:code},
                            async: false,
                            success: function (data) {
                                if (data.successFlg) {
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
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDimensionMain/isNameExists", {
                            data: {name:name},
                            async: false,
                            success: function (data) {
                                if (data.successFlg) {
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
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjDimensionMain/updateTjDimensionMain", {
                            data: {tjDimensionMainModelJsonData:JSON.stringify(values)},
                            async: false,
                            success: function (data) {
                                debugger
                                if (data.successFlg) {
                                    win.parent.closeAddWeiduInfoDialog(function () {
                                        if(self.$weiDuId.val()){//修改
                                            win.parent.$.Notice.success('修改成功');
                                        }else{
                                            win.parent.$.Notice.success('新增成功');
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
                    parent.closeDialog();
                })

            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();
    })(jQuery, window);
</script>

