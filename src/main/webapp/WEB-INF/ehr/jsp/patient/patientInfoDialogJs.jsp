<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>
    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var patientInfo = null;

        var cardInfoGrid = null;
        var archiveInfoGrid = null;

        var cardFormInit = null;
        var archiveFormInit = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
        var dataModel = $.DataModel.init();
        var patientModel = "";
        var idCardNo="";
        var patientDialogType = '${patientDialogType}';
        if (!(Util.isStrEquals(patientDialogType, 'addPatient'))) {
            patientModel =${patientModel}.obj;
            idCardNo = patientModel.idCardNo;
//            //todo:暂不发布
//            $("#btn_archive").hide();
//            $("#btn_home_relation").hide();
        }else{
            $(".pop_tab").hide();
        }
        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            patientInfo.init();
            if (!(Util.isStrEquals(patientDialogType, 'addPatient'))) {
                cardFormInit.init();
                archiveFormInit.init();
                $(window).resize();
            }
            tab_click();
        }
        function tab_click(){
            $("#btn_basic").click(function(){
                $("li").removeClass('cur');
                $(this).addClass('cur');
                $("#div_patient_info_form").show();
                $("#div_card_info").hide();
                $("#div_home_relation").hide();
                $("#div_archive_info").hide();
                $(window).resize();
            });
            $("#btn_card").click(function(){
                $("li").removeClass('cur');
                $(this).addClass('cur');
                $("#div_card_info").show();
                $("#div_patient_info_form").hide();
                $("#div_home_relation").hide();
                $("#div_archive_info").hide();
                $(window).resize();
            });
            $("#btn_archive").click(function(){
                $("li").removeClass('cur');
                $(this).addClass('cur');
                $("#div_archive_info").show();
                $("#div_patient_info_form").hide();
                $("#div_card_info").hide();
                $("#div_home_relation").hide();
                $(window).resize();
            });
            $("#btn_home_relation").click(function(){
                $("li").removeClass('cur');
                $(this).addClass('cur');
                $("#div_home_relation").show();
                $("#div_patient_info_form").hide();
                $("#div_card_info").hide();
                $("#div_archive_info").hide();
                $.get("${contextRoot}/home_relation/home_relationship?id="+$("#inp_idCardNo").val(),function(data){
                    $("#div_home_relation").html(data);
                    home.list.init();
                });
                $(window).resize();
            });
        }
        function updatePatient(patientJsonData){
            dataModel.updateRemote("${contextRoot}/patient/updatePatient", {
                data: {patientJsonData:patientJsonData,patientDialogType:patientDialogType},
                success: function (data) {
                    if(data.successFlg){
                        if (Util.isStrEquals(patientDialogType, 'addPatient')){
                            win.parent.$.Notice.success('新增成功');
                        }else{
                            win.parent.$.Notice.success('修改成功');
                        }
                    }else{
                        if (Util.isStrEquals(patientDialogType, 'addPatient')){
                            win.parent.$.Notice.error('新增失败');
                        }else{
                            win.parent.$.Notice.error('修改失败');
                        }
                    }
                    win.parent.patientDialogClose();
                    //dialog.close();
                }
            })
        }
        function cardInfoRefresh(){
            var searchNm = cardFormInit.$cardSearch.val();
            var cardType = cardFormInit.$selectCardType.ligerComboBox().getValue();
            cardFormInit.searchCard(searchNm,cardType);
        }
        function archiveInfoRefresh(){
            var start = archiveFormInit.$selectStart.val();
            var end = archiveFormInit.$selectEnd.val();
            var org = archiveFormInit.$selectArchiveOrg.ligerComboBox().getValue();
            archiveFormInit.searchCard(start,end,org);
        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        patientInfo = {
            $form: $("#div_patient_info_form"),
            $realName: $("#inp_realName"),
            $idCardNo: $("#inp_idCardNo"),
            $gender: $('input[name="gender"]', this.$form),
            $patientNation: $("#inp_patientNation"),
            $patientNativePlace: $("#inp_patientNativePlace"),
            $patientMartialStatus: $("#inp_select_patientMartialStatus"),
            $patientBirthday: $("#inp_patientBirthday"),
            $birthPlace: $("#inp_birthPlace"),
            $homeAddress: $("#inp_homeAddress"),
            $workAddress: $("#inp_workAddress"),
            $residenceType: $('input[name="residenceType"]', this.$form),
            $patientTel: $("#inp_patientTel"),
            $patientEmail: $("#inp_patientEmail"),
            $updateBtn: $("#div_update_btn"),
            $cancelBtn: $("#div_cancel_btn"),
            $resetArea: $("#reset_password"),
            $resetPassword: $("#div_resetPassword"),
            $patientImgUpload: $("#div_patient_img_upload"),
            $patientCopyId:$("#inp_patientCopyId"),
            $picPath:$('#div_file_list'),

            init: function () {
                var self = this;
                $("#div_card_info").hide();
                $("#div_home_relation").hide();
                $("#div_archive_info").hide();
                self.$gender.eq(0).attr("checked",'true');
                self.initForm();
                self.bindEvents();

                self.$patientImgUpload.instance = self.$patientImgUpload.webupload({
                    server: "${contextRoot}/patient/updatePatient",
                    pick: {id:'#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
//                    formData:{msg:"upload"},
                    auto: false,
                    async:false
                });

                self.$patientImgUpload.instance.on( 'uploadSuccess', function( file, resp ) {
                    $('#inp_img_url').val(resp.url);
                    $( '#'+file.id ).addClass('upload-state-done');
                    $.ligerDialog.alert("保存成功",function () {
                        win.parent.patientDialogClose();
                        //dialog.close();
                    });
                });
            },
            initForm: function () {
                var self = this;
                self.$realName.ligerTextBox({width: 240});
                self.$idCardNo.ligerTextBox({width: 240});
                self.$gender.ligerRadio();
                self.initDDL(4,this.$patientMartialStatus);
                self.initDDL(5, this.$patientNation);
                self.$patientNation.ligerTextBox({width: 240});
                self.$patientNativePlace.ligerTextBox({width: 240});
                self.$patientBirthday.ligerDateEditor({format: "yyyy-MM-dd"});
                self.initAddress(self.$birthPlace);
                self.initAddress(self.$homeAddress);
                self.initAddress(self.$workAddress);
                self.$residenceType.ligerRadio();
                self.$patientTel.ligerTextBox({width: 240});
                self.$patientEmail.ligerTextBox({width: 240});
                self.$resetArea.hide();
                self.$form.attrScan();
                if (!(Util.isStrEquals(patientDialogType, 'addPatient'))) {
                    self.$resetArea.show();
                    var birthPlaceInfo = patientModel.birthPlaceInfo;
                    var homeAddressInfo = patientModel.homeAddressInfo;
                    var workAddressInfo = patientModel.workAddressInfo;
                    self.$form.Fields.fillValues({
                        name: patientModel.name,
                        idCardNo: patientModel.idCardNo,
                        gender: patientModel.gender,
                        nativePlace: patientModel.nativePlace,
                        birthday: patientModel.birthday,
                        birthPlaceInfo: birthPlaceInfo&&[birthPlaceInfo.province,birthPlaceInfo.city,birthPlaceInfo.district,birthPlaceInfo.street],
                        homeAddressInfo: homeAddressInfo&&[homeAddressInfo.province,homeAddressInfo.city,homeAddressInfo.district,homeAddressInfo.street] ,
                        workAddressInfo: workAddressInfo&&[workAddressInfo.province,workAddressInfo.city,workAddressInfo.district,workAddressInfo.street],
                        residenceType: patientModel.residenceType,
                        telephoneNo: patientModel.telephoneNo,
                        email: patientModel.email
                    });
                    self.$patientCopyId.val(patientModel.idCardNo);

                    var pic = patientModel.picPath;
                    if(!Util.isStrEmpty(pic)){
                        self.$picPath.html('<img src="${contextRoot}/patient/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w88 f-h110"></img>');
                    }
                }
            },
            initDDL: function (dictId, target) {
                var self = this;
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value',
                    autocomplete:true,
                    onSuccess: function () {
                        self.$form.Fields.fillValues({nation: patientModel.nation});
                        self.$form.Fields.fillValues({martialStatus: patientModel.martialStatus});
                    }
                });
            },
            initAddress: function (target){
                target.addressDropdown({tabsData:[
                    {name: '省份',code:'id',value:'name', url: '${contextRoot}/address/getParent', params: {level:'1'}},
                    {name: '城市',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                    {name: '县区',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                    {name: '街道',maxlength: 200}
                ]});
            },

            bindEvents: function () {
                var self = this;
                $(".u-dropdown-icon").click(function(){
                    $('#inp_realName').click();
                });
                var idCardNo = self.$form.Fields.idCardNo.getValue();
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    if(Util.isStrEquals($(elm).attr('id'),'inp_idCardNo')){
                        var copyCardNo = self.$patientCopyId.val();
                        var result = new jValidation.ajax.Result();
                        var idCardNo = self.$idCardNo.val();
                        var dataModel = $.DataModel.init();
                        if(Util.isStrEquals(idCardNo,copyCardNo)){
                            return true;
                        }
                        dataModel.fetchRemote("${contextRoot}/patient/checkIdCardNo", {
                            data: {searchNm:idCardNo},
                            async: false,
                            success: function (data) {
                                if (!data.successFlg) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("该身份证已被使用");
                                }
                            }
                        });
                        return result;
                    }
                }});

                //修改人口信息
                patientInfo.$updateBtn.click(function () {
                    var picHtml = self.$picPath.children().length;
                    if(validator.validate()){
                        var addressList = self.$form.Fields.birthPlaceInfo.getValue();
                        var homeAddressList = self.$form.Fields.homeAddressInfo.getValue();
                        var workAddressList = self.$form.Fields.workAddressInfo.getValue();
                        var values = $.extend({},self.$form.Fields.getValues(),{
                            birthPlaceInfo: {
                                province:  addressList.names[0] || null,
                                city: addressList.names[1] || null,
                                district: addressList.names[2] || null,
                                street: addressList.names[3] || null
                            },
                            homeAddressInfo:{
                                province:  homeAddressList.names[0] || null,
                                city: homeAddressList.names[1] || null,
                                district: homeAddressList.names[2] || null,
                                street: homeAddressList.names[3] || null
                            },
                            workAddressInfo:{
                                province:  workAddressList.names[0] || null,
                                city: workAddressList.names[1] || null,
                                district: workAddressList.names[2] || null,
                                street: workAddressList.names[3] || null
                            }
                        });
                        var jsonData = JSON.stringify(values)+";"+patientDialogType;
                        if(picHtml == 0){
                            updatePatient(jsonData);
//                        updatePatient(JSON.stringify(values));
                        }else{
                            var upload = self.$patientImgUpload.instance;
                            var image = upload.getFiles().length;
                            if(image){
                                upload.options.formData.patientJsonData =   encodeURIComponent(jsonData);
                                upload.upload();
                                win.parent.patientDialogRefresh();
                            }else{
                                updatePatient(jsonData);
                            }
                        }
                    }else{
                        return
                    }
                });

                //重置密码
                patientInfo.$resetPassword.click(function () {
                    var patientIdCardNo = self.$form.Fields.idCardNo.getValue();
                    $.ligerDialog.confirm('确认重置密码？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                        if (yes) {
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/patient/resetPass", {
                                data: {idCardNo: patientIdCardNo},
                                success: function (data) {
                                    if (data.successFlg) {
                                        win.parent.$.Notice.success('密码修改成功');
                                    } else {
                                        win.parent.$.Notice.error('密码修改失败');
                                    }
                                    //dialog.close();
                                }
                            })
                        }
                    });


                });
                //关闭dailog的方法
                patientInfo.$cancelBtn.click(function(){
                    win.parent.patientDialogClose();
                    //dialog.close();
                })
            }
        };

        //卡管理
        cardFormInit = {
            $selectCardType:$('#inp_select_cardType'),
            $addCard: $("#div_addCard"),
            $cardSearch: $("#inp_card_search"),
            $cardBasicMsg: $("#div_card_basicMsg"),

            $cardForm: $("#div_card_info_form"),

            $cardType:$("#inp_cardType"),
            $cardNo:$("#inp_cardNo"),
            $holderName:$("#inp_HolderName"),
            $issueAddress:$("#inp_issueAddress"),
            $issueOrg:$("#inp_issueOrg"),
            $addDate:$("#inp_addDate"),
            $cardStatus:$("#inp_cardStatus"),
            $cardExplain:$("#inp_cardExplain"),

            init: function () {
                this.$cardType.ligerTextBox({width: 240});
                this.$cardNo.ligerTextBox({width: 240});
                this.$holderName.ligerTextBox({width: 240});
                this.$issueAddress.ligerTextBox({width: 240});
                this.$issueOrg.ligerTextBox({width: 240});
                this.$addDate.ligerTextBox({width: 240});
                this.$cardStatus.ligerTextBox({width: 240});
                this.$cardExplain.ligerTextBox({width: 240});
                this.$selectCardType.ligerComboBox(
                        {
                            url: '${contextRoot}/dict/searchDictEntryList',
                            valueField: 'code',
                            textField: 'value',
                            dataParmName: 'detailModelList',
                            urlParms: {
                                dictId: 10
                            },
                            width:120,
                            autocomplete: true,
                            onSelected: function (v, t) {
                                cardFormInit.searchCard(cardFormInit.$cardSearch.val(), v);
                            }
                        });
                this.$cardSearch.ligerTextBox({
                    width: 240, isSearch: true, search: function () {
                        cardInfoRefresh();
                    }
                });
                this.$cardForm.attrScan();
                cardInfoGrid = cardFormInit.$cardForm.ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/card/searchCard',
                    parms: {
                        idCardNo: idCardNo,
                        searchNm: '',
                        cardType: ''
                    },
                    columns: [
                        { name: 'id',hide: true},
                        { name: 'cardType',hide: true},
                        {display: '类型', name: 'typeName', width: '10%'},
                        {display: '卡号', name: 'number', width: '30%'},
                        {display: '发行机构', name: 'releaseOrgName', width: '20%'},
                        {display: '创建时间', name: 'createDate', width: '18%'},
                        {display: '状态', name: 'statusName', width: '8%'},
                        {
                            display: '操作', name: 'operator', width: '14%', render: function (row) {
                            var html = '<a href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "patient:cardInfoModifyDialog:open", row.id,row.cardType) + '">解除关联</a>  ';
                            return html;
                        }
                        }
                    ],
                    allowHideColumn:false,
                    inWindow: false,
                    height:400,
                    onDblClickRow: function (row) {
                        //查看卡信息
                        $.ligerDialog.open({ width:450, height:500,target: cardFormInit.$cardBasicMsg});
                        var self = this;
                        var dataModel = $.DataModel.init();
                        dataModel.createRemote('${contextRoot}/card/getCard', {
                            data: {id: row.id,cardType:row.cardType},
                            success: function (data) {
                                if (data.successFlg) {
                                    cardFormInit.$cardForm.Fields.fillValues({
                                        cardType: data.obj.typeName,
                                        number: data.obj.number,
                                        ownerName: data.obj.ownerName,
                                        local: data.obj.local,
                                        releaseOrgName: data.obj.releaseOrgName,
                                        createDate: data.obj.createDate,
                                        statusName: data.obj.statusName,
                                        description: data.obj.description
                                    });
                                }
                            }
                        });
                    }
                }));
                cardInfoGrid.adjustToWidth();
                this.bindEvents();
            },

            searchCard: function (searchNm, cardType) {
                cardInfoGrid.setOptions({parms: {searchNm: searchNm, idCardNo: idCardNo, cardType: cardType},newPage:1});
                cardInfoGrid.loadData(true);
            },
            bindEvents: function () {
                //解绑卡信息
                $.subscribe('patient:cardInfoModifyDialog:open',function(event,id,cardType){
                    $.ligerDialog.confirm('确认解除关联该卡信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                        if (yes) {
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote('${contextRoot}/card/detachCard', {
                                data: {id: id,cardType:cardType},
                                success: function (data) {
                                    if (data.successFlg) {
                                        $.ligerDialog.alert('解除关联成功');
                                        cardFormInit.searchCard();
                                    } else {
                                        $.Notice.error('解除关联失败');
                                    }
                                }
                            });
                        }
                    })
                });
                //添加卡
                cardFormInit.$addCard.click(function(){
                    var idCardNo = patientInfo.$form.Fields.idCardNo.getValue();
                    $.ligerDialog.open({
                        height: 640,
                        width: 600,
                        title: '新增卡',
                        url: '${contextRoot}/card/addCardInfoDialog',
                        urlParms: {
                            idCardNo: idCardNo
                        },
                        onClosed: function () {
                            cardInfoRefresh();
                        }
                    })
                })
            }

        };
        //档案信息
        archiveFormInit = {
            $selectStart:$('#inp_select_start'),
            $selectEnd:$('#inp_select_end'),
            $selectArchiveOrg:$('#inp_select_archiveOrg'),
            $searchArchive:$('#div_search_archive'),
            $archiveForm: $("#div_archive_info_form"),
            init: function () {
                this.$selectStart.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$selectEnd.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$selectArchiveOrg.addressDropdown({
                    tabsData: [
                        {
                            name: '省份',
                            code: 'id',
                            value: 'name',
                            url: '${contextRoot}/address/getParent',
                            params: {level: '1'}
                        },
                        {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                        {
                            name: '医院',
                            code: 'orgCode',
                            value: 'fullName',
                            url: '${contextRoot}/address/getOrgs',
                            beforeAjaxSend: function (ds, $options) {
                                var province = $options.eq(0).attr('title'),
                                        city = $options.eq(1).attr('title');
                                ds.params = $.extend({}, ds.params, {

                                    province: province,
                                    city: city
                                });
                            }
                        }
                    ]
                });

                archiveInfoGrid = this.$archiveForm.ligerGrid($.LigerGridEx.config({
                    <%--url: '${contextRoot}/archive/searchArchive',--%>
                    url: '${contextRoot}/card/searchCard',
                    parms: {
                        start: '',
                        end: '',
                        org: ''
                    },
                    columns: [
                        { name: 'id',hide: true},
                        {display: '就诊时间', name: 'archiveTime', width: '28%'},
                        {display: '就诊机构', name: 'archiveOrg', width: '30%'},
                        {display: '关联时间', name: 'archiveRelateTime', width: '28%'},
                        {
                            display: '操作', name: 'operator', width: '14%', render: function (row) {
                            var html = '<a href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "patient:archiveView:open", row.id) + '">查看</a>  ';
                            return html;
                        }
                        }
                    ],
                    allowHideColumn:false,
                    inWindow: false,
                    height:400
                }));
                archiveInfoGrid.adjustToWidth();
                this.bindEvents();
            },

            searchArchive: function (start,end, org) {
                archiveInfoGrid.setOptions({parms: {start: start, end: end, org: org},newPage:1});
                archiveInfoGrid.loadData(true);
            },
            bindEvents: function () {
                //查看档案
                $.subscribe('patient:archiveView:open',function(event,id,cardType){

                });
                //档案搜索
                archiveFormInit.$searchArchive.click(function(){

                });
            }

        };

        /* *************************** 模块初始化结束 ***************************** */

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */


    })(jQuery, window);
</script>