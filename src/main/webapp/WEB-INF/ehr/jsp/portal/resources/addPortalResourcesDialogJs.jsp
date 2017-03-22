<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;
        var addResourcesInfo = null;
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
            addResourcesInfo.init();
            $("#div_addResources_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addResourcesInfo = {
            $form: $("#div_addResources_form"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $imageShow: $("#div_file_list"),
            $uploader: $("#div_resources_img_upload"),
            $name:$("#inp_name"),
            $version:$("#inp_version"),
            $description:$("#inp_description"),
            $selectPlatformType: $("#inp_select_platform_type"),
            $selectDevelopLanType: $("#inp_select_portal_develop_lan"),
            $apkUrl:$("#apkUrl"),
            $androidUrl:$("#androidUrl"),
            $iosUrl:$("#iosUrl"),

            $uploadApk: $("#apkUploadButton"),
            $uploadAndroid: $("#androidUploadButton"),
            $uploadIos: $("#iosUploadButton"),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/portalResources/updatePortalResources",
                    pick: {id: '#div_file_picker'},
//                    accept: {
//                        title: 'Images',
//                        extensions: 'gif,jpg,jpeg,bmp,png',
//                        mimeTypes: 'image/*'
//                    },
                auto: false
            });
            self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                if(!resp.successFlg)
                    win.parent.$.Notice.error(resp.errorMsg);
                else
                    win.parent.$.Notice.success('新增成功');
                    win.parent.closeAddPortalResourcesInfoDialog(function () {
                });
            });
        },
        initForm: function () {
            this.$name.ligerTextBox({width: 240});
            this.$version.ligerTextBox({width:240 });
            this.$description.ligerTextBox({width:240,height:50 });

            var platformType = this.$selectPlatformType.ligerComboBox({
            url: '${contextRoot}/dict/searchDictEntryList',
                valueField: 'code',
                textField: 'value',
                dataParmName: 'detailModelList',
                urlParms: {
                    dictId: 57
                },
                autocomplete: true,
                onSuccess: function (data) {
                    if (data.length > 0) {
                        platformType.setValue(data[0].code);
                    }
                }
            });

            var developLanType = this.$selectDevelopLanType.ligerComboBox({
                url: '${contextRoot}/dict/searchDictEntryList',
                valueField: 'code',
                textField: 'value',
                dataParmName: 'detailModelList',
                urlParms: {
                    dictId: 58
                },
                autocomplete: true,
                onSuccess: function (data) {
                    if (data.length > 0) {
                        developLanType.setValue(data[0].code);
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
                    var imgHtml = self.$imageShow.children().length;
                    var portalResources = self.$form.Fields.getValues();
                    if (validator.validate()) {
                        if (imgHtml == 0) {
                            update(portalResources);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.portalResourcesModelJsonData = encodeURIComponent(JSON.stringify(portalResources));
                                upload.upload();
                            } else {
                                update(portalResources);
                            }
                        }

                    } else {
                        return;
                    };
                });

                function update(ResourcesModel) {
                    var modelJsonData = JSON.stringify(ResourcesModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/portalResources/updatePortalResources", {
                        data: {portalResourcesModelJsonData: modelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.parent.closeAddPortalResourcesInfoDialog(function () {
                                    win.parent.$.Notice.success('新增成功');
                                });
                            } else {
                                window.top.$.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }


                this.$uploadApk.click(function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUpload';
                    doUpload(url);
                });
                this.$uploadAndroid.click(function () {
                  var url = '${contextRoot}/portalResources/portalResourcesFileUploadAndriod';
                    doUpload(url);
                });
                this.$uploadIos.click(function () {
                  var url = '${contextRoot}/portalResources/portalResourcesFileUploadIos';
                    doUpload(url);
                });

                function doUpload(url) {
                    var formData = new FormData($( "#uploadForm" )[0]);
                    $.ajax({
                        url: url ,
                        type: 'POST',
                        data: formData,
                        async: false,
                        cache: false,
                        contentType: false,
                        processData: false,
                        success: function (returndata) {
                            if(returndata != "fail"){
                                self.$apkUrl.val(returndata);
                                alert("上传成功");
                            }else{
                                alert("上传失败");
                            }
                        },
                        error: function (returndata) {
                            alert("上传失败");
                        }
                    });
                }

                self.$cancelBtn.click(function () {
                    dialog.close();
                });

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