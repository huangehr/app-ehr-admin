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
        var code = '${code}';
        var name = '${name}';
        var catalog = '${catalog}';
        var systemDictId = '${systemDictId}';

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            stdInfoForm.init();
        }

        /* *************************** 模块初始化 ***************************** */
        stdInfoForm = {
            $form: $("#div_add_systemDictEntityDialog"),
            $systemDictEntityCode: $("#inp_systemDictEntity_code"),
            $systemDictEntityValue: $("#inp_systemDictEntity_value"),
            $systemDictEntityCatalog: $("#inp_systemDictEntity_catalog"),
            $btnSave: $("#btn_save"),
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$systemDictEntityCode.ligerTextBox({width:240,validate:{required:true }});
                this.$systemDictEntityValue.ligerTextBox({width:240,validate:{required:true }});
                this.$systemDictEntityCatalog.ligerTextBox({width:240,validate:{required:true }});
                if (!Util.isStrEquals(code, "") && !Util.isStrEquals(code, undefined)) {
                    this.$systemDictEntityCode.val(code);
                }
                if (!Util.isStrEquals(name, "") && !Util.isStrEquals(name, undefined)) {
                    this.$systemDictEntityValue.val(name);
                }
                if (!Util.isStrEquals(catalog, "") && !Util.isStrEquals(catalog, undefined)) {
                    this.$systemDictEntityCatalog.val(catalog);
                }
                if(mode=="add"){
                    $(".div-dict-code").removeClass("m-form-readonly");
                }
                if(mode=="modify"){
                    $(".div-dict-code").addClass("m-form-readonly");
                }
            },
            bindEvents: function () {
                var self = this;
                debugger
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){ }
                });

                this.$btnSave.click(function () {
                    if(!validator.validate()){
                        return;
                    }
                    var code = self.$systemDictEntityCode.val();
                    var value = self.$systemDictEntityValue.val();
                    var sort = "";
                    var catalog = self.$systemDictEntityCatalog.val();
                    var url = mode=="add"?'${contextRoot}/dict/createDictEntry':'${contextRoot}/dict/updateDictEntry';
                    if (Util.isStrEquals(systemDictId,'30')){
                        catalog = catalog.replace('，',',');
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote(url, {
                        data: {dictId: systemDictId, code: code, value: value, sort: sort, catalog: catalog},
                        success: function (data) {
                            if (data.successFlg) {
                                $.ligerDialog.success(mode=="add"?"新增成功":"更新成功");
                                //parent._LIGERDIALOG.success(mode=="add"?"新增成功":"更新成功");
                                win.reloadEntryMasterGrid();
                                win.closeDetailDialog();
                            } else {
                                $.ligerDialog.error(data.errorMsg);
                            }
                        }
                    });

                });

            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>