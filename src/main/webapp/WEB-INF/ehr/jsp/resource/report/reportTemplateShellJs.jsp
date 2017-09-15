<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${contextRoot}/develop/lib/jquery/jquery-1.9.1.js"></script>
<script src="${contextRoot}/develop/lib/plugin/echarts/2.2.7/js/echarts-all.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/core/base.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/plugins/ligerDialog.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/plugins/ligerGrid.js"></script>
<script src="${contextRoot}/develop/lib/plugin/scrollbar/jquery.mCustomScrollbar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/ligerGridEx.js"></script>
<script src="${contextRoot}/develop/lib/mustache/mustache.min.js"></script>
<script src="${contextRoot}/develop/module/util.js"></script>
<script src="${contextRoot}/develop/lib/plugin/notice/topNotice.js"></script>
<script>
    var wait = $.Notice.waitting("加载中...");
    var reportCode = ${reportCode};
    var quotaFilter = [],//条件集
        dimensionMapArr = [],//维度数据集
        dimensionList = [],//维度集
        indexArr = [],//下砖层级集
        upDomsArr = [],
        chartsArr = [],
        quotaIdArr = [],
        resourceId = '';

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
                        if(viewInfo.type === 'quota') {
                            // 指标视图场合，展示为图形
                            renderQuota(viewInfo);
                        } else if(viewInfo.type === 'record') {
                            // 档案视图场合，展示为列表
                            renderRecord(viewInfo);
                        }
                    }
                    wait.close();
                    bindEvent();
                } else {
                    wait.close();
                    $.Notice.warn('获取报表模版失败！');
                }
            },
            error: function () {
                wait.close();
                $.Notice.error('获取报表模版发生异常！');
            }
        });
    }

    // 渲染指标视图图形
    function renderQuota(viewInfo) {
        var options = viewInfo.options;
        resourceId = viewInfo.resourceId;
        for (var i = 0; i < options.length; i++) {
            indexArr.push(0);
            (function (j) {
                // 渲染图形
                var item = options[j];
                upDomsArr.push(item.quotaCode);
                dimensionList.push(item.dimensionList);
                dimensionMapArr.push(item.dimensionOptions);
                $('#' + item.quotaCode + '_a').attr('data-id', j);
                var chart = echarts.init(document.getElementById('' + item.quotaCode));
                chart.setOption(JSON.parse(item.option));
                (function (c, n, id) {
                    chartsArr.push(c);
                    quotaIdArr.push(id);
                    c.on('click',function (e) {
                        getUpDownData(e, n);
                        e.event.stopPropagation();
                    });
                })(chart, j, item.quotaId);
                // 渲染数据的条件范围
                renderConditions(item.quotaCode, viewInfo.conditions);
            })(i);
        }
    }

    // 渲染档案视图列表
    function renderRecord(viewInfo) {
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
        for(var k = 0; k < viewInfo.columns.length; k++) {
            var column = viewInfo.columns[k];
            columns.push({name: column.code, display: column.value, width: 100});
        }
        var $gridDom = $("#" + viewInfo.resourceCode);
        var grid = $gridDom.ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resourceBrowse/searchResourceData',
            parms: {
                resourcesCode: viewInfo.resourceCode,
                searchParams: viewInfo.searchParams
            },
            columns: columns,
            height: $gridDom.height(),
            allowHideColumn: false,
            usePager: true
        }));
        // 渲染数据的条件范围
        renderConditions(viewInfo.resourceCode, viewInfo.conditions);
    }

    // 渲染数据的条件范围
    function renderConditions(code, conditions) {
        var conditionsTpl = document.getElementById('data-conditions-tpl').innerHTML.trim();
        Mustache.parse(conditionsTpl);
        var conditionsHtml = Mustache.render(conditionsTpl, conditions);
        $('#' + code).before(conditionsHtml);
    }

    // 获取上卷下砖数据
    function getUpDownData (e, n) {
        if (!e) {
            indexArr[n]--;
            if (indexArr[n] == 0) {
                $('#' + upDomsArr[n] + '_a').hide();
            }
            if (indexArr[n] < 0) {
                indexArr[n] = 0;
                return;
            }
            quotaFilter[n].pop();
        }
        var code = dimensionList[n][indexArr[n]].code,
            value = '';
        if (e) {
            value = dimensionMapArr[n][e.name];
            $('#' + upDomsArr[n] + '_a').show();
            indexArr[n]++;
            if (indexArr[n] >= dimensionList[n].length) {
                indexArr[n]--;
                $.Notice.success('已是最底层！');
                return;
            }
            quotaFilter[n] = quotaFilter[n] || [];
            quotaFilter[n].push(code + '=' + value);
        }
        $.ajax({
            url: '${contextRoot}/resource/resourceManage/resourceUpDown',
            data: {
                id: resourceId,
                dimension: code,
                quotaFilter: quotaFilter[n].join(','),
                quotaId: quotaIdArr[n]
            },
            type: 'GET',
            dataType: 'json',
            success: function (res) {
                if (res && res.length > 0) {
                    var dimensionMap = res[0].dimensionMap,
                        options = JSON.parse(res[0].option);
                    dimensionMapArr[n] = dimensionMap;
                    chartsArr[n].un('click');
                    chartsArr[n].clear();
                    chartsArr[n].hideLoading();
                    chartsArr[n].setOption(options);
                    chartsArr[n].on('click', function (e) {
                        getUpDownData (e, n);
                        e.event.stopPropagation();
                    });
                }
            }
        });
    }
    
    function  bindEvent () {
        $.each(upDomsArr, function (k, v) {
            $('#' + v + '_a').on('click', function () {
                var n = $(this).attr('data-id');
                getUpDownData('', n);
            });
        });
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