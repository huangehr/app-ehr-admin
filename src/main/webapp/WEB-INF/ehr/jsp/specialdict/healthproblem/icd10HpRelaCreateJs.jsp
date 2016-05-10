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
			var icd10HpRelaExcludeinfoGrid = null;

			var hpId = '';

			/* ***************************函数定义************************ */
			function pageInit(){
				retrieve.init();
				masters.init();
			}
			function reloadGrid(params){
				icd10HpRelaExcludeinfoGrid.set({
					parms:params
				});
				icd10HpRelaExcludeinfoGrid.reload();
			}

			/* ***************************模块初始化************************ */
			retrieve = {
				$element:$('.m-retrieve-area'),
				$searchNm: $('#ipt_create_search'),
				init:function(){
					hpId = $('#ipt_create_hpId').val();
					this.$element.attrScan();
					this.$searchNm.ligerTextBox({width:240,isSearch:true,search: function(){
						var searchNm = $('#ipt_create_search').val();
						var params = {
							searchNm:searchNm,
							hpId:hpId,
						};
						reloadGrid(params);
					}});
				},
			};

			masters = {
				init:function(){
					icd10HpRelaExcludeinfoGrid = $('#div_icd10_exclude_info_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/hp/icd10ListRelaExclude',
						parms: {
							searchNm: '',
							hpId:hpId,
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '疾病编码', name: 'code', width: '50%', align: 'left',checkbox:false},
							{display: '疾病名称', name: 'name', width: '50%',align:'left'},

						],
						validate: true,
						unSetValidateAttr: false,
						usePager:true,
						checkbox:true,
						height:330,
						rownumbers:true,
					}));
					icd10HpRelaExcludeinfoGrid.adjustToWidth();
					masters.bindEvents();

				},

				reloadGrid: function(){
					var searchNm = $('#ipt_create_search').val();
					var params = {
						searchNm:searchNm,
						hpId:hpId,
					};
					reloadGrid(params);
				},

				bindEvents: function(){
					//单个、批量删除事件(单个情况有传id号，批量自动扫描Grid表）
					$('#btn_relation_creates').click(function(){
						$.publish("hp:icd10:create",[''])
					});

					$.subscribe("hp:icd10:create",function(event,ids){
						if(!ids){
							var rows = icd10HpRelaExcludeinfoGrid.getSelectedRows();
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
						dataModel.createRemote("${contextRoot}/specialdict/hp/hpIcd10Relation/creates",{
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

					//新增关联窗口的确认按钮点击事件
//					$('#btn_create_confirm').click(function(){
//						win.closeCreateRelationDialog();
//					});

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
