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
                $searchPortalSetting: $("#inp_search"),
                $newPortalSetting: $("#div_new_portalSetting"),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchPortalSetting.ligerTextBox({width: 240 });
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };

            master = {
                messageInfoDialog: null,
                addMessageInfoDialog:null,
                init: function () {
                    grid = $("#div_portalSetting_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/portalSetting/searchPortalSettings',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: '',
                            page:1,
                            rows:15
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '机构ID', name: 'orgId', width: '8%'},
                            {display: '机构名称', name: 'orgName', width: '8%'},
                            {display: '应用ID', name: 'appId', width: '8%',align: 'center'},
                            {display: '应用名称', name: 'appName', width: '8%',align: 'center'},
                            {display: '推送栏目地址', name: 'columnUri', width: '18%'},
                            {display: '栏目名称', name: 'columnName', width: '8%'},
                            {display: '栏目请求方式', name: 'columnRequestTypeName', width: '15%', resizable: true,align: 'left'},
                            {display: 'API编号', name: 'appApiId', width: '5%'},
                            { display: '状态', name: 'status',width: '10%',isAllowHide: false,render:function(row){
                                    if (Util.isStrEquals(row.status,'0')) {
                                        return '有效';
                                    } else {
                                        return '失效';
                                    }
                               }
                            },
                            {
                                display: '操作', name: 'operator', width: '10%', render: function (row) {
                                var html = '<sec:authorize url="/portalSetting/updatePortalSetting"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalSetting:messageInfoModifyDialog:open", row.id) + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/portalSetting/deletePortalSetting"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalSetting:messageInfoModifyDialog:del", row.id) + '"></a></sec:authorize>';
                                return html;
                            }
                            }
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        onDblClickRow : function (row){
                            var mode = 'view';
                            var wait = $.Notice.waitting("请稍后...");
                            var rowDialog = $.ligerDialog.open({
                                height: 800,
                                width: 600,
                                isDrag:true,
                                isHidden: false,
                                show: false,
                                title:'门户配置提醒基本信息',
                                url: '${contextRoot}/portalSetting/getPortalSetting',
                                load: true,
                                urlParms: {
                                    portalSettingId: row.id,
                                    mode:mode
                                },
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
                    reloadGrid.call(this, '${contextRoot}/portalSetting/searchPortalSettings', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });

                    //新增门户配置提醒信息
                    retrieve.$newPortalSetting.click(function(){
                        self.addMessageInfoDialog = $.ligerDialog.open({
                            height: 600,
                            width: 550,
                            title: '新增门户配置提醒信息',
                            url: '${contextRoot}/portalSetting/addPortalSettingInfoDialog?'+ $.now()
                        })
                    });
                    //修改门户配置提醒信息
                    $.subscribe('portalSetting:messageInfoModifyDialog:open', function (event, portalSettingId, mode) {
                        var wait = $.Notice.waitting("请稍后...");
                        self.messageInfoDialog = $.ligerDialog.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 600,
                            width: 550,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/portalSetting/getPortalSetting',
                            load: true,
                            show: false,
                            urlParms: {
                                portalSettingId: portalSettingId,
                                mode:mode
                            },
							onLoaded:function() {
								wait.close(),
                                self.messageInfoDialog.show()
							}
                        });
                        self.messageInfoDialog.hide();
                    });
                    //删除门户配置提醒
                    $.subscribe('portalSetting:messageInfoModifyDialog:del', function (event, portalSettingId) {
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/portalSetting/deletePortalSetting",{
                                    data:{portalSettingId:portalSettingId},
                                    async:true,
                                    success: function(data) {
                                        if(data.successFlg){
                                            $.Notice.success('删除成功。');
                                            isFirstPage = false;
                                            master.reloadGrid();
                                        }else{
                                            $.Notice.error('删除失败。');
                                        }
                                    }
                                });
                            }
                        });

                    });
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };
            win.closeAddPortalSettingInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.addMessageInfoDialog.close();
            };
            win.closeMessageInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.messageInfoDialog.close();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>