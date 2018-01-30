<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/1/24 0024
  Time: 下午 4:29
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/jquery/jquery-1.9.1.js"></script>
<script src="${contextRoot}/develop/lib/plugin/es6Promise/es6-promise.js"></script>
<script src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.core.js"></script>
<script src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.core.js"></script>
<script src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.excheck.js"></script>
<script src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.exedit.js"></script>
<script src="${contextRoot}/develop/browser/lib/grid/js/bootstrap-table.min.js"></script>
<script src="${contextRoot}/develop/browser/lib/grid/js/bootstrap-table-zh-CN.min.js"></script>
<script src="${contextRoot}/develop/lib/plugin/layer/layer.min.js"></script>
<script src="${contextRoot}/develop/lib/plugin/layui/layui.all.js"></script>

<script>
    (function ($,win) {
        $(function () {
            var paramOne = null,
                paramTwo = '',
                paramThree = '',
                type = 0;
            function assignment() {
                parent.GlobalEventBus.$on("getAddQueryParam",function(arg) {
                    paramOne = arg.paramOne;
                    paramTwo = arg.paramTwo;
                    paramThree = arg.paramThree;
                    type = arg.type;
                    AQ.init();
                });
            }
            assignment();

            function setLoading() {//loading
                var loading = layer.open({
                    shade: [0.8, '#393D49'],icon: 1,
                    title: false,
                    type: 3
                });
                return loading;
            }
            var loading = setLoading();
            var AQ = {
                $selBtn: $('.sel-btn'),
                $selCon: $('.sel-con'),
                $selList: $('#dynamicSelData'),
                $aqTable: $('.aq-table'),
                $searchBtn: $('#searchBtn'),
                $saveBtn: $('#saveBtn'),
                $outExc: $('#outExc'),
                // $showSetBtn: $('.show-set-btn'),
                $selSetBody: $('.sel-set-body'),
                QAVue: null,
                tcHei: $('.aq-bottom').height(),
                type: 0,
                columns: [],
                paramObj: null,
                childParam: [],
                paramThreeLen: paramThree.length,
                index: 0,
                init: function () {
                    var me = this;
                    me.initVue();
                    me.bindEvent();
                    me.$selList.append(me.getHtml('时间', 'event_date', null));
                    if (type == 0) {
                        me.loadResNormalSelData();
                        me.checkData(paramThree[me.index]);
                        me.createResourceTable();
                    } else {
                        me.loadQuotaNormalData();
                        me.getQuotaCol();
                    }
                },
                initVue: function () {
                    var me = this;
                    me.QAVue = new Vue({
                        el: '#selSetBody',
                        data: {
                            timeChkBox: [],
                            textChkBox: [],
                            timeClass: 'checked',
                            textClass: 'checked',
                            timeNum: 0,
                            textNum: 0
                        },
                        methods: {
                            setCheckTimeSta: function (n) {
                                if (this.timeChkBox[n].checked == '') {
                                    this.timeChkBox[n].checked = 'checked';
                                    this.timeNum++;
                                } else {
                                    this.timeChkBox[n].checked = '';
                                    this.timeNum--;
                                }
                                if (this.timeChkBox.length > this.timeNum) {
                                    this.timeClass = '';
                                } else {
                                    this.timeClass = 'checked';
                                }
                            },
                            setCheckTextSta:function (n, v) {
                                if (this.textChkBox[n].checked == '') {
                                    this.textChkBox[n].checked = 'checked';
                                    this.textNum++;
                                } else {
                                    this.textChkBox[n].checked = '';
                                    this.textNum--;
                                }
                                if (this.textChkBox.length > this.textNum) {
                                    this.textClass = '';
                                } else {
                                    this.textClass = 'checked';
                                }
                            },
                            checkTimeAll: function () {
                                var isTrue = false;
                                if (this.timeClass == '') {
                                    isTrue = true;
                                    this.timeClass = 'checked';
                                    this.timeNum = this.timeChkBox.length;
                                } else {
                                    this.timeClass = ''
                                    this.timeNum = 0;
                                }
                                this.setArrCheck(isTrue, this.timeChkBox);
                            },
                            checkTextAll: function () {
                                var isTrue = false;
                                if (this.textClass == '') {
                                    isTrue = true;
                                    this.textClass = 'checked';
                                    this.textNum = this.textChkBox.length;
                                } else {
                                    this.textNum = 0;
                                    this.textClass = ''
                                }
                                this.setArrCheck(isTrue, this.textChkBox);
                            },
                            setArrCheck: function (sta, arr) {
                                _.each(arr, function (obj) {
                                    if (sta) {
                                        obj.checked = 'checked';
                                    } else {
                                        obj.checked = '';
                                    }
                                });
                            },
                            resetCheck: function () {
                                this.timeClass = 'checked';
                                this.textClass = 'checked';
                                _.each(this.timeChkBox, function (obj) {
                                    obj.checked = 'checked'
                                });
                                _.each(this.textChkBox, function (obj) {
                                    obj.checked = 'checked'
                                });
                            },
                            setTableTitle: function () {
                                _.each(this.timeChkBox, function (obj) {
                                    var code = type == 0 ? obj.code : obj.key;
                                    if (obj.checked == '') {
                                        me.$aqTable.bootstrapTable('hideColumn', obj.code);
                                    } else {
                                        me.$aqTable.bootstrapTable('showColumn', obj.code);
                                    }
                                });
                                _.each(this.textChkBox, function (obj) {
                                    var code = type == 0 ? obj.code : obj.key;
                                    if (obj.checked == '') {
                                        me.$aqTable.bootstrapTable('hideColumn', code);
                                    } else {
                                        me.$aqTable.bootstrapTable('showColumn', code);
                                    }
                                });
                                // me.$showSetBtn.removeClass('active');
                                // $('#selSetBody').slideUp();
                            }
                        },
                        created: function () {
                            if (type == 0) {
                                var arr = JSON.parse(paramOne),
                                    that = this;
                                _.each(arr, function (obj) {
                                    obj.checked = 'checked';
                                    if (obj.dictCode) {
                                        if (obj.dictCode == 'DATECONDITION') {
                                            that.timeChkBox.push(obj)
                                        } else {
                                            that.textChkBox.push(obj)
                                        }
                                    } else {
                                        if (obj.code == 'event_date') {
                                            that.timeChkBox.push(obj)
                                        } else {
                                            that.textChkBox.push(obj)
                                        }
                                    }
                                });
                                that.textNum = that.textChkBox.length;
                                that.timeNum = that.timeChkBox.length;
                            }
                        }
                    });
                },
                setVueData: function (arr) {
                    var that = this.QAVue;
                    that.textChkBox = [];
                    _.each(arr, function (obj) {
                        obj.checked = 'checked';
                        that.textChkBox.push(obj);
                    });
                    that.textNum = that.textChkBox.length;
                    that.timeNum = that.timeChkBox.length;
                },
                loadResNormalSelData: function () {//默认搜索条件-档案数据
                    var me = this;
                    me.$selList.append(me.getHtml('事件类型', 'event_type', [
                        {code: 0, name: '门诊'},
                        {code: 1, name: '住院'},
                        {code: 2, name: '线上'}
                    ]));
                },
                searchQuotaParam: function (opt, type) {//综合查询指标统计数据检索条件
                    return httpGet('${contextRoot}/resourceIntegrated/searchQuotaParam', opt, type)
                },
                loadQuotaNormalData: function () {
                    var pt = (JSON.parse(paramTwo)).join(','),
                        me = this;
                    me.searchQuotaParam({
                        data: {
                            tjQuotaCodes: pt
                        }
                    }, 'none').then(function (res) {
                        if (res.successFlg) {
                            var data = res.obj;
                            _.each(data, function (obj) {
                                me.$selList.append(me.getHtml(obj.name, obj.key, function () {
                                    var arr = [];
                                    _.each(obj.value, function (o) {
                                        arr.push({
                                            code: o,
                                            name: o
                                        });
                                    });
                                    return arr;
                                }()));
                            });
                            // me.judgeIndex();
                        } else {
                            console.log('数据获取失败');
                        }
                        me.loadLayui();
                    });
                },
                judgeIndex: function () {//下标判断
                    var me = this;
                    if (me.index < me.paramThreeLen) {
                        me.checkData(paramThree[me.index]);
                    } else {
                        me.loadLayui();
                    }
                },
                getRsDictEntryList: function (opt, type) {//获取字典值
                    return httpGet('${contextRoot}/resourceIntegrated/getRsDictEntryList', opt, type)
                },
                checkData: function (obj) {//检查数据元是否存在在数据字典中- 档案数据
                    var me = this;
                    me.index++;
                    if (obj.dictCode && obj.dictCode != '' && obj.dictCode != 0) {
                        if (obj.dictCode == 'DATECONDITION') {//时间类型
                            me.$selList.append(me.getHtml(obj.name, obj.code, null));
                            me.judgeIndex();
                        } else {
                            me.getRsDictEntryList({
                                data: {
                                    dictId: obj.dictCode
                                }
                            }, 'none').then(function (res) {
                                if (res.successFlg) {
                                    me.$selList.append(me.getHtml(obj.name, obj.code, res.detailModelList));
                                } else {
                                    console.log('获取数据失败！');
                                }
                                me.judgeIndex();
                            });
                        }
                    } else {
                        me.judgeIndex();
                    }
                },
                getHtml: function (name, code, data) {//获取筛选条件html
                    var me = this;
                    var html = ['<li class="sel-item" data-code="'+ code +'">',
                        '<label for="">' + name + '：</label>',
                        me.getConditionSelHtml(data, data != null ? 'sel-' + code : 'sel1-' + code),
                        me.geValSelHtml(data, code, 'start-' + code),
                        data != null ? '' : (me.getConditionSelHtml(data, 'sel2-' + code)) + me.geValSelHtml(data, code, 'end-' + code),
                        '</li>'].join('');
                    return html;
                },
                getConditionSelHtml: function (type, code) {
                    return ['<div class="item-sel item-sel-nor"><select name="'+ code +'">',
                        type != null ? ['<option value="!=" selected>不属于</option>', '<option value="=">属于</option>'].join('') :
                            [
                                // '<option value="=" selected>等于</option>',
                                '<option value="!=">不等于</option>',
                                '<option value="<">小于</option>',
                                '<option value=">">大于</option>',
                                '<option value="<=">小于等于</option>',
                                '<option value=">=">大于等于</option>'
                            ].join(''),
                        '</select></div>'].join('');
                },
                geValSelHtml: function (data, code, id) {
                    var html = '';
                    if (data != null) {
                        html += '<select name="'+ code +'"><option value=""></option>';
                        _.each(data, function (obj) {
                            html += '<option value="' + obj.code + '">' + obj.name + '</option>';
                        });
                        html+= '<select name="">';
                    } else {
                        html = '<input type="text" class="layui-input c-date" name="'+ id +'" data-type="date" id="' + id + '" readonly>';
                    }
                    return '<div class="item-sel">' + html + '</div>';
                },

                //档案数据接口
                searchMetadataData: function () {//综合查询档案数据检索
                return  '${contextRoot}/resourceIntegrated/searchMetadataData'
                },
                createResourceTable: function (sp) {//档案数据
                    var me = this;
                    me.paramObj = JSON.parse(paramOne);
                    _.each(me.paramObj, function (obj) {
                        me.columns.push({
                            field: obj.code,
                            title: obj.name,
                            align: 'center'
                        });
                    });
                    _.each(paramThree, function (obj) {
                        me.childParam.push(obj.code);
                    });
                    me.initTable(me.searchMetadataData(), function(params){//传递参数（*）
                        return me.getResParams('[]', params.pageSize, params.pageNumber);
                    }, me.columns);
                },
                searchQuotaDataPro: function (opt, type) {//综合查询指标统计数据检索
                    return httpGet('${contextRoot}/resourceIntegrated/searchQuotaData', opt, type)
                },
                searchQuotaData: function () {//综合查询指标统计数据检索
                    return '${contextRoot}/resourceIntegrated/searchQuotaData'
                },
                getQuotaCol: function () {//指标统计
                    var me = this;
                    var po = (JSON.parse(paramOne)).join(','),
                        pt = (JSON.parse(paramTwo)).join(','),
                        params = {
                            tjQuotaIds: po,
                            tjQuotaCodes: pt,
                            searchParams: '{}',
                        };
                    me.searchQuotaDataPro({
                        data: params
                    }, 'none').then(function (res) {
                        var c = [];
                        if (res.successFlg) {
                            _.each(res.obj, function (obj) {
                                c.push({
                                    field: obj.key,
                                    title: obj.name,
                                    align: 'center'
                                });
                            });
                            me.setVueData(res.obj);
                            me.initTable(me.searchQuotaData(), params, c, {pagination: false});
                        }
                    });
                },
                initTable: function (url, params, columns, opt) {//初始化表格参数
                    console.log(url)
                    var option = {
                        url: url,//请求后台的URL（*）
                        queryParams: params,
                        queryParamsType: '',
                        columns: columns,
                        height: this.tcHei,
                        width:'100%',
                        striped: true,//是否显示行间隔色
                        pageSize: 15,//每页的记录行数（*）
                        strictSearch: true,
                        pageList: [15, 25, 50, 100],//可供选择的每页的行数（*）
                        pageNumber: 1,//初始化加载第一页，默认第一页
                        sidePagination: 'server',//分页方式：client客户端分页，server服务端分页（*）
                        pagination: true,//是否显示分页（*）
                        sortable: false,//是否启用排序
                        showColumns: false,//是否显示所有的列
                        iconSize: "outline",
                        responseHandler:  function (res) {
                            if (res.successFlg) {
                                return {
                                    total:res.totalCount,//totalCount
                                    rows: res.detailModelList
                                }
                            } else {
                                return []
                            }
                        },
                        onLoadSuccess: function () {
                            layer.close(loading);
                        }
                    };
                    opt && $.extend(option, opt);
                    this.$aqTable.bootstrapTable(option);
                },

                addView: function () {//生成视图
                    return '${contextRoot}/resourceIntegrated/addView'
                },

                outExcel: function () {//综合查询档案数据导出
                    return '${contextRoot}/resourceIntegrated/outFileExcel';
                },

                outQuotaExcel: function () {//综合查询指标数据导出
                    return '${contextRoot}/resourceIntegrated/outQuotaExcel';
                },

                bindEvent: function () {
                    var  me = this;
                    me.$selBtn.on('click', function () {
                        // $('#selSetBody').slideUp();
                        if (me.$selCon.css('display') == 'none') {
                            $(this).addClass('active');
                            me.$selCon.slideDown();
                        } else {
                            $(this).removeClass('active');
                            me.$selCon.slideUp();
                        }
                    });

                    me.$saveBtn.on('click', function () {//生成视图
                        layer.open({
                            title: '生成视图',
                            type: 2,
                            full: false,
                            area: ['420px', '390px'],
                            fixed: false, //不固定
                            maxmin: true,
                            content: me.addView(),
                            success: function (layero) {
                                $(layero.find('.layui-layer-max')).hide();
                                $(layero.find('.layui-layer-min')).hide();
                                var queryCondition = '',
                                    metadatas = [],
                                    quotas = '';
                                if (type == 0) {
                                    queryCondition = me.getResSeachVal(me.getFormData());
                                    _.each(paramThree, function (obj) {
                                        metadatas.push({
                                            resourcesId: '',
                                            metadataId: obj.code,
                                            groupType: obj.groupType,
                                            groupData: obj.groupData,
                                            description: obj.description
                                        });
                                    });
                                    metadatas = metadatas;
                                } else {
                                    queryCondition = me.getQuotaSearchVal(me.getFormData());
                                    quotas = paramThree;
                                }
                                parent.GlobalEventBus.$emit("postAddViewParam", {queryCondition: queryCondition, metadatas: metadatas, type: type, quotas: quotas});
                            }
                        });
                    });
                    me.$outExc.on('click', function () {
                        var formVals = me.getFormData(), searchParams = null, p = me.$aqTable.bootstrapTable('getOptions');
                        if (type == 0) {
                            searchParams = me.getResSeachVal(formVals);
                            var spArr = me.getResParams(JSON.stringify(searchParams)),
                                metaData = [];
                            _.each(paramThree, function (obj) {
                                metaData.push({
                                    name: obj.name,
                                    code: obj.code
                                });
                            });
                            window.open(me.outExcel() +
                                "?size=" + p.pageSize +
                                "&resourcesCode=" + spArr.resourcesCode +
                                "&searchParams=" + spArr.searchParams +
                                "&metaData=" + JSON.stringify(metaData) +
                                '&page=' + p.pageNumber, "档案数据导出");
                        } else {
                            searchParams = me.getQuotaSearchVal(formVals);
                            window.open(me.outQuotaExcel() +
                                "?tjQuotaIds=" + JSON.parse(paramOne).join(',') +
                                "&tjQuotaCodes=" + JSON.parse(paramTwo).join(',') +
                                "&searchParams=" + JSON.stringify(searchParams) +
                                '&size=' + p.totalRows +
                                '&page=' + p.pageNumber);
                        }
                    });
                    $('#resetForm').on('click', function () {
                        me.QAVue.timeClass = 'checked';
                        me.QAVue.textClass = 'checked';
                        _.each(me.QAVue.timeChkBox, function (obj) {
                            obj.checked = 'checked'
                        });
                        _.each(me.QAVue.textChkBox, function (obj) {
                            obj.checked = 'checked'
                        });
                    });
                },
                getCheckStatus: function ($dom) {
                    if ($dom.hasClass('checked')) {
                        $dom.removeClass('checked');
                        return false;
                    } else {
                        $dom.addClass('checked');
                        return true;
                    }
                },
                getFormData: function () {
                    var formVals = {};
                    $.map($('[name=aqform]').serializeArray(), function(item, index){
                        formVals[item.name] = item.value;
                    });
                    return formVals;
                },
                getResParams: function (searchParams, size, page) {//档案数据参数
                    var me= this,
                        metaData = JSON.stringify(me.childParam);
                    return {
                        resourcesCode: paramTwo,
                        metaData: metaData,
                        searchParams: searchParams,
                        page: page,
                        rows: size
                    }
                },
                loadLayui: function () {
                    var me = this;
                    var form = layui.form,
                        laydate = layui.laydate;
                    _.each($('input[data-type=date]'), function (obj) {
                        var id = $(obj).attr('id');
                        laydate.render({
                            elem: '#' + id, //指定元素
                            type: 'date'
                        });
                    });
                    form.render();
                    form.on('submit(formDemo)', function(data){
                        var field = data.field,
                            searchParams = null,
                            p = me.$aqTable.bootstrapTable('getOptions');


                        _.each(me.QAVue.timeChkBox, function (obj) {
                            var code = type == 0 ? obj.code : obj.key;
                            if (obj.checked == '') {
                                me.$aqTable.bootstrapTable('hideColumn', obj.code);
                            } else {
                                me.$aqTable.bootstrapTable('showColumn', obj.code);
                            }
                        });
                        _.each(me.QAVue.textChkBox, function (obj) {
                            var code = type == 0 ? obj.code : obj.key;
                            if (obj.checked == '') {
                                me.$aqTable.bootstrapTable('hideColumn', code);
                            } else {
                                me.$aqTable.bootstrapTable('showColumn', code);
                            }
                        });

                        if (type == 0) {
                            searchParams = me.getResSeachVal(field);
                            p.queryParams = function (params) {
                                return me.getResParams(JSON.stringify(searchParams), params.pageSize, params.pageNumber);
                            }
                        } else {
                            var po = (JSON.parse(paramOne)).join(','),
                                pt = (JSON.parse(paramTwo)).join(',');
                            searchParams = me.getQuotaSearchVal(field);
                            p.queryParams = function (params) {
                                return {
                                    tjQuotaIds: po,
                                    tjQuotaCodes: pt,
                                    searchParams: JSON.stringify(searchParams),
                                }
                            }
                        }
                        me.$aqTable.bootstrapTable('refresh', p);
                        me.$selBtn.removeClass('active');
                        me.$selCon.slideUp();
                    });
                },
                getQuotaSearchVal: function (field) {//格式化筛选条件 - 指标统计
                    var p = {};
                    _.map(field, function (v, k) {
                        if (v != '') {
                            p[k] = v;
                        }
                    });
                    return p;
                },
                getResSeachVal: function (field) {//格式化筛选条件 - 档案数据
                    var searchParams = [];
                    _.map(field, function (v, key) {
                        var values = {andOr: 'Or', condition: v, field: '', value: ''},
                            k = key.split('-')[1];
                        if(key.indexOf('sel-') >= 0) {
                            var val = field[k];
                            if (val != '') {
                                var valArr = val.split(',');
                                _.each(valArr, function (o) {
                                    values.field = k;
                                    values.value = o;
                                    searchParams.push(values)
                                });
                            }
                        } else if (key.indexOf('sel1-') >= 0) {
                            var date = field['start-' + k];
                            if (date != '') {
                                values.field = k;
                                values.value = date + 'T00:00:00Z';
                                searchParams.push(values);
                            }
                        } else if (key.indexOf('sel2-') >= 0) {
                            var date = field['end-' + k];
                            if (date != '') {
                                values.field = k;
                                values.value = date + 'T23:59:59Z';
                                searchParams.push(values);
                            }
                        }
                    });
                    return searchParams;
                }
            };
        })

    })(jQuery,window)

</script>
