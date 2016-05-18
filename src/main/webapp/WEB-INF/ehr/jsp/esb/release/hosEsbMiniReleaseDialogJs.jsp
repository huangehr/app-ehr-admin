<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var hosReleaseInfoForm = null;
        var jValidation = $.jValidation;

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            hosReleaseInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        hosReleaseInfoForm = {
            $form: $("#div_hos_release_info_form"),
            $systemCode: $("#inp_system_code"),
            $file: $("#inp_file"),
            $versionName: $("#inp_version_name"),
            $versionCode: $("#inp_version_code"),
            $id: $("#id"),

            $btnSave: $("#btn_save"),
            $btnCancel: $("#btn_cancel"),

            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$systemCode.ligerTextBox({width:240,validate:{required:true }});
                this.$file.ligerTextBox({width:240,validate:{required:true }});
                this.$versionName.ligerTextBox({width:240,validate:{required:true }});
                this.$versionCode.ligerTextBox({width:240,validate:{required:true }});
                this.$form.attrScan();
				var info = ${info};
                this.$form.Fields.fillValues({
                    systemCode: info.systemCode,
                    file: info.file,
                    versionName : info.versionName,
                    versionCode : info.versionCode,
                    id: info.id
                });

                this.$form.show();
            },

            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,
                    onElementValidateForAjax:function(elm){

                    }
                });

                this.$btnSave.click(function () {
                    self.$btnSave.attr('disabled','disabled');
                    var values = self.$form.Fields.getValues();
                    var data = {
                        systemCode:values.systemCode,
                        releaseId:values.id,
                        file:values.file,
                        versionName:values.versionName,
                        versionCode:values.versionCode
                    };
                    if(!validator.validate()){
                        self.$btnSave.removeAttr('disabled');
                        return;
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/esb/hosRelease/saveReleaseInfo",{
                        data: data,
                        success: function(data) {
                            if(data.successFlg){
                                var app = data.obj;
                                parent.reloadMasterGrid();
                                parent.closeDialog('保存成功！');
                            }else{
                                $.Notice.error(data.errorMsg);
                            }
                            self.$btnSave.removeAttr('disabled');
                        },
                        error: function () {
                            $.Notice.error('出错了！');
                            self.$btnSave.removeAttr('disabled');
                        }
                    });

                });

                this.$btnCancel.click(function () {
                    parent.closeDialog();
                });
            }
        };
        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>