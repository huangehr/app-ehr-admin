<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var appInfoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
		var catalogDictId = 1;
		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            appInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        appInfoForm = {
            $form: $("#div_app_info_form"),
            $name: $("#inp_app_name"),
			$orgCode: $("#inp_org_code"),
			$catalog: $("#inp_dialog_catalog"),
            $url: $("#inp_url"),
            $description: $("#inp_description"),
            $btnSave: $("#btn_save"),
            $btnCancel: $("#btn_cancel"),

            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$name.ligerTextBox({width:240});
				this.initDDL(catalogDictId, $('#inp_dialog_catalog'));
				this.$orgCode.customCombo('${contextRoot}/esb/acqTask/orgCodes',{})
				this.$url.ligerTextBox({width:240, height: 50 });
                this.$description.ligerTextBox({width:240, height: 120 });
                var mode = '${mode}';
				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					appInfoForm.$form.addClass('m-form-readonly');
					$("#btn_save").hide();
					$("#btn_cancel").hide();
					//$("input,select", this.$form).prop('disabled', false);
				}
                this.$form.attrScan();
                if(mode !='new'){
                    var app = ${app}.obj;
                    this.$form.Fields.fillValues({
                        name:app.name,
                        catalog: app.catalog,
                        status:app.status,
                        tags:app.tags,
                        id:app.id,
                        secret:app.secret,
                        url:app.url,
                        description:app.description
                    });
					$("#inp_org_code").ligerGetComboBoxManager().setValue(app.org);
					$("#inp_org_code").ligerGetComboBoxManager().setText(app.org);
                }
                this.$form.show();
            },
            initDDL: function (dictId, target) {
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value'
                });
            },

            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
                    onElementValidateForAjax:function(elm){
                    }
                });
                this.$btnSave.click(function () {
                    if(validator.validate()){
                        if('${mode}' == 'new'){
                            var values = self.$form.Fields.getValues();
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/createApp",{data: $.extend({}, values),
                                success: function(data) {
                                    if (data.successFlg) {
                                        win.parent.closeDialog(function () {
                                        });
                                    } else {
                                        window.top.$.Notice.error(data.errorMsg);
                                    }
                                }});
                        }else{
                            var values = self.$form.Fields.getValues();
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/updateApp",{data: $.extend({}, values),
                                success: function(data) {
                                    if (data.successFlg) {
                                        win.parent.closeDialog(function () {
                                        });
                                    } else {
                                        window.top.$.Notice.error(data.errorMsg);
                                    }
                                }});
                        }
                    }else{
                        return;
                    }
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