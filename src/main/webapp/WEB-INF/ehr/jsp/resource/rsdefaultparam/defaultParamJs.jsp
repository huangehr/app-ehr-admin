<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>
	(function($,win){
		$(function(){
			/* ***************************变量定义************************ */
			//通用工具
			var Util = $.Util;
			//控制模块
			var ParamMasters = null;
			var resourcesId = '${resourcesId}';
			var resourcesCode = '${resourcesCode}';
			/* ***************************函数定义************************ */
			function pageInit(){
				ParamMasters.init();
			}
			/* ***************************模块初始化************************ */
			ParamMasters = {
				paramGrid:undefined,
				EditRowIndex:undefined,
				init:function(){
					this.paramGrid = $('#div_param_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/rsDefaultParam/searchList',
						parms: {
							resourcesId:resourcesId,
						},
						columns: [
							{display:'id',name:'id',hide:true},
							{display: '资源id', name: 'resourcesId',hide:true},
							{display: '资源code', name: 'resourcesCode',hide:true},
							{display: '参数名', name: 'paramKey', width: '40%', align: 'center'},
							{display: '参数值', name: 'paramValue', width: '40%',align:'center'},
							{display: '操作', name: 'operator', width: '20%', align: 'center',render: function(row){
								var html = '';
								var rowIndex = row.__index;
								html += '<a class="grid_edit" name="delete_click" style="" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "resource:param:info:open",row.id,'modify',rowIndex) + '"></a>';
								html += '<a class="grid_delete" name="delete_click" style="" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "resource:param:delete", row.id,rowIndex) + '"></a>';
								return html;
							}},
						],
						enabledEdit:true,
						usePager:false,
						height:380,
					}));
					this.bindEvents();
				},
				bindEvents: function(){
					$('#btn_param_new').click(function(){
						$.publish("resource:param:info:open",['','new',''])
					});
					$.subscribe("resource:param:info:open",function(event,id,mode,rowIndex){
						var title = '';
						if(mode == 'new'){
							title = '新增资源接口'
						}else{
							title = '修改资源接口';
						};
						ParamMasters.infoDialog = $.ligerDialog.open({
							height: 250,
							width: 500,
							title: title,
							urlParms:{
								id:id,
								mode:mode,
								rowIndex:rowIndex,
								resourcesId:resourcesId,
								resourcesCode:resourcesCode
							},
							url: '${contextRoot}/resource/rsDefaultParam/infoInitial',
							isHidden: false,
							load: true,
						})
					});
					$.subscribe("resource:param:delete",function(event,id,rowIndex){
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.createRemote("${contextRoot}/resource/rsDefaultParam/delete",{
									data:{id:id},
									success: function(data){
										if (data.successFlg) {
											ParamMasters.paramGrid.deleteRow(rowIndex)
											$.Notice.success('删除成功');
										} else {
											$.Notice.error('删除失败');
										}
									}
								});
							}
						});
					});
				},
			};
			win.updateParamMasterInfo = function (rowIndex,data) {
				ParamMasters.paramGrid.updateRow(rowIndex,data);
			};
			win.addParamMasterInfo = function (data) {
				ParamMasters.paramGrid.append(data);
			};
			win.closeParamMasterInfoDialog = function(){
				ParamMasters.infoDialog.close();
			};
			/* ***************************页面初始化************************ */
			pageInit();
		})
	})(jQuery,window);
</script>
