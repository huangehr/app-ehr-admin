<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var hosReleaseRetrieve = null;
            var hosReleaseMaster = null;

            var installLogRetrieve = null;
            var installLogMater = null;

            var selectRowObj = null;

            var isSaveSelectStatus = false;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                resizeContent();
                hosReleaseRetrieve.init();
                installLogRetrieve.init();
            }

            function resizeContent() {
                var contentW = $('#grid_content').width();
                var left = contentW*0.7;
                var right = contentW*0.3 - 20;
                $('#div_left').width(left);
                $('#div_right').width(right);
            }

            /* *************************** 标准字典模块初始化 ***************************** */

            hosReleaseRetrieve = {
                $element: $('#hosReleaseRetrieve'),
                $systemCode: $('#systemCode'),
                $addBtn: $('#btn_create'),
                init: function () {
                    this.$systemCode.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            hosReleaseMaster.reloadGrid(1);
                        }
                    });
                    this.$systemCode.keyup(function (e) {
                        if (e.keyCode == 13) {
                            hosReleaseMaster.reloadGrid(1);
                        }
                    });
                    this.$element.show();
                    window.form = this.$element;
                    hosReleaseMaster.init();
                }
            };

            hosReleaseMaster = {
                hosReleaseInfoDialog: null,
                grid: null,
                init: function () {
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        var systemCode = $("#systemCode").val();
                        this.grid = $("#div_hosRelease_grid").ligerGrid($.LigerGridEx.config({
                            url: '${contextRoot}/esb/hosRelease/getReleaseInfoList',
                            parms: {
                                systemCode: systemCode
                            },
                            columns: [
                                {display: 'id', name: 'id', hide: true},
                                {display: '系统代码', name: 'systemCode', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '文件路径', name: 'file', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '版本名称', name: 'versionName', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '发布时间', name: 'releaseDate', width: '20%', isAllowHide: false, align: 'left'},
                                {
                                    display: '操作', name: 'operator', width: '20%', render: function (row) {
                                    var html = '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "hosRelease:releaseInfo:open", row.id, 'modify') + '"></a>' +
                                               '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "hosRelease:releaseInfoGrid:delete", row.id) + '"></a>';
                                    return html;
                                }
                                }
                            ],
                            //enabledEdit: true,
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            onBeforeShowData: function (data) {
                                if (data.totalCount == 0) {
                                    installLogMater.reloadGrid(1, '');
                                }
                            },
                            onAfterShowData: function (data) {
                                if (selectRowObj != null && isSaveSelectStatus) {
                                    isSaveSelectStatus = false;
                                    hosReleaseMaster.grid.select(selectRowObj);
                                }else
                                    this.select(0);
                            },
                            onSelectRow: function (row) {
                                selectRowObj = row;
                                installLogMater.init("-1");
                                installLogMater.reloadGrid(1,row.systemCode);
                            }
                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },
                reloadGrid: function (curPage) {
                    var systemCode = $("#systemCode").val();
                    var values = {
                        systemCode: systemCode
                    };
                    this.grid.reload();
                },
                bindEvents: function () {
                    $.subscribe('hosRelease:releaseInfo:open', function (event, id, mode) {
                        var title = '';
                        //只有new 跟 modify两种模式会到这个函数
                        if (mode == 'modify') {
                            title = '修改程序包';
                        }
                        else {
                            title = '新增程序包';
                        }
                        isSaveSelectStatus = true;
                        hosReleaseMaster.releaseInfoDialog = $.ligerDialog.open({
                            height: 380,
                            width: 460,
                            title: title,
                            url: '${contextRoot}/esb/hosRelease/releaseInfo',
                            urlParms: {
                                releaseInfoId: id,
                                mode: mode
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('hosRelease:releaseInfoGrid:delete', function (event, id) {
                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/esb/hosRelease/deleteReleaseInfo', {
                                    data: {releaseInfoId: id},
                                    success: function (data) {
                                        if(data.successFlg){
                                            $.Notice.success('删除成功！');
                                            hosReleaseMaster.reloadGrid(Util.checkCurPage.call(hosReleaseMaster.grid, 1));
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

            installLogRetrieve = {
                init: function () {

                }
            };

            installLogMater = {
                grid: null,
                init: function (systemCode) {
                    if (this.grid)
                        return;
                    this.grid = $("#div_install_log_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/esb/installLog/searchInstallLogList',
                        parms: {
                            systemCode: systemCode
                        },
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: 'systemCode', name: 'systemCode', hide: true},
                            {display: '机构代码', name: 'orgCode', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '机构名称', name: 'orgName', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '更新时间', name: 'installDate', width: '34%', isAllowHide: false, align: 'left'}
                        ],
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: false,
                    }));
                    this.bindEvents();
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                reloadGrid: function (curPage, systemCode) {
                     systemCode = systemCode == '' ? -1 : hosReleaseMaster.grid.getSelectedRow().systemCode;
                    var values = {
                        systemCode: systemCode
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/esb/installLog/searchInstallLogList', values, curPage);
                },
                bindEvents: function () {
                    //窗体改变大小事件
                    $(window).bind('resize', function () {
                        resizeContent();
                    });

                }
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                hosReleaseMaster.reloadGrid();
            };
            win.closeDialog = function (msg) {
                hosReleaseMaster.releaseInfoDialog.close();
                if (msg){
                    $.Notice.success(msg);
                }
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
