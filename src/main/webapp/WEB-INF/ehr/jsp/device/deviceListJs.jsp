<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var grid = null;
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
                $deviceName: $('#device_name'),
                $orgCode: $('#org_code'),
                $deviceType: $('#device_type'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),
                $importBtn: $('#btn_import'),
                init: function () {
					this.$deviceName.ligerTextBox({width: 200});
                    this.$element.show();
                    this.$element.attrScan();
                    this.$orgCode.customCombo('${contextRoot}/organization/orgCodes',{filters: "activityFlag=1;"});
                    this.$deviceType.customCombo('${contextRoot}/dict/searchDictForSelect',{dictId:"181"});
                    window.form = this.$element;
                }
            };
            master = {
                dialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_device_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/device/list',
                        parms: {

                        },
                        method:'GET',
                        columns: [
							{ display: 'ID',name: 'id', width: '0.1%',isAllowHide: false,hide:true},
                            { display: '设备名称', name: 'deviceName',width: '20%', isAllowHide: false,align:'left' },
							{ display: '归属机构', name: 'orgName',width: '20%',align:'left'},
							{ display: '设备代号', name: 'deviceTypeName', width: '20%',align:'left'},
							{ display: '设备型号', name: 'deviceModel', width: '10%',align:'left'},
							{ display: '购进台数', name: 'purchaseNum', width: '10%'},
							{ display: '产地', name: 'originPlace', width: '10%', render: function (row) {
                                if(row.originPlace=="1"){
                                    return '进口';
                                }else if (row.originPlace=="2"){
                                    return '国产/合资';
                                }else{
                                    return '';
                                }
                            }},
							{ display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '';
                                html += '<sec:authorize url="/device/info"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "device:deviceInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
								html += '<sec:authorize url="/device/delete"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "device:deviceInfo:delete", row.id) + '"></a></sec:authorize>';
								return html;
                            }}
                        ],
						enabledSort:false,
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false,
                        onDblClickRow : function (row){
							$.publish("device:deviceInfo:open",[row.id,'view']);
                        },
                    }));

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
                    var vo = [
                        {name: 'deviceName', logic: '?'},
                        {name: 'deviceType', logic: '='},
                        {name: 'orgCode', logic: '='}
                    ];
                    params = {filters: covertFilters(vo, retrieve.$element)};
					reloadGrid.call(this, params);
                },

                bindEvents: function () {
					//检索按钮
					retrieve.$searchBtn.click(function () {
						master.reloadGrid();
					});
					//新增按钮
					retrieve.$addBtn.click(function(){
						$.publish("device:deviceInfo:open",['','new']);
					});
					//导入按钮
					retrieve.$importBtn.click(function(){
						$.publish("device:deviceInfo:import");
					});
					//新增、修改、查看统一定制方法
                    $.subscribe('device:deviceInfo:open',function(event,id,mode){
						isFirstPage = false;
                        var title = '';
                        var wait=null;
                        wait = parent._LIGERDIALOG.waitting('正在加载中...');

                        if(mode == 'modify'){title = '修改设备信息';};
						if(mode == 'new'){title = '新增设备信息';};
						if(mode == 'view'){title = '查看设备信息';}
                        master.dialog = parent._LIGERDIALOG.open({
                            height:530,
                            width: 850,
                            title : title,
                            url: '${contextRoot}/device/deviceInfo',
                            urlParms: {
                                id: id,
                                mode:mode
                            },
                            isHidden: false,
                            opener: true,
							load:true,
							isDrag:true,
							show:false,
							onLoaded:function() {
                                wait.close();
                                master.dialog.show();
                            }
                        });
                        master.dialog.hide();
                    });

					//删除
					$.subscribe('device:deviceInfo:delete',function(event,id){
						isFirstPage = false;
						parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/device/delete', {
									data: {ids: id},
									success: function (data) {
									    console.info(data);
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

                    $.subscribe('device:deviceInfo:import', function (event) {
                        master.dialog = parent._LIGERDIALOG.open({
                            height: 400,
                            width: 512,
                            title: '导入',
                            url: '${contextRoot}/device/importInit',
                            urlParms: {},
                            isHidden: false
                        });
                    });
                }
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
                master.dialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>