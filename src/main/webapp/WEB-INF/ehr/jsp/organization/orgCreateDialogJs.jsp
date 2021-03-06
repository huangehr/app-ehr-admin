<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%--<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/jquery.js"></script>--%>
<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/webuploader.js"></script>
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/webuploader.css" />
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/style.css" />
<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
//        $ = $.extend(parent.$,$);
        var Util = $.Util;
        var organizationInfo = null;
        var orgModel = null;

        var orgTypeDictId =  7;
        var settledWayDictId = 8;
        var hosTypeDictId =  62;
        var ascriptionTypeDictId =  63;
        var zxyDictId = 70;
        // 表单校验工具类
        var jValidation = $.jValidation;
        var dialog = null;

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            organizationInfo.init();


        }
    /* *************************** 模块初始化 ***************************** */
        organizationInfo = {
            $form: $("#div_organization_info_form"),
            $orgCode: $("#org_code"),
            $fullName: $('#full_name'),
            $shortName: $('#short_name'),
            $location: $('#location'),
            $settledWay: $('#settled_way'),
            $admin: $('#admin'),
            $tel: $('#tel'),
            $orgType: $('#org_type'),
            $tags: $("#tags"),
            $keyReadBtn:$("#keyReadBtn"),
            $updateOrgBtn: $("#div_update_btn"),
            $cancelBtn: $("#btn_cancel"),
            $uploader:$("#div_aptitude_img_upload"),
            $orgImageShow:$("#div_file_list"),

            $traffic: $("#traffic"),
            $ing: $("#ing"),
            $lat: $("#lat"),
            $hosType:$("#hosType"),
            $ascriptionType:$("#ascriptionType"),
            $phone:$("#phone"),
            $introduction:$("#introduction"),
            $levelId:$("#levelId"),
            $legalPerson:$("#legalPerson"),
            $logoUrlButton:$("#logoUrlButton"),
            $logoUrl:$("#logoUrl"),
            $parentHosId:$("#parentHosId"),
            $zxy:$("#zxy"),
            $berth:$("#berth"),

            init: function () {

                this.initForm();
                this.bindEvents();

                this.$uploader.instance = this.$uploader.webupload({
                    server: "${contextRoot}/organization/updateOrg",
                    pick: {id: '#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
                    auto: false,

                });
                this.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    $.ligerDialog.alert("保存成功", function () {
                        win.closeAddOrgInfoDialog(function () {

                        });
                    });
                });
            },
            initForm: function () {
                var self=this;
                this.$orgCode.ligerTextBox({width: 140});
                this.$fullName.ligerTextBox({width: 140});
                this.$shortName.ligerTextBox({width: 140});
                this.$location.ligerComboBox({width: 290});

                this.$traffic.ligerTextBox({width: 140});
                this.$ing.ligerTextBox({width: 140});
                this.$lat.ligerTextBox({width: 140});
                this.$hosType.ligerComboBox({width: 140});
                this.$phone.ligerTextBox({width: 140});
                this.$introduction.ligerTextBox({width: 396,height:104,padding:10});
                this.$levelId.ligerTextBox({width: 140});
                this.$legalPerson.ligerTextBox({width: 140});
//                this.$parentHosId.ligerTextBox({width: 140});
                this.$zxy.ligerComboBox({width: 140});
                this.$berth.ligerTextBox({width: 140});
                this.$orgType.ligerComboBox({width:140});
                this.$ascriptionType.ligerComboBox({width:140});
                this.$settledWay.ligerComboBox({width:140});


                this.initDDL(orgTypeDictId,this.$orgType);
                this.initDDL(settledWayDictId,this.$settledWay);
                this.initDDL(hosTypeDictId,this.$hosType);
                this.initDDL(ascriptionTypeDictId,this.$ascriptionType);
                this.initDDL(zxyDictId,this.$zxy);

                var url = '${contextRoot}/deptMember/getOrgList';
                this.$parentHosId.customCombo(url);

                this.$form.attrScan();
                /*todo 20160704 cyc*/
               /*self.$location.click(function(){
                    $(this).linkageCyc($(this));//toDO cyc 20160704

                })*/

                this.$location.addressDropdown({tabsData:[
                    {name: '省份',code:'id',value:'name',url: '${contextRoot}/address/getParent', params: {level:'1'}},
                    {name: '城市',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                    {name: '县区',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                    {name: '街道', maxlength: 200}
                ]});

                this.$location.parent().find('.u-select-title').css({
                    width: '100%'
                })
                this.$admin.ligerTextBox({width: 140, height:28});
                this.$tags.ligerTextBox({width: 140, height:28});
                this.$tel.ligerTextBox({width: 140, height:28});
                this.$tel.removeClass('l-text-field-number');
            },
            initDDL: function (dictId, target) {
                var self = this;
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField:'value',
                    onSuccess: function () {
                        self.$form.Fields.fillValues({orgType: "Hospital"});
                        self.$form.Fields.fillValues({settledWay: "Direct"});
                    },
                    onSelected: function (v) {
                        var dom = $(this.element);
                        if (dom.attr('id') == 'org_type') {
                            if (v != 'Hospital') {
                                $('#berthDiv').hide();
                                $('#berth').removeClass('required');
                                $('#berth').parent().removeClass('essential');
                            } else {
                                $('#berthDiv').show();
                                $('#berth').addClass('required');
                                $('#berth').parent().addClass('essential');
                            }
                        }
                    }
                });
            },
            bindEvents: function () {
                var self = this;
                $("#location,.u-dropdown-icon").click(function(){
                    self.$orgCode.click();
                });
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    if(Util.isStrEquals($(elm).attr('id'),'org_code')){
                        var result = new jValidation.ajax.Result();
                        var orgCode = self.$orgCode.val();
                        if(!/^[a-z0-9A-Z]+[-]*[a-z0-9A-Z]+$/.test(orgCode)){
                            if (orgCode.length < 2) {
                                result.setResult(false);
                                result.setErrorMsg("至少需要两个字符或者数字");
                                return result;
                            }
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/organization/validationOrg", {
                            data: {orgCode:orgCode},
                            async: false,
                            success: function (data) {
                                if (data.successFlg) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("组织机构已存在");
                                }
                            }
                        });
                        return result;

                    }
                }});
                this.$updateOrgBtn.click(function () {
                    var orgImgHtml = self.$orgImageShow.children().length;
                    if(validator.validate()){
                    	var dataModel = $.DataModel.init();
                    	self.$form.attrScan();
                        /*TODO 20160706 cyc*/
                        //var orgAddress=JSON.parse(self.$form.Fields.location.attr("data-arry"))
                    	var orgAddress = self.$form.Fields.location.getValue();

						var orgModel = self.$form.Fields.getValues();
						//标签字符串转化为数组
						var tags = orgModel.tags;
						tags = tags.split(/[;；]/)
						orgModel.tags = tags;
						//原location是对象，传到controller转化成model会报错--机构、地址分开传递（json串）
						orgModel.location = "";
                        //用于存储机构最小划分区域的id -追加 start by zdm
                        var administrative_division=null;
                        if(!Util.isStrEmpty(orgAddress.keys[2])){
                            administrative_division = orgAddress.keys[2];
                        } else if(!Util.isStrEmpty( orgAddress.keys[1])){
                            administrative_division = orgAddress.keys[1];
                        }else if(!Util.isStrEmpty( orgAddress.keys[0])){
                            administrative_division = orgAddress.id[0];
                        }
                        orgModel.administrativeDivision = administrative_division;
                        //用于存储机构最小划分区域的id -追加 end by zdm
                        var addressModel = {
                            province: orgAddress.names[0],
                            city: orgAddress.names[1],
                            district: orgAddress.names[2],
                            town: "",
                            street: orgAddress.names[3]
                        };

                        if (Util.isStrEmpty(orgImgHtml)) {
                            updateOrg(orgModel,addressModel,'new');
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.orgModel = encodeURIComponent(JSON.stringify(orgModel)+";"+JSON.stringify(addressModel)+";new");
                                upload.upload();
                            } else {
                                updateOrg(orgModel,addressModel,'new');
                            }
                        }
                    }else{
                        return;
                    }
                });

                this.$logoUrlButton.on('change',function () {
                    var url = '${contextRoot}/organization/orgLogoFileUpload';
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
                                $('#logoUrl').val(returndata);
                                self.$logoUrl.val(returndata);
                                $.Notice.success('上传成功');
                            }else{
                                $.Notice.error('上传失败');
                            }
                        },
                        error: function (returndata) {
                            $.Notice.error('上传失败');
                        }
                    });
                }
                self.$cancelBtn.click(function(){
                    win.closeAddOrgInfoDialog();
                });
                function updateOrg(orgModel,addressModel,msg) {
                    var wait = $.ligerDialog.waitting('正在保存中,请稍候...');
                    var orgModel = JSON.stringify(orgModel);
                    var addressModel = JSON.stringify(addressModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/organization/updateOrg", {
                        data: {orgModel: orgModel,addressModel:addressModel,mode:msg},
                        success: function (data) {
                            wait.close();
                            uploader.options.successCallBack=function(){
                                win.closeAddOrgInfoDialog(function () {
                                    $.Notice.success('保存成功！');
                                });
                            };
                            uploader.options.formData.objectId = data.obj.orgCode;
                            if (data.successFlg) {
                                if($(".filelist li").length>0) {
                                    uploader.options.server="${contextRoot}/file/upload/image";
                                    $(".uploadBtn").click();
                                }else{
                                    win.closeAddOrgInfoDialog(function () {
                                       $.Notice.success('保存成功！');
                                    });
                                }
                            } else {
                                window.top.$.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

            }
        };

        /* *************************** 页面初始化 **************************** */
//        内容折叠
        var listTit = $('.list-tit');
        listTit.on('click',function () {
            var nextNode = $(this).next();
                sty = nextNode.css('display');
            console.log(sty);
            if (sty === 'block') {
                nextNode.slideUp();
                $(this).children().html('+');
            } else {
                nextNode.slideDown();
                $(this).children().html('-');
            }
        });
        pageInit();
    })(jQuery, window);
</script>
<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/upload.js"></script>

