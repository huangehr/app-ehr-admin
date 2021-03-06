<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>

	(function ($, win) {
		$(function () {

			var openedDialog, curOprator;
			var dataModel = ${dataModel};
//			var resourceId = dataModel.resourceId;
			var rolesBackId = dataModel.rolesId;
			var rolesRsId = '${rolesRsId}';
			var initSub = function (){
				<%--$('#btn_back').click(function(){--%>
					<%--$('#contentPage').empty();--%>
					<%--$('#contentPage').load('${contextRoot}/userRoles/resource/initial?backParams='+JSON.stringify(dataModel.backParams));--%>
				<%--});--%>
				$('#resource_name').val(dataModel.resourceName);
				$('#resource_code').val(dataModel.code);
				$('#resource_sub').val(dataModel.resourceSub);
				$('#resource_title').html(dataModel.resourceName + "_数据元授权");
			}();

			var em = {
				grid: undefined, dialog: undefined, params: {},
				urls: {
					list: '${contextRoot}/rolesResource/grant/list',
					gotoModify: '${contextRoot}/rolesResource/grant/gotoMetaGrant',
					lock: '${contextRoot}/rolesResource/grant/rolesLock'
				},
				//初始化
				init: function(){
					var m = this;
					m.rendBarTools();
					m.rendGrid();
					m.publishFunc();
					em.find(rolesBackId, rolesRsId);


                    $(document).on('click', '.go-back', function (e) {
                        e.stopPropagation();
                        $("#contentPage").empty().load('${contextRoot}/userRoles/resource/initial?backParams='+JSON.stringify(dataModel.backParams));
                    });
				},

				//初始化工具栏
				rendBarTools : function(){
					function lock(type, isLock){
						var m = em, g = em.grid;
						var ids = [], rows;
						if(type==1){
							rows = g.getSelectedRows();
							if(rows.length==0){
								parent._LIGERDIALOG.warn("请选择数据！");
								return;
							}
						}else{
							if((rows = g.getData()).length==0){
								parent._LIGERDIALOG.warn("没有数据！");
								return;
							}
						}
						var data = [];
						$.each(rows, function (i, v) {
							if((isLock==0 && v.id) || isLock==1)
								data.push({
									"id": v.id,
									"rolesResourceId": v.rolesResourceId,
									"rolesId": v.rolesId,
									"resourceMetadataId": v.resourceMetadataId,
									"resourceMetadataName": v.resourceMetadataName,
									"dimensionId": v.dimensionId,
									"dimensionValue": v.dimensionValue,
									"valid": isLock
								});
						})



						var dialog = parent._LIGERDIALOG.waitting('正在处理中,请稍候...');
						var dataModel = $.DataModel.init();
						dataModel.updateRemote(m.urls.lock, {
							data: {data: JSON.stringify(data), valid: isLock, type: type},
							success: function (data) {
								if (data.successFlg) {
									parent._LIGERDIALOG.success('操作成功！');
                                    m.rendGrid();
                                    m.find();
                                } else {
									parent._LIGERDIALOG.error(data.errorMsg);
								}
							},
							complete: function () {
								dialog.close();
							},
							error: function(){
								parent._LIGERDIALOG.error('请求错误！');
							}
						});
					}
					var btn = [
						{type: '选中允许', id: 'allowChecked', clkFun: function(){
							lock(1, 1);
						}},
						{type: '选中禁止', id: 'forbidChecked', clkFun: function () {
							lock(1, 0);
						}},
						{type: '全部允许', id: 'allowAll', clkFun: function () {
							lock(2, 1);
						}},
						{type: '全部禁止', id: 'forbidAll', clkFun: function () {
							lock(2, 0);
						}}
					];
					initBarBtn($('#entry_retrieve_inner'), btn)
				},
				//初始化表格
				rendGrid : function(){
					function dimensionRender(row){
						try{
							var val = "";
							var dimensionValue = eval('('+ row.dimensionValue +')');
							if(dimensionValue.length>1)
								val = dimensionValue[0].conditionName || dimensionValue[1].conditionName;
							else
								val = dimensionValue[0].conditionName;
							return val;
						}catch(e){
							return "";
						}
					}
					var m = em;
					var columns = [
						{display: 'ID', name: 'id', hide: true},
						{display: '字段名称', name: 'resourceMetadataName', width: '30%', align: 'left'},
						{display: '维度授权', name: 'dimensionValue', width: '50%', align: 'left', render: dimensionRender},
						{display: '是否有效', name: 'valid', width: '10%', align: 'left', render: function (row) {
							return row.valid==1? '是': '否';
						}},
						{display: '操作', name: 'operator', width: '10%', render: m.opratorRender}];

					m.grid = initGrid($('#rightGrid'), m.urls.list, {}, columns, {delayLoad: true, rownumbers: true, usePager: false, heightDiff: 20});
				},
				//操作栏渲染器
				opratorRender: function (row){
					var vo = [
						{type: 'edit', clkFun: "$.publish('grant:meta:modify',['"+ row['id'] +"', '"+ row['rolesResourceId'] +"', '"+ row['resourceMetadataId'] +"', '"+ row['rolesId'] +"', 'modify'])"}
					];
					return initGridOperator(vo);
				},
				//修改、新增点击事件
				gotoModify : function (event, id, rolesResId, resMetaId, rolesId, mode) {
					id = id || '';
					curOprator = em;
					var params = {id: id, mode: mode, rolesResId: rolesResId, resMetaId: resMetaId, rolesId: rolesId};
					em.dialog = openedDialog = openDialog(em.urls.gotoModify, '维度授权', 500, 250, params);
				},
				//查询列表方法
				find : function (rolesId, rolesResourceId) {
					var params = !rolesId? em.params: (em.params = {extParms: '{"rolesResId": "'+ rolesResourceId +'", "appId": "'+ dataModel.backParams.appId +'"}', page:1, rows: 999});
					console.log(this)
					reloadGrid(this.grid, 1, params);
                },
				//公开方法
				publishFunc : function (){
					var m = em;
					$.subscribe('grant:meta:modify', m.gotoModify);
				}
			}
			em.init();

			win.parent.closeDialog = function (msg) {
				openedDialog.close();
				if(msg){
					parent._LIGERDIALOG.success(msg);
					curOprator.find();
				}
			}

			function cloneData(data){
				if(!data || data.length==0)
					return undefined;
				var newData = [];
				$.each(data, function (i, v) {
					newData.push({id: v.id, name: v.name, children: cloneData(v.children)})
				})
				return newData;
			}
		});
	})(jQuery, window);

</script>