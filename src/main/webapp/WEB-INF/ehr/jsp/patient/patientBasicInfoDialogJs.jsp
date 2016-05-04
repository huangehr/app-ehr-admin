<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
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
        var patientModel =${patientModel}.obj;
        var idCardNo =patientModel.idCardNo;
        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            patientInfo.init();
            //todo:暂不发布
            $("#btn_archive").hide();
            $("#btn_home_relation").hide();
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
                $.get("${contextRoot}/home_relation/home_relationship",function(data){
                    $("#div_home_relation").html(data);
                    home.list.event();
                });
                $(window).resize();
            });
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
            $cardInfo:$("#div_card_info"),
            $archiveInfo:$("#div_archive_info"),

            $realName: $("#inp_realName"),
            $idCardNo: $("#inp_idCardNo"),
            $gender: $('input[name="gender"]', this.$form),
            $patientNation: $("#inp_patientNation"),
            $patientNativePlace: $("#inp_patientNativePlace"),
            $patientMartialStatus: $("#inp_select_patientMartialStatus"),
            $patientBirthday: $("#inp_patientBirthday"),
            $birthPlace: $("#inp_birthPlace"),
            $birthPlaceTitle: $("#div_birthPlaceTitle"),
            $homeAddress: $("#inp_homeAddress"),
            $homeAddressTitle: $("#div_homeAddressTitle"),
            $workAddress: $("#inp_workAddress"),
            $workAddressTitle: $("#div_workAddressTitle"),
            $residenceType: $('input[name="residenceType"]', this.$form),
            $patientTel: $("#inp_patientTel"),
            $patientEmail: $("#inp_patientEmail"),
            picPath:$('#div_file_list'),

            init: function () {
                this.initForm();
                this.bindEvents();
                cardFormInit.init();
                archiveFormInit.init();
                $("#div_card_info").hide();
                $("#div_home_relation").hide();
                $("#div_archive_info").hide();
            },
            initForm: function () {
                this.$realName.ligerTextBox({width: 240});
                this.$idCardNo.ligerTextBox({width: 240});
                this.$gender.ligerRadio();
                //this.$patientNation.ligerTextBox({width: 240});
                this.$patientNativePlace.ligerTextBox({width: 240});
                this.$patientBirthday.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$birthPlace.ligerTextBox({width: 240});
                this.$homeAddress.ligerTextBox({width: 240});
                this.$workAddress.ligerTextBox({width: 240});
                this.$residenceType.ligerRadio();
                this.$patientTel.ligerTextBox({width: 240});
                this.$patientEmail.ligerTextBox({width: 240});
                //this.$patientMartialStatus.ligerTextBox({width: 240});
                this.$patientMartialStatus.ligerComboBox(
                        {
                            url: '${contextRoot}/dict/searchDictEntryList',
                            valueField: 'code',
                            textField: 'value',
                            dataParmName: 'detailModelList',
                            urlParms: {
                                dictId: 4
                            }
                        });
                this.$patientNation.ligerComboBox(
                        {
                            url: '${contextRoot}/dict/searchDictEntryList',
                            valueField: 'code',
                            textField: 'value',
                            dataParmName: 'detailModelList',
                            urlParms: {
                                dictId: 5
                            }
                        });

                this.$form.attrScan();
                this.$form.Fields.fillValues({
                    name: patientModel.name,
                    idCardNo: idCardNo,
                    gender: patientModel.gender,
                    nation: patientModel.nation,
                    nativePlace: patientModel.nativePlace,
                    martialStatus: patientModel.martialStatus,
                    birthday: patientModel.birthday,
                    birthPlaceFull: patientModel.birthPlaceFull,
                    homeAddressFull: patientModel.homeAddressFull,
                    workAddressFull: patientModel.workAddressFull,
                    residenceType: patientModel.residenceType,
                    telephoneNo: patientModel.telephoneNo,
                    email: patientModel.email
                });
                this.$birthPlaceTitle.attr("title",patientModel.birthPlaceFull);
                this.$homeAddressTitle.attr("title",patientModel.homeAddressFull);
                this.$workAddressTitle.attr("title",patientModel.workAddressFull);
                var pic = patientModel.picPath;
                if(!(Util.isStrEquals(pic,null)||Util.isStrEquals(pic,""))){
                    this.picPath.html('<img src="${contextRoot}/patient/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w88 f-h110" ></img>');
                }
            },
            bindEvents: function () {
            }
        };
        cardFormInit = {
            $selectCardType:$('#inp_select_cardType'),
            $search: $("#div_search"),
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
                this.$cardForm.attrScan();
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
                            var html = '<a href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "card:archive:view", row.id,row.cardType) + '">查看</a>  ';
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
                //查看档案信息
                $.subscribe('card:archive:view',function(event,id,cardType){
                    //todo:档案赞不发布，先查看卡信息
                    $.ligerDialog.open({ width:450, height:500,target: cardFormInit.$cardBasicMsg});
                    var self = this;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/card/getCard', {
                        data: {id: id,cardType:cardType},
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
                });
                //搜索
                cardFormInit.$search.click(function(){
                    cardInfoRefresh();
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