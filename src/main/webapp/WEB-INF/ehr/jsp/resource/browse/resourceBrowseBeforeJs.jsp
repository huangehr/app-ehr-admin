<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        debugger;

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var categoryInfo = null;

        //修改变量
        var categoryModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var category = ${model};

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            debugger
            categoryInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        debugger
        categoryInfo = {
            $form: $("#div_info_form"),
            $rid: $('#inp_id'),
            $name: $('#inp_name'),
            $updateDtn: $("#div_update_btn"),

            init: function () {
                debugger;
                var self = this;
                self.initForm();
                self.bindEvents();
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/resourceBrowse/browse",
                    auto: false,
                    async:false
                });
                self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    if(!resp.successFlg)
                        win.parent.$.Notice.error(resp.errorMsg);
                    else
                        win.parent.$.Notice.success('修改成功');
                    win.parent.closeAddDoctorInfoDialog(function () {});
                });
            },//树形结构todo
            initForm: function () {
                var self = this;
                this.$form.removeClass("m-form-readonly");
                this.$name.ligerTextBox({width: 240});
                this.$form.Fields.fillValues({
                    name: category.name,
                    rid: category.id
                });

                if ('${mode}' == 'view') {
                    this.$form.addClass("m-form-readonly");
                    this.$cancelBtn.hide();
                    this.$filePicker.hide();
                }
            },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {    }
                });

                //点击事件
                this.$updateDtn.click(function () {

                    var imgHtml = self.$imageShow.children().length;
                    if (validator.validate()) {
                        categoryModel = self.$form.Fields.getValues();
                        if (imgHtml == 0) {
                            update(categoryModel);
                        } else {
                            var upload = self.$uploader.instance;
                        }
                    } else {
                        return;
                    }
                });

                function update(categoryModel) {
                    var categoryModelJsonData = JSON.stringify(categoryModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/doctor/updateDoctor", {
                        data: {categoryModelJsonData: categoryModelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.closeDoctorInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                this.$cancelBtn.click(function () {
                    win.closeDoctorInfoDialog();
                });
            }

        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>