<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;

            // 画面用户信息表对象
            var grid = null;

            // 页面表格条件部模块
            var patientRetrieve = null;

            // 页面主模块，对应于用户信息表区域
            var patientMaster = null;

            var patientDialog=null;

            var filters="";//未识别列表搜索
            /* ************************** 变量定义结束 ******************************** */

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                patientRetrieve.init();
                patientMaster.init();
            }

            function reloadGrid (url, params) {
//                grid.set({
//                    url: url,
//                    parms: params
////                    newPage:1
//                });
//                grid.reload();
                grid.setOptions({parms: params});
                grid.loadData(true);
            }
            /* *************************** 函数定义结束******************************* */

            patientRetrieve = {
                $element: $(".m-retrieve-area"),
                $knownForm: $("#known_form"),
                $unknownForm: $("#unknown_form"),
                $searchBtn: $('#btn_search'),
                $searchPatient: $("#inp_search"),
                $homeAddress: $("#search_homeAddress"),
                $newPatient: $("#div_new_patient"),
                $searchHhomeAddress: $("#search_homeAddress"),
                $sex: $('#sex'),
                $starTime: $('#star_time'),
                $endTime: $('#end_time'),
                //未识别筛选框
                $searchName: $("#inp_name"),
                $searchCardNo: $("#inp_card_no"),
                $searchTelephone: $("#inp_telephone"),
                $searchBtnUn: $('#btn_search_un'),

//                $jg: $('#jg'),
                init: function () {
                    this.$knownForm.show();
                    this.$sex.ligerComboBox({
                        valueField: 'code',
                        textField: 'value',
                        width: '100',
                        data:[{
                            code: '1',
                            value: '男'
                        },{
                            code: '2',
                            value: '女'
                        }]
                    });
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false});

                    this.$searchPatient.ligerTextBox({width: 170 });
                    this.$searchHhomeAddress.ligerTextBox({width: 200 });
                    this.$searchName.ligerTextBox({width: 200 });
                    this.$searchCardNo.ligerTextBox({width: 200 });
                    this.$searchTelephone.ligerTextBox({width: 200 });
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };
            patientMaster = {
                KnownPatientGrid:null,
                UnknowArchivesGrid:null,
                init: function () {
                    var self = this;
                    var num=1 ;
                    var afternum;
                    self.KnownPatientGrid =grid = $("#div_patient_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/patient/searchPatientByParams',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: '',
                            searchType: '',
                            homeAddress:'',
                            searchRegisterTimeStart: '',
                            searchRegisterTimeEnd: '',
                            gender: ''
                        },
                       allowHideColumn:false,
                        columns: [
                            {display: '姓名', name: 'name', width: '10%',align: 'left', render:function (row) {
                                var name = row.name;
                                var newName = "";
                                var html = "";
                                if (null != name && name != "") {
                                    var length = name.length;
                                    if (length<=2) {
                                        newName = name.substring(0,1) + "*";
                                    } else {
                                        newName = name.substring(0,1) + "*" + name.substring(length-1);
                                    }
                                }
                                html = '<sec:authorize url="/patient/viewPatient">' + name + '</sec:authorize>';
                                if (html == "") {
                                    html = newName;
                                }
                                return html;
                            }},
                            {display: '身份证号', name: 'idCardNo', width: '15%', align: 'left', render: function(row) {
                                var idCardNo = row.idCardNo;
                                var html = "";
                                if (null != idCardNo && idCardNo != "") {
                                    var length = idCardNo.length;
                                    var pre = idCardNo.substring(0, 6);
                                    var suf = idCardNo.substring(length-4, length);
                                    var middle = "";
                                    for (var i=0; i < length-10; i++) {
                                        middle += "*";
                                    }
                                    html = '<sec:authorize url="/patient/viewPatient">' + idCardNo + '</sec:authorize>';
                                    if (html == "") {
                                        html = pre + middle + suf;
                                    }
                                }
                                return html;
                            }},
                            {display: '性别', name: 'gender', width: '5%',  render : function (row) {
                                if (row.gender == 0){
                                    return "未知";
                                } else if(row.gender == 1){
                                    return "男";
                                } else {
                                    return "女";
                                }
                            }},
                            {display: '联系方式', name: 'telephoneNo', width: '10%', resizable: true,align: 'left', render: function(row) {
                                var telephoneNo = row.telephoneNo;
                                var html = "";
//                                var myreg=/^(\d{3,4}-)?\d{7,8}|^[1][0-9]{10}$/;
                                var myreg=/^[1][0-9]{10}$/;
                                if (telephoneNo && myreg.test(telephoneNo)) {
                                    var length = telephoneNo.length;
                                    var pre = telephoneNo.substring(0, 2);
                                    var suf = telephoneNo.substring(length - 2, length);
                                    var middle = "";
                                    for (var i=0; i < length-4; i++) {
                                        middle += "*";
                                    }
                                    html = '<sec:authorize url="/patient/viewPatient">' + telephoneNo + '</sec:authorize>';
                                    if (html == "") {
                                        html = pre + middle + suf;
                                    }
                                }
                                return html;
                            }},
                            {display: '家庭地址', name: 'homeAddress', width: '25%', minColumnWidth: 20,align: 'left'},
                            {display: '注册时间', name: 'registerTime', width: '15%', minColumnWidth: 20,align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 160, render: function (row) {
                                var html = '<a href="javascript:void(0)" target="_blank" style="display: inline-block;height: 33px;padding: 0 10px;line-height: 40px;vertical-align: top;" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "patient:patientBroswerInfoDialog:open", row.idCardNo) + '">档案查询</a>';

                                html += '<sec:authorize url="/patient/updatePatient"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "patient:patientInfoModifyDialog:open", row.idCardNo,row.userId) + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/patient/deletePatient"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "patient:patientInfoModifyDialog:delete", row.idCardNo) + '"></a></sec:authorize>';
                                return html;
                            }
                            }
                        ],
                        enabledSort:false,
                        onDblClickRow: function (row) {
                            self.showUserInfo(row.idCardNo,row.userId);
                        }
                    }));
                    self.KnownPatientGrid.adjustToWidth();
                    self.UnknowArchivesGrid = $("#div_unknowarchives_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/archiveRelation/page',
                        parms:{
                            filters:filters,
                            size:15,
                            sort:'',
                        },
                        pageSize:15,
                        width:'97%',
                        columns: [
                            {display: '档案编号', name: 'sn', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '姓名', name: 'name', width: '10%',isAllowHide: false, align: 'left'},
                            {display: '性别', name: 'gender', width: '5%', isAllowHide: false, align: 'left',
                                render : function (row) {
                                    if (row.gender == 0){
                                        return "未知";
                                    } else if(row.gender == 1){
                                        return "男";
                                    } else {
                                        return "女";
                                    }
                                }
                            },
                            {display: '就诊卡类型', name: 'card_type', width: '20%',isAllowHide: false, align: 'left'},
                            {display: '就诊卡号码', name: 'card_no', width: '20%',isAllowHide: false, align: 'left'},
                            {display: '手机号码', name: 'telephone', width: '10%',  isAllowHide: false,align: 'left'},
                            {display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '<a href="javascript:void(0)" target="_blank" style="display: inline-block;height: 40px;padding: 0 10px;line-height: 40px;vertical-align: top;" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "patient:patientBroswerInfoDialog:open", row.id_card_no) + '">档案查询</a>';
                                return html;
                            }
                            }
                        ],
                        enabledSort:false,
                        method:'GET'
                    }));
                    self.UnknowArchivesGrid.adjustToWidth();
                    this.bindEvents();
                },
                showUserInfo: function (id,userId) {
                    var wait=null;
                    wait = parent._LIGERDIALOG.waitting('正在加载中...');
                    var dialog = parent._LIGERDIALOG.open({
                        title:'居民信息详情',
                        height: 630,
                        width: 600,
                        url: '${contextRoot}/patient/patientDialogType',
                        load: true,
                        isDrag:true,
                        show:false,
                        urlParms: {
                            idCardNo: id,
                            userId:userId,
                            patientDialogType: 'patientInfoMessage'
                        },
                        isHidden: false,
                        onLoaded:function() {
                            wait.close();
                            dialog.show();
                        }
                    });
                    dialog.hide();
                },
                /*searchPatient: function (searchNm) {
                    grid.setOptions({parms: {searchNm: searchNm}});
                    grid.loadData(true);
                },*/
                reloadGrid: function () {
                    //var values = retrieve.$element.Fields.getValues();
                    patientRetrieve.$knownForm.attrScan();
                    var values = patientRetrieve.$knownForm.Fields.getValues();
                    values.gender = values.gender.trim() == '男' ? '1' : values.gender.trim() == '女' ? '2' : '';
                    debugger
                    reloadGrid.call(this, '${contextRoot}/patient/searchPatientByParams', values);
                },
                reloadunknownGrid: function () {
                    //var values = retrieve.$element.Fields.getValues();
                    patientRetrieve.$unknownForm.attrScan();
                    var values = patientRetrieve.$unknownForm.Fields.getValues();
                    filters="";
                    if(values.name){filters+="name="+values.name+";"}
                    if(values.card_no){filters+="card_no="+values.card_no+";"}
                    if(values.telephone){filters+="telephone="+values.telephone+";"}
                    debugger
                    this.UnknowArchivesGrid.setOptions({parms: {filters: filters,sort:"",size:15}});
                    this.UnknowArchivesGrid.reload()
                },
                bindEvents: function () {
                    var self = this;
                    patientRetrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        patientMaster.reloadGrid();
                    });
                    patientRetrieve.$searchBtnUn.click(function () {
                        self.UnknowArchivesGrid.options.newPage = 1;
                        patientMaster.reloadunknownGrid();
                    });
