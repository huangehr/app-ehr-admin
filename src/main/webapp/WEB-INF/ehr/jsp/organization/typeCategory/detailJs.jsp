<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator;
    var $form = $("#orgTypeCategoryForm");

    $(function () {
        init();
    });

    function init() {
        validator = customFormValidator();
        initForm();
        bindEvents();
    }

    function initForm() {
        var codeTb = $('#code').ligerTextBox({width: 240});
        $('#name').ligerTextBox({width: 240});
        var pidTb = $("#pid").ligerComboBox({
            treeLeafOnly: false,
            tree: {
                ajaxType: 'get',
                url: '${contextRoot}/org/typeCategory/getComboTreeData',
                idFieldName :'id',
                parentIDFieldName :'pid',
                parentIcon: '',
                childIcon: '',
                checkbox: false,
                single: true
            }
        });
        $('#remark').ligerTextBox({width: 240, height: 150});

        if(detailModel.id) {
            codeTb.setDisabled(true);
            codeTb.setReadonly(true);
            pidTb.setDisabled(true);
            pidTb.setReadonly(true);
        }

        $form.attrScan();
        $form.Fields.fillValues(detailModel);
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            if (!validator.validate()) { return; }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/org/typeCategory/save", {
                type: 'post',
                data: {data: JSON.stringify($form.Fields.getValues())},
                success: function (data) {
                    if (data.successFlg) {
                        if (detailModel.id) {
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
            window.closeDetailDialog();
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
                    case 'code':
                        var code = $("#code").val();
                        if(!$.Util.isStrEquals(code, detailModel.code)) {
                            var ulr = "${contextRoot}/org/typeCategory/isUniqueCode";
                            return $.Util.validateByAjax(ulr, {id: id, code: code});
                        }
                        break;
                    case 'name':
                        var name = $("#name").val();
                        if(!$.Util.isStrEquals(name, detailModel.name)) {
                            var ulr = "${contextRoot}/org/typeCategory/isUniqueName";
                            return $.Util.validateByAjax(ulr, {id: id, name: name});
                        }
                        break;
                }
            }
        });
    }

</script>