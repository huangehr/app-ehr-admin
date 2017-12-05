<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${staticRoot}/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script src="${staticRoot}/lib/plugin/editTmp/editTmp.js"></script>

<script>
    (function (w, $) {
        var selViewDialog;
        var url = [
                '${contextRoot}/resource/report/getRsQuotaPreview',//获取视图列表
                '${contextRoot}/resource/report/uploadTemplate',//保存模板
                '${contextRoot}/resource/report/getTemplateData',//获取模板
                '${contextRoot}/resourceBrowse/searchResourceData',//获取模板对应的数据
                '${contextRoot}/resourceBrowse/getGridCloumnNames'//获取表头
        ];
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
                            $.each(d , function (k, obj) {
                                var $dom = $('#' + obj.resourceId),
                                        option = JSON.parse(obj.options[0].option);
                                me.rIdsAndQCode.push(obj.resourceId);
                                me.renderQuota($dom, option);
                            });
                            $quotaIds = $(document).find('#quotaIds');
                            if ($quotaIds.length > 0) {
                                quotaIds = ($quotaIds.val()).split(',')
                            }
                            $.each(quotaIds, function (k, v) {
                                var $dom = $('#' + v);
                                me.rIdsAndQCode.push(v);
                                me.getResourceData(v, $dom, null, $dom.attr('data-name'));
                            })
                        } else {
                            me.$noneTmp.show();
                            $.Notice.warn('获取报表模版失败！');
                        }
                    })
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
                            me.$tmpCon.html(this.result);
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
                            if (t == 2) {
                                reportData.push({
                                    id: '',
                                    reportId: me.id,
                                    resourceId: tId
                                });
                            } else if (t == 1) {
                                quotaIds.push(tId);
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
                                    isT = TVS.checkIsExist(resourceId);
                            if (!isT) return;
                            TVS.chart.attr('id', resourceId);
                            TVS.chart.attr('data-type', 2);
                            var option = JSON.parse(res.detailModelList[0].option);
                            TVS.renderQuota(TVS.chart, option);
                        } else {
                            $.Notice.error(res.errorMsg);
                        }
                    })
                },
                renderQuota: function ($dom, opt) {//渲染指标图表
                    var myChart = null;
                    myChart = echarts.init($dom[0]);
                    $dom.parent().find('.c-title').html(opt.title.text);
                    delete opt.title;
                    myChart.setOption(opt);
                },
                getResourceData: function (id, $dom, sta, name) {//档案数据
                    var me = this;
                    me.resData(url[4], {
                        dictId: id
                    }, function (res) {
                        me.renderResourceTable(id, res, $dom, sta, name)
                    });
                },
                renderResourceTable: function (id, res, $dom, sta, name) {//档案数据表格渲染
                    var col = [], isT = false;
                    if (sta == 'change') {//change: 视图替换   undefined: 第一次渲染视图
                        isT = TVS.checkIsExist(id);
                        if (!isT) return;
                    }
                    if (res && res.length > 0) {
                        col = defauleColumnModel;
                        $.each(res, function (k, obj) {
                            col.push({display: obj.value, name: obj.code, width: 100});
                        })
                    }
                    $dom.ligerGrid($.LigerGridEx.config({
                        url: url[3],
                        height: $dom.height(),
                        parms: {
                            searchParams: '',
                            resourcesCode: id
                        },
                        pageSize: 5,
                        columns: col,
                        checkbox: true
                    }));
                    $dom.parent().find('.c-title').html(name);
                    $dom.attr('id', id);
                    $dom.attr('data-name', name);
                    $dom.attr('data-type', 1);
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
                resetHtml: function () {
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
            w.closeselViewDialog = function (msg, id, type, name) {
                selViewDialog.close();
                msg && $.Notice.success(msg);
                (id && type) && (function () {
                    if (type == 1) {
                        TVS.getResourceData(id, TVS.chart, 'change', name);
                    } else {
                        TVS.getChartData(id);
                    }
                })()
                w._ET = null;
            };
            TVS.init();
        });
    })(window, jQuery);
</script>