<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/ueditor.all.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/ueditor/lang/zh-cn/zh-cn.js" defer="defer"></script>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var noticeInfo = null;

        //修改变量
        var noticeModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var notice = allData.obj;

        // 编辑器
        var ue = UE.getEditor('inp_content', {
            serverUrl: '${contextRoot}/develop/lib/ueditor/jsp/config.json',
            initialFrameWidth:'100%',
            initialFrameHeight:'150px'
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
        function pageInit() {
            noticeInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        noticeInfo = {
            $form: $("#div_info_form"),
            $selectType: $("#inp_select_type"),
            $selectPortalType: $("#inp_select_portal_type"),
            $title: $("#inp_title"),
            $content: $("#inp_content"),
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
                this.$title.ligerTextBox({width: 240});
                this.$content.ligerTextBox({width: 840, height: 250});

                var selectType = this.$selectType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 55
                    }
                });

                var selectPortalType = this.$selectPortalType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 56
                    }
                });

                this.$form.attrScan();
                this.$form.Fields.fillValues({
                    id: notice.id,
                    title: notice.title,
                    type: notice.type,
                    portalType: notice.portalType,
//                    content: notice.content
                });
                var ue = UE.getEditor('inp_content');
                ue.setContent(notice.content);


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
                    onElementValidateForAjax: function (elm) {
                    }
                });

                //修改的点击事件
                this.$updateDtn.click(function () {
                    if (validator.validate()) {
                        noticeModel = self.$form.Fields.getValues();
                        var ue = UE.getEditor('inp_content');
                        var ueditContent  = ue.getContent();
                        if (validator.validate()) {
                            update(noticeModel,ueditContent);
                        } else {
                            return;
                        }
                    } else {
                        return;
                    }
                });

                function update(noticeModel,ueditContent) {
                    var noticeModelJsonData = JSON.stringify(noticeModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/portalNotice/updatePortalNotice", {
                        data: {
                            portalNoticeModelJsonData: noticeModelJsonData,
                            ueditContent:ueditContent
                        },
                        success: function (data) {
                            if (data.successFlg) {
                                win.closeNoticeInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                this.$cancelBtn.click(function () {
                    win.closeNoticeInfoDialog();
                });
            }

        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>