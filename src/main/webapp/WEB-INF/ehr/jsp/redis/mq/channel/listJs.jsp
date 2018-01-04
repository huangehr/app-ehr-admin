<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var detailDialog = null;
    var grid = null;

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
    }

    function initWidget() {
        $('#searchContent').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid();
            }
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/redis/mq/channel/search',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '消息队列编码', name: 'channel', width: '20%', isAllowHide: false, align: 'left'},
                {display: '消息队列名称', name: 'channelName', width: '20%', isAllowHide: false, align: 'left'},
                {display: '入列数', name: 'enqueuedNum', width: '5%', isAllowHide: false, align: 'center'},
                {display: '出列数', name: 'dequeuedNum', width: '5%', isAllowHide: false, align: 'center'},
                {display: '订阅者数', name: 'subscriberNum', width: '5%', isAllowHide: false, align: 'center'},
                {display: '发布者数', name: 'publisherNum', width: '5%', isAllowHide: false, align: 'center'},
                {display: '备注', name: 'remark', width: '25%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', width: '15%', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/redis/mq/channel/publisherList"><a class="label_a f-ml10" title="发布者" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:mq:channel:publisherList", row.channel) + '">发布者</a></sec:authorize>';
                        html += '<sec:authorize url="/redis/mq/channel/subscriberList"><a class="label_a f-ml10" title="订阅者" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:mq:channel:subscriberList", row.channel) + '">订阅者</a></sec:authorize>';
                        html += '<sec:authorize url="/redis/mq/channel/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "redis:mq:channel:detail", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/redis/mq/channel/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:mq:channel:delete", row.id) + '"></a></sec:authorize>';
                        return html;
                    }
                }
            ],
            allowHideColumn: false,
            usePager: true
        }));
        grid.collapseAll();
        grid.adjustToWidth();
    }

    function bindEvents() {
        // 发布者
        $.subscribe('redis:mq:channel:publisherList', function (event, channel) {
            var url = '${contextRoot}/redis/mq/publisher/index?';
            $("#contentPage").empty();
            $("#contentPage").load(url,{channel: channel});
        });

        // 订阅者
        $.subscribe('redis:mq:channel:subscriberList', function (event, channel) {
            var url = '${contextRoot}/redis/mq/subscriber/index?';
            $("#contentPage").empty();
            $("#contentPage").load(url,{channel: channel});
        });

        // 新增/修改
        $.subscribe('redis:mq:channel:detail', function (event, id, mode) {
            var title = '新增消息队列';
            if (mode == 'modify') {
                title = '修改消息队列';
            }
            detailDialog = parent._LIGERDIALOG.open({
                height: 560,
                width: 480,
                title: title,
                url: '${contextRoot}/redis/mq/channel/detail',
                urlParms: {
                    id: id,
                    mode: mode
                },
                opener: true,
                load: true
            });
        });

        // 删除
        $.subscribe('redis:mq:channel:delete', function (event, id) {
            parent._LIGERDIALOG.confirm('确认要删除所选数据吗？', function (r) {
                if (r) {
                    var loading = parent._LIGERDIALOG.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/redis/mq/channel/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                parent._LIGERDIALOG.success('删除成功！');
                                reloadGrid();
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            parent._LIGERDIALOG.error('删除发生异常');
                        },
                        complete: function () {
                            loading.close();
                        }
                    });
                }
            })
        });
    }

    function reloadGrid() {
        var params = {searchContent: $('#searchContent').val()};
        $.Util.reloadGrid.call(grid, '${contextRoot}/redis/mq/channel/search', params);
    }

    /*-- 与明细 Dialog 页面间回调的函数 --*/
    window.parent.reloadMasterGrid = window.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.parent.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && parent._LIGERDIALOG.success(msg);
    };

</script>
