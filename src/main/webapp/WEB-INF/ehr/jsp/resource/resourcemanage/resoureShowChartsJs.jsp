<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/echarts/3.0/js/echarts.min.js"></script>
<script>
    $(function () {
        var inf = ['${contextRoot}/resource/resourceManage/resourceUpDown']
        var obj = null,
            chartsTitArr = [],
            optsArr = [],
            listMap = [],
            dimensionMapArr = [],
            qutoId = [],
            dataLength = 0,
            id = '${id}',
            charts = [];
        try {
            obj = ${resultStr};
        } catch (e) {
            $.Notice.success('获取数据失败，请重新加载页面！');
            return;
        }
        dataLength = obj.length;
        if (obj && obj.length > 0) {
            for (var i = 0, len = obj.length; i < len; i++) {
                var opt = {};
                try {
                    opt = obj[i].option ? JSON.parse(obj[i].option) : {};
                } catch (e) {
                    console.log(e.message);
                }
                optsArr.push(opt);
                chartsTitArr.push(obj[i].title);
                listMap.push(obj[i].listMap);
                dimensionMapArr.push(obj[i].dimensionMap);
                qutoId.push(obj[i].quotaId);
            }
        }
//        console.log('optsArr:' + JSON.stringify(optsArr));
//        console.log('listMap:' + JSON.stringify(listMap));
//        console.log('dimensionMap:' + JSON.stringify(dimensionMapArr));
        var showSharts = {
            $tabList: $('.tab-list'),
            $chartsMain: $('.charts-main'),
            conTmp: $('#tabTmp').html(),
            optionsArr: [],
            index: 0,
            myChartsArr: [],
            dataModel: $.DataModel.init(),
            init: function () {
                this.insertHtml();
                this.$tabList.mCustomScrollbar({
                    axis: "x"
                });
                this.bindEvnt();
            },
            initCharts: function () {
                var me = this;
                for (var m = 0; m < dataLength; m ++) {
                    var myChart1 = echarts.init(document.getElementById("chartsMain" + m + "1")),
                        myChart2 = echarts.init(document.getElementById("chartsMain" + m + "2")),
                        options = optsArr[m];
                    if(options) {
                        try {
                            myChart1.setOption(options);
                            myChart2.setOption(options);
                            (function (ec) {
                                charts.push(ec);
                                ec.on('click', function (param) {
                                    me.reloadECharts(param, ec, me)
                                });
                            })(myChart1);
                        } catch (e) {
                            console.log(e.message);
                        }
                    }
                }
            },
            reloadECharts: function (param, dom, me) {
                var $dom = $(dom._dom),
                    domId = $dom.closest('.tab-con ').attr('data-id'),
                    $condition = $dom.prev(),
                    $goBack = $condition.find('.go-back'),
                    dataNum = parseInt($condition.attr('data-num')),//下转层级
                    quotaFilter = $condition.attr('data-quota-filter'),//过滤条件
                    dataList = ($condition.attr('data-list')).split(','),
                    key = dataList[dataNum],
                    dimension = '';//维度
                $goBack.show();
                quotaFilter += ((quotaFilter == '' ? '' : ';') + key + '=' + dimensionMapArr[domId][param.name]);
                dataNum++;
                dimension = dataList[dataNum];
                if (dimension) {
                    me.loadData(dimension, quotaFilter, $condition, dataNum, domId);
                } else {
                    $.Notice.success('已是最底层！');
                }
            },
            loadData: function (dim, qf, $con, num, domId) {
                var me = this;
                me.dataModel.fetchRemote( inf[0], {
                    data: {
                        id: id,
                        dimension: dim,
                        quotaFilter: qf,
                        quotaId: qutoId[domId]
                    },
                    async: false,
                    success: function (data) {
                        if (data && data[0]) {
                            var opt = JSON.parse(data[0].option);
                            dimensionMapArr[domId] = data[0].dimensionMap;
                            $con.attr('data-num', num);
                            $con.attr('data-quota-filter', qf);
                            charts[domId].setOption(opt);
                        } else {
                            $.Notice.success('获取数据失败,请重试！');
                        }
                    }
                });
            },
            //加载html
            insertHtml: function () {
                var me = this,
                    html = '',
                    conHtml = '';
                $.each(chartsTitArr, function (key, val) {
                    var cN = key == 0 ? 'active' : '',
                        cl = key != 0 ? 'un-show' : '',
                        obj = {
                            class: cl,
                            id: key,
                            idOne: 'chartsMain' + key + '1',
                            idTwo: 'chartsMain' + key + '2',
                            checkboxs: '',
                            dimension: ''
                        },
                        checkboxHtml = '';
                    var list = [];
                    $.each(listMap[key], function (key, obj) {
                        var dis = obj.isMain == 'true' ? 'disabled' : '';
                        var che = obj.isCheck == 'true' ? 'checked' : '';
                        checkboxHtml += '<input type="checkbox" data-key="' +
                                            obj.code + '" ' +
                                            che + '  '+
                                            dis + '/>' +
                                            obj.name;
                        list.push(obj.code);
                    });
                    obj.dimension = list.join(',');
                    obj.checkboxs = checkboxHtml;
                    html += '<li class="tab-item '+ cN +'"><a href="javascript:;" title="'+ val +'">' + val + '</a></li>';
                    conHtml += me.render(me.conTmp, obj);
                });
                me.$tabList.append(html);
                me.$chartsMain.append(conHtml);
                me.initCharts();
            },
            bindEvnt: function () {
                var me = this;
                me.$tabList.on('click', '.tab-item', function () {
                    var index = $(this).index(),
                            $tabCon = me.$chartsMain.find('.tab-con');
                    $(this).addClass('active').siblings().removeClass('active');
                    $tabCon.hide().eq(index).show();
                });
                me.$chartsMain.on('click', '.con-t-i', function () {
                    var $that = $(this),
                        $parent = $that.closest('.tab-con'),
                        $conTCon = $parent.find('.con-t-con'),
                        $goBack = $parent.find('.go-back'),
                        index = $that.index();
                    if (index == 0) {
                        $goBack.show();
                    } else {
                        $goBack.hide();
                    }
                    $that.addClass('active').siblings().removeClass('active');
                    $conTCon.hide().eq(index).show();
                }).on('click', '.go-back', function () {
                    var $parent = $(this).parent(),
                        domId = $(this).closest('.tab-con ').attr('data-id'),
                        dataNum = parseInt($parent.attr('data-num')),//下转层级
                        quotaFilter = $parent.attr('data-quota-filter'),//过滤条件
                        dataList = ($parent.attr('data-list')).split(','),
                        qf = quotaFilter.split(';'),
                        dimension = '';
                    dataNum--;
                    qf.pop();
                    if (qf.length <= 0) {
                        $(this).hide();
                    }
                    dimension = dataList[dataNum];
                    quotaFilter = qf;
                    me.loadData(dimension, quotaFilter, $parent, dataNum, domId);
                });
            },
            render: function(tmpl, data, cb){
                return tmpl.replace(/\{\{(\w+)\}\}/g, function(m, $1){
                    cb && cb.call(this, data, $1);
                    return data[$1];
                });
            }
        }
        showSharts.init();
    });
</script>