<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2018/1/9
  Time: 9:17
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/vue.min.js"></script>
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
            window.GlobalEventBus = new Vue();
            //默认表头
            var columns = function (tStr) {
                return [
                    {
                        title: '序号',
                        formatter: function (value, row, index) {
                            return index+1;
                        },
                        align: 'center'
                    },
                    {
                        field: 'name',
                        title: '名称',
                        align: 'center'
                    }, {
                        field: 'type',
                        title: '数据来源',
                        align: 'center',
                        formatter: function (v, r, i) {
                            return tStr;
                        }
                    }, {
                        field: 'dictName',
                        title: '关联字典',
                        align: 'center'
                    }, {
                        field: 'price',
                        title: '操作',
                        formatter: function (v, r, i) {
                            return '<a href="#" title="删除" class="del-btn" data-code="'+ r.code +'"></a>'
                        },
                        align: 'center'
                    }
                ];
            };
            function httpGet(url,options) {
                //发送ajax请求
                return new Promise(function(resolve, reject) {
                    $.ajax($.extend({},{
                            url: url,
                            type: 'GET',
                            dataType: 'JSON',
                            beforeSend: function(request) {
                            },
                            error: function(res) {
                                reject(res);
                            },
                            success: function(res) {
                                resolve(res);
                            }
                        },options));
                }).catch(function () {

                })
            }
            var num = 0;
            var IQ = {
                $selBtn: $('#selBtn'),
                $checkItem: $('.check-item'),
                $iqMain: $('.iq-main'),
                $iqTypeItem: $('.iq-type-item'),
                $iqTree: $('.iq-tree'),
                $iqCharList: $('.iq-char-list'),
                $iconLoad: $('.icon-load'),
                $loadCon: $('.load-con'),
                IQVue: null,
                type: 0,//0:档案数据；1：指标统计,
                isLoadQuota: false,//是否加载指标树
                isLoadSearchOk: false,//是否加载已查询数据
                resourceTree: null,//档案树
                quotaTree: null,//指标树
                $iqTable: $('.iq-table'),
                $resourceTable: $('#resourceTable'),//档案表格
                $quotaTable: $('#quotaTable'),//指标表格
                $searchBtn: $('#searchBtn'),
                $searchVal: $('#searchVal'),
                $iqTableCon: $('.iq-table-con'),
                tcHei: $('.iq-table-con').height(),
                normalAttr: [],
                pageSize: 15,
                pageNumber: 1,
                isMore: false,
                init: function () {
                    this.IQVue = this.initVue();
                    this.loadResourceTreeData('');
                    this.loadResourceTable();
                    this.loadQuotaTable();
                    $('.bootstrap-table').eq(1).hide();
                    this.$iqTable.eq(1).hide();
                    this.bindEvent();
                },
                //删除
                delete: function (opt) {//删除资源
                    return httpGet( '${contextRoot}/resourceIntegrated/delete', opt)
                },
                initVue: function () {
                    var me = this;
                    return new Vue({
                        el: '#iqApp',
                        data: {
                            qrList: [],
                            isShow: true,
                            message: '加载中...'
                        },
                        methods: {
                            load: function () {
                                if (me.isMore) {
                                    me.loadQueryAlready(me.pageNumber)
                                }
                            },
                            goInfo: function (id, code, dataSource, name) {
                                parent._SHOWTAB({name: name, url: '${contextRoot}/resourceIntegrated/goShowViewPage', cb: function ($dom) {
                                    $dom[0].onload = function(e){
                                        window.GlobalEventBus.$emit("getShowViewParam", {code: code, type: dataSource, id: id})
                                    };
                                }});
                            },
                            del: function (id) {
                                event.stopPropagation();
                                layer.confirm('确定要删除该视图吗？', {
                                    btn: ['确定','取消'] //按钮
                                }, function(){
                                    me.delete({
                                        data: {
                                            id: id
                                        }
                                    }).then(function (res) {
                                        if (res.successFlg) {
                                            $('[data-id='+ id +']').remove();
                                            layer.msg('删除成功', {icon: 1});
                                        } else {
                                            layer.msg('删除失败', {icon: 2});
                                        }
                                    });
                                });
                            }
                        }
                    });
                },
                getMetadataList: function (opt) {//综合查询档案数据列表树
                    return httpGet('${contextRoot}/resourceIntegrated/getMetadataList', opt)
                },
                loadResourceTreeData: function (f) {
                    var me = this;
                    me.getMetadataList({
                        data: {
                            filters: f
                        }
                    }).then(function (res) {
                        if (res.successFlg) {
                            if (res.detailModelList) {
                                me.initTree(res.detailModelList);
                            } else {
                                layer.alert('数据出错！', {
                                    icon: 2,
                                    skin: 'layer-ext-moon'
                                });
                            }
                        } else {
                                layer.alert(res.errorMsg, {
                                    icon: 2,
                                    skin: 'layer-ext-moon'
                                });
                        }
                    })
                },
                setTreeOpt: function (c) {//树的配置
                    var me = this;
                    return {
                        data: {
                            key: {
                                name: 'name',
                                children: c
                            },
                            simpleData: {
                                pIdKey: 'level',
                                idKey: 'code'
                            }
                        },
                        check: {
                            enable: true,
                            chkStyle: "checkbox"
                        },
                        view: {
                            showIcon: true,
                            selectedMulti: true
                        },
                        callback: {
                            onCheck: function (e, str, selNode) {
                                var $table = null,
                                    md = null;
                                if (me.type == 0) {
                                    md = selNode.metaDataList;
                                    $table = me.$resourceTable;
                                } else {
                                    md = selNode.child;
                                    $table = me.$quotaTable;
                                }
                                if (md) {
                                    if (selNode.checked) {
                                        if (me.type == 0) {
                                            _.each(md, function (obj, k) {
                                                $table.bootstrapTable('insertRow', {index:6, row: obj});
                                            });
                                        } else {
                                            var codes = me.getChildData(md);
                                            _.each(codes, function (obj, k) {
                                                $table.bootstrapTable('insertRow', {index:6, row: obj});
                                            });
                                        }
                                    } else {
                                        var codes = [];
                                        if (me.type == 0) {
                                            _.each(md, function (obj, k) {
                                                codes.push(obj.code);
                                            });
                                        } else {
                                            _.each(md, function (obj) {
                                                if (obj.detailList) {
                                                    _.each(obj.child, function (ob) {
                                                        if (ob.checked == false) {
                                                            codes.push(ob.code);
                                                        }
                                                    });
                                                } else {
                                                    codes.push(obj.code);
                                                }
                                            });
                                        }
                                        $table.bootstrapTable('remove', {field: 'code', values: codes});
                                    }
                                } else {
                                    if (selNode.checked) {
                                        $table.bootstrapTable('insertRow', {index:6, row: selNode});
                                    } else {
                                        $table.bootstrapTable('remove', {field: 'code', values: [selNode.code]});
                                    }
                                }
                            }
                        }
                    }
                },
                getChildData: function (md) {
                    var codes = [];
                    _.each(md, function (obj) {
                        if (obj.detailList) {
                            _.each(obj.child, function (ob) {
                                if (ob.checked) {
                                    codes.push(ob);
                                }
                            });
                        } else {
                            codes.push(obj);
                        }
                    });
                    return codes;
                },
                initTree: function (data) {//初始化树（档案）
                    var me = this,
                        treeData = [];
                    _.each(data, function (obj, k) {
                        if (k == 0 && me.type == 0) {
                            me.normalAttr = obj.baseInfo;
                        } else {
                            if (me.type == 0) {
                                treeData.push(obj);
                            } else {
                                var dl = obj.child;
                                _.each(dl, function (ob) {
                                    if (ob.detailList) {
                                        ob.child = ob.detailList;
                                    }
                                })
                                treeData.push(obj);
                            }
                        }
                    });
                    $.fn.zTree.init(me.$iqTree.eq(me.type), me.setTreeOpt(me.type == 0 ? 'metaDataList' : 'child'), treeData);
                },
                loadResourceTable: function () {//档案数据元
                    var me = this;
                    me.$resourceTable.bootstrapTable({
                        height: me.tcHei,
                        columns: columns('档案数据'),
                        striped: true,
                        data: []
                    });
                },
                loadQuotaTable: function () {//指标统计
                    var me = this;
                    me.$quotaTable.bootstrapTable({
                        height: me.tcHei,
                        columns: columns('指标统计'),
                        striped: true,
                        data: []
                    });
                },
                getQuotaList:function (opt) {
                    return httpGet('${contextRoot}/resourceIntegrated/getQuotaList', opt)
                },
                loadQuotaTreeData: function (f) {//加载指标统计(树)
                    var me = this;
                    me.getQuotaList({
                        data: {
                            filters: f
                        }
                    }).then(function (res) {
                        if (res.successFlg) {
                            if (res.detailModelList) {
                                me.initTree(res.detailModelList);
                            } else {
                                layer.alert('数据出错！', {
                                    icon: 2,
                                    skin: 'layer-ext-moon'
                                });
                            }
                        } else {
                            layer.alert(res.errorMsg, {
                                icon: 2,
                                skin: 'layer-ext-moon'
                            })
                        }
                    })
                },
                //已查询
                getResourceList: function (opt, type) {//获取视图列表（不区分数据源）
                    return httpGet('${contextRoot}/resourceIntegrated/getResourceList', opt, type)
                },
                loadQueryAlready: function (page) {//已查询
                    var me = this;
                    me.getResourceList({
                        data: {
                            page: page,
                            size: me.pageSize
                        }
                    }, 'none').then(function (res) {
                        me.pageNumber++;
                        if (res.successFlg) {
                            if (res.detailModelList) {
                                var tc = res.totalCount,
                                    count = Math.ceil(tc/me.pageSize);
                                if (res.detailModelList.length > 0) {
                                    me.isMore = true;
                                    me.IQVue.isShow = false;
                                    me.IQVue.message = '点击加载更多';
                                    me.IQVue.qrList = _.union(me.IQVue.qrList, res.detailModelList);
                                } else {
                                    me.isMore = false;
                                    me.IQVue.isShow = false;
                                    me.IQVue.message = '暂无数据';
                                }
                                if (me.pageNumber > count) {
                                    me.isMore = false;
                                    me.IQVue.isShow = false;
                                    me.IQVue.message = '暂无更多数据';
                                }
                            } else {
                                me.isMore = false;
                                if (me.pageNumber == 1) {
                                    me.IQVue.isShow = false;
                                    me.IQVue.message = '暂无数据';
                                }
                            }
                        } else {
                            me.IQVue.isShow = false;
                            me.IQVue.message = '暂无数据';
                            layer.alert(res.errorMsg, {icon: 2});
                        }
                    });
                },
                bindEvent: function () {
                    var me = this;
                    //新查询&已存查询 切换
                    me.$checkItem.on('click', function () {
                        me.tabSH($(this), me.$iqMain);
                        if (!me.isLoadSearchOk) {
                            me.isLoadSearchOk = true;
                            me.loadQueryAlready(me.pageNumber);
                        }
                    });
                    //树切换
                    me.$iqTypeItem.on('click', function () {
                        var index = $(this).index();
                        me.type = index;
                        $('.bootstrap-table').hide().eq(index).show();
                        me.$iqTable.hide().eq(index).show();
                        me.tabSH($(this), me.$iqTree);
                        if (index == 1 && !me.isLoadQuota) {
                            me.isLoadQuota = true;
                            me.loadQuotaTreeData('');
                        }
                    });
                    //搜索-树
                    me.$searchBtn.on('click', function () {
                        var zTree = $.fn.zTree.getZTreeObj(me.type == 0 ? "resourceTree" : "quotaTree"),
                            val = me.$searchVal.val();
                        zTree.destroy();
                        if (me.type == 0) {
                            me.loadResourceTreeData(val);
                        } else {
                            me.loadQuotaTreeData(val);
                        }
                    });
                    //删除表格数据
                    me.$iqTableCon.on('click', '.del-btn', function (e) {
                        e.stopPropagation();
                        var code = $(this).attr('data-code'),
                            zTree = $.fn.zTree.getZTreeObj(me.type == 0 ? "resourceTree" : "quotaTree"),
                            selN = zTree.getCheckedNodes(),
                            thisN = null,
                            $table = null;
                        _.each(selN, function (obj, k) {
                            if (obj.code == code) {
                                zTree.checkNode(obj, false, true);
                            }
                        });
                        if (me.type == 0) {
                            $table = me.$resourceTable;
                        } else {
                            $table = me.$quotaTable;
                        }
                        $table.bootstrapTable('remove', {field: 'code', values: [code]});
                    });
                    //新建查询
                    me.$selBtn.on('click', function () {
                        var param = me.type ==0 ? (function () {
                                var arr = [];
                                _.each(me.normalAttr, function (obj) {
                                    arr.push(obj);
                                });
                                return arr;
                            })() : [],
                            zTree = $.fn.zTree.getZTreeObj(me.type == 0 ? "resourceTree" : "quotaTree"),
                            selN = zTree.getCheckedNodes(),
                            paramOne = '',
                            paramTwo = [],
                            paramThree = [];
                        if (me.type == 0) {
                            _.each(selN, function (obj, k) {
                                if (!obj.isParent) {
                                    param.push({
                                        dictCode: obj.dictCode,
                                        name: obj.name,
                                        code: obj.code
                                    });
                                    paramThree.push(obj)
                                } else {
                                    paramTwo.push(obj.code);
                                }
                            });
                            paramOne = param;
                        } else {
                            paramOne = [];
                            _.each(selN, function (obj, k) {
                                if (!obj.isParent) {
                                    paramOne.push(obj.id);
                                    paramTwo.push(obj.code);
                                } else {
                                    if (obj.detailList) {//指标生成视图是需要的参数
                                        var name = obj.name;
                                        _.each(obj.child, function (ob) {
                                            if (ob.checked) {
                                                paramThree.push({
                                                    resourceId: '',
                                                    quotaTypeName: name,
                                                    quotaChart: 1,
                                                    quotaId: ob.id
                                                });
                                            }
                                        })
                                    }
                                }
                            });
                        }
                        if ((me.type == 1 && paramOne.length <= 0) || paramTwo.length <= 0) {
                            layer.alert('请选择数据元!', {
                                icon: 3,
                                skin: 'layer-ext-moon'
                            });
                            return;
                        }
                        num++;
                        parent._SHOWTAB({name: '新建查询'+num, url: '${contextRoot}/resourceIntegrated/goAddQueryPage', cb: function ($dom) {
                            $dom[0].onload = function(e){
                                window.GlobalEventBus.$emit("getAddQueryParam", {paramOne: JSON.stringify(paramOne), paramTwo: JSON.stringify(paramTwo), type: me.type, paramThree: paramThree})
                            };
                        }});
                    });
                },
                tabSH: function ($dom1, $dom2) {
                    var index = $dom1.index();
                    $dom1.addClass('active').siblings().removeClass('active');
                    $dom2.hide().eq(index).show();
                }
            };
            IQ.init();
        })
    })(jQuery,window)

</script>
