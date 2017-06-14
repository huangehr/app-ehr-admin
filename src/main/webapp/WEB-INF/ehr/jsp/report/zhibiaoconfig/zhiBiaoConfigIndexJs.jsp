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
                grid: null,
                $element: $('.m-retrieve-area'),
                // 搜索框
                $searchBox: $('#inp_search'),
                $searchBtn: $('#btn_search'),
                init: function (dictId) {
                    var self = this;
                    this.$searchBox.ligerTextBox({width:240});
                    this.$element.show();
                    this.$element.attrScan();


                    if (this.grid)
                        return;
                    this.grid = $("#div_weidu_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDimensionMain/getTjDimensionMain',
                        parms: {
                            name: ""
                        },
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: 'dictId', name: 'dictId', hide: true},
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
                                display: '操作', name: 'operator', width: '10%', render: function (row) {
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
                    this.grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    Util.reloadGrid.call(this.grid, '${contextRoot}/tjDimensionMain/getTjDimensionMain', {name:this.$searchBox.val()}, 1);
                },
                bindEvents: function () {
                    var self = this;
                    self.$searchBtn.click(function () {
                        self.reloadGrid();
                    });
                    $.subscribe('zhibiao:zhiBiaoInfo:open', function (event, id, mode) {
                        var title = '';
                        //只有new 跟 modify两种模式会到这个函数
                        if (mode == 'modify') {
                            title = '修改维度';
                        }
                        else {
                            title = '新增维度';
                        }
                        entryMater.entryInfoDialog = $.ligerDialog.open({
                            height: 480,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/zhibiaoconfig/weiDuDialog',
                            urlParms: {
                                weiDuId:id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('zhibiao:zhiBiaoGrid:delete', function (event, id) {
                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/tjDimensionMain/deleteTjDimensionMain', {
                                    data: {tjDimensionMainId: id},
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

