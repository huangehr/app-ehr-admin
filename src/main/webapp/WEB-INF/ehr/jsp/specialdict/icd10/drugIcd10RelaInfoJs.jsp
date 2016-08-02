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
					infoGrid = $('#div_drug_include_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/icd10/drugs/include',
						parms: {
							searchNm: '',
							icd10Id:icd10Id,
							page:0,
							rows:0
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '药品编码', name: 'code', width: '30%', align: 'left',checkbox:false},
							{display: '药品名称', name: 'name', width: '30%',align:'left'},
							{display: '药品类别', name: 'typeName', width: '20%',align:'left'},
							{display: '操作', name: 'operator', width: '20%', align: 'center',render: function(row){
								html ='<a class="label_a" name="" style="margin-left:15px;" title="取消关联" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "icd10:drug:delete", row.id) + '">取消关联</a>';
								return html;
							}},
						],
						validate: true,
						unSetValidateAttr: false,
						usePager:false,
						checkbox:true,
						height:330,
						rownumbers:false,
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
						$.publish("icd10:drug:delete",[''])
					});

					$.subscribe("icd10:drug:delete",function(event,ids){
						if(!ids){
							var rows = infoGrid.getSelectedRows();
							if(rows.length==0){
								$.Notice.warn('请选择要解除关联的数据行！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids;
						}
						var dataModel = $.DataModel.init();
						dataModel.createRemote("${contextRoot}/specialdict/icd10/drug/deletes",{
							data:{drugIds:ids,icd10Id:icd10Id},
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

					//新增关联对话框
					$('#btn_relation_new').click(function(){
						var title = '药品字典';
						masters.createRelationDialog = $.ligerDialog.open({
							height:500,
							width:700,
							title:title,
							url:'${contextRoot}/specialdict/icd10/drugRelaCreate/initial',
							urlParms:{
								id:icd10Id
							},
							isHidden: false,
							opener: true,
							load:true
						});
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
