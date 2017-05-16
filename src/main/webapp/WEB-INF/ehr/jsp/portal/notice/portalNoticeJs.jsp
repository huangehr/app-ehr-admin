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
                $searchPortalNotice: $("#inp_search"),
                $newPortalNotice: $("#div_new_portalNotice"),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchPortalNotice.ligerTextBox({width: 240 });
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };

            master = {
                noticeInfoDialog: null,
                addNoticeInfoDialog:null,
                init: function () {
                   grid = $("#div_portalNotice_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/portalNotice/searchPortalNotices',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: '',
                        },
                       allowHideColumn:false,
                        columns: [
                            {display: '标题', name: 'title', width: '35%',align: 'left'},
                            {display: '类型', name: 'typeName', width: '15%'},
                            {display: '门户类型', name: 'portalTypeName', width: '10%'},
//                            {display: '内容', name: 'content', width: '45%', resizable: true,align: 'left'},
                            {display: '发布日期', name: 'releaseDate', width: '20%', resizable: true,align: 'center'},
                            {
                                display: '操作', name: 'operator', width: '20%', render: function (row) {
                                    var html = '<sec:authorize url="/portalNotice/updatePortalNotice"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalNotice:noticeInfoModifyDialog:open", row.id) + '"></a></sec:authorize>';
                                    html += '<sec:authorize url="/portalNotice/deletePortalNotice"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "portalNotice:noticeInfoModifyDialog:del", row.id) + '"></a></sec:authorize>';
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
                                //isResize:true,
                                title:'公告基本信息',
                                url: '${contextRoot}/portalNotice/getPortalNotice',
                                load: true,
                                isHidden: false,
                            	show: false,
                                urlParms: {
                                    portalNoticeId: row.id,
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
                    reloadGrid.call(this, '${contextRoot}/portalNotice/searchPortalNotice', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });

                    //新增通知公告信息
                    retrieve.$newPortalNotice.click(function(){
                        self.addNoticeInfoDialog = $.ligerDialog.open({
                            height: 550,
                            width: 750,
                            load: false,
                            title: '新增通知公告信息',
                            url: '${contextRoot}/portalNotice/addNoticeInfoDialog?'+ $.now()
                        })
                    });
                    //修改通知公告信息
                    $.subscribe('portalNotice:noticeInfoModifyDialog:open', function (event, portalNoticeId, mode) {
                        var wait = $.Notice.waitting("请稍后...");
                        self.noticeInfoDialog = $.ligerDialog.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 550,
                            width: 750,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/portalNotice/getPortalNotice',
                            load: true,
                        	show: false,
                            urlParms: {
                                portalNoticeId: portalNoticeId,
                                mode:mode
                            },
						    onLoaded:function() {
								wait.close(),
                                self.noticeInfoDialog.show()
							}
                        });
                        self.noticeInfoDialog.hide();
                    });
                    //删除通知公告
                    $.subscribe('portalNotice:noticeInfoModifyDialog:del', function (event, portalNoticeId) {
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/portalNotice/deletePortalNotice",{
                                    data:{portalNoticeId:portalNoticeId},
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
            win.closeAddPortalNoticeInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.addNoticeInfoDialog.close();
            };
            win.closeNoticeInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.noticeInfoDialog.close();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>