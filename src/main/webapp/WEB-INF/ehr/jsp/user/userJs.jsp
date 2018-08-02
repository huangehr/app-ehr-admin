<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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
            var dialog=null;
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
                //$inpOrg: $('#inp_org'),
                init: function () {
                    var self = this;
                    retrieve.initDDL(settledWayDictId,this.$searchType);
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchBox.ligerTextBox({width:240});
                    /*var combo = self.$inpOrg.customCombo('${contextRoot}/deptMember/getOrgList');
                     self.$inpOrg.parent().css({
                     width:'240'
                     }).parent().css({
                     display:'inline-block',
                     width:'240px'
                     });*/
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
                                data: [].concat(data.detailModelList),
                                width:150
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
                            {name: 'id', hide: true, width: '0.1%', isAllowHide: false},
                            {display: '用户类型', name: 'userTypeName', width: '15%',align:'left'},
                            {display: '姓名', name: 'realName', width: '15%',align:'left'},
                            {display: '账号',name: 'loginCode', width:'15%', isAllowHide: false,align:'left'},
//                            {display: '所属机构', name: 'organizationName', width: '15%',align:'left'},
                            {display: '联系方式', name: 'telephone',width: '10%',align:'left'},
                            {display: '用户邮箱', name: 'email', width: '13%', resizable: true,align:'left'},

                            {display: '是否生/失效', name: 'activated', width: '8%', minColumnWidth: 20,render:function(row){
                                var html = Util.isStrEquals(row.activated,true) ? "生效" : "失效";
                                <sec:authorize url='User_Actived'>
                                if(Util.isStrEquals(row.activated,true)){
                                    html = '<a class="grid_on" href="javascript:void(0)" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "user:userInfoModifyDialog:failure", row.id,0,"失效") + '"></a>';
                                }else if(Util.isStrEquals(row.activated,false)){
                                    html ='<a class="grid_off" href="javascript:void(0)" title="已失效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "user:userInfoModifyDialog:failure", row.id,1,"生效") + '"></a>';
                                }
                                </sec:authorize>
                                return html;

                            }},
//                            {display:'用户来源',name:'sourceName',width:'10%'},
                            {display: '最近登录时间', name: 'lastLoginTime', width: '12%',align:'left'},
                            {display: '操作', name: 'operator', minWidth: 130, render: function (row) {
                                var html = '';
                                <sec:authorize url="/user/appFeatureInitial">
                                html += '<a class="label_a" title="查看权限" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "user:feature:open", row.id) + '">查看权限</a>';
                                </sec:authorize>
                                <sec:authorize url="/user/updateUser">
                                html += '<a class="grid_edit" title="编辑" style="width:30px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoModifyDialog:open", row.id, 'modify') + '"></a>';
                                </sec:authorize>
                                <sec:authorize url="/user/deleteUser">
                                html += '<a class="grid_delete" title="删除" style="width:30px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoDialog:del", row.id, 'delete') + '"></a>';
                                </sec:authorize>
                                return html;
                            }}
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        onDblClickRow : function (row){
                            var mode = 'view';
                            var wait = parent._LIGERDIALOG.waitting("请稍后...");
                            var rowDialog = parent._LIGERDIALOG.open({
                                height: 620,
                                width: 600,
                                isDrag:true,
                                //isResize:true,
                                title:'用户基本信息',
                                isHidden: false,
                                load: true,
                                show:false,
                                url: '${contextRoot}/user/getUser',
                                urlParms: {
                                    userId: row.id,
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
                    // 自适应宽度
                    userInfoGrid.adjustToWidth();

                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    //values.searchOrg = retrieve.$element.Fields.searchOrg.val();
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
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.userInfoDialog = parent._LIGERDIALOG.open({
                            //  关闭对话框时销毁对话框
                            title:'修改基本信息',
                            height: 620,
                            width: 800,
                            load: true,
                            isDrag: true,
                            isResize: true,
                            isHidden: false,
                            show: false,
                            url: '${contextRoot}/user/getUser',
                            urlParms: {
                                userId: userId,
                                mode:mode
                            },
                            onLoaded:function() {
                                wait.close(),
                                    self.userInfoDialog.show()
                            }
                        });
                        self.userInfoDialog.hide();
                    });
                    //新增用户
                    retrieve.$newRecordBtn.click(function () {
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.addUserInfoDialog = parent._LIGERDIALOG.open({
                            height: 520,
                            width: 600,
                            isDrag: true,
                            //isResize:true,
                            title: '新增用户信息',
                            url: '${contextRoot}/user/addUserInfoDialog',
                            load: true,
                            urlParms: {

                            },
                            isHidden: false,
                            show: false,
                            onLoaded: function () {
                                wait.close(),
                                    self.addUserInfoDialog.show()
                            }
                        });
                        self.addUserInfoDialog.hide();
                    });
                    //修改用户状态(生/失效)
                    $.subscribe('user:userInfoModifyDialog:failure', function (event, userId,activated,msg) {
                        parent._LIGERDIALOG.confirm('是否对该用户进行'+msg+'操作', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/user/activityUser', {
                                    data: {userId: userId,activated:activated},
                                    success: function (data) {
                                        if (data.successFlg) {
//                                            parent._LIGERDIALOG.success('修改成功');
                                            isFirstPage = false;
                                            master.reloadGrid();
                                        } else {
//                                            parent._LIGERDIALOG.error('修改失败');
                                        }
                                    }
                                });
                            }
                        });
                    });
                    //删除用户
                    $.subscribe('user:userInfoDialog:del', function (event, userId, activityFlg) {
                        parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/user/deleteUser",{
                                    data:{userId:userId},
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
                    //查看应用权限
                    $.subscribe('user:feature:open', function (event, userId) {
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote("${contextRoot}/user/isRoleUser",{
                            data:{userId:userId},
                            async:false,
                            success: function(data) {
                                if(data){
                                    self.userInfoDialog = parent._LIGERDIALOG.open({
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
                                }else{
                                    parent._LIGERDIALOG.error('该用户无任何应用的授权信息。');
                                }
                            }
                        });
                    });
                }
            };

            /* ************************* 模块初始化结束 ************************** */

            /* ************************* Dialog页面回调接口 ************************** */
            win.parent.reloadMasterUpdateGrid = win.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeUserInfoDialog = function (callback) {
                isFirstPage = false;
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.userInfoDialog.close();
            };
            win.parent.closeAddUserInfoDialog = function (callback) {
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