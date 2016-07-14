<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            // 页面表格条件部模块
            var retrieve = null;
            // 页面主模块，对应于用户信息表区域
            var master = null;
            // 画面用户信息表对象
            var userInfoGrid = null;
            // 用户类型字典Id
            var settledWayDictId = 15;

            var isFirstPage = true;

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                retrieve.init();
                master.init();
            }
            //多条件查询参数设置
            function reloadGrid (url, params) {
                if (isFirstPage){
                    userInfoGrid.options.newPage = 1;
                }
//                userInfoGrid.set({
//                    url: url,
//                    parms: params
//                });
//
//                userInfoGrid.reload();

                userInfoGrid.setOptions({parms: params});
                userInfoGrid.loadData(true);

                isFirstPage = true;
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                // 模块对应的容器
                $element: $('.m-retrieve-area'),
                // 搜索框
                $searchBox: $('#inp_search'),
                // 新增按钮
                $newRecordBtn: $('#div_new_record'),
                //用户类型查询下拉框
                $searchType: $('#inp_select_searchType'),
                //查询按钮
                $searchBtn: $('#btn_search'),
                init: function () {
                    retrieve.initDDL(settledWayDictId,this.$searchType);
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchBox.ligerTextBox({width:240});
                },
                //下拉框列表项初始化
                initDDL: function (dictId, target) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList",{data:{dictId: dictId},
                        success: function(data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                data: [].concat(data.detailModelList)
                            });
                        }
                    });
                }
            };
            master = {
                userInfoDialog: null,
                addUserInfoDialog:null,
                init: function () {
                    userInfoGrid = $("#div_user_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/user/searchUsers',
                        // 传给服务器的ajax 参数
                        parms: {
                            searchNm: '',
                            searchType: ''
                        },
                        columns: [
                            // 隐藏列：hide: true（隐藏），isAllowHide: false（列名右击菜单中不显示）
                            {name: 'id', hide: true, isAllowHide: false},
                            {display: '用户类型', name: 'userTypeName', width: '10%',align:'left'},
                            {display: '姓名', name: 'realName', width: '10%',align:'left'},
                            {display: '账号',name: 'loginCode', width:'10%', isAllowHide: false,align:'left'},
                            {display: '所属机构', name: 'organizationName', width: '15%',align:'left'},
                            {display: '联系方式', name: 'telephone',width: '10%',align:'left'},
                            {display: '用户邮箱', name: 'email', width: '13%', resizable: true,align:'left'},
                            {display: '是否生/失效', name: 'activated', width: '10%', minColumnWidth: 20,render:function(row){
								var html ='';
								if(Util.isStrEquals(row.activated,true)){
//										html +='<div class="grid_on"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoModifyDialog:failure", row.id,0) + '"></div>';
									html+= '<a class="grid_on" href="javascript:void(0)" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "user:userInfoModifyDialog:failure", row.id,0,"失效") + '"></a>';
								}else if(Util.isStrEquals(row.activated,false)){
//										html +='<div class="grid_off" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoModifyDialog:failure", row.id,1) + '"></div>';
									html+='<a class="grid_off" href="javascript:void(0)" title="已失效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "user:userInfoModifyDialog:failure", row.id,1,"生效") + '"></a>';
								}
								return html;
                            }},
//                            {display:'用户来源',name:'sourceName',width:'10%'},
							{display: '最近登录时间', name: 'lastLoginTime', width: '12%',align:'left'},
                            {
                                display: '操作', name: 'operator', width: '10%', render: function (row) {
                                var html = '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoModifyDialog:open", row.id, 'modify') + '"></a>';
                                    //html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoDialog:del", row.id, 'delete') + '"></a>';
									html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "user:feature:open", row.id) + '"></a>';
								return html;
							}}
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        onDblClickRow : function (row){
                            var mode = 'view';
                            $.ligerDialog.open({
                                height: 750,
                                width: 600,
                                isDrag:true,
                                //isResize:true,
                                title:'用户基本信息',
                                url: '${contextRoot}/user/getUser',
                                load: true,
                                urlParms: {
                                    userId: row.id,
                                    mode:mode
                                }
                            });
                        }
                    }));
                    // 自适应宽度
                    userInfoGrid.adjustToWidth();

                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    reloadGrid.call(this, '${contextRoot}/user/searchUsers', values);
                },
                bindEvents: function () {
                    var self = this;
                    //查询事件
                    retrieve.$searchBtn.click(function(){
                            master.reloadGrid();
                    });
                    //修改用户信息
                    $.subscribe('user:userInfoModifyDialog:open', function (event, userId, mode) {
                        self.userInfoDialog = $.ligerDialog.open({
                            //  关闭对话框时销毁对话框
                            isHidden: false,
                            title:'修改基本信息',
                            height: 700,
                            width: 600,
                            isDrag:true,
                            isResize:true,
                            url: '${contextRoot}/user/getUser',
                            load: true,
                            urlParms: {
                                userId: userId,
                                mode:mode
                            }
                        });
                    });
                    //新增用户
                    retrieve.$newRecordBtn.click(function () {
                        self.addUserInfoDialog = $.ligerDialog.open({
                            height: 620,
                            width: 600,
                            title: '新增用户信息',
                            url: '${contextRoot}/user/addUserInfoDialog?'+ $.now()
                        })
                    });
                    //修改用户状态(生/失效)
                    $.subscribe('user:userInfoModifyDialog:failure', function (event, userId,activated,msg) {
                        $.ligerDialog.confirm('是否对该用户进行'+msg+'操作', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/user/activityUser', {
                                    data: {userId: userId,activated:activated},
                                    success: function (data) {
                                        if (data.successFlg) {
//                                            $.Notice.success('修改成功');
                                            isFirstPage = false;
                                            master.reloadGrid();
                                        } else {
//                                            $.Notice.error('修改失败');
                                        }
                                    }
                                });
                            }
                        });
                    });
                    //删除用户
                    $.subscribe('user:userInfoDialog:del', function (event, userId, activityFlg) {
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/user/deleteUser",{
                                    data:{userId:userId},
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
					//查看应用权限
					$.subscribe('user:feature:open', function (event, userId) {
						self.userInfoDialog = $.ligerDialog.open({
							title:'查看权限',
							height: 650,
							width: 600,
							isDrag:true,
							isResize:true,
							url: '${contextRoot}/user/appFeatureInitial',
							load: true,
							urlParms: {
								userId: userId,
							}
						});
					});
                }
            };

            /* ************************* 模块初始化结束 ************************** */

            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };
            win.closeUserInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.userInfoDialog.close();
            };
            win.closeAddUserInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.addUserInfoDialog.close();
            };



            /* ************************* Dialog页面回调接口结束 ************************** */

            /* *************************** 页面初始化 **************************** */

            pageInit();

            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>