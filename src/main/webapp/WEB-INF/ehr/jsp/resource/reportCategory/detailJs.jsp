<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator;
    var $form = $("#reportCategoryForm");

    $(function () {
        init();
    });

    function init() {
        validator = customFormValidator();
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
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            if (!validator.validate()) { return; }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/resource/reportCategory/save", {
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
                debugger;
                var id = detailModel.id || -1; // 新增时传-1。
                var elId = $(el).attr("id");
                switch(elId) {
                    case 'code':
                        var code = $("#code").val();
                        if(!$.Util.isStrEquals(code, detailModel.code)) {
                            var ulr = "${contextRoot}/resource/reportCategory/isUniqueCode";
                            return validateByAjax(ulr, {id: id, code: code});
                        }
                        break;
                    case 'name':
                        var name = $("#name").val();
                        if(!$.Util.isStrEquals(name, detailModel.name)) {
                            var ulr = "${contextRoot}/resource/reportCategory/isUniqueName";
                            return validateByAjax(ulr, {id: id, name: name});
                        }
                        break;
                }
            }
        });
    }

    // 通过 jValidation 进行异步验证
    function validateByAjax(url, params) {
        var result = new $.jValidation.ajax.Result();
        var dataModel = $.DataModel.init();
        dataModel.fetchRemote(url, {
            data: params,
            async: false,
            success: function (data) {
                if (data.successFlg) {
                    result.setResult(true);
                } else {
                    result.setResult(false);
                    result.setErrorMsg(data.errorMsg);
                }
            },
            error: function () {
                $.Notice.error('验证发生异常');
            }
        });
        return result;
    }

</script>