<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var portalSettingInfo = null;

        //修改变量
        var portalSettingModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var portalSetting = allData.obj;

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            portalSettingInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        portalSettingInfo = {
            $form: $("#div_info_form"),
            $orgId:$("#inp_orgId"),
            $appId:$("#inp_appId"),
            $columnUri:$("#inp_columnUri"),
            $columnName:$("#inp_columnName"),
            $appApiId:$("#inp_appApiId"),
            $status: $("#inp_status"),
            $columnRequestType: $("#inp_columnRequestType"),
            $updateDtn: $("#div_update_btn"),
            $cancelBtn: $("#div_cancel_btn"),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
            },//树形结构todo
            initForm: function () {
                var self = this;
                this.$form.removeClass("m-form-readonly");
                this.$orgId.ligerTextBox({width: 240});
                this.$appId.ligerTextBox({width: 240});
                this.$columnUri.ligerTextBox({width: 240});
                this.$columnName.ligerTextBox({width: 240});
                this.$appApiId.ligerTextBox({width: 240});

                var columnType = this.$columnRequestType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 60
                    },
                    autocomplete: true,
                    onSuccess: function (data) {
                        if (data.length > 0) {
                            columnType.setValue(data[0].code);
                        }
                    }
                });

                var stausType = this.$status.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 61
                    },
                    autocomplete: true,
                    onSuccess: function (data) {
                        if (data.length > 0) {
                            stausType.setValue(data[0].code);
                        }
                    }
                });

                this.$form.attrScan();
                this.$form.Fields.fillValues({
                    id: portalSetting.id,
                    appId: portalSetting.appId,
                    orgId: portalSetting.orgId,
                    columnUri: portalSetting.columnUri,
                    columnName: portalSetting.columnName,
                    appApiId: portalSetting.appApiId,
                    status: portalSetting.status,
                    columnRequestType: portalSetting.columnRequestType
                });

                if ('${mode}' == 'view') {
                    this.$form.addClass("m-form-readonly");
                    this.$cancelBtn.hide();
                    this.$updateDtn.hide();
                    this.$filePicker.hide();
                }
            },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {    }
                });

                //修改的点击事件
                this.$updateDtn.click(function () {
                    if (validator.validate()) {
                        portalSettingModel = self.$form.Fields.getValues();
                        update(portalSettingModel);
                    } else {
                        return;
                    }
                });

                function update(portalSettingModel) {
                    var portalSettingModelJsonData = JSON.stringify(portalSettingModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/portalSetting/updatePortalSetting", {
                        data: {portalSettingModelJsonData: portalSettingModelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.closeMessageInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                this.$cancelBtn.click(function () {
                    win.closeMessageInfoDialog();
                });
            }

        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>