<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator = null;
    var $form = $("#reportCategoryForm");

    $(function () {
        init();
    });

    function init() {
        initForm();
        bindEvents();
    }

    function initForm() {
        $('#code').ligerTextBox({width: 240});
        $('#name').ligerTextBox({width: 240});
        $("#pid").ligerComboBox({
            treeLeafOnly: false,
            tree: {
                ajaxType: 'get',
                url: '${contextRoot}/resource/reportCategory/getComboTreeData',
                idFieldName :'id',
                parentIDFieldName :'pid',
                parentIcon: '',
                childIcon: '',
                checkbox: false,
                single: true
            }
        });
        $('#remark').ligerTextBox({width: 240, height: 150});

        $form.attrScan();
        $form.Fields.fillValues({
            id: detailModel.id,
            code: detailModel.code,
            name: detailModel.name,
            pid: detailModel.pid,
            remark: detailModel.remark
        });
        $form.show();
    }

    function bindEvents() {
        var validator = new $.jValidation.Validation($form, {
            immediate: true,
            onSubmit: false,
            onElementValidateForAjax: function (el) {
            }
        });

        // 新增/修改
        $('#btnSave').click(function () {
            debugger;
            if (!validator.validate()) {
                return;
            }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            $('#btnSave').attr('disabled', 'disabled');

            var formFieldsVal = $form.Fields.getValues();
            formFieldsVal.id = $("#id").val();
            formFieldsVal.code = $("#code").val();
            formFieldsVal.name = $("#name").val();
//            formFieldsVal.pid = $("#pid").val().trim() == "" ? 0 : parentSelectedVal;
            formFieldsVal.remark = $("#remark").val();

            dataModel.fetchRemote("${contextRoot}/resource/reportCategory/save", {
                type: 'post',
                data: {data: JSON.stringify(formFieldsVal)},
                success: function (data) {
                    if (data.successFlg) {
                        if (detailModel.id) {
                            window.closeDetailDialog('新增成功');
                        } else {
                            window.closeDetailDialog('修改成功');
                        }
                    } else {
                        $.Notice.error(data.errorMsg);
                    }
                },
                error: function () {
                    $.Notice.error('保存发生异常');
                    $('#btnSave').removeAttr('disabled');
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

</script>