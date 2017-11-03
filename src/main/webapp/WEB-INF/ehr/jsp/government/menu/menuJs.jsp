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
                            url:  '${contextRoot}/governmentMenu/getGovernmentMenuList',
                            parms: {
                                name: ""
                            },
                            columns: [
                                {display: 'id', name: 'id', width: '0.1%', hide: true},
                                {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '链接地址', name: 'url', width: '15%', isAllowHide: false, align: 'left'},
                                {display: '创建时间', name: 'createTime', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '创建者', name: 'createUser', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '修改者', name: 'updateUser', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '修改时间', name: 'updateTime', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '状态', name: 'status', width: '5%', isAllowHide: false, align: 'left',render: function (row) {
                                    if (row.status == 0) {
                                        return "无效";
                                    } else {
                                        return "有效";
                                    }
                                }},
                                {
                                    display: '操作', name: 'operator', minWidth: 120, align: 'center',render: function (row) {
                                        var html = '';
                                        html += '<sec:authorize url="/government/editMenu"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "government:menuInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
                                        <%--html += '<sec:authorize url="/government/deleteMenu"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "government:menuInfo:delete", row.id) + '"></a></sec:authorize>';--%>
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
                    Util.reloadGrid.call(this.grid, '${contextRoot}/governmentMenu/getGovernmentMenuList', values, curPage);
                },
                bindEvents: function () {
                    $.subscribe('government:menuInfo:open', function (event, id, mode) {
                        var title = '';
                        var height = 400;
                        var width = 480;
                        if (mode == 'modify') {
                            title = '修改菜单';

                        }
                        else {
                            title = '新增菜单';
                            height = 300;
                        }
                        dictMaster.dictInfoDialog = $.ligerDialog.open({
                            height: height,
                            width: width,
                            title: title,
                            url: '${contextRoot}/governmentMenu/getPage',
                            urlParms: {
                                id: id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('government:menuInfo:delete', function (event, id) {

                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/governmentMenu/deleteQuotaCategory', {
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
            win.closeMenuInfoDialog = function (callback) {
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
