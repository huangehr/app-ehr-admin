<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${staticRoot}/lib/bootstrap/js/bootstrap.min.js"></script>
<script src="${staticRoot}/lib/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script src="${staticRoot}/lib/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script src="${staticRoot}/lib/bootstrap-select/js/bootstrap-select.min.js"></script>
<script src="${staticRoot}/lib/bootstrap-select/js/i18n/defaults-zh_CN.min.js"></script>
<script src="${staticRoot}/lib/plugin/echarts/2.2.7/js/echarts.js"></script>
<script src="${staticRoot}/lib/plugin/echarts/3.0/map/js/china.js"></script>
<script src="${staticRoot}/lib/plugin/editTmp/editTmp.js"></script>

<script>
    (function (w, $) {
        var selViewDialog;
        var url = [
            '${contextRoot}/resource/report/getRsQuotaPreview',//获取视图列表
            '${contextRoot}/resource/report/uploadTemplate',//保存模板
            '${contextRoot}/resource/report/getTemplateData',//获取模板
            '${contextRoot}/resourceBrowse/searchResourceData',//获取模板对应的数据
            '${contextRoot}/resourceBrowse/getGridCloumnNames',//获取表头
            ''
        ];
        require.config({
            paths: {
                echarts: 'http://echarts.baidu.com/build/dist'
            }
        });
        //档案数据基本数据
        var defauleColumnModel = [
            {"name": 'patient_name', "display": "病人姓名", "width": 100},
            {"name": 'event_type', "display": "就诊类型", "width": 100},
            {"name": 'org_name', "display": "机构名称", "width": 100},
            {"name": 'org_code', "display": "机构编号", "width": 100},
            {"name": 'event_date', "display": "时间", "width": 100},
            {"name": 'demographic_id', "display": "病人身份证号码", "width": 100}
        ];
        $(function () {
            // 使用
            require(
                [
                    'echarts',
                    'echarts/chart/bar',
                    'echarts/chart/line',
                    'echarts/chart/pie',
                    'echarts/chart/map',
                    'echarts/chart/radar',
                ],
                function (echarts) {
                    var TVS = {
                        $upHtmlFile: $('#upHtmlFile'),
                        $noneTmp: $('.none-tmp'),
                        $upFileInp: $('.up-file'),
                        $tmpCon: $('.tmp-con'),
                        $saveTmp: $('#saveTmp'),
                        rIdsAndQCode: [],
                        chart: null,
                        chartTit: '',
                        id: '${id}',
                        code: '${code}',
                        ET: null,
                        init: function () {
                            this.getTmp();
                            this.ET = _ET({
                                $main: $('#editMain'),
                                addViewFun: this.showViewList.bind(this),
                                cb: this.removeId
                            });
                            this.bindEvent();
                        },
                        getTmp: function () {//获取模板&&数据
                            var me = this;
                            me.resData(url[2], {
                                reportCode: me.code
                            }, function (data) {
                                if(data.successFlg) {
                                    var d = data.obj.viewInfos, quotaIds = [], $quotaIds = null;
                                    me.$noneTmp.hide();
                                    me.$tmpCon.html(data.obj.templateContent);
                                    //查找js&&渲染
                                    me.findJs();
//                                    加载地图
                                    me.loadMap();
                                    //查找空间&&渲染
                                    me.findFormCrl();
                                    //加载图表
                                    if ($('#specialDiv').length == 0) {
                                        $.each(d , function (k, obj) {
                                            var $dom = $('#' + obj.resourceId),
                                                option = [];
                                            me.rIdsAndQCode.push(obj.resourceId);

                                            option = TVS.resetOption($dom, JSON.parse(obj.options[0].option));
                                            me.renderQuota($dom, option);
                                        });
                                    }
                                    $quotaIds = $(document).find('#quotaIds');
                                    if ($quotaIds.length > 0) {
                                        quotaIds = ($quotaIds.val()).split(',')
                                    }
                                    //加载二维表视图
                                    $.each(quotaIds, function (k, v) {
                                        var $dom = null;
                                        if (v != '') {
                                            $dom = $('#' + v);
                                            me.rIdsAndQCode.push(v);
                                            //特殊二维表模版
                                            if ($('#specialDiv').length > 0) {
                                                var speFunTmp = '', data = [], code = '', id= '';
                                                speFunTmp = $('#specialFunTmp').html();
                                                code = $dom.attr('data-code');
                                                id = $dom.attr('data-id');
                                                eval(speFunTmp);
                                                gridObj && (function () {
                                                    gridObj['parms'] = {
                                                        resourcesCode: code,
                                                        page: 1,
                                                        rows: 500
                                                    }
                                                })();
                                                TVS.renderResourceTable(id, (col || []), $dom, null, $dom.attr('data-name'), '2', (gridObj || {}), code);
                                            } else {
                                                me.getResourceData(v, $dom, null, $dom.attr('data-name'));
                                            }
                                        }
                                    })
                                } else {
                                    me.$noneTmp.show();
                                    $.Notice.warn('获取报表模版失败！');
                                }
                            })
                        },
                        findJs: function () {
                            var $jsTmp = $('#specialFunTmp');
                            if ($jsTmp.length > 0) {
                                eval('(function (data,cityName) {' + $jsTmp.html() + '})("","")');
                            }
                        },
                        findFormCrl: function () {//查找控件
                            var me = this,$regionSel = $('#regionSel'), $dataSel = $('#dataSel'), html = '';
                            if ($regionSel.length > 0) {//区域
                                <%--me.resData('${contextRoot}/address/getDistrictByParent', {--%>
                                <%--pid: '361100'--%>
                                <%--},function (data) {--%>
                                <%--var obj = data.obj;--%>
                                <%--$.each(obj, function (k, o) {--%>
                                <%--html += '<option value="' + o.id + '">' + o.name + '</option>';--%>
                                <%--});--%>
                                <%--$regionSel.html(html);--%>
                                <%--$regionSel.selectpicker({--%>
                                <%--width: 150--%>
                                <%--});--%>
                                <%--$regionSel.on('changed.bs.select', function (e, index) {--%>
                                <%--var o = obj;--%>
                                <%--//                                        条件筛选暂时不弄--%>
                                <%--});--%>
                                <%--});--%>
                            }
                            if ($dataSel.length > 0) {//时间
                                $dataSel.datetimepicker({
                                    format: 'yyyy-mm',
                                    autoclose: true,
                                    todayBtn: true,
                                    startView: 'year',
                                    minView:'year',
                                    maxView:'decade',
                                    language:  'zh-CN'
                                }).on('changeDate',function(e){
                                    var startTime = e.date;
//                                        条件筛选暂时不弄
                                });
                            }
                        },
                        showViewList: function ($dom) {//展示视图列表
                            var wait = $.Notice.waitting("请稍后..."),
                                me = this;
                            me.chart = $dom.closest('.charts').find('.charts-con');
                            me.chartTit = $dom.closest('.charts').find('.c-title');
                            selViewDialog = $.ligerDialog.open({
                                height: 700,
                                width: 378,
                                title: '报表视图列表',
                                url: '${contextRoot}/resource/report/selView',
                                urlParms: {id: ${id}},
                                opener: true,
                                load: true,
                                onLoaded: function () {
                                    wait.close();
                                    selViewDialog.show();
                                }
                            });
                            selViewDialog.hide();
                        },
                        //加载地图
                        loadMap: function () {
                            var me = this, $map = me.$tmpCon.find('[data-type=map]'), fileName = '', myChart = null;
                            if ($map.length > 0) {
                                fileName = $map.attr('data-city-map');
                                myChart = echarts.init($map[0]);
                                var mapGeoData = require('echarts/util/mapData/params');
                                mapGeoData.params['上饶市'] = {
                                    getGeoJson: (function () {
                                        return function (callback) {
                                            me.resData('${staticRoot}/lib/plugin/echarts/3.0/map/json/china-main-city/'+ fileName + '.json', {}, callback);
                                        }
                                    })()
                                };
                                var ecConfig = require('echarts/config');
                                myChart.setOption({
                                    tooltip : {
                                        trigger: 'item',
                                        formatter: '{b}'
                                    },
                                    dataRange: {
                                        min: 0,
                                        max: 100,
                                        text: ['高', '低'],
                                        color: ['#78a2c6', '#c7d2e3'],
                                    },
                                    series : [
                                        {
                                            type: 'map',
                                            mapType: '上饶市',
                                            selectedMode : 'single',
                                            itemStyle: {
                                                normal: {
                                                    label: {
                                                        show: true,
                                                        textStyle: {
                                                            color: '#0f375a'
                                                        }
                                                    },
                                                    borderWidth: 2,
                                                    borderColor: '#fff'
                                                },
                                                areaStyle: {color: '#55c5fb'},
                                                emphasis: {
                                                    borderWidth: 2,
                                                    color: '#55c5fb',
                                                    label: {
                                                        show: true,
                                                        textStyle: {
                                                            color: '#0f375a'
                                                        }
                                                    }
                                                }
                                            },
                                            data:[]
                                        }
                                    ]
                                });
                            }
                        },
                        bindEvent: function () {
                            var me = this;
                            me.$upHtmlFile.on('click', function () {
                                me.$upFileInp.trigger('click');
                            });
                            me.$upFileInp.on('change', function (e) {//上传模板文件
                                var files = e.target.files[0],
                                    type = files.type,
                                    reader = new FileReader();
                                if (type != 'text/html') {
                                    $.Notice.error('请添加后缀名为’.html‘的模板文件！');
                                    return;
                                }
                                reader.onload = function () {
                                    me.rIdsAndQCode = [];
                                    me.$tmpCon.html(this.result);
                                    me.findJs();
                                    me.loadMap();
                                    me.findFormCrl();
                                };
                                reader.readAsText(files);
                            });
                            me.$saveTmp.on('click', function () {//保存模板
                                var tmp = me.$tmpCon.html(),
                                    num = tmp.indexOf('</style>') + ('</style>'.length),
                                    styleStr = me.getFormatData(tmp.substring(0, num)),
                                    tmpStr = me.getFormatData(tmp.substring(num, tmp.length)),
                                    $tmpDom = $('<div>' + tmpStr + '</div>'),
                                    reportData = [],
                                    quotaIds = [],
                                    isHas = false,
                                    $input = $tmpDom.find('#quotaIds');
                                if ($input.length <= 0) {
                                    $input = document.createElement('input');
                                    $input.type = 'hidden';
                                    $input.id = 'quotaIds';
                                } else {
                                    $input = $input[0];
                                    isHas = true;
                                }
                                $tmpDom.find('.c-title').html('');
                                $tmpDom.find('.charts-con').removeAttr('style').removeAttr('ligeruiid').removeAttr('_echarts_instance_').removeClass('l-panel').removeClass('l-frozen').html('');
                                $.each($tmpDom.find('.charts-con'), function (k, o) {
                                    var tId = $(o).attr('id'),
                                        t = $(o).attr('data-type');
                                    if (tId) {
                                        if (t == 2) {
                                            reportData.push({
                                                id: '',
                                                reportId: me.id,
                                                resourceId: tId
                                            });
                                        } else if (t == 1) {
                                            quotaIds.push(tId);
                                        }
                                        //特殊二维表模版
                                        if ($('#specialDiv').length > 0) {
                                            reportData.push({
                                                id: '',
                                                reportId: me.id,
                                                resourceId: tId
                                            });
                                        }
                                    }
                                });
                                $input.value = quotaIds.join(',');
                                reportData = JSON.stringify(reportData);
                                isHas || $tmpDom.append($input);
                                tmpStr = styleStr + '<div>' + $tmpDom.html() + '</div>';
                                me.saveData(parseInt(me.id), tmpStr, reportData);
                            });
                        },
                        saveData:function (id, tmpStr, reportData) {
                            this.resData(url[1],{
                                id: id,
                                content: tmpStr,
                                reportData: reportData
                            }, function (res) {
                                if (res.successFlg) {
                                    closeTmpSettingDialogDialog();
                                    $.Notice.success('保存成功！');
                                } else {
                                    $.Notice.error('保存失败！');
                                }
                            }, 'POST');
                        },
                        getFormatData: function (str) {//去除空格
                            return str.replace(/[\r\n]/g, '').replace(/^\s+|\s+$/g, '');
                        },
                        getChartData: function (id) {//获取选中的指标视图数据
                            TVS.resData(url[0], {
                                resourceId: id
                            }, function (res) {
                                if (res.successFlg) {
                                    var resourceId = res.detailModelList[0].resourceId,
                                        isT = TVS.checkIsExist(id),option = {}, xyChange = 'false', color = '';
                                    if (!isT) return;
                                    TVS.chart.attr('id', id);
                                    TVS.chart.attr('data-type', 2);
                                    option = TVS.resetOption(TVS.chart, JSON.parse(res.detailModelList[0].option));
//                                    xyChange = TVS.chart.attr('data-xy-change');
//                                    color = TVS.chart.attr('data-color');

//                                    if (xyChange == 'true') {
//                                        var x = option.xAxis, y = option.yAxis;
//                                        option.yAxis = x;
//                                        option.xAxis = y;
//                                    }
//                                    if (color && color != '') {
//                                        option.color = color.split(',');
//                                    }
                                    TVS.renderQuota(TVS.chart, option);
                                } else {
                                    $.Notice.error(res.errorMsg);
                                }
                            })
                        },
                        resetOption: function ($dom, opt) {
                            var option = opt,
                                color = $dom.attr('data-color'),
                                zoom = $dom.attr('data-zoom'),
                                grid = $dom.attr('data-grid'),
                                legend = $dom.attr('data-legend'),
                                seriesRadius = $dom.attr('data-series-radius'),
                                seriesCenter = $dom.attr('data-series-center'),
                                xaxisSplitLine = $dom.attr('data-xaxis'),
                                yaxisSplitLine = $dom.attr('data-yaxis'),
                                axisLine = $dom.attr('data-axis-line'),
                                axisTick = $dom.attr('data-axis-tick'),
                                seriesItemstyle = $dom.attr('data-series-itemstyle'),
                                xyChange = $dom.attr('data-xy-change');
                            if (color && color != '') {
                                option['color'] = JSON.parse(color);
                            }
                            if (zoom && zoom != '') {
                                option['dataZoom'] = JSON.parse(zoom);
                            }
                            if (grid && grid != '') {
                                option['grid'] = JSON.parse(grid);
                            }
                            if (xaxisSplitLine && xaxisSplitLine != '') {
                                option['xAxis']['splitLine'] = JSON.parse(xaxisSplitLine);
                            }
                            if (yaxisSplitLine && yaxisSplitLine != '') {
                                option['yAxis']['splitLine'] = JSON.parse(yaxisSplitLine);
                            }
                            if (legend && legend != '') {
                                var legObj = JSON.parse(legend);
                                legObj.data = [];
                                _.each(option['series'][0].data, function (o, k) {
                                    legObj.data.push(o.name ? o.name : '');
                                });
                                option['legend'] = legObj;
                            }
                            if (seriesRadius && seriesRadius != '') {
                                _.each(option['series'], function (o, k) {
                                    option['series'][k]['radius'] = seriesRadius.split(',');
                                });
                                // option['series']['radius'] = seriesRadius;
                            }
                            if (seriesCenter && seriesCenter != '') {
                                _.each(option['series'], function (o, k) {
                                    option['series'][k]['center'] = seriesCenter.split(',');
                                });
                                // option['series']['center'] = seriesCenter;
                            }
                            if (axisLine && axisLine != '') {
                                option['xAxis']['axisLine'] = axisLine;
                                option['yAxis']['axisLine'] = axisLine;
                            }
                            if (axisTick && axisTick != '') {
                                option['xAxis']['axisTick'] = axisTick;
                            }
                            if (seriesItemstyle && seriesItemstyle != '') {
                                _.each(option['series'], function (o, k) {
                                    option['series'][k]['itemStyle'] = JSON.parse(seriesItemstyle);
                                });
                                // option['series'][0]['itemStyle'] = JSON.parse(seriesItemstyle);
                            }
                            if (xyChange && xyChange == 'true') {
                                var x = [], y = [];
                                x = option['xAxis'];
                                y = option['yAxis'];
                                option['xAxis'] = y;
                                option['yAxis'] = x;
                            }
                            return option;
                        },
                        renderQuota: function ($dom, opt) {//渲染指标图表
                            var myChart = null;
                            myChart = echarts.init($dom[0]);
                            $dom.parent().find('.c-title').html(opt.title.text);
                            delete opt.title;
                            myChart.setOption(opt);
                        },
                        //获取表头
                        getResourceData: function (id, $dom, sta, name) {//档案数据
                            var me = this;
                            if (id != '') {
                                me.resData(url[4], {
                                    dictId: id
                                }, function (res) {
                                    me.renderResourceTable(id, res, $dom, sta, name)
                                });
                            }
                        },
                        //加载表格
                        renderResourceTable: function (id, res, $dom, sta, name, gridType, opt, code) {//档案数据表格渲染
                            var col = [], isT = false, params = {};
                            if (sta == 'change') {//change: 视图替换   undefined: 第一次渲染视图
                                isT = TVS.checkIsExist(id);
                                if (!isT) return;
                            }
                            if (!gridType) {
                                if (res && res.length > 0) {
                                    col = defauleColumnModel;
                                    $.each(res, function (k, obj) {
                                        col.push({display: obj.value, name: obj.code, width: 100});
                                    })
                                }
                            } else {
                                col = res;
                            }
                            params = {
                                url: url[3],
                                height: $dom.height(),
                                parms: {
                                    searchParams: '',
                                    resourcesCode: code || id
                                },
                                pageSize: 5,
                                columns: col,
                                checkbox: true
                            };
                            $dom.ligerGrid($.LigerGridEx.config($.extend({},params, opt || {})));
                            $dom.parent().find('.c-title').html(name);
                            $dom.attr('id', id);
                            $dom.attr('data-name', name);
                            $dom.attr('data-type', 1);

                            code && $dom.attr('data-code', code);
                        },
                        checkIsExist: function (id) {//检测id
                            var oldResourceId = TVS.chart.attr('id'),
                                newIndex = TVS.rIdsAndQCode.indexOf(id),
                                oldIndex = TVS.rIdsAndQCode.indexOf(oldResourceId);
                            if (newIndex >= 0) {
                                $.Notice.error('该视图已选择，请重选！');
                                return false;
                            }
                            if (oldIndex >= 0) {
                                TVS.resetHtml();
                            }
                            TVS.rIdsAndQCode.push(id);
                            return true;
                        },
                        resetHtml: function () {//删除图表
                            TVS.chart && TVS.ET.resetHtml(TVS.chart.parent(), TVS.removeId);
                        },
                        removeId: function (id) {
                            var index = TVS.rIdsAndQCode.indexOf(id);
                            if (index >= 0) {
                                TVS.rIdsAndQCode.splice(index, 1);
                            }
                        },
                        resData: function (url, param, cb, type) {
                            $.ajax({
                                url: url,
                                type: type || 'GET',
                                dataType: 'json',
                                data: param,
                                success: function (res) {
                                    cb && cb.call(this, res);
                                },
                                error: function () {
                                    $.Notice.error('发生异常！');
                                }
                            });
                        }
                    };
                    w.closeselViewDialog = function (msg, id, type, name, code) {
                        selViewDialog.close();
                        msg && $.Notice.success(msg);
                        (id && type) && (function () {
                            //特殊二维表模版
                            if ($('#specialDiv').length > 0) {
                                var speFunTmp = '', data = [];
                                speFunTmp = $('#specialFunTmp').html();
                                eval(speFunTmp);
                                gridObj && (function () {
                                    gridObj['parms'] = {
                                        resourcesCode: code,
                                        page: 1,
                                        rows: 500
                                    }
                                })();
                                TVS.renderResourceTable(id, (col || []), TVS.chart, 'change', name, '2', (gridObj || []), code);
                            } else {
                                if (type == 1) {
                                    TVS.getResourceData(id, TVS.chart, 'change', name);
                                } else {
                                    TVS.getChartData(id);
                                }
                            }
                        })()
                        w._ET = null;
                    };
                    TVS.init();
                });
        });
    })(window, jQuery);
</script>