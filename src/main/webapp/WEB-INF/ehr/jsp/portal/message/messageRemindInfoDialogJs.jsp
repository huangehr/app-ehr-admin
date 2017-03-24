<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var messageRemindInfo = null;

        //修改变量
        var messageRemindModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var messageRemind = allData.obj;

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            messageRemindInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        messageRemindInfo = {
            $form: $("#div_info_form"),
            $appId:$("#inp_appId"),
            $appName:$("#inp_appName"),
            $selectType:$("#inp_typeId"),
            $toUserId:$("#inp_toUserId"),
            $workUri:$("#inp_workUri"),
            $content:$("#inp_content"),
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
                this.$appId.ligerTextBox({width: 240});
                this.$appName.ligerTextBox({width: 240});
                this.$toUserId.ligerTextBox({width: 240});
                this.$workUri.ligerTextBox({width: 240,height:50});
                this.$content.ligerTextBox({width:240,height:50 });

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
                this.$form.Fields.fillValues({
                    id: messageRemind.id,
                    appId: messageRemind.appId,
                    appName: messageRemind.appName,
                    typeId: messageRemind.typeId,
                    toUserId: messageRemind.toUserId,
                    workUri: messageRemind.workUri,
                    content: messageRemind.content
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
                        messageRemindModel = self.$form.Fields.getValues();
                        update(messageRemindModel);
                    } else {
                        return;
                    }
                });

                function update(messageRemindModel) {
                    var messageRemindModelJsonData = JSON.stringify(messageRemindModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/messageRemind/updateMessageRemind", {
                        data: {messageRemindModelJsonData: messageRemindModelJsonData},
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