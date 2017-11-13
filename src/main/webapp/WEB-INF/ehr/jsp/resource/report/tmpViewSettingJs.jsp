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
        ];
        $(function () {
            var TVS = {
                $upHtmlFile: $('#upHtmlFile'),
                $noneTmp: $('.none-tmp'),
                $upFileInp: $('.up-file'),
                $tmpCon: $('.tmp-con'),
                $saveTmp: $('#saveTmp'),
                resourseIds: [],
                chart: null,
                chartTit: '',
                id: '${id}',
                code: '${code}',
                init: function () {
                    this.getTmp();
                    _ET({
                        $main: $('#editMain'),
                        addViewFun: this.showViewList.bind(this)
                    });
                    this.bindEvent();
                },
                getTmp: function () {
                    var me = this;
                    $.ajax({
                        url: url[2],
                        type: 'GET',
                        data: {reportCode: me.code},
                        success: function(data) {
                            if(data.successFlg) {
                                me.$noneTmp.hide();
                                me.$tmpCon.html(data.obj.templateContent);
                            } else {
                                me.$noneTmp.show();
                                $.Notice.warn('获取报表模版失败！');
                            }
                        },
                        error: function () {
                            $.Notice.error('获取报表模版发生异常！');
                        }
                    });
                },
                getTmpData: function () {

                },
                showViewList: function ($dom) {
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
                    me.$upFileInp.on('change', function (e) {
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
                    me.$saveTmp.on('click', function () {
                        var tmp = me.$tmpCon.html(),
                            num = tmp.indexOf('</style>') + ('</style>'.length),
                            styleStr = me.getFormatData(tmp.substring(0, num)),
                            tmpStr = me.getFormatData(tmp.substring(num, tmp.length)),
                            $tmpDom = $(tmpStr);
                        $tmpDom.find('.c-title').html('');
                        $tmpDom.find('.charts-con').removeAttr('style').removeAttr('_echarts_instance_').html('');
                        tmpStr = styleStr + $tmpDom.html();
                        $.ajax({
                            url: url[1],
                            data: {
                                id: parseInt(me.id),
                                content: tmpStr
                            },
                            type: 'GET',
                            dataType: 'json',
                            success: function (res) {
                                if (res.successFlg) {
                                    $.Notice.success('保存成功！');
                                } else {
                                    $.Notice.error('保存失败！');
                                }
                            }
                        });
                    });
                },
                getFormatData: function (str) {
                    return str.replace(/[\r\n]/g, '').replace(/^\s+|\s+$/g, '');
                },
                getChartData: function (id) {
                    $.ajax({
                        url: url[0],
                        data: {resourceId: id},
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            if (res.successFlg) {
                                var resourceId = res.detailModelList[0].resourceId,
                                    oldResourceId = TVS.chart.attr('id'),
                                    newIndex = TVS.resourseIds.indexOf(resourceId),
                                    oldIndex = TVS.resourseIds.indexOf(oldResourceId);
                                debugger
                                if (newIndex >= 0) {
                                    console.log(TVS.resourseIds);
                                    alert('该视图已选择，请重选！');
                                    return;
                                }
                                if (oldIndex >= 0) {
                                    TVS.resourseIds = TVS.resourseIds.splice(oldIndex, 1);
                                }
                                var option = JSON.parse(res.detailModelList[0].option);
                                var myChart = echarts.init(TVS.chart[0]);
                                TVS.chartTit.html(option.title.text);
                                TVS.resourseIds.push(resourceId);
                                TVS.chart.attr('id', resourceId);
                                delete option.title;
                                myChart.setOption(option);
                                console.log(TVS.resourseIds);
                            } else {
                                $.Notice.error(res.errorMsg);
                            }
                        }
                    });
                }
            };
            w.closeselViewDialog = function (msg, id) {
                selViewDialog.close();
                TVS.getChartData(id);

                w._ET = null;
                msg && $.Notice.success(msg);
            };
            TVS.init();
        });
    })(window, jQuery);
</script>