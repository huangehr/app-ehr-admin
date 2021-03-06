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
            /* *************************** 函数定义结束******************************* */

            retrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $searchPortalResources: $("#inp_search"),
                $newPortalResources: $("#div_new_portalResources"),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchPortalResources.ligerTextBox({width: 240 });
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };

            master = {
                ResourcesInfoDialog: null,
                addResourcesInfoDialog:null,
                init: function () {
                    grid = $("#div_portalResources_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/portalResources/searchPortalResources',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '名称', name: 'name', width: '15%',align: 'center'},
                            {display: '版本', name: 'version', width: '5%'},
                            {display: '平台类别', name: 'platformTypeName', width: '10%', resizable: true,align: 'left'},
                            {display: '应用开发环境', name: 'developLanName', width: '10%', resizable: true,align: 'left'},
                            {display: '描述', name: 'description', width: '25%', resizable: true,align: 'left'},
                            {display: '上传日期', name: 'uploadTime', width: '15%', resizable: true,align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 160, render: function (row) {
                                var html = '<sec:authorize url="/portalResources/updatePortalResources"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalResources:ResourcesInfoModifyDialog:open", row.id) + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/portalResources/deletePortalResources"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalResources:ResourcesInfoModifyDialog:del", row.id) + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/appportalResources/uploadFile"><a data-toggle="model"  class="label_a" target="_blank" href="${contextRoot}/portalResources/uploadFile?storagePath='+ row.url + ' " >'+'下载'+'</a></sec:authorize>'
                                return html;
                            }
                            }
                        ]
                    }));
                    grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    retrieve.$element.attrScan();
                    reloadGrid.call(this, '${contextRoot}/portalResources/searchPortalResources', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });

                    //新增资源信息
                    retrieve.$newPortalResources.click(function(){
                        self.addResourcesInfoDialog = parent._LIGERDIALOG.open({
                            height: 470,
                            width: 600,
                            title: '新增资源信息',
                            url:'${contextRoot}/portalResources/addResourcesInfoDialog?'+ $.now()
                        })
                    });

                    //修改资源信息
                    $.subscribe('portalResources:ResourcesInfoModifyDialog:open', function (event, portalResourcesId, mode) {
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.ResourcesInfoDialog = parent._LIGERDIALOG.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 490,
                            width: 600,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/portalResources/getPortalResources',
                            load: true,
                            show: false,
                            urlParms: {
                                portalResourcesId: portalResourcesId,
                                mode:mode
                            },
							onLoaded:function() {
								wait.close(),
                                self.ResourcesInfoDialog.show()
							}
                        });
                        self.ResourcesInfoDialog.hide();
                    });
                    //删除资源
                    $.subscribe('portalResources:ResourcesInfoModifyDialog:del', function (event, portalResourcesId) {
                        parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/portalResources/deletePortalResources",{
                                    data:{portalResourcesId:portalResourcesId},
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
            win.parent.reloadMasterUpdateGrid = win.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeAddPortalResourcesInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.addResourcesInfoDialog.close();
            };
            win.parent.closeResourcesInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.ResourcesInfoDialog.close();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>