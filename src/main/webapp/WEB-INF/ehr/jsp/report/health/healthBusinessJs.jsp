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

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                dictMaster.init();
            }

            /* *************************** 标准字典模块初始化 ***************************** */
            dictMaster = {
                dictInfoDialog: null,
                detailDialog:null,
                grid: null,
                $searchNm: $('#searchNm'),
                init: function () {
                    var self = this;
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadGrid(1);
                        }
                    });
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        this.grid = $("#div_stdDict_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/health/getHealthBusinessList',
                            parms: {
                                name: ""
                            },
                            columns: [
                                {display: 'id', name: 'id', hide: true},
                                {display: '编码', name: 'code', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '父级ID', name: 'parentName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '备注', name: 'note', width: '25%', isAllowHide: false, align: 'left'},
                                {
                                    display: '操作', name: 'operator', width: '25%', align: 'center',render: function (row) {
                                        var html = '';
                                        html += '<sec:authorize url="/"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "health:healthBusinessInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
                                        html += '<sec:authorize url="/health/deleteHealthBusiness"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "health:healthBusinessInfo:delete", row.id) + '"></a></sec:authorize>';
                                        return html;
                                    }
                                }
                            ],
                            //enabledEdit: true,
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            onBeforeShowData: function (data) {

                            },
                            onAfterShowData: function (data) {

                            },
                            onSelectRow: function (row) {
//
                            },
                            onDblClickRow: function (row) {

                            }
                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },
                reloadGrid: function (curPage) {
                    var searchNm = $("#searchNm").val();
                    var values = {
                        name: searchNm
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/health/getHealthBusinessList', values, curPage);
                },
                bindEvents: function () {
                    $.subscribe('health:healthBusinessInfo:open', function (event, id, mode) {
                        var title = '';
                        if (mode == 'modify') {
                            title = '修改指标分类';
                        }
                        else {
                            title = '新增指标分类';
                        }
                        dictMaster.dictInfoDialog = $.ligerDialog.open({
                            height: 400,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/health/getPage',
                            urlParms: {
                                id: id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('health:healthBusinessInfo:delete', function (event, id) {

                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/health/deleteHealthBusiness', {
                                    data: {id: parseInt(id)},
                                    success: function (data) {
                                        debugger
                                        if(data.successFlg){
                                            $.Notice.success('删除成功！');
                                            dictMaster.reloadGrid(Util.checkCurPage.call(dictMaster.grid, 1));
                                        }else{
                                            $.Notice.error(data.errorMsg);
                                        }
                                    }
                                });
                            }
                        })
                    });

                }
            };

            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                dictMaster.reloadGrid();
            };
            win.closeDialog = function (type, msg) {
                dictMaster.dictInfoDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            win.closeZhiBiaoInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    dictMaster.reloadGrid();
                }
                dictMaster.dictInfoDialog.close();
            };

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
