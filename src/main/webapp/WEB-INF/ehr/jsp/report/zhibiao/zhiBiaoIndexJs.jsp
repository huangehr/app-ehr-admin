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
                            url:  '${contextRoot}/tjQuota/getTjQuota',
                            parms: {
                                name: ""
                            },
                            columns: [
                                {display: 'id', name: 'id', hide: true},
                                {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'name', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '指标类型', name: 'quotaTypeName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: 'cron表达式', name: 'cron', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '执行时间', name: 'execTime', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '执行方式', name: 'execTypeName', width: '5%', isAllowHide: false, align: 'left'},
                                {display: '任务类', name: 'jobClazz', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '状态', name: 'status', width: '5%', render: function (row) {
                                    var sta = row.status,
                                        str = '';
                                    if (sta == '-1') {
                                        str = '已删除'
                                    }else if (sta == '0') {
                                        str = '不可用'
                                    }else if (sta == '1') {
                                        str = '正常'
                                    }
                                    return str;
                                }, isAllowHide: false, align: 'center'},
                                {display: '存储方式', name: 'dataLevelName', width: '7%', isAllowHide: false, align: 'left'},
                                {display: '备注', name: 'remark', width: '8%', isAllowHide: false, align: 'left'},
                                {
                                    display: '操作', name: 'operator', width: '31%', align: 'center',render: function (row) {
                                    var html = '';
                                    html += '<sec:authorize url="/tjQuota/updateTjDataSource"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:weidu:config", row.code) + '">维度配置</a></sec:authorize>';
                                    html += '<sec:authorize url="/tjQuota/updateTjDataSource"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
                                    html += '<sec:authorize url="/tjQuota/deleteTjDataSave"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a></sec:authorize>';
                                    html += '<sec:authorize url="/tjQuota/updateTjDataSource"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:execu", row.id) + '">任务执行</a></sec:authorize>';
                                    html += '<sec:authorize url="/tjQuota/updateTjDataSource"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:result:selectResult", row.id) + '">结果查询</a></sec:authorize>';
                                    html += '<sec:authorize url="/tjQuota/updateTjDataSource"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:log:quotaLog", row.code) + '">日志查询</a></sec:authorize>';
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
                    Util.reloadGrid.call(this.grid, '${contextRoot}/tjQuota/getTjQuota', values, curPage);
                },
                bindEvents: function () {
                    $.subscribe('zhibiao:zhiBiaoInfo:open', function (event, id, mode) {
                        var title = '';
                        if (mode == 'modify') {
                            title = '修改指标';
                        }
                        else {
                            title = '新增指标';
                        }
                        isSaveSelectStatus = true;
                        dictMaster.dictInfoDialog = $.ligerDialog.open({
                            height: 650,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/tjQuota/getPage',
                            urlParms: {
                                id: id
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
                                dataModel.updateRemote('${contextRoot}/tjQuota/deleteTjDataSave', {
                                    data: {tjQuotaId: parseInt(id)},
                                    success: function (data) {
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

                    $.subscribe('zhibiao:weidu:config', function (event, code) {
                        dictMaster.detailDialog = $.ligerDialog.open({
                            title:'维度配置',
                            height: 625,
                            width: 800,
                            url: '${contextRoot}/zhibiao/zhiBiaoDetail',
                            isHidden: false,
                            opener: true,
                            load: true,
                            urlParms: {
                                quotaCode:code
                            },
                            onLoaded:function() {

                            }
                        });
                    });

                    $.subscribe('zhibiao:execu', function (event, id) {
                        $.Notice.confirm('确认要执行所选指标？', function (r) {
                            if (r) {
                                debugger
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/tjQuota/execuQuota', {
                                    data: {tjQuotaId: parseInt(id)},
                                    success: function (data) {
                                        if(data.successFlg){
                                            $.Notice.success('执行成功！');
                                        }else{
                                            $.Notice.error(data.errorMsg);
                                        }
                                    }
                                });
                            }
                        })
                    });

                    $.subscribe('zhibiao:result:selectResult', function (event, id) {
                        var url = '${contextRoot}/tjQuota/initialResult';
                        var urlParms = {
                            tjQuotaId:id
                        }
                        $("#contentPage").empty();
                        $("#contentPage").load(url, urlParms);
                    });

                    $.subscribe('zhibiao:log:quotaLog', function (event, quotaCode) {
                        var url = '${contextRoot}/tjQuota/initialQuotaLog';
                        var urlParms = {
                            quotaCode:quotaCode
                        }
                        $("#contentPage").empty();
                        $("#contentPage").load(url, urlParms);
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
