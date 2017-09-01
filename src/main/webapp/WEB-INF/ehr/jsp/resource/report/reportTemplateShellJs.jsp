<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${contextRoot}/static-dev/base/jquery/jquery-1.11.3.js"></script>
<script src="${contextRoot}/develop/module/util.js"></script>
<script src="${contextRoot}/develop/lib/plugin/notice/topNotice.js"></script>
<script>
    var reportCode = ${reportCode};

    $(function () {
        renderTemplate(reportCode);
    });

    // 渲染报表模版
    function renderTemplate(reportCode) {
        $.ajax({
            url: '${contextRoot}/resource/report/getTemplateData',
            method: 'get',
            data: {reportCode: reportCode},
            success: function(data) {
                if(data.successFlg) {
                    $('#reportTemplate').html(data.obj);
                } else {
                    $.Notice.warn('获取报表模版失败！');
                }
            },
            error: function () {
                $.Notice.error('获取报表模版发生异常！');
            }
        });
    }
</script>