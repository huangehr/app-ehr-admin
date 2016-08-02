<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
	#btn_param_new { position: absolute; top: 0px; right: 10px;}
</style>

<script>

	//参数列表
	var parmGrid = {
		grid: undefined,
		init: function () {
			this.barTools();
			this.rendGrid();
		},
		barTools: function(){
			var m = this;
			var btn = [{type: 'edit', clkFun: function () {
				m.grid.append({id:0, name: 'param', type: '0', dataType: 'DATE', required: '0', defaultValue: '', description: '', memo: ''});
			}}];
			initBarBtn($('#parmsForm'), btn);
		},
		opratorRender: function (row){
			var vo = [
				{type: 'del', clkFun: "$.publish('app:api:param:del',["+ row['id'] +", '"+ row['__id'] +"'])"}];
			return initGridOperator(vo);
		},
		rendGrid: function(){
			var columns = [
				{display: '参数名', name: 'name', width: '20%', align: 'left',
					editor: {type:"text", reg: 'required'}},
				{display: '参数类型', name: 'type', width: '10%', align: 'left', render: function (record) {
					return paramTypeMap[record.type];
				}, editor: {type:"select", data: paramTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
				{display: '数据类型', name: 'dataType', width: '10%', align: 'left',render: function (record) {
					debugger
					return dataTypeMap[record.dataType];
				}, editor: {type:"select", data: dataTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
				{display: '是否必填', name: 'required', width: '10%', align: 'left',render: function (record) {
					return requiredTypeMap[record.required];
				}, editor: {type:"select", data: requiredTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
				{display: '默认值', name: 'defaultValue', width: '10%', align: 'left', editor: {type:"text"}},
				{display: '说明', name: 'description', width: '20%', align: 'left', editor: {type:"text"}},
				{display: '备注', name: 'memo', width: mode=='view'?'20%':'10%', align: 'left', editor: {type:"text"}}];
			if(mode!='view'){
				columns.push({display: '操作', name: 'operator', width: '10%', render: this.opratorRender});
			}
			this.grid = initGridDef($('#parmsGrid'), urls.apiParameterLs, {}, columns,
					{delayLoad: true, checkbox: false, usePager: false, height:70, rownumbers: false, enabledEdit: mode!='view', editorTopDiff: 0,
						onBeforeSubmitEdit: onBeforeSubmitEdit,
						onSuccess: function (data) {
							if(data.successFlg) {
								if(data.detailModelList.length==0) {
									this.options.height = 70;
									this.setHeight(this.options.height);
								}
								if(mode=='modify') initBtn();
							}
							else $.Notice.error("参数列表加载失败！");
						},
						onAfterShowData: onAfterShowData
					});
			this.searchFun();
			$('.l-scroll', $('#parmsGrid')).css('overflow', 'hidden');
		},
		searchFun: function () {
			var params = {filters: "appApiId="+ model.id , page: 1, rows: 999}
			reloadGrid(parmGrid.grid, 1, params);
		},
		del: function (e, id, rowId) {
			var g= parmGrid.grid;
			g.deleteRow(rowId);
		}
	}
</script>