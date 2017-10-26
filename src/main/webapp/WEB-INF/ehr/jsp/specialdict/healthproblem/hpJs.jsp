<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/4/13
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
	(function($,win){
		$(function(){
			/* ***************************变量定义************************ */
			// 通用工具类库
			var Util = $.Util;
			// 页面查询模块
			var retrieve = null;
			// 页面信息模块
			var masters = null;
			//版本信息表对象
			var infoGrid = null;
			/* **************************函数定义************************ */
			// 页面初始化函数
			function pageInit(){
				retrieve.init();
				masters.init();
			};
			// 数据重载函数
			function reloadGrid(parms){
				infoGrid.set({
					parms:parms,
				});
				infoGrid.reload();
			};

			/* *************************模块初始化*********************** */
			retrieve = {
				$element:$('.m-retrieve-area'),
				$searchNm:$('#inp_searchNm'),
				$searchBtn:$('#btn_search'),
				$newRecordBtn:$('#div_new_record'),
				$btnDeletes:$('#btn_deletes'),
				init:function(){
					this.$element.attrScan();
					window.form=this.$element;
					this.$searchNm.ligerTextBox({width:240,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {searchNm:searchNm};
						reloadGrid(parms);
					}});
				},
			};
			masters = {
				relationInfoDialog : null,
				init:function(){
					infoGrid = $('#div_special_dict_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/hp/hps',
						parms: {
							searchNm: ''
						},
						columns: [
							{display:'id',name:'id', width: '0.1%',hide:true},
							{display: '疾病编码', name: 'code', width: '20%', align: 'left'},
							{display: '疾病名称', name: 'name', width: '25%',align:'left'},
							{display: '关联诊断', name: 'icd10Name', width: '35%',align:'left'},
							{
								display: '操作', name: 'operator', minWidth: 170, align: 'center',render: function(row){
								var html = '';
								html += '<sec:authorize url="/specialdict/hp/hpIcd10Relation/initial"><a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "hpIcd10:relation:info:open", row.id) + '">关联诊断</a></sec:authorize>';
								html += '<sec:authorize url="/specialdict/hp/dialog/hp"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "hp:info:open", row.id,'modify') + '"></a></sec:authorize>';
								html += '<sec:authorize url="/specialdict/hp/deletes"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "hp:info:delete", row.id) + '"></a></sec:authorize>';
								return html;
							}},
						],
						//enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
						usePager:true,
						checkbox:true,
					}));
					infoGrid.adjustToWidth();
					masters.bindEvents();
				},

				reloadGrid: function () {
					var searchNm = retrieve.$searchNm.val();
					var  values ={
						searchNm: searchNm,
					};
					reloadGrid.call(this, values);
				},

				bindEvents:function(){
					var self = this;
					//TODO 字典导入事件
					//TODO 字典导出事件

					//新增、修改点击事件
					$('#div_new_record').click(function(){
						$.publish('hp:info:open',['','new']);
					});

					$.subscribe('hp:info:open',function(event,id,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改字典项';
						}else{
							title = '新增字典项'
						};
						self.infoDialog = $.ligerDialog.open({
							height:400,
							width:500,
							title:title,
							url:'${contextRoot}/specialdict/hp/dialog/hp',
							urlParms:{
								id:id,
								mode:mode,
							},
							isHidden: false,
							opener: true,
							load:true
						});
					});

					//单个、批量删除事件(单个情况有传id号，批量自动扫描Grid表）
					$('#btn_deletes').click(function(){
						$.publish('hp:info:delete',['']);
					});
					$.subscribe('hp:info:delete',function(event,ids){
						if(!ids){
							var rows = infoGrid.getSelectedRows();
							if(rows.length==0){
								$.Notice.warn('请选择要删除的数据行！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
						}
						$.Notice.confirm('确认要删除所选数据？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/hp/deletes',{
									data:{ids:ids},
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '删除成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error('删除失败！');
										}
									}
								});
							}
						})
					});

					//管理ICD10事件
					$.subscribe('hpIcd10:relation:info:open',function(event,id){
						var title = '关联诊断';
						self.relationInfoDialog = $.ligerDialog.open({
							height:500,
							width:700,
							title:title,
							url:'${contextRoot}/specialdict/hp/hpIcd10Relation/initial',
							urlParms:{
								hpId:id
							},
							isHidden: false,
							opener: true,
							load:true
						});
					});
				},
			};
			/* ************************* Dialog页面回调接口 ************************** */
			win.reloadHpInfoGrid = function () {
				masters.reloadGrid();
			};
			win.closeHpInfoDialog = function () {
				masters.infoDialog.close();
			};
			win.closeHpRelationInfoDialog = function () {
				masters.relationInfoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* ************************* 页面初始化 ************************** */
			pageInit();
		});
	})(jQuery,window);
</script>