<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${contextRoot}/develop/lib/jquery/jquery-1.9.1.js"></script>
<script src="${contextRoot}/develop/lib/plugin/echarts/2.2.7/js/echarts-all.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/core/base.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/plugins/ligerDialog.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/plugins/ligerGrid.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/ligerGridEx.js"></script>
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
                debugger;
                if(data.successFlg) {
                    $('#reportTemplate').html(data.obj.templateContent);
                    var viewInfos = data.obj.viewInfos;
                    for(var a = 0; a < viewInfos.length; a++) {
                        var viewInfo = viewInfos[a];
                        if(viewInfo.type === 'quota') {
                            // 指标视图场合，展示为图形
                            var options = viewInfo.options;
                            var filter = viewInfo.filter;
                            for (var i = 0; i < options.length; i++) {
                                (function (j) {
                                    // 渲染图形
                                    var item = options[j];
                                    var chart = echarts.init(document.getElementById('' + item.quotaCode));
                                    chart.setOption(JSON.parse(item.option));
                                    // 渲染数据的条件范围
                                    renderFilter(item.quotaCode, filter);
                                })(i);
                            }
                        } else if(viewInfo.type === 'record') {
                            // 档案视图场合，展示为列表
                            var columns = [
                                {name: 'patient_name', display: '病人姓名', width: 100},
                                {name: 'event_type', display: '就诊类型', width: 100,
                                    render: function (row, key, val, rowData) {
                                        if (val == '0') {
                                            return '门诊';
                                        }
                                        if (val == '1') {
                                            return '住院';
                                        }
                                    }
                                },
                                {name: 'org_name', display: '机构名称', width: 100},
                                {name: 'org_code', display: '机构编号', width: 100},
                                {name: 'event_date', display: '时间', width: 100,
                                    render: function (row, key, val, rowData) {
                                        return formatDate(val);
                                    }
                                },
                                {name: 'demographic_id', display: '病人身份证号码', width: 100}
                            ];
                            for(var k = 0; k < viewInfo.rows.length; k++) {
                                var row = viewInfo.rows[k];
                                columns.push({name: row.code, display: row.value, width: 100});
                            }
                            var $gridDom = $("#" + viewInfo.resourceCode);
                            var grid = $gridDom.ligerGrid($.LigerGridEx.config({
                                url: '${contextRoot}/resourceBrowse/searchResourceData',
                                parms: {
                                    resourcesCode: viewInfo.resourceCode,
                                    searchParams: '' // Todo 拼接查询条件
                                },
                                columns: columns,
                                height: $gridDom.height()
//                                allowHideColumn: false,
//                                usePager: true
                            }));
                            // 渲染数据的条件范围
                            renderFilter(viewInfo.resourceCode, filter);
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

    // 渲染数据的条件范围
    function renderFilter(code, filter) {
        var filterTpl = document.getElementById(code + '-filter').innerHTML.trim();
        // Todo 没有条件时，设置模版变量空的场合
        if(filter) {
            Mustache.parse(filterTpl);
            var filterHtml = Mustache.render(filterTpl, filter);
            $('#' + code).before(filterHtml);
        }
    }

    function formatDate(date) {
        var thisDate = new Date(date);
        var year = thisDate.getFullYear();
        var month = resetVal(thisDate.getMonth() + 1);
        var da = resetVal(thisDate.getDate());
        var hours = resetVal(thisDate.getHours());
        var minutes = resetVal(thisDate.getMinutes());
        var seconds = resetVal(thisDate.getSeconds());
        return year + '-' + month + '-' + da + ' ' + hours + ':' + minutes + ':' + seconds;
    }

    function resetVal(val) {
        return val < 9 ? '0' + val : val;
    }

</script>