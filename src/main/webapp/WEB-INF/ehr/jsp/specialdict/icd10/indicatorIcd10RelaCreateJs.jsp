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
				$element:$('.m-retrieve-area'),
				$searchNm: $('#ipt_create_search'),
				init:function(){
					icd10Id = $('#ipt_create_icd10Id').val();
					this.$element.attrScan();
					this.$searchNm.ligerTextBox({width:240,isSearch:true,search: function(){
						var searchNm = retrieve.$searchNm.val();
						var params = {
							searchNm:searchNm,
							icd10Id:icd10Id
						};
						reloadGrid(params);
					}});
				},
			};

			masters = {
				init:function(){
					infoGrid = $('#div_indicator_create_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/icd10/indicators/exclude',
						parms: {
							searchNm: '',
							icd10Id:icd10Id
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '指标编码', name: 'code', width: '40%', align: 'left',checkbox:false},
							{display: '指标名称', name: 'name', width: '40%',align:'left'},
							{display: '指标类别', name: 'typeName', width: '20%', align: 'center'},
						],
						validate: true,
						unSetValidateAttr: false,
						usePager:true,
						checkbox:true,
						height:330,
						rownumbers:false,
					}));
					infoGrid.adjustToWidth();
					masters.bindEvents();

				},

				reloadGrid: function(){
					var searchNm = $('#ipt_create_search').val();
					var params = {
						searchNm:searchNm,
						icd10Id:icd10Id
					};
					reloadGrid(params);
				},

				bindEvents: function(){
					//单个、批量删除事件(单个情况有传id号，批量自动扫描Grid表）
					$('#btn_relation_create').click(function(){
						$.publish("icd10:indicator:create",[''])
					});

					$.subscribe("icd10:indicator:create",function(event,ids){
						if(!ids){
							var rows = infoGrid.getSelectedRows();
							if(rows.length==0){
								$.Notice.warn('请选择要关联的数据行！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids;
						}
						var dataModel = $.DataModel.init();
						dataModel.createRemote("${contextRoot}/specialdict/icd10/indicator/creates",{
							data:{indicatorIds:ids,icd10Id:icd10Id},
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

					//新增关联窗口的确认按钮点击事件
					$('#btn_create_close').click(function(){
						win.closeCreateRelationDialog();
					});

					//新增关联窗口右上角的关闭按钮的关闭事件
					if($('.l-dialog-close')){
						$('.l-dialog-close').click(function(){
							win.reloadRelationInfoDialog();
						});
					};
				}
			};
			/* ***************************页面回调接口************************ */
			/* ***************************页面初始化************************ */
			pageInit();
		})
	})(jQuery,window);
</script>
