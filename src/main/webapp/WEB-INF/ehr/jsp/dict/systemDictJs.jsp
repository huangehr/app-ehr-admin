<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */

            // 通用工具类库
            var Util = $.Util;

            // 页面主模块，对应于用户信息表区域
            var master = null;
            // 表单校验工具类
            var jValidation = $.jValidation;

            var retrieve = null;

            var systemDictInfoGrid = null;
            var systemDictEntryInfoGrid = null;
            var systemDictEntityDialog = null;
            var code = null;
            var selectRow = null, selectEntityRow=null;
            var isSaveSelectStatus = false, isSaveEntitySelectStatus = false;
            /* ************************** 变量定义结束 **************************** */

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                resizeContent();
                retrieve.init();
                master.initSystemDict();
                master.initSystemDictEntity(-1);
                master.initSystemDictForm();
            }
            function resizeContent(){
                var contentW = $('#grid_content').width();
                var leftW = $('.u-left').width();
                $('.u-right').width(contentW-leftW-20);
            }
            /* ************************** 函数定义结束 **************************** */

            /* *************************** 模块初始化 ***************************** */

            retrieve = {

//                // 模块对应的容器
//                $element: $('.m-retrieve-area'),
                // 搜索框
                $searchBox: $('#inp_search'),

                init: function () {
//                    this.$element.show();
                    this.$searchBox.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            var searchNm = $("#inp_search").val();
                            master.searchSystemDict(searchNm, 1);
                        }
                    });
                    /*********add by linz 2016-5-9 14:32:56 begin  content:新增keyUp查询事件***********/
                    this.$searchBox.keyup(function (e) {
                        if (e.keyCode == 13) {
                            var searchNm = $("#inp_search").val();
                            master.searchSystemDict(searchNm);
                        }
                    });
                    /*******************add end*******************/
                }
            };
            master = {
                // 新增按钮
                $form:$("#inp_form"),
                $newRecordBtn: $('#div_new_record'),
                $addSystemDict: $('#div_addSystemDict'),
                $updateSystemDictDialog: $('#div_updateSystemDictDialog'),
                $systemDictName: $('#inp_systemDictName'),
                $addSystemDictBtn: $('#div_addSystemDict_btn'),
                $systemDictReference: $("#inp_systemDictReference"),
                $systemDictId: $("#inp_systemDictId"),
                $addSystemDictEntity: $("#div_addSystemDictEntity"),
                $addSystemDictEntityDialog: $("#div_add_systemDictEntityDialog"),
                $updateSystemDictEntityDialog: $("#div_update_systemDictEntityDialog"),
                $systemDictEntityValue: $("#inp_systemDictEntity_value"),
                $systemDictEntityCode: $("#inp_systemDictEntity_code"),
                $systemDictEntitySort: $("#inp_systemDictEntity_sort"),
                $addSystemDictEntityBtn: $('#div_addSystemDictEntity_btn'),
                $updateSystemDictEntityBtn: $('#div_update_SystemDictEntity_btn'),
                $systemDictEntityCatalog: $("#inp_systemDictEntity_catalog"),
                $updateSystemDictEntityCode: $("#inp_update_systemDictEntity_code"),
                $updateSystemDictEntityValue: $("#inp_update_systemDictEntity_value"),
                $updateSystemDictEntitySort: $("#inp_update_systemDictEntity_sort"),
                $updateSystemDictEntityCatalog: $("#inp_update_systemDictEntity_catalog"),
                $systemNameCopy:$("#inp_systemNameCopy"),

                initSystemDictForm: function () {
                    var self = this;
                    self.$systemDictEntityValue.ligerTextBox({width: 240});
                    self.$systemDictEntitySort.ligerTextBox({width: 240});
                    self.$systemDictEntityCatalog.ligerTextBox({width: 240});
                    self.$systemDictEntityCode.ligerTextBox({width: 240});
                    self.$updateSystemDictEntityCode.ligerTextBox({width: 240});
                    self.$updateSystemDictEntityValue.ligerTextBox({width: 240});
                    self.$updateSystemDictEntitySort.ligerTextBox({width: 240});
                    self.$updateSystemDictEntityCatalog.ligerTextBox({width: 240});

                    self.$systemDictReference.hide();
                },
                userInfoDialog: null,
                initSystemDict: function () {
                    systemDictInfoGrid = $("#div_SystemDict_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/dict/searchSysDicts',
                        parms: {
                            searchNm: '',
                            searchType: ''
                        },
                        columns: [
                            {display: 'dictId', name: 'id', hide: true},
                            {display: '字典名称', name: 'name', width: '70%', align: 'left'},
                            {
                                display: '操作', name: 'operator', width: '30%', render: function (row) {
                                var html = '';
                                <sec:authorize url='/dict/updateDict'>
                                html += '<a class="grid_edit" href="javascript:void(0)" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "systemDict:systemInfoModifyDialog:update", row.id, row.name) + '"></a>';
                                </sec:authorize>
                                <sec:authorize url='/dict/deleteDict'>
                                html += '<a class="grid_delete" href="javascript:void(0)" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "systemDict:systemInfoModifyDialog:delete", row.id) + '"></a>';
                                </sec:authorize>
                                return html;
                            }
                            }
                        ],
                        allowHideColumn:false,
                        validate: true,
                        unSetValidateAttr: false,
                        onSelectRow: function (data, rowindex, rowobj) {
                            selectRow = data;
                            master.searchSystemDictEntity(data.id, 1);
                            master.$systemDictId.val(data.id);
                        },
                        onAfterShowData: function () {
                            if(selectRow!=null && isSaveSelectStatus){
                                isSaveSelectStatus = false;
                                systemDictInfoGrid.select(selectRow);
                            }else
                                systemDictInfoGrid.select(0);
                        },onBeforeShowData:function(currentData){
                            if(currentData.detailModelList.length==0)
                                master.searchSystemDictEntity('-1');
                        }

                    }));
                    // 自适应宽度
                    systemDictInfoGrid.adjustToWidth();
                    this.bindEvents();
                },
                // 重新查询
                searchSystemDict: function (searchNm, curPage) {
                    if (systemDictEntryInfoGrid==null)
                        master.initSystemDictEntity(-1);

                    Util.reloadGrid.call(systemDictInfoGrid, "", {searchNm: searchNm}, curPage);
                },

                searchSystemDictEntity: function (dictId, curPage) {
                    if (systemDictEntryInfoGrid==null)
                        master.initSystemDictEntity(dictId);

                    Util.reloadGrid.call(systemDictEntryInfoGrid, "",  {dictId: dictId}, curPage);
                },
                initSystemDictEntity: function (dictId) {
                    systemDictEntryInfoGrid = $("#div_systemEntity_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/dict/searchDictEntryList',
                        parms: {
                            dictId: dictId
                        },
                        columns: [
                            {display: 'sort', name: 'sort', hide: true, width: '0.1%'},
                            {display: 'catalog', name: 'catalog', hide: true, width: '0.1%'},
                            {display: '字典代码', name: 'code', width: '40%'},
                            {display: '值', name: 'value', width: '45%'},
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '';
                                <sec:authorize url="/dict/updateDictEntry">
                                html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "systemDictEntity:systemDictEntityInfoModifyDialog:update", row.code, row.value, row.sort, row.catalog) + '"></a>';
                                </sec:authorize>
                                <sec:authorize url="/dict/deleteDictEntry">
                                html += '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "systemDictEntity:systemDictEntityInfoModifyDialog:delete", row.code) + '"></a> ';
                                </sec:authorize>
                                return html;
                            }
                            }
                        ],
                        onSelectRow: function (data, rowindex, rowobj) {
                            selectEntityRow = data;
                        },
                        onAfterShowData: function () {
                            if(selectEntityRow!=null && isSaveEntitySelectStatus){
                                isSaveEntitySelectStatus = false;
                                systemDictEntryInfoGrid.select(selectEntityRow);
                            }
                        },
                        allowHideColumn:false,
                        validate: true
                    }));
                    // 自适应宽度
                    systemDictEntryInfoGrid.adjustToWidth();
                },

                bindEvents: function () {
                    //窗体改变大小事件
                    $(window).bind('resize', function() {
                        resizeContent();
                    });
                    var self = this;

                    //新增系统字典弹出窗口点击事件
                    self.$addSystemDict.click(function () {
                        self.$systemDictName.val("");
                        self.$systemDictId.val("");
                        self.updateSystemDialog("add");
                    });
                    //新增系统字典明细弹出窗口点击事件
                    self.$addSystemDictEntity.click(function () {
                        var systemDictId = master.$systemDictId.val();
                        if (Util.isStrEquals(systemDictId,'30')){
                            self.$systemDictEntityCatalog.addClass("mateDate-logic-conditions")
                        }else{
                            self.$systemDictEntityCatalog.removeClass("mateDate-logic-conditions")
                        }
                        self.$systemDictEntityCode.val("");
                        self.$systemDictEntityValue.val("");
                        self.$systemDictEntitySort.val("");
                        self.$systemDictEntityCatalog.val("");
                        self.addSystemEntityDialog();
                    });

                    //修改系统字典弹出窗口点击事件
                    $.subscribe('systemDict:systemInfoModifyDialog:update', function (event, systemDictId, systemDictName) {
                        isSaveSelectStatus = true;
                        self.$systemDictName.val(systemDictName);
                        self.$systemDictId.val(systemDictId);
                        self.$systemNameCopy.val(systemDictName);
                        self.updateSystemDialog();
                    });
                    //删除系统字典弹出窗口点击事件
                    $.subscribe('systemDict:systemInfoModifyDialog:delete', function (event, systemDictId) {
                        self.deleteSystemDictDialog('Dict',systemDictId, '', '${contextRoot}/dict/deleteDict');
                    });
                    //删除系统字典 详情 弹出窗口点击事件
                    $.subscribe('systemDictEntity:systemDictEntityInfoModifyDialog:delete', function (event, code) {
                        var dictId = self.$systemDictId.val();
                        self.deleteSystemDictDialog('DictEntry',dictId, code, '${contextRoot}/dict/deleteDictEntry');
                    });

                    //修改系统字典 详情 弹出窗口点击事件
                    $.subscribe('systemDictEntity:systemDictEntityInfoModifyDialog:update', function (event, code, value, sort, catalog) {
                        isSaveEntitySelectStatus = true;
                        var systemDictId = master.$systemDictId.val();
                        if (Util.isStrEquals(systemDictId,'30')){
                            self.$updateSystemDictEntityCatalog.addClass("mateDate-logic-conditions")
                        }else{
                            self.$updateSystemDictEntityCatalog.removeClass("mateDate-logic-conditions")
                        }
                        self.$updateSystemDictEntityCode.val(code);
                        self.$updateSystemDictEntityValue.val(value);
                        self.$updateSystemDictEntitySort.val(sort);
                        self.$updateSystemDictEntityCatalog.val(catalog);
                        self.updateSystemEntityDialog();
                    });

                },
                updateSystemDialog: function (mode) {
                    var self = this;
                    var title = '';
                    if (Util.isStrEquals(mode, 'add')) {
                        title = '新增字典'
                    } else {
                        title = '修改字典'
                    }
                    self.$updateSystemDictDialog = parent._LIGERDIALOG.open({
                        height:200,
                        width: 400,
                        title : title,
                        url: '${contextRoot}/dict/editSystemDict',
                        urlParms: {
                            mode:mode,
                            systemName:self.$systemDictName.val(),
                            systemDictId:self.$systemDictId.val()
                        },
                        isHidden: false,
                        opener: true,
                        load:true
                    });
                },
                addSystemEntityDialog: function () {
                    var self = this;
                    systemDictEntityDialog = parent._LIGERDIALOG.open({
                        height:280,
                        width: 416,
                        title : "新增字典详情",
                        url: '${contextRoot}/dict/editSystemDictDetail',
                        urlParms: {
                            mode:"add",
                            code:"",
                            name:"",
                            catalog:"",
                            systemDictId:master.$systemDictId.val()
                        },
                        isHidden: false,
                        opener: true,
                        load:true
                    });
                },
                updateSystemEntityDialog: function () {

                    var self = this;
                    systemDictEntityDialog = parent._LIGERDIALOG.open({
                        height:280,
                        width: 416,
                        title : "修改字典详情",
                        url: '${contextRoot}/dict/editSystemDictDetail',
                        urlParms: {
                            mode:"modify",
                            code:self.$updateSystemDictEntityCode.val(),
                            name:self.$updateSystemDictEntityValue.val(),
                            catalog:self.$updateSystemDictEntityCatalog.val(),
                            systemDictId:master.$systemDictId.val()
                        },
                        isHidden: false,
                        opener: true,
                        load:true
                    });
                },
                deleteSystemDictDialog: function (type,dictId, code, deleteUrl) {
                    var self = this;
                    var data = '';
                    if (Util.isStrEquals(code, '')) {
                        data = {dictId: dictId}
                    } else {
                        data = {dictId: dictId, code: code}
                    }
                    parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                        if (yes) {
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote(deleteUrl, {
                                data: data,
                                success: function (data) {
                                    if (data.successFlg) {
                                        parent._LIGERDIALOG.success('删除成功');
                                        if (type=='Dict') {
                                            self.searchSystemDict("", Util.checkCurPage.call(systemDictInfoGrid, 1));
                                        }else if (type=='DictEntry') {
                                            master.searchSystemDictEntity(master.$systemDictId.val(), Util.checkCurPage.call(systemDictEntryInfoGrid, 1));
                                        }

                                    } else {
                                        parent._LIGERDIALOG.error('删除失败');
                                    }
                                }
                            });
                        }
                    });
                }
            };
            /* ************************* 模块初始化结束 ************************** */
            /* ******************Dialog页面回调接口****************************** */
            win.parent.reloadMasterGrid = function () {
                master.searchSystemDict();
            };
            win.parent.closeDialog = function (msg) {
                master.$updateSystemDictDialog.close();
                if(msg)
                    parent._LIGERDIALOG.success(msg);
            };
            win.parent.closeDetailDialog = function (msg) {
               systemDictEntityDialog.close();
                if(msg)
                    parent._LIGERDIALOG.success(msg);
            };
            win.parent.reloadEntryMasterGrid = function () {
                master.searchSystemDictEntity(master.$systemDictId.val());
            };

            /* *************************** 页面功能 **************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>