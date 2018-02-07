<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rsInfoForm = null;
		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var nameCopy = '';
		var codeCopy = '';
		var categoryIdOld = '${categoryId}'
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			rsInfoForm.init();
		}
		/* *************************** 模块初始化 ***************************** */
		rsInfoForm = {
			$form: $("#div_rs_info_form"),
			$category:$("#inp_category"),
			$name: $("#inp_name"),
			$code: $("#inp_code"),
			$interface: $("#inp_interface"),
			$grantType: $('input[name="grantType"]', this.$form),
//			$dataSource: $('input[name="dataSource"]', this.$form),
            $dataSource: $('#dataSource'),
			$description: $("#inp_description"),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $echartType: $("#echartType"),
			$dimension: $("#dimension"),


			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.initDDL();
				this.$name.ligerTextBox({width:240});
				this.$code.ligerTextBox({width:240});
				this.$description.ligerTextBox({width:240, height: 120 });
				this.$grantType.ligerRadio();
                this.$dataSource.ligerTextBox({width:240});
                this.$echartType.ligerComboBox({
                    data: [
                        {text:"混合图形", id:"mixed"},
                        {text:"数值", id:"data"},
                        {text:"柱状图", id:"bar"},
                        {text:"线形图", id:"line"},
                        {text:"饼图", id:"pie"},
                        {text:"二维表", id:"twoDimensional"},
                        {text:"雷达图", id:"radar"},
                        {text:"旭日图", id:"nestedPie"}
                    ]
                });
				this.$dimension.ligerTextBox({width:240});
//				this.$dataSource.ligerRadio();
//                this.$dataSource.ligerGetRadioManager().setDisabled();
				var mode = '${mode}';
				if(mode == 'view'){
					rsInfoForm.$form.addClass('m-form-readonly');
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}
				this.$form.attrScan();
				if ('${dataSource}' == 2) {
				    $("#dataShowType").show()
                }
				if(mode == 'new'){
                    $("#inp_category").attr('data-id', '${categoryId}');
                    $("#inp_category").ligerGetTextBoxManager().setValue('${name}');
                    this.$dataSource.attr('data-source', '${dataSource}');
                    this.$dataSource.ligerGetTextBoxManager().setValue('${dataSource}' == '1' ? '档案数据' : '指标统计');
					<%--$("#inp_category").ligerGetComboBoxManager().setValue('${categoryId}');--%>
					<%--$("#inp_category").ligerGetComboBoxManager().setText('${categoryName}');--%>
				}
				debugger
				if(mode !='new'){
					var info = ${envelop}.obj;
					debugger
					nameCopy = info.name;
					codeCopy = info.code;
					this.$form.Fields.fillValues({
						id:info.id,
						code:info.code,
						name:info.name,
						dimension:info.dimension,
						categoryId:'${name}',
						rsInterface:info.rsInterface,
						grantType:info.grantType,
						dataSource:info.dataSource.toString() == '1' ? '档案数据' : '指标统计',
                        echartType:info.echartType,
						description:info.description
					});

                    this.$echartType.ligerGetComboBoxManager().setValue(info.echartType);
                    $("#inp_category").attr('data-id', info.categoryId);
                    this.$dataSource.attr('data-source', info.dataSource);
					<%--$("#inp_category").ligerGetComboBoxManager().setValue('${categoryId}');--%>
					<%--$("#inp_category").ligerGetComboBoxManager().setText('${categoryName}');--%>
				}
				this.$form.show();
			},
			initDDL: function () {
				this.$grantType.eq(1).attr("checked", 'true')
				this.$dataSource.eq(0).attr("checked", 'true')
                this.$category.ligerTextBox({width:240})
				<%--this.$category.customCombo('${contextRoot}/resource/resourceManage/rsCategory',{});--%>
				this.$interface.ligerComboBox({
					url: "${contextRoot}/resource/resourceInterface/searchRsInterfaces",
					dataParmName: 'detailModelList',
					urlParms: {
						searchNm: '',
						page:1,
						rows:999
					},
					valueField: 'resourceInterface',
					textField: 'name',
					width:240
				});
			},

			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_name')) {
							var name = $("#inp_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/resource/resourceManage/isExistName",name,"资源名称不能重复！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_code')) {
							var code = $("#inp_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/resource/resourceManage/isExistCode",code,"资源编码不能重复！");
							}
						}
					}
				});
				//验证编码、名字不可重复
				function checkUnique(url, value, errorMsg) {
					var result = new jValidation.ajax.Result();
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {name:value,code:value},
						async: false,
						success: function (data) {
							if (data.successFlg) {
								result.setResult(false);
								result.setErrorMsg(errorMsg);
							} else {
								result.setResult(true);
							}
						}
					});
					return result;
				}

				this.$btnSave.click(function () {
					if(validator.validate() == false){
						return
					}
					var values = self.$form.Fields.getValues();
                    values.dataSource = self.$dataSource.attr('data-source');
                    values.categoryId = self.$category.attr('data-id');
                    values.echartType = $("#echartType_val").val().trim();
					var categoryId = values.categoryId;
					if(Util.isStrEquals(categoryIdOld,categoryId)){
						update(values)
						return
					}
					var callbackParams = {
						'categoryId':categoryId,
						'typeFilter':$('#inp_category').val(),
					}
					update(values,categoryId);
				});

				function update(values,categoryIdNew){
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
					var dataModel = $.DataModel.init();
					dataModel.updateRemote("${contextRoot}/resource/resourceManage/update", {
						data:{dataJson:JSON.stringify(values),mode:mode},
						success: function(data) {
                            waittingDialog.close();
							if (data.successFlg) {
								$.Notice.success('操作成功');
								win._closeRsInfoDialog(data.obj);
							} else {
								$.Notice.error('操作失败！');
							}
						}
					});
				}

				this.$btnCancel.click(function () {
					win._closeRsInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>