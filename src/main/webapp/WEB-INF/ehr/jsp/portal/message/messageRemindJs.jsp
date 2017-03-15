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
                $searchMessageRemind: $("#inp_search"),
                $newMessageRemind: $("#div_new_messageRemind"),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchMessageRemind.ligerTextBox({width: 240 });
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
                    grid = $("#div_messageRemind_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/messageRemind/searchMessageReminds',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            searchNm: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '应用ID', name: 'appId', width: '8%',align: 'left'},
                            {display: '应用名称', name: 'appName', width: '8%'},
                            {display: '发起用户', name: 'fromUserId', width: '8%'},
                            {display: '对象用户', name: 'toUserId', width: '8%'},
                            {display: '内容', name: 'content', width: '15%', resizable: true,align: 'left'},
                            {display: '消息类型', name: 'typeName', width: '5%'},
                            {display: '工作应用链接', name: 'workUri', width: '15%'},
                            {display: '发布日期', name: 'createDate', width: '15%', resizable: true,align: 'center'},
                            {
                                display: '操作', name: 'operator', width: '10%', render: function (row) {
                                var html = '<sec:authorize url="/messageRemind/updateMessageRemind"><a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "messageRemind:messageInfoModifyDialog:open", row.id) + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/messageRemind/deleteMessageRemind"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "messageRemind:messageInfoModifyDialog:del", row.id) + '"></a></sec:authorize>';
                                return html;
                            }
                            }
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        onDblClickRow : function (row){
                            var mode = 'view';
                            $.ligerDialog.open({
                                height: 800,
                                width: 600,
                                isDrag:true,
                                title:'消息提醒基本信息',
                                url: '${contextRoot}/messageRemind/getMessageRemind',
                                load: true,
                                urlParms: {
                                    messageRemindId: row.id,
                                    mode:mode
                                }
                            });
                        }
                    }));
                    grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    retrieve.$element.attrScan();
                    reloadGrid.call(this, '${contextRoot}/messageRemind/searchMessageRemind', values);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });

                    //新增消息提醒信息
                    retrieve.$newMessageRemind.click(function(){
                        self.addMessageInfoDialog = $.ligerDialog.open({
                            height: 600,
                            width: 550,
                            title: '新增消息提醒信息',
                            url: '${contextRoot}/messageRemind/addMessageRemindInfoDialog?'+ $.now()
                        })
                    });
                    //修改消息提醒信息
                    $.subscribe('messageRemind:messageInfoModifyDialog:open', function (event, messageRemindId, mode) {
                        self.messageInfoDialog = $.ligerDialog.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 600,
                            width: 550,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/messageRemind/getMessageRemind',
                            load: true,
                            urlParms: {
                                messageRemindId: messageRemindId,
                                mode:mode
                            }
                        });
                    });
                    //删除消息提醒
                    $.subscribe('messageRemind:messageInfoModifyDialog:del', function (event, messageRemindId) {
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/messageRemind/deleteMessageRemind",{
                                    data:{messageRemindId:messageRemindId},
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
            win.closeAddMessageRemindInfoDialog = function (callback) {
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