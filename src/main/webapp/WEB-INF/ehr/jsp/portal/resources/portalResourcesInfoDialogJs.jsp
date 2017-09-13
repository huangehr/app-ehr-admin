<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var resourcesInfo = null;

        //修改变量
        var resourcesModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var resources = allData.obj;

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            resourcesInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        resourcesInfo = {
            $form: $("#div_info_form"),
            $imageShow: $("#div_file_list"),
            $uploader: $("#div_resources_img_upload"),
            $name:$("#inp_name"),
            $version:$("#inp_version"),
            $description:$("#inp_description"),
            $selectPlatformType: $("#inp_select_platform_type"),
            $selectDevelopLanType: $("#inp_select_portal_develop_lan"),
            $updateDtn: $("#div_update_btn"),
            $cancelBtn: $("#div_cancel_btn"),

            $apkUrl:$("#apkUrl"),
            $androidUrl:$("#androidUrl"),
            $iosUrl:$("#iosUrl"),

            $inpFileAndroid: $('#inp_file_android'),
            $inpFileIosUrl: $('#inp_file_iosUrl'),
            $inpFileApk: $("#inp_file_apk"),
//            $uploadApk: $("#apkUploadButton"),
//            $uploadAndroid: $("#androidUploadButton"),
//            $uploadIos: $("#iosUploadButton"),

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
            },//树形结构todo
            initForm: function () {
                var self = this;
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
                    }
                });

                var developLanType = this.$selectDevelopLanType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 58
                    }
                });

                this.$form.attrScan();
                this.$form.Fields.fillValues({
                    id: resources.id,
                    name: resources.name,
                    version: resources.version,
                    platformType: resources.platformType,
                    developLan: resources.developLan,
                    description: resources.description,
                    url:resources.url,
                    androidQrCodeUrl:resources.androidQrCodeUrl,
                    iosQrCodeUrl:resources.iosQrCodeUrl
                });

                var picUrl = resources.picUrl;
                if (!Util.isStrEmpty(picUrl)) {
                    self.$imageShow.html('<img src="${contextRoot}/portalResources/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w88 f-h110"></img>');
                }

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
                    debugger;
                    var imgHtml = self.$imageShow.children().length;
                    if (validator.validate()) {
                        resourcesModel = self.$form.Fields.getValues();
                        if (imgHtml == 0) {
                            update(resourcesModel);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.portalResourcesModelJsonData = encodeURIComponent(JSON.stringify(resourcesModel));
                                upload.upload();
                                win.reloadMasterUpdateGrid();

                                update(resourcesModel);
                            } else {
                                update(resourcesModel);
                            }
                        }
                    } else {
                        return;
                    }
                });

                function update(resourcesModel) {
                    var resourcesModelJsonData = JSON.stringify(resourcesModel);
                    var dataModel = $.DataModel.init();
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                    dataModel.updateRemote("${contextRoot}/portalResources/updatePortalResources", {
                        data: {portalResourcesModelJsonData: resourcesModelJsonData},
                        success: function (data) {
                            waittingDialog.close();
                            if (data.successFlg) {
                                win.closeResourcesInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                //change事件
                this.$inpFileApk.on( 'change', function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUpload';
                    self.$apkUrl.val(doUpload(url));
                });
                this.$inpFileAndroid.on( 'change', function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUploadAndriod';
                    self.$androidUrl.val(doUpload(url));
                });
                this.$inpFileIosUrl.on( 'change',function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUploadIos';
                    self.$iosUrl.val( doUpload(url));
                });

                <%--this.$uploadApk.click(function () {--%>
                    <%--var url = '${contextRoot}/portalResources/portalResourcesFileUpload';--%>
                    <%--self.$apkUrl.val(doUpload(url));--%>
                <%--});--%>
                <%--this.$uploadAndroid.click(function () {--%>
                    <%--var url = '${contextRoot}/portalResources/portalResourcesFileUploadAndriod';--%>
                    <%--self.$androidUrl.val(doUpload(url));--%>
                <%--});--%>
                <%--this.$uploadIos.click(function () {--%>
                    <%--var url = '${contextRoot}/portalResources/portalResourcesFileUploadIos';--%>
                    <%--self.$iosUrl.val( doUpload(url));--%>
                <%--});--%>

                function doUpload(url) {
                    var formData = new FormData($( "#uploadForm" )[0]);
                    var fileUrl;
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
//                                alert("上传成功");
                                $.Notice.success('上传成功');
                                fileUrl = returndata;
                            }else{
//                                alert("上传失败");
                                $.Notice.success('上传失败');
                            }
                        },
                        error: function (returndata) {
//                            alert("上传失败");
                            $.Notice.success('上传失败');
                        }
                    });
                    return fileUrl;
                }

                this.$cancelBtn.click(function () {
                    win.closeResourcesInfoDialog();
                });
            }

        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>