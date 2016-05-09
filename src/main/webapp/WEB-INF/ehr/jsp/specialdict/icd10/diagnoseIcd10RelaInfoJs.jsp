<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/4/20
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function($,win){
		$(function(){
			/* ***************************变量定义************************ */
			//通用工具
			var Util = $.Util;
			//检索模块对象
			var retrieve = null;
			//控制模块
			var masters = null;
			//列表对象
			var infoGrid = null;

			var icd10Id = '';

			/* ***************************函数定义************************ */
			function pageInit(){
				retrieve.init();
				masters.init();
			}

			function reloadGrid(params){
				infoGrid.set({
					parms:params
				});
				infoGrid.reload();
			}

			/* ***************************模块初始化************************ */
			retrieve = {
				$searchNm: $('#ipt_include_search'),
				init:function(){
					icd10Id = $('#ipt_include_icd10Id').val();
					this.$searchNm.ligerTextBox({width:240,isSearch:true,search: function(){
						var searchNm = retrieve.$searchNm.val();
						var params = {
							searchNm:searchNm,
							icd10Id:icd10Id,
							page:0,
							rows:0
						};
						masters.reloadGrid(params);
					}});
				},
			};
			//控制模块
			masters = {
				infoDialog:null,
				init:function(){
					infoGrid = $('#div_diagnose_include_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/icd10/diagnoses/no_paging',
						parms: {
							searchNm: '',
							icd10Id:icd10Id,
							page:0,
							rows:0
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '诊断名称', name: 'name', width: '70%', align: 'left',checkbox:false},
							{display: '操作', name: 'operator', width: '30%', align: 'center',render: function(row){
								html ='<a class="label_a" name="" style="margin-left:15px;" title="解除关联" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "icd10:diagnoses:delete", row.id) + '">解除关联</a>'
									 +'<a class="grid_edit" name="delete_click" style="" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "icd10:diagnose:update", row.id,'modify') + '"></a>';

								return html;
							}},
						],
						validate: true,
						unSetValidateAttr: false,
						usePager:false,
						checkbox:true,
						height:330,
						rownumbers:false,
						onDblClickRow : function (row){
							var mode = 'view';
							$.publish('icd10:diagnose:update',[row.id,mode])
						}
					}));
					infoGrid.adjustToWidth();
					masters.bindEvents();

				},

				reloadGrid: function(){
					var searchNm = retrieve.$searchNm.val();
					var  values ={
						searchNm: searchNm,
						icd10Id:icd10Id,
						page:0,
						rows:0
					};
					reloadGrid.call(this, values);
				},

				bindEvents: function(){
					//单个、批量删除事件(单个情况有传id号，批量自动扫描Grid表）
					$('#btn_relation_deletes').click(function(){
						$.publish("icd10:diagnoses:delete",[''])
					});

					$.subscribe("icd10:diagnoses:delete",function(event,ids){
						if(!ids){
							var rows = infoGrid.getSelectedRows();
							if(rows.length==0){
								$.Notice.warn('请选择要删除的数据行！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids;
						}
						var dataModel = $.DataModel.init();
						dataModel.createRemote("${contextRoot}/specialdict/icd10/diagnoses/delete",{
							data:{ids:ids,icd10Id:icd10Id},
							success: function(data){
								if(data.successFlg){
									masters.reloadGrid();
									$.Notice.success('操作成功');
								}else{
									$.Notice.error(data.errorMsg);
								}
							}
						});
					});

					//新增、修改、查看对话框
					$('#btn_relation_new').click(function(){
						$.publish("icd10:diagnose:update",['','new']);
					});
					$.subscribe("icd10:diagnose:update",function(event,id,mode){
						var title = '';
						if(Util.isStrEquals('new',mode)){title = '新增关联诊断'}
						if(Util.isStrEquals('modify',mode)){title = '修改关联诊断';}
						if(Util.isStrEquals('view',mode)){title = '诊断信息';}
						masters.createRelationDialog = $.ligerDialog.open({
							height:350,
							width:500,
							title:title,
							url:'${contextRoot}/specialdict/icd10/diagnoseInfo/initial',
							urlParms:{
								icd10Id:icd10Id,
								id:id,
								mode:mode
							},
							isHidden: false,
							opener: true,
							load:true
						});
					});

					//关闭按钮点击事件关闭关联的诊断列表会话框
					$('#btn_include_close').click(function(){
						win.closeIcd10RelationInfoDialog();
					});
				}
			};
			/* ***************************页面回调接口************************ */
			//关闭关联窗口，刷新页面
			win.closeCreateRelationDialog = function(){
				masters.reloadGrid();
				masters.createRelationDialog.close()
			};

			//关联窗口关闭后的回调函数
			win.reloadRelationInfoDialog = function (callback) {
				masters.reloadGrid();
				if(callback){
					callback.call(win);
					masters.reloadGrid();
				}
			};

			/* ***************************页面初始化************************ */
			pageInit();
		})
	})(jQuery,window);
</script>
