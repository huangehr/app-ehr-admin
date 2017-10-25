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
				})
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
				infoDialog : null,
				init:function(){
					infoGrid = $('#div-special-dict-grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/indicator/indicators',
						parms: {
							searchNm: ''
						},
						columns: [
							{display:'id',name:'id', width: '0.1%',hide:true},
							{display: '指标编码', name: 'code', width: '20%', align: 'left'},
							{display: '指标名称', name: 'name', width: '20%',align:'left'},
							{display: '指标类别', name: 'typeName', width: '10%',align:'center'},
							{display: '指标单位', name: 'unit', width: '20%',align:'center'},
							{display: '正常值上限', name: 'upperLimit', width: '10%', align: 'center'},
							{display: '正常值下限', name: 'lowerLimit', width: '10%', align: 'center'},
							{
								display: '操作', name: 'operator', minWidth: 100, align: 'center',render: function(row){
								html ='<sec:authorize url="/specialdict/indicator/update"><a class="grid_edit" name="delete_click" style="" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "indicator:info:open", row.id,'modify') + '"></a></sec:authorize>'
										+'<sec:authorize url="/specialdict/indicator/deletes"><a class="grid_delete" name="delete_click" style="" title="删除"' +
										' onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "indicator:info:delete", row.id) + '"></a></sec:authorize>';
								return html;
							}},
						],
						//enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
						usePager:true,
						checkbox:true
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
					//新增、修改事件
					$('#div_new_record').click(function () {
						$.publish('indicator:info:open',['','new']);
					})
					$.subscribe('indicator:info:open',function(event,id,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改字典项';
						}else{
							title = '新增字典项'
						};
						self.infoDialog = $.ligerDialog.open({
							height:550,
							width:500,
							title:title,
							url:'${contextRoot}/specialdict/indicator/dialog/indicator',
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
						$.publish('indicator:info:delete',['']);
					});
					$.subscribe('indicator:info:delete',function(event,ids){
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
								dataModel.updateRemote('${contextRoot}/specialdict/indicator/deletes',{
									data:{ids:ids},
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '删除成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error(data.errorMsg);
										}
									}
								});
							}
						})
					});
				},
			};
			/* ************************* Dialog页面回调接口 ************************** */
			win.reloadIndicatorInfoGrid = function () {
				masters.reloadGrid();
			};
			win.closeIndicatorInfoDialog = function () {
				masters.infoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* ************************* 页面初始化 ************************** */
			pageInit();
		});
	})(jQuery,window);
</script>