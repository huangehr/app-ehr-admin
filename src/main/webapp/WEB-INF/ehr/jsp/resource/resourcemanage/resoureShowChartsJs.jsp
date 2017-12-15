<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    $(function () {
        var inf = ['${contextRoot}/resource/resourceManage/resourceUpDown'];
        var showCharts = {
            id: '${id}',
            dataModel: $.DataModel.init(),
            chartInfoModel: ${chartInfoModel},//总数据
            nrsAvalon: null,
            chart: document.getElementById('chart'),
            resourceId: '${id}',
            myChart: null,
            xAxisMap: {},//细维度
            firstDimension: '',//默认第一次查询的主维度code
            dimensionMap: {},//主维度-对象
            $cDropDown: $('#cDropDown'),
            init: function () {
                this.initAvalon();
                this.initData();
                this.bindEvents();
            },
            initAvalon: function () {
                var me = this;
                me.nrsAvalon = avalon.define({
                    $id: 'nrsApp',
                    downClass: '',
                    showDown: false,//是否显示下拉
                    dimensionMap: [],//主维度-数组
                    downValArr: [],//下钻数据
                    downKeyArr: [],//主维度index
                    selVal: '',//图表选中值
                    isSel: false,//是否先选中图表
                    nowDimension: [],//下砖维度顺序
                    num: 0,
                    upVal: function() {
                        var valArr = [],
                                str = '无上卷项';
                        _.each(this.nowDimension, function (o, k) {
                            if (k == 0) return;
                            valArr.push(o);
                        });
                        if (valArr.length > 0) {
                            str = me.dimensionMap[valArr[valArr.length - 1]];
                        }
                        return str;
                    },
                    cUp: function () {//上卷
                        if (this.downKeyArr.length > 0) {
                            var dimension = '';
                            this.selVal = '';
                            this.nowDimension.pop();
                            this.num--;
                            this.dimensionMap[this.downKeyArr[this.downKeyArr.length - 1]].isShow = true;
                            this.downKeyArr.splice(this.downKeyArr.length - 1, 1);
                            this.downValArr.splice(this.downValArr.length - 1, 1);
                            dimension = this.nowDimension[this.nowDimension.length - 1];
                            me.reloadData((dimension ? dimension : me.firstDimension), this.downValArr.join(';'));
                        }
                    },
                    cSH: function () {//控制 下拉
                        var that = this;
                        if (!that.isSel) return;
                        if (that.showDown) {
                            that.showDown = false;
                        } else {
                            that.showDown = true;
                        }
                    },
                    cDown: function (key, v, num) { //选择下砖数据
                        this.showDown = false;
                        this.isSel = false;
                        this.downKeyArr.push(num);
                        this.dimensionMap[num].isShow = false;
                        this.downValArr.push(this.nowDimension[this.num] + '=' + me.xAxisMap[this.selVal]);
                        this.downClass = '';
                        this.selVal = '';
                        this.nowDimension.push(key);
                        me.reloadData(key, this.downValArr.join(';'));
                        this.num++;
                    },
                    cLink: function (k, l) {
                        var arrVal = [],
                            arrKey = [],
                            arrND = [me.firstDimension],
                            i;
                        if (typeof l != 'undefined') {
                            for (i = 0; i <= l; i++) {
                                arrVal.push(this.downValArr[i]);
                                arrKey.push(this.downKeyArr[i]);
                                arrND.push(this.nowDimension[i + 1]);
                            }
                            for (; i < this.dimensionMap.length; i++) {
                                this.dimensionMap[this.downKeyArr[i]].isShow = true;
                            }
                            this.downValArr = arrVal;
                            this.downKeyArr = arrKey;
                            this.nowDimension = arrND;
                            me.reloadData(k, this.downValArr.join(';'));
                        }
                    },
                    getFirstVal: function () {
                        return me.dimensionMap[me.firstDimension];
                    }
                });
            },
            reloadData: function (dimension, quotaFilter) {
                var me = this;
                this.dataModel.fetchRemote(inf, {
                    data: {
                        id: this.resourceId,
                        dimension: dimension,
                        quotaFilter: quotaFilter
                    },
                    success: function(data) {
                        me.xAxisMap = data.xAxisMap;
                        var option = data.option;
                        if (option) {
                            option = JSON.parse(option);
                            me.reloadChart(option);
                        }
                    }
                });
            },
            initData: function () {
                var me = this,
                        option = JSON.parse(me.chartInfoModel.option),
                        arr = [];
                if (option) {
                    _.each(option.xAxis, function (o, k) {
                        option.xAxis[k]['axisTick'] = {};
                        option.xAxis[k]['axisTick']['alignWithLabel'] = true;
                    });
                    me.initChart(option);
                } else {
                    $.Notice.success('图表数据有误！');
                    return;
                }
                me.dimensionMap = me.chartInfoModel.dimensionMap;
                me.xAxisMap = me.chartInfoModel.xAxisMap;
                me.firstDimension = me.chartInfoModel.firstDimension;//
                me.nrsAvalon.nowDimension = [me.chartInfoModel.firstDimension];
                _.map(me.chartInfoModel.dimensionMap, function (v, k) {
                    if (k == me.firstDimension) return;
                    arr.push({
                        value: v,
                        key: k,
                        isShow: true//是否显示
                    });
                });
                me.nrsAvalon.dimensionMap = arr;
            },
            initChart: function (option) {
                var me = this;
                me.myChart = echarts.init(me.chart);
                function eConsole(param) {
                    var num = 0;
                    _.each(me.nrsAvalon.dimensionMap, function (o , k) {
                        if (!o.isShow) {
                            num++;
                        }
                    });
                    if (me.nrsAvalon.dimensionMap.length > num) {
                        me.nrsAvalon.selVal = param.name;
                        me.nrsAvalon.isSel = true;
                        me.nrsAvalon.downClass = 'active';
                    }
                }
                me.myChart.on('click', eConsole);
                me.myChart.setOption(option);
            },
            reloadChart: function (opt) {
                this.myChart.clear();
                this.myChart.setOption(opt, true);
            },
            bindEvents: function () {
                var me = this;
                me.$cDropDown.on('click', function () {
                    var key = $(this).attr('key');
                    me.reloadData(key, '');
                    me.nrsAvalon.downValArr = [];
                    me.nrsAvalon.downKeyArr = [];
                    me.nrsAvalon.nowDimension = [me.firstDimension];
                    me.nrsAvalon.selVal = '';
                    _.each(me.nrsAvalon.dimensionMap, function (o , k) {
                        o.isShow = true;
                    });
                });
            }
        };
        showCharts.init();
    });
</script>