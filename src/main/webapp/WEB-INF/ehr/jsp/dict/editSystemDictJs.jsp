<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var stdInfoForm = null;

//        var dialog = frameElement.dialog;
        // 表单校验工具类
        var jValidation = $.jValidation;
        var mode = '${mode}';
        var systemDictId = '${systemDictId}';
        var systemName = '${systemName}';

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            stdInfoForm.init();
        }

        /* *************************** 模块初始化 ***************************** */
        stdInfoForm = {
            $form: $("#div_updateSystemDictDialog"),
            $systemDictName: $("#inp_systemDictName"),
            $systemNameCopy:$("#inp_systemNameCopy"),
            $btnSave: $("#btn_save"),
            $btnCancel: $("#btn_cancel"),
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$systemDictName.ligerTextBox({width:240,validate:{required:true }});
                if (!Util.isStrEquals(systemName, "") && !Util.isStrEquals(systemName, undefined)) {
                    this.$systemNameCopy.val(systemName);
                    this.$systemDictName.val(systemName);
                }
            },
            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    var systemNameCopy =  self.$systemNameCopy.val();
                    var systemName = self.$systemDictName.val();
                    var result = new jValidation.ajax.Result();
                    if(Util.isStrEquals(systemNameCopy,systemName)){
                        return true;
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote('${contextRoot}/dict/validator', {
                        data: {systemName: systemName},
                        async: false,
                        success: function (data) {
                            if (data.successFlg) {
                                result.setResult(true);
                            } else {
                                result.setResult(false);
                                result.setErrorMsg("该字典名称已被使用");
                            }
                        }
                    });
                    return result;
                }
                });

                this.$btnSave.click(function () {
                    if(!validator.validate()){
                        return;
                    }
                    var systemName = self.$systemDictName.val();
                    var systemDictUpdateUrl = null;
                    var data = null;
                    if (Util.isStrEquals(systemDictId, "") || Util.isStrEquals(systemDictId, undefined)) {
                        systemDictUpdateUrl = '${contextRoot}/dict/createDict';
                        data = {name: systemName, reference: ''};
                    } else {
                        systemDictUpdateUrl = '${contextRoot}/dict/updateDict';
                        data = {dictId: systemDictId, name: systemName};
                    }
                    var dataModel = $.DataModel.init();
                    var waittingDialog = parent._LIGERDIALOG.waitting('正在保存中,请稍候...');
                    dataModel.createRemote(systemDictUpdateUrl, {
                        data: data,
                        success: function (data) {
                            setTimeout(function () {
                                waittingDialog.close();
                                if (data.successFlg) {
                                    parent._LIGERDIALOG.success(mode=="add"?"新增成功":"更新成功");
                                    win.reloadMasterGrid();
                                    win.closeDialog();
                                } else {
                                    parent.$.Notice.error(data.errorMsg);
                                }
                            },500)
                        }
                    });

                });

                this.$btnCancel.click(function () {
                    win.closeDialog();
                });
            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>