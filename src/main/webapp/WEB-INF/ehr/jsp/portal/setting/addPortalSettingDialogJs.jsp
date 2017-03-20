<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var addPortalSettingInfo = null;

        var dialog = frameElement.dialog;

        var source;
        var trees;


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addPortalSettingInfo.init();
            $("#div_addPortalSetting_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addPortalSettingInfo = {
            $form: $("#div_addPortalSetting_form"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $orgId:$("#inp_orgId"),
            $appId:$("#inp_appId"),
            $columnUri:$("#inp_columnUri"),
            $columnName:$("#inp_columnName"),
            $appApiId:$("#inp_appApiId"),
//            $status: $('inp_status'),
            $columnRequestType: $('inp_columnRequestType'),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
            },
            initForm: function () {
                this.$orgId.ligerTextBox({width: 240});
                this.$appId.ligerTextBox({width: 240});
                this.$columnUri.ligerTextBox({width: 240});
                this.$columnName.ligerTextBox({width: 240});
                this.$appApiId.ligerTextBox({width: 240});

                <%--var columnType = this.$columnRequestType.ligerComboBox({--%>
                    <%--url: '${contextRoot}/dict/searchDictEntryList',--%>
                    <%--valueField: 'code',--%>
                    <%--textField: 'value',--%>
                    <%--dataParmName: 'detailModelList',--%>
                    <%--urlParms: {--%>
                        <%--dictId: 60--%>
                    <%--},--%>
                    <%--autocomplete: true,--%>
                    <%--onSuccess: function (data) {--%>
                        <%--if (data.length > 0) {--%>
                            <%--columnType.setValue(data[0].code);--%>
                        <%--}--%>
                    <%--}--%>
                <%--});--%>

                this.$form.attrScan();
            },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {  }
                });

                //新增的点击事件
                this.$addBtn.click(function () {
                    var addPortalSetting = self.$form.Fields.getValues();
                    if (validator.validate()) {
                        update(addPortalSetting);
                    } else {
                        return;
                    }
                });

                function update(portalSettingModel) {
                    var modelJsonData = JSON.stringify(portalSettingModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/portalSetting/updatePortalSetting", {
                        data: {portalSettingModelJsonData: modelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.parent.closeAddPortalSettingInfoDialog(function () {
                                    win.parent.$.Notice.success('新增成功');
                                });
                            } else {
                                window.top.$.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

                self.$cancelBtn.click(function () {
                    dialog.close();
                });
            }
        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();

        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>