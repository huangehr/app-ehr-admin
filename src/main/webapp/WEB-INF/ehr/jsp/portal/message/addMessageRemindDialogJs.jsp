<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var addMessageRemindInfo = null;

        var dialog = frameElement.dialog;
        var searchUser;
        var source;
        var trees;


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addMessageRemindInfo.init();
            $("#div_addMessageRemind_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addMessageRemindInfo = {
            $form: $("#div_addMessageRemind_form"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $appId:$("#inp_appId"),
            $appName:$("#inp_appName"),
            $selectType:$("#inp_typeId"),
            $workUri:$("#inp_workUri"),
            $content:$("#inp_content"),
            $chooseUserBtn:$("#chooseUserBtn"),

            $searchUser: $("#ipt_search_user"),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
            },


            initForm: function () {
                this.$appId.ligerTextBox({width: 240});
                this.$appName.ligerTextBox({width: 240});
                this.$workUri.ligerTextBox({width: 240,height:50});
                this.$content.ligerTextBox({width:240,height:50 });
                this.$searchUser.customCombo('${contextRoot}/messageRemind/getUserList');

                var selectType = this.$selectType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 59
                    },
                    autocomplete: true,
                    onSuccess: function (data) {
                        if (data.length > 0) {
                            selectType.setValue(data[0].code);
                        }
                    }
                });

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
                    var addMessageRemind = self.$form.Fields.getValues();
                    if (validator.validate()) {
                        update(addMessageRemind);
                    } else {
                        return;
                    }
                });

                function update(messageRemindModel) {
                    var modelJsonData = JSON.stringify(messageRemindModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/messageRemind/updateMessageRemind", {
                        data: {messageRemindModelJsonData: modelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                closeAddMessageRemindInfoDialog(function () {
                                    $.Notice.success('新增成功');
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

                self.$chooseUserBtn.click(function () {
                    $.ligerDialog.open({ target: $("#div_mutil_dialog_content"), width: 300 ,height:300});
                });
            }
        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();

        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>