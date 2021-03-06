<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/webuploader.js"></script>
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/webuploader.css" />
<link rel="stylesheet" type="text/css" href="${contextRoot}/develop/webuploader/js/style.css" />
<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var organizationInfo = null;
        var orgModel = null;

        var settledWayDictId = 8;
        var orgTypeDictId = 7;
        var hosTypeDictId =  62;
        var ascriptionTypeDictId =  63;
        var zxyDictId = 70;

        // 表单校验工具类
        var jValidation = $.jValidation;

        //公钥管理弹框
        var publicKeyMsgDialog = null;

        var org =${envelop}.obj;
        var imgLop =${imageLop};
        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            organizationInfo.init();

        }

        /* *************************** 模块初始化 ***************************** */
        organizationInfo = {
            //form
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

            $traffic: $("#traffic"),
            $ing: $("#ing"),
            $lat: $("#lat"),
            $hosType:$("#hosType"),
            $ascriptionType:$("#ascriptionType"),
            $phone:$("#phone"),
            $introduction:$("#introduction"),
            $levelId:$("#levelId"),
            $legalPerson:$("#legalPerson"),
            $logoUrl:$("#logoUrl"),
            $parentHosId:$("#parentHosId"),
            $zxy:$("#zxy"),
            $logoImageShow: $('#logoImage'),
            $logoUrlButton:$("#logoUrlButton"),

            $keyReadBtn: $("#keyReadBtn"),
            $footer: $("#div_footer"),
            $updateOrgBtn: $("#div_update_btn"),
            $cancelBtn: $("#btn_cancel"),
            $publicKey: $("#div_publicKey"),
            $allotpublicKey: $("#div_allot_publicKey"),
            $publicManage: $("#div_public_manage"),

            //公钥管理弹窗控件
            $publicKeyMessage: $("#txt_publicKey_message"),
            $publicKeyValidTime: $("#lbl_publicKey_validTime"),
            $publicKeyStartTime: $("#lbl_publicKey_startTime"),

            //明细公钥信息显示
            $selectPublicKeyMessage: $("#div_publicKeyMessage"),
            $selectPublicKeyValidTime: $("#div_publicKey_validTime"),
            $selectPublicKeyStartTime: $("#div_publicKey_startTime"),
            $filePicker: $("#div_file_picker"),
            $publicKeyInfo: $("#publicKeyInfo"),
            $publicKeyInfoDiv:$("#publicKeyInfoDiv"),
            $parentPublicKey:$("#parentPublicKey"),

            $berth:$("#berth"),
            $affirmBtn: $('#div_affirm_btn'),

            $orgImageShow: $('#div_file_list'),
            $uploader: $("#div_aptitude_img_upload"),

            init: function () {
                this.initForm();
                this.bindEvents();
                addImg();
            },
            initForm: function () {
                this.$orgCode.ligerTextBox({width: 140});
                this.$fullName.ligerTextBox({width: 140});
                this.$shortName.ligerTextBox({width: 140});
                this.$location.ligerComboBox({width: 290});
                this.$orgType.ligerComboBox({width: 140});
//                this.$tags.ligerTextBox({width: 240, height: 56});
                this.$admin.ligerTextBox({width: 140, height: 28});
                this.$tel.ligerTextBox({width: 140, height: 28});
                this.$tel.removeClass('l-text-field-number');
                this.$location.addressDropdown({
                    tabsData: [
                        {
                            name: '省份',
                            code: 'id',
                            value: 'name',
                            url: '${contextRoot}/address/getParent',
                            params: {level: '1'}
                        },
                        {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                        {name: '县区', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                        {name: '街道', maxlength: 200}
                    ]
                });
                this.$location.parent().find('.u-select-title').css({
                    width: '100%'
                })
                this.$traffic.ligerTextBox({width: 140});
                this.$ing.ligerTextBox({width: 140});
                this.$lat.ligerTextBox({width: 140});
                this.$hosType.ligerComboBox({width: 140});
                this.$ascriptionType.ligerComboBox({width: 140});
                this.$phone.ligerTextBox({width: 140});
                this.$introduction.ligerTextBox({width: 396,height:104,padding:10});
                this.$levelId.ligerTextBox({width: 140});
                this.$legalPerson.ligerTextBox({width: 140});
                this.$zxy.ligerComboBox({width: 140});
                this.$settledWay.ligerComboBox({width: 140});
                this.$publicKeyInfo.ligerTextBox({width: 140});

                this.$berth.ligerTextBox({width: 140});
                this.initDDL(orgTypeDictId, this.$orgType);
                this.initDDL(settledWayDictId, this.$settledWay);
                this.initDDL(hosTypeDictId,this.$hosType);
                this.initDDL(ascriptionTypeDictId,this.$ascriptionType);
                this.initDDL(zxyDictId,this.$zxy);

                var url = '${contextRoot}/deptMember/getOrgList';
                this.$parentHosId.customCombo(url);

                this.$form.attrScan();
                var tags = '';
                if (org) {
                    for (var i = 0; i < org.tags.length; i++) {
                        tags += (org.tags)[i] + ';'
                    }
                    tags = tags.substring(0, tags.length - 1);
                    this.$form.Fields.fillValues({
                        orgCode: org.orgCode,
                        fullName: org.fullName,
                        shortName: org.shortName,
                        //location: org.location,
                        orgType: org.orgType,
                        settledWay: org.settledWay,
                        admin: org.admin,
                        tel: org.tel,
                        tags: tags,

                        traffic:org.traffic,
                        ing:org.ing,
                        lat:org.lat,
                        hosTypeId:org.hosTypeId,
                        ascriptionType:org.ascriptionType,
                        phone:org.phone,
                        introduction:org.introduction,
                        levelId:org.levelId,
                        legalPerson:org.legalPerson,
                        zxy:org.zxy,
                        berth: org.berth,

                        publicKey: org.publicKey,
                        validTime: org.validTime,
                        startTime: org.startTime
                    });
                    this.$publicKeyMessage.val(org.publicKey);
                    this.$publicKeyValidTime.html(org.validTime);
                    this.$publicKeyStartTime.html(org.startTime);
                    if (org.publicKey != null && org.publicKey != undefined) {
                        this.$publicKeyInfo.val("已分配");
                    } else {
                        this.$publicKeyInfo.val("未分配");
                    }
                    $("#parentHosId").ligerGetComboBoxManager().setValue(org.parentHosId);
                    $("#parentHosId").ligerGetComboBoxManager().setText(org.parentHosName);

                    this.$form.Fields.location.setValue([org.province, org.city, org.district, org.street]);

                    if ('${mode}' == 'view') {
                        this.$form.addClass("m-form-readonly");
                        this.$publicKey.hide();
                        this.$footer.hide();
                        this.$publicKeyInfoDiv.show();
    //                    this.$selectPublicKeyMessage.show();
    //                    this.$selectPublicKeyValidTime.show();
    //                    this.$selectPublicKeyStartTime.show();
                        this.$filePicker.addClass("hidden");
                        $("#filePicker2").hide();
                        $('#div_organization_info_form textarea').attr("disabled","disabled");
                        $(".m-form-control .l-text-trigger-cancel").remove();
                        $(".info").hide();
                    }
                    if ('${mode}' == 'modify') {
                        //this.$publicManage.hide();
                        this.$parentPublicKey.show();
                    }
                    var pic = org.imgRemotePath;
                    if (!Util.isStrEmpty(pic)) {
                        this.$orgImageShow.html('<img src="${contextRoot}/organization/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w70 f-h70"></img>');
                    }

                    var logoPic = org.logoUrl;
                    if (!Util.isStrEmpty(logoPic)) {
                        this.$logoImageShow.html('<img style="width:130px;height:80px;" src="${contextRoot}/organization/showImageLogo?storagePath='+logoPic+'" ></img>');
                    }

                }
            },
            initDDL: function (dictId, target) {
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value',
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

                $('#location,.u-dropdown-icon').click(function () {
                    self.$orgCode.click();
                });
                var validator = new jValidation.Validation(self.$form, {immediate: true, onSubmit: false});
                self.$updateOrgBtn.click(function () {
                    var orgImgHtml = self.$orgImageShow.children().length;
                    if (validator.validate()) {
                        var dataModel = $.DataModel.init();
                        self.$form.attrScan();
                        var orgAddress = self.$form.Fields.location.getValue();
                        var orgModel = self.$form.Fields.getValues();
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
                        //标签字符串转化为数组
                        var tags = orgModel.tags;
                        tags = tags.split(/[;；]/)
                        orgModel.tags = tags;
                        //原location是对象，传到controller转化成model会报错--机构、地址分开传递（json串）
                        orgModel.location = "";
                        var addressModel = {
                            province: orgAddress.names[0],
                            city: orgAddress.names[1],
                            district: orgAddress.names[2],
                            town: "",
                            street: orgAddress.names[3]
                        };

                        if (Util.isStrEmpty(orgImgHtml)) {
                            updateOrg(orgModel, addressModel, '');
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.orgModel = encodeURIComponent(JSON.stringify(orgModel) + ";" + JSON.stringify(addressModel) + ";update");
                                upload.upload();
                            } else {
                                updateOrg(orgModel, addressModel, '');
                            }
                        }

                    } else {
                        return;
                    }
                });

                function updateOrg(orgModel, addressModel, msg) {
                    var wait = $.ligerDialog.waitting('正在保存中,请稍候...');
                    var orgCode = orgModel.orgCode;
                    var orgModel = JSON.stringify(orgModel);
                    var addressModel = JSON.stringify(addressModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/organization/updateOrg", {
                        data: {orgModel: orgModel, addressModel: addressModel, mode: msg},
                        success: function (data) {
                            wait.close();
                            uploader.options.formData.objectId = orgCode;
                            uploader.options.server="${contextRoot}/file/upload/image";
                            uploader.options.successCallBack=function(){
                               closeAddOrgInfoDialog(function () {
                                    $.Notice.success('保存成功！');
                                });
                            }
                            if (data.successFlg) {
                                win.closeDialog();
                                if(uploader.getFiles().length>0){
                                    $(".uploadBtn").click();
                                }else{
                                    closeAddOrgInfoDialog(function () {
                                        $.Notice.success('保存成功！');
                                    });
                                }
                            } else {
                                closeAddOrgInfoDialog(function () {
                                });
                                window.top.$.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

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
//                                alert("上传成功");
                                $.Notice.success('上传成功');
                            }else{
//                                alert("上传失败");
                                $.Notice.error('上传失败');
                            }
                        },
                        error: function (returndata) {
//                            alert("上传失败");
                           $.Notice.error('上传失败');
                        }
                    });
                }

                self.$cancelBtn.click(function () {
                    win.closeDialog();
                });

                //公钥管理窗口点击事件
                this.$publicKey.click(function () {
                    publicKeyMsgDialog = $.ligerDialog.open({
                        title: '公钥管理',
                        width: 416,
                        height: 320,
                        target: self.$publicManage
                    });
                    //分配公钥点击事件
                    self.$allotpublicKey.click(function () {
                        var code = self.$form.Fields.orgCode.getValue();
                        var dataModel = $.DataModel.init();
                        dataModel.createRemote('${contextRoot}/organization/distributeKey', {
                            data: {orgCode: code},
                            success: function (data) {
                                if (data.successFlg) {
                                    self.$publicKeyMessage.val(data.obj.publicKey);
                                    self.$publicKeyValidTime.html(data.obj.validTime);
                                    self.$publicKeyStartTime.html(data.obj.startTime);
                                    $.ligerDialog.alert('分配公钥成功');
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    });

                    $(document.body).on('click', '#div_affirm_btn', function () {
                        publicKeyMsgDialog.close();
                    })
                });


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
        function addImg(){
            if (imgLop.detailModelList) {
                if(imgLop.detailModelList.length>0){
                    $("#dndArea").css("display",'none');
                    $(".filelist").css("display","block");
                    var html=""
                    for(var j in imgLop.detailModelList){
                        html+="<li id='WU_FILE_"+(parseInt(j)+1)+"' class=\"state-complete\">"+
                                "<p class=\"title\">服务器图片"+(parseInt(j)+1)+".JPG</p>"+
                                "<p class=\"imgWrap\">"+
                                "<img style='height: 100%;' id='imageview"+(parseInt(j)+1)+"'></p><p class=\"progress\"><span style=\"display: none; width: 0px;\">"+
                                " </span>"+
                                "</p>"+
                                "<span class=\"success\"></span>"+
                                "<div class='file-panel' ><a href='javascript:void(0);' class='fangda'></a><span class='cancel' imgnum='"+(parseInt(j)+1)+"'   id='"+imgLop.detailModelList[j]+"'>删除</span></div>"+
                                "</li>"
                    }
                    $("#filelist").html(html);
                    if ('${mode}' == 'view') {
                        $(".file-panel .cancel").hide();
                    }
                    doGetImg(1,imgLop.detailModelList[0]);
                }
            }
            $("#filelist .cancel").bind("click",function(){
                _this = this;
                $.ajax({
                    type: 'get',
                    url: '${contextRoot}/file/delete/image?storagePath='+this.id,
                    dataType: "json",
                    async:true,
                    success: function (data) {
                        if(data.successFlg){
                            $("#WU_FILE_"+$(_this).attr("imgnum")).remove();
                        }else{
                            $.Notice.error("删除失败！");
                        }
                    }
                });
            })
        }

        function doGetImg(index,storagePath){
            $.ajax({
                type: 'get',
                url: '${contextRoot}/file/view/image?storagePath='+storagePath ,
                dataType: "json",
                async:true,
                success: function (data) {
                    if(data.successFlg){
                        $("#imageview"+index).attr("src",data.obj);
                    }
                }
            });
            if (imgLop.detailModelList) {
                if(index<imgLop.detailModelList.length){
                    setTimeout(function(){
                        doGetImg((index+1),imgLop.detailModelList[index])
                    },200);
                }
            }
        }


    })(jQuery, window);
</script>
<script type="text/javascript" src="${contextRoot}/develop/webuploader/js/upload.js"></script>