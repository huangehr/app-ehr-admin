<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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
            var sourceTypeDictId = 38;
			var isFirstPage = true;

			//初始检索条件、page、pageSize
			var appPageParams = JSON.parse(sessionStorage.getItem('appPageParams'))
			sessionStorage.removeItem('appPageParams');
			var searchParms = {
				searchNm:appPageParams && appPageParams.searchNm || '',
				org:appPageParams && appPageParams.org || '',
				catalog:appPageParams && appPageParams.catalog || '',
				status:appPageParams && appPageParams.status || '',
				page:appPageParams && appPageParams.page || 1,
				pageSize:appPageParams && appPageParams.pageSize || 15,
			}


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
			//添加碎片
			function appendNav(str, url, data) {
                sessionStorage.setItem("applevel1",JSON.stringify(data));
                $('#navLink').append('<span class="applevel1"> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $('#inp_search'),
				$searchOrg: $('#inp_search_org'),
                $catalog: $('#ipt_catalog'),
                $status: $('#ipt_status'),
                $sourceType: $('#ipt_sourceType'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),
                init: function () {
                    this.initDDL(catalogDictId, $('#ipt_catalog'),searchParms.catalog);
                    this.initDDL(statusDictId, $('#ipt_status'),searchParms.status);
                    this.initDDL(sourceTypeDictId, $('#ipt_sourceType'),searchParms.sourceType);
					this.$searchNm.ligerTextBox({width: 200,value:searchParms.searchNm});
					this.$searchOrg.ligerTextBox({width:200,value:searchParms.org});

                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },
                initDDL: function (dictId, target,initValue) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList",{data:{dictId: dictId,page: 1, rows: 10},
                        success: function(data) {
                            var comboBox = target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                data: [].concat({code:'',value:''},data.detailModelList),
								width:160,
                            });
							comboBox.setValue(initValue);//设置初始值
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
							searchNm:searchParms.searchNm,
							org: searchParms.org,
							catalog: searchParms.catalog,
                            sourceType: searchParms.sourceType,
                            status: searchParms.status,
							page:searchParms.page
                        },
                        columns: [
							{ display: 'APP ID',name: 'id', width: '0.1%',isAllowHide: false,hide:true},
							{ display: 'APP Secret', name: 'secret', width: '0.1%', minColumnWidth: 60, hide:true},
                            { display: '应用名称', name: 'name',width: '20%', isAllowHide: false,align:'left' },
                            { display: '应用来源', name: 'sourceType',width: '10%',isAllowHide: false,render:function(row){
                                if (row.sourceType==1) {
                                    return '平台';
                                } else {
                                    return '接入';
                                }
                            }
                            },
							{ display: '机构代码', name: 'org',width: '10%',align:'left'},
							{ display: '机构名称', name: 'orgName',width: '18%',align:'left'},
							{ display: '类型', name: 'catalogName', width: '10%'},
//                          { display: '回调URL', name: 'url', width: '15%',align:'left'},
							{ display: '审核', name: 'checkStatus', width: 80,minColumnWidth: 20,render: function (row){
								if(Util.isStrEquals( row.status,'WaitingForApprove')) {
									return '<sec:authorize url="/app/check"><a data-toggle="model"  class="checkPass label_a" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","appInfo:appInfoGrid:approved", row.id)+'">'+'通过'+'</a>/' +
											'<a class="veto label_a" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","appInfo:appInfoGrid:reject", row.id)+'">'+'否决'+'</a></sec:authorize>'
								} else if(Util.isStrEquals( row.status,'Approved')){
									return '<sec:authorize url="/app/check"><a data-toggle="model"  class="Forbidden label_a" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","appInfo:appInfoGrid:forbidden", row.id)+'">'+'禁用'+'</a></sec:authorize>'
								}else if(Util.isStrEquals( row.status,'Forbidden')){
									return '<sec:authorize url="/app/check"><a data-toggle="model"  class="checkPass label_a" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","appInfo:appInfoGrid:open", row.id)+'">'+'开启'+'</a></sec:authorize>'
								}else if(Util.isStrEquals( row.status,'Reject')){
									return '无'
								}
							}},
//							{ display: '已授权资源', name: 'resourceNames', width: '8%',align:'left'},
							{ display: '操作', name: 'operator', minWidth: 240, render: function (row) {
								var html = '';
								if(Util.isStrEquals( row.status,'WaitingForApprove') || Util.isStrEquals( row.status,'Approved')){
									html += '<sec:authorize url="/app/resource/initial"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "app:resource:list", row.id,row.name,row.catalogName) + '">视图授权</a></sec:authorize>';
								}
                                html += '<sec:authorize url="/app/functionfeature/initial"><a class="label_a" style="margin-left:10px"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "app:platform:manager", row.id,row.name) + '">功能管理</a></sec:authorize>';
                                html += '<sec:authorize url="/app/feature/initial"><a class="label_a" style="margin-left:10px"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "app:api:manager", row.id,row.name) + '">API管理</a></sec:authorize>';
                                html += '<sec:authorize url="/app/template/appInfo"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:appInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
								html += '<sec:authorize url="/app/deleteApp"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "app:appInfo:delete", row.id) + '"></a></sec:authorize>';
								return html;
                            }}
                        ],
						pageSize:searchParms.pageSize,

						enabledSort:false,
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false,
                        onDblClickRow : function (row){
							$.publish("app:appInfo:open",[row.id,'view']);
                        },
                    }));

					delete master.grid.options.parms.page;
					if(searchParms.page >1){
						master.grid.options.newPage = searchParms.page;
					}

                    this.bindEvents();
                    this.grid.adjustToWidth();
                },
                check: function (id,status) {
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/app/check",{data:{appId:id,status:status},
                        success: function(data) {
                            isSaveSelectStatus = true;
                            master.reloadGrid();
                        }});
                },
                reloadGrid: function (curPage) {
                    var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
                },

				//获取当前页面检索条件及页面分页信息,并保存到session中
				savePageParamsToSession: function(){
					var values = retrieve.$element.Fields.getValues();
					values.page = parseInt($('.pcontrol input', master.grid.toolbar).val());
					values.pageSize = $(".l-bar-selectpagesize select", master.grid.toolbar).val();
					sessionStorage.setItem("appPageParams",JSON.stringify(values));
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
						isFirstPage = false;
                        var title = '';
                        var wait=null;
                        wait = parent._LIGERDIALOG.waitting('正在加载中...');

                        if(mode == 'modify'){title = '修改应用信息';};
						if(mode == 'new'){title = '新增应用信息';};
						if(mode == 'view'){title = '查看应用信息';}
                        master.appInfoDialog = parent._LIGERDIALOG.open({
                            height:530,
                            width: 850,
                            title : title,
                            url: '${contextRoot}/app/template/appInfo',
                            urlParms: {
                                appId: appId,
                                mode:mode
                            },
                            isHidden: false,
                            opener: true,
							load:true,
							isDrag:true,
							show:false,
							onLoaded:function() {
                                wait.close();
                                master.appInfoDialog.show();
                            }
                        });
                        master.appInfoDialog.hide();
                    });

					//删除
					$.subscribe('app:appInfo:delete',function(event,appId){
						isFirstPage = false;
						parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/deleteApp', {
									data: {appId: appId},
									success: function (data) {
										if (data.successFlg) {
                                            parent._LIGERDIALOG.success('操作成功。');
											master.reloadGrid();
										} else {
                                            parent._LIGERDIALOG.open({type: 'error', msg: '操作失败。'});
										}
									}
								});
							}
						});
					});

                    $.subscribe('appInfo:appInfoGrid:approved',function(event,id) {
                        var status = "Approved";
                        master.check(id,status);
                    });
                    $.subscribe('appInfo:appInfoGrid:reject',function(event,id) {
                        var status = "Reject";
                        master.check(id,status);
                    });
                    $.subscribe('appInfo:appInfoGrid:forbidden',function(event,id) {
                        var status = "Forbidden";
                        master.check(id,status);
                    });
                    $.subscribe('appInfo:appInfoGrid:open',function(event,id) {
                        var status = "Approved";
                        master.check(id,status);
                    });
					//资源授权页面跳转
					$.subscribe('app:resource:list', function (event, appId,name,catalogName) {
						master.savePageParamsToSession();
						var data = {
							'appId':appId,
							'appName':name,
							'catalogName':catalogName,
							'categoryIds':'',
							'sourceFilter':'',
						}
						var url = '${contextRoot}/app/resource/initial';
                        appendNav("视图授权", url, {backParams:JSON.stringify(data)});
					});
                    //功能管理
                    $.subscribe('app:platform:manager', function (event, appId,name) {
                        var data = {
                            'dataModel':appId+","+name
                        }
                        var url = '${contextRoot}/app/feature/initial';
                        appendNav("功能管理", url, data);
                    });

                    //API管理
                    $.subscribe('app:api:manager', function (event, appId,name) {
                        var url= '${contextRoot}/app/api/initial';
                        var data = {
                            'dataModel':appId
                        }
                        appendNav("API管理", url, data);
                    });

                    $(document).on('click', '.go-back', function () {
                        win.location.reload();
                    });

                },
            };
            /* ******************Dialog页面回调接口****************************** */
            win.parent.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.reloadGrid();
                master.appInfoDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>