<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            var urls = {
                gotoImportLs: "${contextRoot}/doctorImport/gotoImportLs"
            }
            // 通用工具类库
            var Util = $.Util;

            // 画面用户信息表对象
            var grid = null;

            // 页面表格条件部模块
            var retrieve = null;

            // 页面主模块，对应于用户信息表区域
            var master = null;

            var dialog=null;
            /* ************************** 变量定义结束 ******************************** */
            var isFirstPage = true;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid (url, params) {
                if (isFirstPage){
                    grid.options.newPage = 1;
                }
                grid.setOptions({parms: params});
                grid.loadData(true);

                isFirstPage = true;
            }
            function onUploadSuccess(g, result){
                if(result) {
                    var wait = parent._LIGERDIALOG.waitting("请稍后...");
                    var rowDialog = parent._LIGERDIALOG.open({
                        height: 640,
                        width: 1000,
                        isDrag: true,
                        //isResize:true,
                        title: '导入错误信息',
                        url: urls.gotoImportLs,
//                        load: true
                        urlParms: {
                            result: result
                        },
                        isHidden: false,
                        show: false,
                        onLoaded: function () {
                            wait.close(),
                                    rowDialog.show()
                        }
                    });
                    rowDialog.hide();
                } else {
                    parent._LIGERDIALOG.success("导入成功！");
                }
            }
            $('#upd').uploadFile({url: "${contextRoot}/doctorImport/import", onUploadSuccess: onUploadSuccess});

            /* *************************** 函数定义结束******************************* */

            retrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $searchDoctor: $("#inp_search"),
                $newDoctor: $("#div_new_doctor"),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchDoctor.ligerTextBox({width: 240 });
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
//                    self.$searchBtn.click(function () {
//                        debugger
//                        patientMaster.grid.options.newPage = 1;
//                        patientMaster.reloadGrid();
//                    });
                }
            };

            master = {
                doctorInfoDialog: null,
                addDoctorInfoDialog:null,
                init: function () {
                   grid = $("#div_doctor_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/doctor/searchDoctor',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: '',
                            searchType: ''
                        },
                       allowHideColumn:false,
                        columns: [
                            {display: '姓名', name: 'name', width: '10%',align: 'left'},
                            {display: '类别', name: 'roleType', width: '5%',align: 'left'},
                            {display: '性别', name: 'sex', width: '5%'},
                            {display: '专长', name: 'skill', width: '8%', resizable: true,align: 'left'},
                            {display: '职称', name: 'lczc', width: '10%', resizable: true,align: 'left'},
                            {display: '手机号码', name: 'phone', width: '10%', resizable: true,align: 'left'},
                            {display: '邮箱', name: 'email', width: '13%', resizable: true,align: 'left'},
                            {display: '医生主页', name: 'workPortal', width: '15%', resizable: true,align: 'left'},
                            {
                                display: '生/失效',
                                name: 'status',
                                minWidth: 80,
                                isAllowHide: false,
                                render: function (row) {
                                    var html = '';
                                    if (row.status == 1) {
                                        html += '<sec:authorize url="/doctor/updDoctorStatus"><a class="grid_on" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "doctor:doctorInfoModifyDialog:failure", row.id, '0','失效') + '"></a></sec:authorize>';
                                    } else {
                                        html += '<sec:authorize url="/doctor/updDoctorStatus"><a class="grid_off" title="未生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "doctor:doctorInfoModifyDialog:failure", row.id, '1','生效') + '"></a></sec:authorize>';
                                    }
                                    return html;
                                }
                            },
                            {display: '注册时间', name: 'insertTime', width: '8%', minColumnWidth: 20,align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 90, render: function (row) {
                                    var html = '<sec:authorize url="/doctor/updateDoctor"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "doctor:doctorInfoModifyDialog:open", row.id) + '"></a></sec:authorize>';
                                    html += '<sec:authorize url="/doctor/deleteDoctor"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "doctor:doctorInfoModifyDialog:del", row.id) + '"></a></sec:authorize>';
                                    return html;
                                }
                            }
                        ],
                       enabledEdit: true,
                       validate: true,
                       unSetValidateAttr: false,
                       onDblClickRow : function (row){
                           var mode = 'view';
                           var wait = parent._LIGERDIALOG.waitting("请稍后...");
                           var rowDialog = parent._LIGERDIALOG.open({
                               height: 620,
                               width: 760,
                               isDrag:true,
                               //isResize:true,
                               title:'医生基本信息',
                               url: '${contextRoot}/doctor/getDoctor',
                               load: true,
                               urlParms: {
                                   doctorId: row.id,
                                   mode:mode
                               },
                               isHidden: false,
                               show: false,
                               onLoaded:function() {
                                   wait.close(),
                                   rowDialog.show()
                               }
                           });
                           rowDialog.hide();
                       }
                    }));
                    grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    retrieve.$element.attrScan();
                    reloadGrid.call(this, '${contextRoot}/doctor/searchDoctor', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });

                    //新增医生信息
                    retrieve.$newDoctor.click(function(){
                        debugger
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.addDoctorInfoDialog = parent._LIGERDIALOG.open({
                            height: 590,
                            width: 820,
                            title: '新增医生信息',
                            url: '${contextRoot}/doctor/addDoctorInfoDialog',
                            isHidden: false,
                            show: false,
                            onLoaded:function() {
                                wait.close(),
                                self.addDoctorInfoDialog.show()
                            },
                            opener: true,
//                            load:true
                        })
                        self.addDoctorInfoDialog.hide();
                    });
                    //修改医生信息
                    $.subscribe('doctor:doctorInfoModifyDialog:open', function (event, doctorId, mode) {
                        var mode = 'modify';
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.doctorInfoDialog = parent._LIGERDIALOG.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 620,
                            width: 760,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/doctor/getDoctor',
                            load: true,
                            urlParms: {
                                doctorId: doctorId,
                                mode:mode
                            },
                            show: false,
                            onLoaded:function() {
                                wait.close(),
                                self.doctorInfoDialog.show()
                            }
                        });
                        self.doctorInfoDialog.hide();
                    });
                    //修改医生状态(生/失效)
                    $.subscribe('doctor:doctorInfoModifyDialog:failure', function (event, doctorId,status,msg) {
                        parent._LIGERDIALOG.confirm('是否对该医生进行'+msg+'操作', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.createRemote('${contextRoot}/doctor/updDoctorStatus', {
                                    data: {doctorId: doctorId,status:status},
                                    success: function (data) {
                                        if (data.successFlg) {
//                                            parent._LIGERDIALOG.success('修改成功');
                                            isFirstPage = false;
                                            master.reloadGrid();
                                        } else {
//                                            parent._LIGERDIALOG.error('修改失败');
                                        }
                                    }
                                });
                            }
                        });
                    });
                    //删除医生
                    $.subscribe('doctor:doctorInfoModifyDialog:del', function (event, doctorId) {
                        parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/doctor/deleteDoctor",{
                                    data:{doctorId:doctorId},
                                    async:true,
                                    success: function(data) {
                                        if(data.successFlg){
                                            parent._LIGERDIALOG.success('删除成功。');
                                            isFirstPage = false;
                                            master.reloadGrid();
                                        }else{
                                            parent._LIGERDIALOG.error('删除失败。');
                                        }
                                    }
                                });
                            }
                        });

                    });
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.parent.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeAddDoctorInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.addDoctorInfoDialog.close();
            };
            win.parent.closeDoctorInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.doctorInfoDialog.close();
            };
            win.parent.showAddSuccPop = function () {
                parent._LIGERDIALOG.success('医生新增成功');
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>