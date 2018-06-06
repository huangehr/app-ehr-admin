<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator;
    var $form = $("#redisCacheKeyRuleForm");

    $(function () {
        init();
    });

    function init() {
        validator = customFormValidator();
        initForm();
        bindEvents();
    }

    function initForm() {
        var nameTb = $('#name').ligerTextBox({width: 240});
        var codeTb = $('#code').ligerTextBox({width: 240});
        var categoryCode = $("#categoryCode").ligerComboBox({
            ajaxType: 'get',
            url: "${contextRoot}/redis/cache/category/searchNoPage",
            dataParmName: 'detailModelList',
            valueField: 'code',
            textField: 'name'
        });
        var expressionTb = $('#expression').ligerTextBox({width: 240});
        $('#remark').ligerTextBox({width: 240, height: 150});

        if(detailModel.id) {
            codeTb.setDisabled(true);
            codeTb.setReadonly(true);
            categoryCode.setDisabled(true);
            categoryCode.setReadonly(true);
            expressionTb.setDisabled(true);
            expressionTb.setReadonly(true);
        }

        $form.attrScan();
        $form.Fields.fillValues(detailModel);
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            if (!validator.validate()) { return; }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/redis/cache/keyRule/save", {
                type: 'post',
                data: {data: JSON.stringify($form.Fields.getValues())},
                success: function (data) {
                    if (data.successFlg) {
                        if (!detailModel.id) {
                            window.closeDetailDialog('新增成功');
                        } else {
                            window.closeDetailDialog('修改成功');
                        }
                        window.reloadMasterGrid();
                    } else {
                        $.Notice.error(data.errorMsg);
                    }
                },
                error: function () {
                    $.Notice.error('保存发生异常');
                },
                complete: function () {
                    loading.close();
                }
            });
        });

        // 关闭
        $('#btnClose').click(function () {
            parent.closeDetailDialog();
        })
    }

    // 表单验证对象
    function customFormValidator() {
        return new $.jValidation.Validation($form, {
            immediate: true,
            onElementValidateForAjax: function (el) {
                var id = detailModel.id || -1; // 新增时传-1。
                var elId = $(el).attr("id");
                switch(elId) {
                    case 'name':
                        var name = $("#name").val();
                        if(!$.Util.isStrEquals(name, detailModel.name)) {
                            var ulr = "${contextRoot}/redis/cache/keyRule/isUniqueName";
                            return $.Util.validateByAjax(ulr, {id: id, name: name});
                        }
                        break;
                    case 'code':
                        var code = $("#code").val();
                        if(!$.Util.isStrEquals(code, detailModel.code)) {
                            var ulr = "${contextRoot}/redis/cache/keyRule/isUniqueCode";
                            return $.Util.validateByAjax(ulr, {id: id, code: code});
                        }
                        break;
                    case 'expression':
                        var categoryCode = $("#categoryCode").ligerComboBox().getValue();
                        var expression = $("#expression").val();
                        if(!$.Util.isStrEquals(expression, detailModel.expression)) {
                            var ulr = "${contextRoot}/redis/cache/keyRule/isUniqueExpression";
                            return $.Util.validateByAjax(ulr, {id: id, categoryCode: categoryCode, expression: expression});
                        }
                        break;
                }
            }
        });
    }

</script>