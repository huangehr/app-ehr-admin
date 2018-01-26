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
        var type = '${type}';
        var nameCopy = '';
        var codeCopy = '';
        <%--var categoryIdOld = '${categoryId}';--%>

        var queryCondition = '${queryCondition}' || [];
        var metadatas = '${metadatas}';
        console.log(metadatas);
        console.log(queryCondition + '-' + metadatas);

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
            $dataSource: $('input[name="dataSource"]', this.$form),
            $description: $("#inp_description"),
            $btnSave: $("#btn_save"),
            $btnCancel: $("#btn_cancel"),
            $echartType: $("#echartType"),


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
                var lr1 = this.$dataSource.eq(0).ligerRadio();
                var lr2 = this.$dataSource.eq(1).ligerRadio();
                if (type && type == 0) {
                    lr1.setValue(true);
                    lr2.setValue(false);
                }
                if (type && type == 1) {
                    lr1.setValue(false);
                    lr2.setValue(true);
                }
                lr1.setDisabled();
                lr2.setDisabled();
                this.$echartType.ligerComboBox({
                    data: [
                        {text:"数值", id:"data"},
                        {text:"柱状图", id:"bar"},
                        {text:"线形图", id:"line"},
                        {text:"饼图", id:"pie"},
                        {text:"二维表", id:"twoDimensional"},
                        {text:"雷达图", id:"radar"},
                        {text:"旭日图", id:"nestedPie"}
                    ]
                });
                if (type && type == 1) {
                    $("#dataShowType").show();
                }
                this.$form.attrScan();
                this.$form.show();
            },
            initDDL: function () {
                this.$grantType.eq(1).attr("checked", 'true')
                this.$dataSource.eq(0).attr("checked", 'true')
                this.$category.customCombo('${contextRoot}/resource/resourceManage/rsCategory',{});
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
                this.$interface.ligerGetComboBoxManager().setValue(type == '0' ? 'getEhrCenter' : 'getQuotaData');
                this.$interface.ligerGetComboBoxManager().setDisabled();
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
                    if (type && type == 1) {
                        values.echartType = $("#echartType_val").val().trim();
                    }
                    var categoryId = values.categoryId;
//                    if(Util.isStrEquals(categoryIdOld,categoryId)){
//                        update(values)
//                        return
//                    }
                    var callbackParams = {
                        'categoryId':categoryId,
                        'typeFilter':$('#inp_category').val(),
                    }
                    update(values,categoryId);
                });

                function update(values,categoryIdNew){
                    var wait = $.Notice.waitting("请稍后...");
                    if (_.isString(queryCondition)) {
                        queryCondition = JSON.parse(queryCondition);
                    }
                    var dataModel = $.DataModel.init(),
                        parms = {};
                    if (type == '0') {
                        parms = {
                            queryCondition: queryCondition,metadatas: JSON.parse(metadatas),resource: values
                        }
                    }
                    if (type == '1') {
                        parms = {
                            queryCondition: queryCondition,quotas: JSON.parse(metadatas),resource: values
                        }
                    }
                    dataModel.updateRemote("${contextRoot}/resourceIntegrated/updateResource", {
                        data:{dataJson: JSON.stringify(parms)},
                        type: 'POST',
                        success: function(data) {
                            wait.close();
                            if (data.successFlg) {
//                                reloadMasterUpdateGrid(categoryIdNew);
                                $.Notice.success('操作成功');
                                win.parent.closeRsInfoDialog();
                            } else {
                                $.Notice.error('操作失败！');
                            }
                        }
                    });
                }

                this.$btnCancel.click(function () {
                    win.parent.closeRsInfoDialog();
                });
            }
        };
        /* *************************** 页面初始化 **************************** */
        pageInit();
    })(jQuery, window);
</script>