<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/ueditor.all.js"></script>
<%--<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/dialogs/image/image.js"></script>--%>

<%--<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/lang/zh-cn/zh-cn.js"></script>--%>
<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var addNoticeInfo = null;

        var dialog = frameElement.dialog;

        // 编辑器
        var ue = UE.getEditor('inp_content',{
            serverUrl: '${contextRoot}/develop/lib/ueditor/jsp/config.json'
        });

        UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
        UE.Editor.prototype.getActionUrl = function (a) {
            if (a === 'uploadimage') {
                return '${contextRoot}/file/upload/EditorImage'
            } else {
                return this._bkGetActionUrl.call(this,a);
            }
        };



        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addNoticeInfo.init();
            $("#div_addNotice_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addNoticeInfo = {
            $form: $("#div_addNotice_form"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $selectType: $("#inp_select_type"),
            $selectPortalType: $("#inp_select_portal_type"),
            $title:$("#inp_title"),
            $content:$("#inp_content"),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
            },
            initForm: function () {
                this.$title.ligerTextBox({width: 240});
                this.$content.ligerTextBox({width:840,height:150 });

                var selectType = this.$selectType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 55
                    },
                    autocomplete: true,
                    onSuccess: function (data) {
                        if (data.length > 0) {
                            selectType.setValue(data[0].code);
                        }
                    }
                });

                var selectPortalType = this.$selectPortalType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 56
                    },
                    autocomplete: true,
                    onSuccess: function (data) {
                        if (data.length > 0) {
                            selectPortalType.setValue(data[0].code);
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
                    var addNotice = self.$form.Fields.getValues();
                    var ue = UE.getEditor('inp_content');
                    var ueditContent  = ue.getContent();
                    if (validator.validate()) {
                        update(addNotice,ueditContent);
                    } else {
                        return;
                    }
                });

                function update(noticeModel,ueditContent) {
                    var modelJsonData = JSON.stringify(noticeModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/portalNotice/updatePortalNotice", {
                        data: {
                            portalNoticeModelJsonData: modelJsonData,
                            ueditContent:ueditContent
                        },
                        success: function (data) {
                            if (data.successFlg) {
                                win.parent.closeAddPortalNoticeInfoDialog(function () {
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