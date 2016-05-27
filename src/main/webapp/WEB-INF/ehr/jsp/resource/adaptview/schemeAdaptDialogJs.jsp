<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var adapterScheme = null;
        var jValidation = $.jValidation;
        //适配方案变量
        var adapterSchemeModel = null;
        var adapterType = 32;
        var versions;
        var types;
        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化
         */
        function pageInit() {
            adapterScheme.init();
        }
        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        adapterScheme = {
            $form: $("#div_adapter_scheme_form"),
            $id: $("#id"),
            $type: $('#ipt_type'),
            $adapterVersionName: $("#adapter_version_name"),
            $adapterVersion: $('#adapter_version'),
            $name: $('#ipt_name'),
            $code: $('#ipt_code'),
            $description: $('#ipt_description'),

            $adapter_version_name_div: $('#adapter_version_name_div'),
            $adapter_version_div: $('#adapter_version_div'),
            $saveBtn: $("#btn_save"),
            $cancelBtn: $("#btn_cancel"),
            $readonly: $('.u-readonly', this.$form),
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                var self = this;
                self.$form.removeClass("m-form-readonly");
                this.$code.ligerTextBox({width:240,validate:{required:true }});
                this.$name.ligerTextBox({width:240,validate:{required:true }});
                this.$adapterVersionName.ligerTextBox({width:240});
                types = self.$type.ligerComboBox(
                        {
                            cancelable: false,
                            url: '${contextRoot}/dict/searchDictEntryList',
                            valueField: 'code',
                            textField: 'value',
                            dataParmName: 'detailModelList',
                            validate:{required:true },
                            urlParms: {
                                page: 1,
                                rows: 1000,
                                dictId: adapterType
                            },
                            onSelected: function (value) {
                                if (Util.isStrEmpty(value)) {
                                    self.$adapter_version_name_div.css("display","none");
                                    self.$adapter_version_div.css("display","none");
                                    return;
                                }else if(value=="1"){
                                    self.$adapter_version_name_div.css("display","none");
                                    self.$adapter_version_div.css("display","");
                                }else if(value=="2"){
                                    self.$adapter_version_name_div.css("display","");
                                    self.$adapter_version_div.css("display","none");
                                }
                            }
                        });
                       versions = self.$adapterVersion.ligerComboBox(
                        {
                            cancelable: false,
                            url: '${contextRoot}/adapter/versions',
                            valueField: 'version',
                            textField: 'versionName',
                            dataParmName: 'detailModelList',
                            urlParms: {
                                page: 1,
                                rows: 1000,
                                dictId: 4,
                                isPublic: "false"
                            }
                        });
                self.$description.ligerTextBox({width: 240, height: 180});
                    //设值
                self.$form.attrScan();
                var info = ${info};
                if(info.successFlg){
                    self.$adapterVersion.ligerTextBox({disabled: true});
                    self.$type.ligerTextBox({disabled: true});
                    self.$form.Fields.fillValues({
                        type: info.obj.type,
                        adapterVersionName: info.obj.adapterVersion,
                        adapterVersion: info.obj.adapterVersion,
                        name : info.obj.name,
                        code : info.obj.code,
                        description : info.obj.description,
                        id: info.obj.id
                    });
                }
            },
            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {

                    }
                });

                //修改用户的点击事件
                this.$saveBtn.click(function () {
                    self.$form.attrScan();
                    adapterSchemeModel = self.$form.Fields.getValues();
                    if(!validator.validate()){
                        return;
                    }
                    if(adapterSchemeModel.type==2){
                        adapterSchemeModel.adapterVersion=adapterSchemeModel.adapterVersionName;
                    }
                    delete adapterSchemeModel.adapterVersionName;
                    save(JSON.stringify(adapterSchemeModel));
                });

                function save(parms) {
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote("${contextRoot}/schemeAdapt/update", {
                        data: {"dataJson":parms},
                        success: function (data) {
                            waittingDialog.close();
                            if (data.successFlg) {
                                win.closeSchemeDialog("保存成功！")
                            } else {
                                if (data.errorMsg)
                                    $.Notice.error(data.errorMsg);
                                else
                                    $.Notice.error('保存失败！');
                            }
                        },
                        error: function () {
                            waittingDialog.close();
                        }
                    })
                }


                this.$cancelBtn.click(function () {
                    win.closeSchemeDialog();
                });
            }

        };
        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>