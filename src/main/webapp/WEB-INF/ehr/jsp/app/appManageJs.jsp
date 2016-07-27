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

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $('#inp_search'),
				$searchOrg: $('#inp_search_org'),
                $catalog: $('#ipt_catalog'),
                $status: $('#ipt_status'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),
                init: function () {
                    this.initDDL(catalogDictId, $('#ipt_catalog'),searchParms.catalog);
                    this.initDDL(statusDictId, $('#ipt_status'),searchParms.status);
					this.$searchNm.ligerTextBox({width: 240,value:searchParms.searchNm});
					this.$searchOrg.ligerTextBox({width:240,value:searchParms.org});

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
                        url: '${contextRoot}/app/searchApps?sourceType=0',
                        parms: {
							searchNm:searchParms.searchNm,
							org: searchParms.org,
							catalog: searchParms.catalog,
							status: searchParms.status,
							page:searchParms.page
                        },
                        columns: [
							{ display: 'APP ID',name: 'id', width: '10%',isAllowHide: false},
							{ display: 'APP Secret', name: 'secret', width: '10%', minColumnWidth: 60,},
                            { display: '应用名称', name: 'name',width: '10%', isAllowHide: false,align:'left' },
							{ display: '机构代码', name: 'org',width: '8%',align:'left'},
							{ display: '机构名称', name: 'orgName',width: '11%',align:'left'},
							{ display: '类型', name: 'catalogName', width: '8%'},
                            { display: '回调URL', name: 'url', width: '15%',align:'left'},
							{ display: '审核', name: 'checkStatus', width: '8%',minColumnWidth: 20,render: function (row){
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
							{ display: '已授权资源', name: 'resourceNames', width: '8%',align:'left'},
							{ display: '操作', name: 'operator', width: '12%', render: function (row) {
								var html = '';
								if(Util.isStrEquals( row.status,'WaitingForApprove') || Util.isStrEquals( row.status,'Approved')){
									html += '<sec:authorize url="/app/resource/initial"><a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "app:resource:list", row.id,row.name,row.catalogName) + '">资源授权</a></sec:authorize>';
								}
								html += '<sec:authorize url="/app/template/appInfo"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:appInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
								html += '<sec:authorize url="/app/deleteApp"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "app:appInfo:delete", row.id) + '"></a></sec:authorize>';
								return html;
                            }}
                        ],
						pageSize:searchParms.pageSize,

						enabledSort:true,
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
                        if(mode == 'modify'){title = '修改应用信息';};
						if(mode == 'new'){title = '新增应用信息';};
						if(mode == 'view'){title = '查看应用信息';}
                        master.appInfoDialog = $.ligerDialog.open({
                            height:640,
                            width: 600,
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

					//删除
					$.subscribe('app:appInfo:delete',function(event,appId){
						isFirstPage = false;
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/deleteApp', {
									data: {appId: appId},
									success: function (data) {
										if (data.successFlg) {
											$.Notice.success('操作成功。');
											master.reloadGrid();
										} else {
											$.Notice.open({type: 'error', msg: '操作失败。'});
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
						var url = '${contextRoot}/app/resource/initial?';
						$("#contentPage").empty();
						$("#contentPage").load(url,{backParams:JSON.stringify(data)});
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