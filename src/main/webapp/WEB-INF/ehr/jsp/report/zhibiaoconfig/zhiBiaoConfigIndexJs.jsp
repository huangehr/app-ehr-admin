<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var dictMaster = null;
            var conditionArea = null;
            var entryMater = null;
            var versionStage = null;
            var DimensionMainId =  72;//主维度字典id
            var DimensionSlaveId = 73;//从维度字典id
            var DimensionStatusId =  74;//维度状态
            var DimensionMainData = null;
            var DimensionSlaveData = null;
            var DimensionStatus = null;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                entryMater.init();
            }

            /* *************************** 标准字典模块初始化 ***************************** */
            entryMater = {
                entryInfoDialog: null,
                DataSourceGrid: null,
                DataStorageGrid: null,
                TjDimensionMainGrid: null,
                TjDimensionSlaveGrid: null,
                $element: $('.m-retrieve-area'),
                // 搜索框
                $searchBox1: $('#inp_datasource_search'),
                $searchBox2: $('#inp_datastorage_search'),
                $searchBox3: $('#inp_main_search'),
                $searchBox4: $('#inp_slave_search'),
                init: function (dictId) {
                    var self = this;
                    this.$searchBox1.ligerTextBox({width:240, isSearch: true, search: function () {
                        entryMater.reloadGrid();
                    }});
                    this.$searchBox2.ligerTextBox({width:240, isSearch: true, search: function () {
                        entryMater.reloadGrid();
                    }});
                    this.$searchBox3.ligerTextBox({width:240, isSearch: true, search: function () {
                        entryMater.reloadGrid();
                    }});
                    this.$searchBox4.ligerTextBox({width:240, isSearch: true, search: function () {
                        entryMater.reloadGrid();
                    }});

                    this.$element.show();
                    this.$element.attrScan();
                    this.bindEvents();
                    $("#div_datasource_info_grid").css("visibility","visible");
                    $("#div_datastorage_info_grid").css("visibility","hidden");
                    $("#div_slave_weidu_info_grid").css("visibility","hidden");
                    $("#div_weidu_info_grid").css("visibility","hidden");
                    this.loadDataSourceGrid();//加载数据源管理
                    this.loadDataStorageGrid();//加载数据存储管理
                    this.loadTjDimensionMainGrid();//加载主维度管理
                    this.loadTjDimensionSlaveGrid();//加载主维度管理
                },
                loadDataSourceGrid:function(){
                    if (this.DataSourceGrid)
                        return;
                    this.DataSourceGrid = $("#div_datasource_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDataSource/getTjDataSource',
                        parms: {
                            name: ""
                        },
                        columns: [
                            {display: 'id', name: 'id', width: '0.1%', hide: true},
                            {display: 'dictId', name: 'dictId', width: '0.1%', hide: true},
                            {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '类型', name: 'typeName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '状态', name: 'statusName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建时间', name: 'createTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建人', name: 'createUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改时间', name: 'updateTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改人', name: 'updateUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '备注', name: 'remark', width: '10%', isAllowHide: false, align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '';
                                <sec:authorize url="/tjDimensionMain/updateTjDimensionMain">
                                html += '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a>';
                                </sec:authorize>

                                <sec:authorize url="/tjDimensionMain/deleteTjDimensionMain">
                                html +=  '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a>';
                                </sec:authorize>

                                return html;
                            }
                            }
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: false
                    }));
                    // 自适应宽度
                    this.DataSourceGrid.adjustToWidth();
                },
                loadDataStorageGrid:function(){
                    if (this.DataStorageGrid)
                        return;
                    this.DataStorageGrid = $("#div_datastorage_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDataSave/getTjDataSave',
                        parms: {
                            name: ""
                        },
                        columns: [
                            {display: 'id', name: 'id', width: '0.1%', hide: true},
                            {display: 'dictId', name: 'dictId', width: '0.1%', hide: true},
                            {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '类型', name: 'typeName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '状态', name: 'statusName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建时间', name: 'createTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建人', name: 'createUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改时间', name: 'updateTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改人', name: 'updateUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '备注', name: 'remark', width: '10%', isAllowHide: false, align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '';
                                <sec:authorize url="/tjDimensionMain/updateTjDimensionMain">
                                html += '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a>';
                                </sec:authorize>

                                <sec:authorize url="/tjDimensionMain/deleteTjDimensionMain">
                                html +=  '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a>';
                                </sec:authorize>

                                return html;
                            }
                            }
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: false
                    }));
                    // 自适应宽度
                    this.DataStorageGrid.adjustToWidth();
                },
                loadTjDimensionMainGrid:function(){
                    if (this.TjDimensionMainGrid)
                        return;
                    this.TjDimensionMainGrid = $("#div_weidu_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDimensionMain/getTjDimensionMain',
                        parms: {
                            name: ""
                        },
                        columns: [
                            {display: 'id', name: 'id', width: '0.1%', hide: true},
                            {display: 'dictId', name: 'dictId', width: '0.1%', hide: true},
                            {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '类型', name: 'typeName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '状态', name: 'statusName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建时间', name: 'createTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建人', name: 'createUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改时间', name: 'updateTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改人', name: 'updateUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '备注', name: 'remark', width: '10%', isAllowHide: false, align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '';
                                <sec:authorize url="/tjDimensionMain/updateTjDimensionMain">
                                html += '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a>';
                                </sec:authorize>

                                <sec:authorize url="/tjDimensionMain/deleteTjDimensionMain">
                                html +=  '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a>';
                                </sec:authorize>

                                return html;
                            }
                            }
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: false
                    }));
                    // 自适应宽度
                    this.TjDimensionMainGrid.adjustToWidth();
                },
                loadTjDimensionSlaveGrid:function(){
                    if (this.TjDimensionSlaveGrid)
                        return;
                    this.TjDimensionSlaveGrid = $("#div_slave_weidu_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDimensionSlave/getTjDimensionSlave',
                        parms: {
                            name: ""
                        },
                        columns: [
                            {display: 'id', name: 'id', width: '0.1%', hide: true},
                            {display: 'dictId', name: 'dictId', width: '0.1%', hide: true},
                            {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '类型', name: 'typeName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '状态', name: 'statusName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建时间', name: 'createTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '创建人', name: 'createUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改时间', name: 'updateTime', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '修改人', name: 'updateUserName', width: '10%', isAllowHide: false, align: 'left'},
                            {display: '备注', name: 'remark', width: '10%', isAllowHide: false, align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '';
                                <sec:authorize url="/tjDimensionMain/updateTjDimensionMain">
                                html += '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a>';
                                </sec:authorize>

                                <sec:authorize url="/tjDimensionMain/deleteTjDimensionMain">
                                html +=  '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a>';
                                </sec:authorize>

                                return html;
                            }
                            }
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: false
                    }));
                    // 自适应宽度
                    this.TjDimensionSlaveGrid.adjustToWidth();
                },
                reloadGrid: function () {
                    var self = this;
                    var activeIndex = $(".btn-group").find(".btn.active").index();
                    var grid = null;
                    var searchUrl = "";
                    var value = "";
                    if(activeIndex==0){//数据源管理
                        grid = self.DataSourceGrid;
                        searchUrl =  '${contextRoot}/tjDataSource/getTjDataSource';
                        value = this.$searchBox1.val();
                    }else if(activeIndex==1){//数据存储管理
                        grid = self.DataStorageGrid;
                        searchUrl = '${contextRoot}/tjDataSave/getTjDataSave';
                        value = this.$searchBox2.val();
                    }else if(activeIndex==2){//主维度管理
                        grid = self.TjDimensionMainGrid;
                        searchUrl = '${contextRoot}/tjDimensionMain/getTjDimensionMain';
                        value = this.$searchBox3.val();
                    }else{//细维度管理
                        grid = self.TjDimensionSlaveGrid;
                        searchUrl = '${contextRoot}/tjDimensionSlave/getTjDimensionSlave';
                        value = this.$searchBox4.val();
                    }
                    Util.reloadGrid.call(grid, searchUrl, {name:value}, 1);
                },
                bindEvents: function () {
                    var self = this;
                    $(".btn-group").on("click",".btn",function(){
                        var index = $(this).index();
                        $(".btn-group").find(".btn").removeClass("active");
                        $(this).addClass("active");
                        if(index==0){//数据源管理
                            $(".div-datasource-search").show();
                            $(".div-datastorage-search").hide();
                            $(".div-main-search").hide();
                            $(".div-slave-search").hide();
                            $("#div_datasource_info_grid").css("visibility","visible");
                            $("#div_datastorage_info_grid").css("visibility","hidden");
                            $("#div_weidu_info_grid").css("visibility","hidden");
                            $("#div_slave_weidu_info_grid").css("visibility","hidden");
                            $("#div_datasource_info_grid").css("height","100%");
                            $("#div_datastorage_info_grid").css("height","0px");
                            $("#div_weidu_info_grid").css("height","0px");
                            $("#div_slave_weidu_info_grid").css("height","0px");
                        }else if(index==1){//数据存储管理
                            $(".div-datasource-search").hide();
                            $(".div-datastorage-search").show();
                            $(".div-main-search").hide();
                            $(".div-slave-search").hide();
                            $("#div_datasource_info_grid").css("visibility","hidden");
                            $("#div_datastorage_info_grid").css("visibility","visible");
                            $("#div_weidu_info_grid").css("visibility","hidden");
                            $("#div_slave_weidu_info_grid").css("visibility","hidden");
                            $("#div_datasource_info_grid").css("height","0px");
                            $("#div_datastorage_info_grid").css("height","100%");
                            $("#div_weidu_info_grid").css("height","0px");
                            $("#div_slave_weidu_info_grid").css("height","0px");
                        }else if(index==2){//主维度管理
                            $(".div-datasource-search").hide();
                            $(".div-datastorage-search").hide();
                            $(".div-main-search").show();
                            $(".div-slave-search").hide();
                            $("#div_datasource_info_grid").css("visibility","hidden");
                            $("#div_datastorage_info_grid").css("visibility","hidden");
                            $("#div_weidu_info_grid").css("visibility","visible");
                            $("#div_slave_weidu_info_grid").css("visibility","hidden");
                            $("#div_datasource_info_grid").css("height","0px");
                            $("#div_datastorage_info_grid").css("height","0px");
                            $("#div_weidu_info_grid").css("height","100%");
                            $("#div_slave_weidu_info_grid").css("height","0px");
                        }else if(index==3){//细维度管理
                            $(".div-datasource-search").hide();
                            $(".div-datastorage-search").hide();
                            $(".div-main-search").hide();
                            $(".div-slave-search").show();
                            $("#div_datasource_info_grid").css("visibility","hidden");
                            $("#div_datastorage_info_grid").css("visibility","hidden");
                            $("#div_weidu_info_grid").css("visibility","hidden");
                            $("#div_slave_weidu_info_grid").css("visibility","visible");
                            $("#div_datasource_info_grid").css("height","0px");
                            $("#div_datastorage_info_grid").css("height","0px");
                            $("#div_weidu_info_grid").css("height","0px");
                            $("#div_slave_weidu_info_grid").css("height","100%");
                        }
                        self.reloadGrid();
                    });

                    $.subscribe('zhibiao:zhiBiaoInfo:open', function (event, id, mode) {
                        var title = '';
                        var titleName = "";
                        var requestUrl = "";
                        var activeIndex = $(".btn-group").find(".btn.active").index();
                        if(activeIndex==0){//数据源管理
                            titleName = "数据源";
                            requestUrl = '${contextRoot}/zhibiaoconfig/dataSourceDialog';
                        }else if(activeIndex==1){//数据存储管理
                            titleName = "数据源";
                            requestUrl = '${contextRoot}/zhibiaoconfig/dataStorageDialog';
                        }else if(activeIndex==2){//主维度管理
                            titleName = "主维度";
                            requestUrl = '${contextRoot}/zhibiaoconfig/weiDuDialog';
                        }else{//细维度管理
                            titleName = "细维度";
                            requestUrl = '${contextRoot}/zhibiaoconfig/xiWeiDuDialog';
                        }

                        if (mode == 'modify') {
                            title = '修改'+titleName;
                        }
                        else {
                            title = '新增'+titleName;
                        }
                        entryMater.entryInfoDialog = $.ligerDialog.open({
                            height: 480,
                            width: 480,
                            title: title,
                            url: requestUrl,
                            urlParms: {
                                id:id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('zhibiao:zhiBiaoGrid:delete', function (event, id) {
                        var requestUrl = "";
                        var reqParams = null;
                        var activeIndex = $(".btn-group").find(".btn.active").index();
                        if(activeIndex==0){//数据源管理
                            requestUrl = '${contextRoot}/tjDataSource/deleteTjDataSource';
                            reqParams = {tjDataSourceId:id};
                        }else if(activeIndex==1){//数据存储管理
                            requestUrl = '${contextRoot}/tjDataSave/deleteTjDataSave';
                            reqParams = {tjDataSaveId:id};
                        }else if(activeIndex==2){//主维度管理
                            requestUrl = '${contextRoot}/tjDimensionMain/deleteTjDimensionMain';
                            reqParams = {tjDimensionMainId:id};
                        }else{//细维度管理
                            requestUrl = '${contextRoot}/tjDimensionSlave/deleteTjDimensionSlave';
                            reqParams = {tjDimensionSlaveId:id};
                        }
                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote(requestUrl, {
                                    data: reqParams,
                                    success: function (data) {
                                        $.Notice.success('删除成功！');
                                        entryMater.reloadGrid();
                                    }
                                });
                            }
                        })
                    });
                },
                closeDl: function () {
                    this.entryInfoDialog.close();
                }
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadEntryMasterGrid = function () {
                entryMater.reloadGrid();
            };
            win.closeAddWeiduInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    entryMater.reloadGrid();
                }
                entryMater.entryInfoDialog.close();
            };
            win.closeDialog = function (type, msg) {
                if (type == 'right')
                    entryMater.closeDl();
                else
                    entryMater.entryInfoDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>

