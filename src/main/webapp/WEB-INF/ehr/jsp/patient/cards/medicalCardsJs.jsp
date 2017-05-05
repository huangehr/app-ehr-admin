<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>

<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var dictId = 43;
			var isFirstPage = true;

            var barTools = function(){
                function onUploadSuccess(g, result){
                    if(result==undefined)
                        $.Notice.success("导入成功");
                    else{
                        result = eval('(' + result + ')')
                        if(result.maxMsg !=undefined){
                            $.Notice.error(result.maxMsg);
                        }else{
                            var url = "${contextRoot}/medicalCards/downLoadErrInfo?f="+ result.eFile[1] + "&datePath=" + result.eFile[0];
                            $.ligerDialog.open({
                                height: 80,
                                content: "请下载&nbsp;<a target='diframe' href='"+ url +"'>导入失败信息</a><iframe id='diframe' name='diframe'> </iframe>",
                            });
                        }
                    }
                }
                $('#upd').uploadFile({url: "${contextRoot}/medicalCards/import", onUploadSuccess: onUploadSuccess});
            };

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
                barTools();
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
                $status: $('#ipt_status'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),

                init: function () {
                    this.initDDL(dictId, $('#ipt_status'));
					this.$searchNm.ligerTextBox({width: 240});

                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },

                initDDL: function (dictId, target) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList", {
                        data: {dictId: dictId},
                        success: function (data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                width: '100',
                                data: [].concat(data.detailModelList)
                            });
                        }
                    });
                }
            };

            master = {
                medicalCardsInfoDialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_medicalCards_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/medicalCards/searchMedicalCardss',
                        parms: {
                            searchNm: '',
                            status: '',
                            page:1,
                            rows:15
                        },
                        columns: [
							{ display: '卡号',name: 'cardNo', width: '10%',isAllowHide: false},
                            { display: '卡类别',name: 'cardTypeName', width: '8%',isAllowHide: false},
							{ display: '发卡机构', name: 'releaseOrg', width: '10%', minColumnWidth: 60,},
                            { display: '发卡时间', name: 'releaseDate',width: '10%', align:'left' },
                            { display: '有效期起始时间', name: 'validityDateBegin',width: '10%',align:'left'},
                            { display: '有效期截止时间', name: 'validityDateEnd',width: '10%', align:'left' },
                            { display: '描述', name: 'description',width: '10%', align:'left' },
                            { display: '状态', name: 'status',width: '8%',render:function(row){
                                if (Util.isStrEquals(row.status,'1')) {
                                    return '有效';
                                } else {
                                    return '无效';
                                }
                            }
                            },
							{ display: '创建时间', name: 'createDate',width: '12%',align:'left'},
							{ display: '操作', name: 'operator', width: '12%', render: function (row) {
								var html = '';
								html += '<sec:authorize url="/medicalCards/medicalCardsInfo"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "medicalCards:medicalCardsInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
								html += '<sec:authorize url="/medicalCards/del"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "medicalCards:medicalCardsInfo:delete", row.id) + '"></a></sec:authorize>';
								return html;
                            }}
                        ],
						pageSize:20,
						enabledSort:true,
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false,
                        onDblClickRow : function (row){
							$.publish("medicalCards:medicalCardsInfo:open",[row.id,'view']);
                        },
                    }));

                    this.bindEvents();
                    this.grid.adjustToWidth();
                },

                reloadGrid: function (curPage) {
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
						$.publish("medicalCards:medicalCardsInfo:open",['','new']);
					});
					//新增、修改、查看统一定制方法
                    $.subscribe('medicalCards:medicalCardsInfo:open',function(event,medicalCardsId,mode){
						isFirstPage = false;
                        var title = '';
                        var wait = $.Notice.waitting("请稍后...");
                        if(mode == 'modify'){title = '修改就诊卡信息';};
						if(mode == 'new'){title = '新增就诊卡信息';};
						if(mode == 'view'){title = '查看就诊卡信息';}
                        master.medicalCardsInfoDialog = $.ligerDialog.open({
                            height:640,
                            width: 600,
                            title : title,
                            isHidden: false,
                            opener: true,
							load:true,
							show:false,
                            url: '${contextRoot}/medicalCards/infoInitial',
                            urlParms: {
                                id: medicalCardsId,
                                mode:mode
                            },
							onLoaded:function() {
								wait.close(),
                                master.medicalCardsInfoDialog.show()
							}
                        });
                        master.medicalCardsInfoDialog.hide();
                    });

					//删除
					$.subscribe('medicalCards:medicalCardsInfo:delete',function(event,id){
						isFirstPage = false;
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/medicalCards/deleteMedicalCards', {
									data: {id: id},
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
                master.medicalCardsInfoDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>