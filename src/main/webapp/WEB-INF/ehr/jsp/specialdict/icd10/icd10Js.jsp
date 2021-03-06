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
				infoDialog : null,
				init:function(){
					infoGrid = $('#div_specialdict_grid').ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/specialdict/icd10/icd10s',
						parms: {
							searchNm: ''
						},
						columns: [
							{display:'id',name:'id',width: '0.1%',hide:true},
							{display:'传染病',name:'infectiousFlag',width: '0.1%',hide:true},
							{display:'慢病',name:'chronicFlag',width: '0.1%',hide:true},
							{display: '诊断编码', name: 'code', width: '30%', align: 'left'},
							{display: '诊断名称', name: 'name', width: '30%',align:'left'},
							{display: '标志', name: '', width: '15%', align: 'center',render:function(row){
								var text1 = '';
								var text2 = '';
								if(row.infectiousFlag == '1'){text1 = '传染病';}
								if(row.chronicFlag == '1'){text2 =  '慢病';}
								if(!Util.isStrEmpty(text1)&&!Util.isStrEmpty(text2)){
									return text1+' / '+text2
								}
								return text1+text2;
							}},
							{display: '数据关联', name: '', minWidth: 100, align: 'center',
								render:function(row){
									var html = '<sec:authorize url="/specialdict/icd10/indicator/initial"><a class="label_a" style="margin-left:0px;" href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "indicatorIcd10:grid:open", row.id) + '">指标</a> /</sec:authorize>';
                                    html += '<sec:authorize url="/specialdict/icd10/drugRelaInfo/initial"><a class="label_a" style="margin-left:5px;" href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "drugIcd10:grid:open", row.id) + '">药品</a></sec:authorize>';
									return html;
								}
							},
							{
								display: '操作', name: 'operator', minWidth: 100, align: 'center',render: function(row){
								var html ='<sec:authorize url="/specialdict/icd10/update"><a class="grid_edit" name="delete_click" style="" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "icd10:info:open", row.id,'modify') + '"></a></sec:authorize>'
										+'<sec:authorize url="/specialdict/icd10/deletes"><a class="grid_delete" name="delete_click" style="" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "icd10:info:delete", row.id) + '"></a></sec:authorize>';
								return html;
							}},
						],
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
					$('#div_new_record').click(function(){
						$.publish('icd10:info:open',['','new']);
					});
					$.subscribe('icd10:info:open',function(event,id,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改字典项';
						}else{
							title = '新增字典项'
						};
						self.infoDialog = parent._LIGERDIALOG.open({
							height:400,
							width:500,
							title:title,
							url:'${contextRoot}/specialdict/icd10/dialog/icd10Info',
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
						$.publish('icd10:info:delete',['']);
					});
					$.subscribe('icd10:info:delete',function(event,ids){
						if(!ids){
							var rows = infoGrid.getSelectedRows();
							if(rows.length==0){
								parent._LIGERDIALOG.warn('请选择要删除的数据行！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
						}
						parent._LIGERDIALOG.confirm('确认要删除所选数据？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/icd10/deletes',{
									data:{ids:ids},
									success:function(data){
										if(data.successFlg){
											parent._LIGERDIALOG.success( '删除成功！');
											masters.reloadGrid();
										}else{
											parent._LIGERDIALOG.error(data.errorMsg);
										}
									}
								});
							}
						})
					});

					//关联指标字典事件
					$.subscribe('indicatorIcd10:grid:open',function(event,id){
						var title = '关联指标';
						self.icd10RelationInfoDialog = parent._LIGERDIALOG.open({
							height:500,
							width:700,
							title:title,
							url:'${contextRoot}/specialdict/icd10/indicator/initial',
							urlParms:{
								id:id
							},
							isHidden: false,
							opener: true,
							load:true
						});
					});

					//关联药品字典事件
					$.subscribe('drugIcd10:grid:open',function(event,id){
						var title = '关联药品';
						self.icd10RelationInfoDialog = parent._LIGERDIALOG.open({
							height:500,
							width:700,
							title:title,
							url:'${contextRoot}/specialdict/icd10/drugRelaInfo/initial',
							urlParms:{
								id:id,
							},
							isHidden: false,
							opener: true,
							load:true
						});
					});
				}
			};
			/* ************************* Dialog页面回调接口 ************************** */
			win.parent.reloadIcd10InfoGrid = function () {
				masters.reloadGrid();
			};
			win.parent.closeIcd10InfoDialog = function () {
				masters.infoDialog.close();
			};
			win.parent.closeIcd10RelationInfoDialog = function () {
				masters.icd10RelationInfoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* ************************* 页面初始化 ************************** */
			pageInit();
		});
	})(jQuery,window);
</script>