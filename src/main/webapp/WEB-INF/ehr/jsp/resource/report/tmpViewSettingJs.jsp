<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${staticRoot}/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script src="${staticRoot}/lib/plugin/editTmp/editTmp.js"></script>

<script>
    (function (w, $) {
        var selViewDialog;
        var url = '${contextRoot}/resource/report/getRsQuotaPreview';
        $(function () {
            var TVS = {
                $upHtmlFile: $('#upHtmlFile'),
                $upFileInp: $('.up-file'),
                $tmpCon: $('.tmp-con'),
                $saveTmp: $('#saveTmp'),
                chart: null,
                chartTit: '',
                init: function () {
                    _ET({
                        $main: $('#editMain'),
                        addViewFun: this.showViewList.bind(this)
                    });
                    this.bindEvent();
                },
                showViewList: function ($dom) {
                    var wait = $.Notice.waitting("请稍后..."),
                        me = this;
                    me.chart = $dom.closest('.charts').find('.charts-con');
                    me.chartTit = $dom.closest('.charts').find('.c-title');
                    selViewDialog = $.ligerDialog.open({
                        height: 700,
                        width: 378,
                        title: '报表视图配置',
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
                        debugger
                        var tmp = me.$tmpCon.html(),
                            num = tmp.indexOf('</style>') + ('</style>'.length),
                            styleStr = tmp.substring(0, num),
                            $tmpDom = $(tmp.substring(num, tmp.length)),
                            tmpStr = '';
                        $tmpDom.find('.c-title').html('');
                        $tmpDom.find('.charts-con').removeAttr('style').removeAttr('_echarts_instance_').html('');
                        tmpStr = styleStr + $tmpDom.toString();
                        console.log(tmpStr);
                    });
                }
            }
            TVS.init();
            function getChartData (id) {
                $.ajax({
                    url: url,
                    data: {resourceId: id},
                    type: 'GET',
                    dataType: 'json',
                    success: function (res) {
                        if (res.successFlg) {
                            var option = JSON.parse(res.detailModelList[0].option);
                            var myChart = echarts.init(TVS.chart[0]);
                            TVS.chartTit.html(option.title.text);
                            delete option.title;
                            myChart.setOption(option);
                        } else {
                            $.Notice.error(res.errorMsg);
                        }
                    }
                });
            }
            w.closeselViewDialog = function (msg, id) {
                selViewDialog.close();
                getChartData(id);

                w._ET = null;
                msg && $.Notice.success(msg);
            };
        });
    })(window, jQuery);
</script>