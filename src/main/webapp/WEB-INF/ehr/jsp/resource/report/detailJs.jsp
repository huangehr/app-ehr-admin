<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator;
    var $form = $("#reportForm");
    var $filePickerBtnDetail = $('#filePickerBtnDetail');

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
        $("#reportCategoryId").ligerComboBox({
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
        $("#status").ligerComboBox({
            ajaxType: 'get',
            url: "${contextRoot}/dict/searchDictEntryList",
            dataParmName: 'detailModelList',
            urlParms: {dictId: 92}, // 报表状态字典ID
            valueField: 'code',
            textField: 'value'
        });
        $("#showType").ligerComboBox({
            data: [
                {text:"图表", id:"1"},
                {text:"二维表", id:"2"},
            ]
        });
        $('#remark').ligerTextBox({width: 240, height: 150});
        $('#templatePath').ligerTextBox({width: 240, disabled: true});

        if(detailModel.id) {
            codeTb.setDisabled(true);
        }

        $filePickerBtnDetail.instance = $filePickerBtnDetail.webupload({
            pick: {id: '#filePickerBtnDetail'},
            auto: true,
            server: '${contextRoot}/fileUpload/upload',
            accept: {
                title: 'Html',
                extensions: 'html',
                mimeTypes: 'text/html'
            }
        });

        $form.attrScan();
        $form.Fields.fillValues({
            id: detailModel.id,
            code: detailModel.code,
            name: detailModel.name,
            reportCategoryId: detailModel.reportCategoryId,
            status: detailModel.status,
            remark: detailModel.remark,
            templatePath: detailModel.templatePath,
            showType: detailModel.showType
        });
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            if (!validator.validate()) { return; }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/resource/report/save", {
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
        });

        // 模版导入
        var uploader = $filePickerBtnDetail.instance;
        $('#templateBtn').click(function () {
            uploader.reset();
            $(".webuploader-element-invisible", $filePickerBtnDetail).trigger("click");
        });
        uploader.on('success', function (file, data, b) {
            if (data.successFlg) {
                $('#templatePath').val(data.obj);
                $.Notice.success('导入成功');
            } else if (data.errorMsg)
                $.Notice.error(data.errorMsg);
            else
                $.Notice.error('导入失败');
        });
        uploader.on('error', function (file, data) {
            if (file == 'Q_TYPE_DENIED')
                $.Notice.error('请上传html的非空文件！');
            else
                $.Notice.error('导入失败');
        });
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
                            var ulr = "${contextRoot}/resource/report/isUniqueCode";
                            return $.Util.validateByAjax(ulr, {id: id, code: code});
                        }
                        break;
                    case 'name':
                        var name = $("#name").val();
                        if(!$.Util.isStrEquals(name, detailModel.name)) {
                            var ulr = "${contextRoot}/resource/report/isUniqueName";
                            return $.Util.validateByAjax(ulr, {id: id, name: name});
                        }
                        break;
                }
            }
        });
    }

</script>