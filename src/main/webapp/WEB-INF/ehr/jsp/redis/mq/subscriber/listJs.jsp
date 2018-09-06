<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var dataModel = $.DataModel.init();
    var channel = '${channel}';
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
            url: '${contextRoot}/redis/mq/subscriber/search',
            urlParms: { channel: channel },
            columns: [
                {display: 'ID', name: 'id', hide: true,width: '0'},
//                {display: '应用ID', name: 'appId', width: '10%', isAllowHide: false, align: 'left'},
                {display: '订阅者服务地址', name: 'subscribedUrl', width: '30%', isAllowHide: false, align: 'left'},
                {display: '创建日期', name: 'createDate', width: '15%', isAllowHide: false, align: 'left'},
                {display: '备注', name: 'remark', width: '30%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', width: '25%', align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/redis/mq/subscriber/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "redis:mq:subscriber:detail", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/redis/mq/subscriber/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:mq:subscriber:delete", row.id) + '"></a></sec:authorize>';
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
        // 新增/修改
        $.subscribe('redis:mq:subscriber:detail', function (event, id, mode) {
            var title = '新增消息订阅者';
            if (mode == 'modify') {
                title = '修改消息订阅者';
            }
            detailDialog = parent._LIGERDIALOG.open({
                height: 450,
                width: 480,
                title: title,
                url: '${contextRoot}/redis/mq/subscriber/detail',
                urlParms: {
                    id: id,
                    channel: channel
                },
                opener: true,
                load: true
            });
        });

        // 删除
        $.subscribe('redis:mq:subscriber:delete', function (event, id) {
            parent._LIGERDIALOG.confirm('删除后该订阅者服务地址将不会接收到发布的消息，确认要删除吗？', function (r) {
                if (r) {
                    var loading = parent._LIGERDIALOG.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/redis/mq/subscriber/delete', {
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

        // 返回上一页
        $('#btn_back').click(function(){
            $('#contentPage').empty();
            $('#contentPage').load('${contextRoot}/redis/mq/channel/index');
        });

    }

    function reloadGrid() {
        var params = {
            searchContent: $('#searchContent').val(),
            channel: channel
        };
        $.Util.reloadGrid.call(grid, '${contextRoot}/redis/mq/subscriber/search', params);
    }

    /*-- 与明细 Dialog 页面间回调的函数 --*/
    window.parent.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.parent.closeDetailDialog = function (msg) {
        detailDialog.close();
        msg && parent._LIGERDIALOG.success(msg);
    };

</script>