//                    点击tab 切换表格
                    $(".btn-group").on("click",".btn",function() {
                        var index = $(this).index();
                        $(".btn-group").find(".btn").removeClass("active");
                        $(this).addClass("active");
                        if(index==0){
                            patientRetrieve.$knownForm.show();
                            patientRetrieve.$unknownForm.hide();
                            $("#div_patient_info_grid").show();
                            $("#div_unknowarchives_info_grid").hide();
                            self.KnownPatientGrid.reload();
                        }else {
                            patientRetrieve.$unknownForm.show();
                            patientRetrieve.$knownForm.hide();
                            $("#div_patient_info_grid").hide();
                            $("#div_unknowarchives_info_grid").show();
                            self.UnknowArchivesGrid.reload();
                        }
                    });
                    //新增人口信息
                    patientRetrieve.$newPatient.click(function(){
                        var wait =  parent._LIGERDIALOG.waitting("正在加载...");
                        patientDialog = parent._LIGERDIALOG.open({
                            isHidden:false,
                            title:'新增居民信息',
                            width:600,
                            height:600,
                            load: true,
                            isDrag:true,
                            show:false,
                            url:'${contextRoot}/patient/patientDialogType',
                            urlParms:{
                                patientDialogType:'addPatient'
                            },
                            onLoaded:function() {
                                wait.close(),
                                patientDialog.show()
                            }
                        })
                        patientDialog.hide();
                    });
                    //修改人口信息
                  $.subscribe('patient:patientInfoModifyDialog:open',function(event,idCardNo,userId){
                      var wait =  parent._LIGERDIALOG.waitting("正在加载...");
                      patientDialog = parent._LIGERDIALOG.open({
                            isHidden:false,
                            title:'修改居民信息',
                            width:600,
                            height:600,
                            load: true,
                            isDrag:true,
                            show:false,
                            url:'${contextRoot}/patient/patientDialogType',
                            urlParms:{
                                userId:userId,
                                idCardNo:idCardNo,
                                patientDialogType:'updatePatient'
                            },
                            onLoaded:function() {
                                wait.close(),
                                patientDialog.show()
                            }
                        })
                      patientDialog.hide();
                    });
                    //删除人口信息
                    $.subscribe('patient:patientInfoModifyDialog:delete', function (event, idCardNo) {
                        parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/patient/deletePatient', {
                                    data: {idCardNo: idCardNo},
                                    success: function (data) {
                                        debugger
                                        if (data.successFlg) {
                                            parent._LIGERDIALOG.success('操作成功。');
                                            patientMaster.reloadGrid();
                                        } else {
                                            parent._LIGERDIALOG.error('操作失败。');
                                        }
                                    }
                                });
                            }
                        });
                    });
                    $.subscribe('patient:patientBroswerInfoDialog:open',function (event,idCardNo) {
                        $.ajax({
                            url: '${contextRoot}/login/checkInfo',
                            data: {
                                idCardNo: idCardNo
                            },
                            dataType: 'json',
                            type: 'GET',
                            success: function (data) {
                                if (data.successFlg) {
                                    window.open('${contextRoot}/login/broswerSignin?idCardNo='+idCardNo,'_blank');
                                } else {
                                    parent._LIGERDIALOG.success('该居民无档案信息');
                                }
                            },
                            error: function (e) {
                                parent._LIGERDIALOG.error('出错了');
                            }
                        });
                    })
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.parent.patientDialogRefresh = win.patientDialogRefresh = function () {
                patientMaster.reloadGrid();
            };
            win.parent.patientDialogClose = function () {
                patientDialog.close();
                patientMaster.reloadGrid();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>