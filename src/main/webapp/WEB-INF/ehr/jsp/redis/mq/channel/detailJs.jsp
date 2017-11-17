<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var detailModel = ${detailModel};
    var dataModel = $.DataModel.init();
    var validator;
    var $form = $("#redisMqChannelForm");

    $(function () {
        init();
    });

    function init() {
        validator = customFormValidator();
        initForm();
        bindEvents();
    }

    function initForm() {
        var channelTb = $('#channel').ligerTextBox({width: 240});
        $('#channelName').ligerTextBox({width: 240});
//        $('#authorizedCode').ligerTextBox({width: 240});
        $('#remark').ligerTextBox({width: 240, height: 150});

        if(detailModel.id) {
            channelTb.setDisabled(true);
        }

        $form.attrScan();
        $form.Fields.fillValues(detailModel);
    }

    function bindEvents() {
        // 保存
        $('#btnSave').click(function () {
            if (!validator.validate()) { return; }

            var loading = $.ligerDialog.waitting("正在保存数据...");
            dataModel.fetchRemote("${contextRoot}/redis/mq/channel/save", {
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
                    case 'channel':
                        var channel = $("#channel").val();
                        if(!$.Util.isStrEquals(channel, detailModel.channel)) {
                            var ulr = "${contextRoot}/redis/mq/channel/isUniqueChannel";
                            return validateByAjax(ulr, {id: id, channel: channel});
                        }
                        break;
                    case 'channelName':
                        var channelName = $("#channelName").val();
                        if(!$.Util.isStrEquals(channelName, detailModel.channelName)) {
                            var ulr = "${contextRoot}/redis/mq/channel/isUniqueChannelName";
                            return validateByAjax(ulr, {id: id, channelName: channelName});
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