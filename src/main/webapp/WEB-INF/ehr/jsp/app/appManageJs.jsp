<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var appInfoGrid = null;
            var catalogDictId = 1;
            var statusDictId = 2;
			var isFirstPage = true;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }
			function reloadGrid (params) {
				if (isFirstPage){
					this.grid.options.newPage = 1;
				}
				this.grid.setOptions({parms: params});
				this.grid.loadData(true);
				isFirstPage = true;
			}

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $('#inp_search'),
				$searchOrg: $('#inp_search_org'),
                $catalogDDL: $('#ipt_catalog'),
                $statusDDL: $('#ipt_status'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),
                init: function () {
                    this.initDDL(catalogDictId, $('#ipt_catalog'));
                    this.initDDL(statusDictId, $('#ipt_status'));
                    this.$searchNm.ligerTextBox({width: 240});
					this.$searchOrg.ligerTextBox({width:240});
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },
                initDDL: function (dictId, target) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList",{data:{dictId: dictId,page: 1, rows: 10},
                        success: function(data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                data: [].concat({code:'',value:''},data.detailModelList),
								width:160,
                            });
                        }});
                },
            };
            master = {
                appInfoDialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_app_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/app/searchApps',
                        parms: {
                            searchNm: '',
							org: '',
                            catalog: '',
                            status: ''
                        },
                        columns: [
							{ display: 'APP ID',name: 'id', width: '15%',isAllowHide: false,hide:true },
							{ display: 'APP Secret', name: 'secret', width: '10%', minColumnWidth: 60,hide:true },
                            { display: '应用名称', name: 'name',width: '10%', isAllowHide: false,align:'left' },
							{ display: '机构代码', name: 'org',width: '10%',align:'left'},
							{ display: '机构名称', name: 'orgName',width: '15%',align:'left'},
							{ display: '类型', name: 'catalogName', width: '10%'},
                            { display: '回调URL', name: 'url', width: '15%',align:'left'},
							{display: '是否生/失效', name: 'status', width: '10%', minColumnWidth: 20,render:function(row){
								var html ='';
								if(Util.isStrEqualsIgnorecase(row.status,'Approved')){
									html+= '<a class="grid_on" href="javascript:void(0)" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "appInfo:appInfoGrid:status", row.id,"Forbidden",'失效') + '"></a>';
								}else{
									html+='<a class="grid_off" href="javascript:void(0)" title="已失效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "appInfo:appInfoGrid:status", row.id,"Approved",'生效') + '"></a>'
								}
								return html;
							}},
							{ display: '已授权资源', name: 'description', width: '20%',align:'left'},
							{ display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '';
								html += '<a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "app:resource:list", row.id) + '">资源授权</a>';
								html += '<a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:appInfo:open", row.id, 'modify') + '"></a>';
								return html;
                            }}
                        ],
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false,
                        onDblClickRow : function (row){
							$.publish("app:appInfo:open",[row.id,'view']);
                        },
                    }));
                    this.bindEvents();
                    this.grid.adjustToWidth();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
                },
                bindEvents: function () {
					//检索按钮
					retrieve.$searchBtn.click(function () {
						master.reloadGrid();
					});
					//新增按钮
					retrieve.$addBtn.click(function(){
						$.publish("app:appInfo:open",['','new']);
					});
					//新增、修改、查看统一定制方法
                    $.subscribe('app:appInfo:open',function(event,appId,mode){
                        var title = '';
                        if(mode == 'modify'){
                            title = '修改应用信息';
                        }else{
                            title = '新增应用信息';
                        }
                        master.appInfoDialog = $.ligerDialog.open({
                            height:500,
                            width: 500,
                            title : title,
                            url: '${contextRoot}/app/template/appInfo',
                            urlParms: {
                                appId: appId,
                                mode:mode
                            },
                            isHidden: false,
                            opener: true,
							load:true
                        });
                    });
					//生/失效---审核通过与禁用
					$.subscribe('appInfo:appInfoGrid:status',function(event,id,status,msg) {
						$.ligerDialog.confirm('是否对该应用进行'+msg+'操作？', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/check', {
									data: {appId:id,status:status},
									success: function (data) {
										if (data.successFlg) {
											isFirstPage = false;
											master.reloadGrid();
										} else {
										}
									}
								});
							}
						});
					});
					//资源授权页面跳转
					$.subscribe('app:resource:list', function (event, appId) {
						var url = '${contextRoot}/app/resource/initial?appId=' + appId+'&backParams=';
						$("#contentPage").empty();
						$("#contentPage").load(url);
					});

                },
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.closeDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.appInfoDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>