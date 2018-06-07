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
            var retrieve = null;

            // 页面主模块，对应于用户信息表区域
            var master = null;

            var dialog = null;
            /* ************************** 变量定义结束 ******************************** */
            var nowDate = '${nowDate}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
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

            retrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $starTime: $('#star_time'),
                $endTime: $('#end_time'),
//                $jg: $('#jg'),
                init: function () {
                    this.$element.show();
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});

                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };
            master = {
                resourceGrid:null,
                init: function () {
                    var self = this;
                    var num=1 ;
                    var afternum;
                    self.resourceGrid =grid = $("#div_platform_receive_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/qcReport/receptionList',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        method:'get',
                        parms: {
                            startTime: '',
                            endTime: ''
                        },
                       allowHideColumn:false,
                        columns: [
                            {display: '机构/部门', name: 'orgName', width: '10%',align: 'left'},
                            {display: '就诊及时率', name: 'visitIntimeRate', width: '10%', align: 'left'},
                            {display: '门诊及时率', name: 'outpatientInTimeRate', width: '10%'},
                            {display: '住院及时率', name: 'hospitalInTimeRate', width: '10%'},
                            {display: '体检及时率', name: 'peInTimeRate', width: '10%',align: 'left'},
                            {display: '就诊完整率', name: 'visitIntegrityRate', width: '10%', align: 'left'},
                            {display: '门诊完整率', name: 'outpatientIntegrityRate', width: '10%'},
                            {display: '住院完整率', name: 'hospitalIntegrityRate', width: '10%'},
                            {display: '体检完整率', name: 'peIntegrityRate', width: '10%',align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 160, render: function (row) {
                                    var html = '<a href="javascript:void(0)" target="_blank" style="display: inline-block;height: 33px;padding: 0 10px;line-height: 40px;vertical-align: top;" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "patient:patientBroswerInfoDialog:open", row.idCardNo) + '">档案查询</a>';
                                    html += '<sec:authorize url="/qcReport/packetNumList"><a class="grid_edit" title="查看" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "patient:patientInfoModifyDialog:open", row.idCardNo,row.userId) + '"></a></sec:authorize>';
                                    return html;
                                }
                            }
                        ],
                        enabledSort:false,
                        checkbox : true
                    }));
                    self.resourceGrid.adjustToWidth();
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

                    retrieve.$element.attrScan();
                    var homeAddress = retrieve.$element.Fields.homeAddress.getValue();
                    var values = $.extend({},retrieve.$element.Fields.getValues(),
                            {province: (homeAddress.names[0]==null?'':homeAddress.names[0])},
                            {city:  (homeAddress.names[1]==null?'':homeAddress.names[1])},
                            {district: (homeAddress.names[2]==null?'':homeAddress.names[2])});
                    values.gender = values.gender.trim() == '男' ? '1' : values.gender.trim() == '女' ? '2' : '';
                    reloadGrid.call(this, '${contextRoot}/patient/searchPatientByParams', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });
//                    点击tab 切换表格
                    $(".btn-group").on("click",".btn",function() {
                        var index = $(this).index();
                        $(".btn-group").find(".btn").removeClass("active");
                        $(this).addClass("active");
                        if(index==0){
                            retrieve.$element.show();
                            $("#div_patient_info_grid").show();
                            $("#div_unknowarchives_info_grid").hide();
                            self.KnownPatientGrid.reload();
                        }else {
                            retrieve.$element.hide();
                            $("#div_patient_info_grid").hide();
                            $("#div_unknowarchives_info_grid").show();
                            self.UnknowArchivesGrid.reload();
                        }
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
            win.parent.dialogRefresh = win.dialogRefresh = function () {
                master.reloadGrid();
            };
            win.parent.dialogClose = function () {
                dialog.close();
                master.reloadGrid();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>