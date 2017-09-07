<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${contextRoot}/develop/lib/jquery/jquery-1.9.1.js"></script>
<script src="${contextRoot}/develop/lib/plugin/echarts/2.2.7/js/echarts-all.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/core/base.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/plugins/ligerDialog.js"></script>
<script src="${contextRoot}/develop/lib/mustache/mustache.min.js"></script>
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
                    $('#reportTemplate').html(data.obj.templateContent);
                    var viewInfos = data.obj.viewInfos;
                    for(var a = 0; a < viewInfos.length; a++) {
                        var viewInfo = viewInfos[a];
                        var options = viewInfo.options;
                        var filter = viewInfo.filter;
                        for(var i = 0; i < options.length; i++) {
                            (function(j) {
                                // 渲染图形
                                var item = options[j];
                                var chart = echarts.init(document.getElementById('' + item.quotaCode));
                                chart.setOption(JSON.parse(item.option));

                                // 渲染图形数据过滤条件
                                var filterTpl = document.getElementById(item.quotaCode + '-filter').innerHTML.trim();
                                Mustache.parse(filterTpl);
                                var filterHtml = Mustache.render(filterTpl, filter);
                                $('#' + item.quotaCode).before(filterHtml);
                            })(i);
                        }
                    }
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