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
			var icd10HpRelaIncludeInfoGrid = null;

			var hpId = '';
			/* ***************************函数定义************************ */

			function pageInit(){
				retrieve.init();
				masters.init();
			}

			function reloadGrid(params){
				icd10HpRelaIncludeInfoGrid.set({
					parms:params
				});
				icd10HpRelaIncludeInfoGrid.reload();
			}

			/* ***************************模块初始化************************ */

			retrieve = {
				$searchNm: $('#ipt_info_search'),
				//初始化检索模块
				init:function(){
					hpId = $('#ipt_info_hpId').val();
					this.$searchNm.ligerTextBox({width:240,isSearch:true,search: function(){
						debugger
						var searchNm = $('#ipt_info_search').val();
						var params = {
							searchNm:searchNm,
							hpId:hpId,
							page:0,
							rows:0
						};
						masters.reloadGrid(params);
					}});
				},
			};

			masters = {
				infoDialog:null,
				init:function(){
					icd10HpRelaIncludeInfoGrid = $('#div_icd10_include_info_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/hp/icd10ListRelaInclude',
						parms: {
							searchNm: '',
							hpId:hpId,
							page:0,
							rows:0
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '疾病编码', name: 'code', width: '35%', align: 'left',checkbox:false},
							{display: '疾病名称', name: 'name', width: '35%',align:'left'},
							{display: '操作', name: 'operator', width: '30%', align: 'center',render: function(row){
								html ='<a class="label_a" name="" style="margin-left:15px;" title="取消关联" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "hp:icd10:delete", row.id) + '">取消关联</a>';
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
					icd10HpRelaIncludeInfoGrid.adjustToWidth();
					masters.bindEvents();

				},

				//重新加载表格数据
				reloadGrid: function(){
					var searchNm = retrieve.$searchNm.val();
					var  values ={
						searchNm: searchNm,
						hpId:hpId,
						page:0,
						rows:0
					};
					reloadGrid.call(this, values);
				},

				bindEvents: function(){

					//单个、批量删除事件(单个情况有传id号，批量自动扫描Grid表）
					$('#btn_relation_deletes').click(function(){
						$.publish("hp:icd10:delete",[''])
					});

					$.subscribe("hp:icd10:delete",function(event,ids){
						if(!ids){
							var rows = icd10HpRelaIncludeInfoGrid.getSelectedRows();
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
						dataModel.createRemote("${contextRoot}/specialdict/hp/hpIcd10Relation/deletes",{
							data:{icd10Ids:ids,hpId:hpId},
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

					//弹出新增关联窗口
					$("#btn_relation_new").click(function(){
						var title = '关联ICD10字典';
						masters.createRelationDialog = $.ligerDialog.open({
							height:500,
							width:700,
							title:title,
							url:'${contextRoot}/specialdict/hp/hpIcd10RelationCreate/initial',
							urlParms:{
								hpId:hpId
							},
							isHidden: false,
							opener: true,
							load:true

						});
					});
					//新增关联窗口右上角的关闭按钮的关闭事件
					if($('.l-dialog-close')){
						$('.l-dialog-close').click(function(){
							win.reloadHpInfoGrid();
						});
					};

					//确认按钮点击事件关闭关联字典会话框
					$('#btn_confirm').click(function(){
						win.reloadHpInfoGrid();
						win.closeHpRelationInfoDialog();
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
