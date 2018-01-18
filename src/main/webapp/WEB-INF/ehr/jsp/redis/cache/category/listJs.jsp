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
            url: '${contextRoot}/redis/cache/category/search',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '缓存分类名称', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                {display: '缓存分类编码', name: 'code', width: '20%', isAllowHide: false, align: 'left'},
                {display: '修改时间', name: 'modifyDate', width: '15%', isAllowHide: false, align: 'left'},
                {display: '备注', name: 'remark', width: '30%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', width: '15%', minWidth: 120, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/redis/cache/category/authorizationList"><a class="label_a f-ml10" title="应用授权" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:cache:category:authorizationList", row.code) + '">微服务授权</a></sec:authorize>';
                        html += '<sec:authorize url="/redis/cache/category/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "redis:cache:category:detail", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/redis/cache/category/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "redis:cache:category:delete", row.id) + '"></a></sec:authorize>';
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

    //添加碎片
    function appendNav(str, url, data) {
        $('#navLink').append('<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
        $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
        $("#contentPage").css({
            'height': 'calc(100% - 40px)'
        }).empty().load(url,data);
    }
    function bindEvents() {
        // 应用授权
        $.subscribe('redis:cache:category:authorizationList', function (event, categoryCode) {
            var url = '${contextRoot}/redis/cache/authorization/index?';
            appendNav('应用授权', url, {categoryCode: categoryCode});
//            $("#contentPage").empty();
//            $("#contentPage").load(url,{categoryCode: categoryCode});
        });

        // 新增/修改
        $.subscribe('redis:cache:category:detail', function (event, id, mode) {
            var title = '新增缓存分类';
            if (mode == 'modify') {
                title = '修改缓存分类';
            }
            detailDialog = parent._LIGERDIALOG .open({
                height: 410,
                width: 480,
                title: title,
                url: '${contextRoot}/redis/cache/category/detail',
                urlParms: {
                    id: id,
                    mode: mode
                },
                opener: true,
                load: true
            });
        });

        $(document).on('click', '.go-back', function () {
            window.location.reload();
        });
        // 删除
        $.subscribe('redis:cache:category:delete', function (event, id) {
            parent._LIGERDIALOG .confirm('确认要删除所选数据吗？', function (r) {
                if (r) {
                    var loading = parent._LIGERDIALOG .waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/redis/cache/category/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                parent._LIGERDIALOG .success('删除成功！');
                                reloadGrid();
                            } else {
                                parent._LIGERDIALOG .error(data.errorMsg);
                            }
                        },
                        error: function () {
                            parent._LIGERDIALOG .error('删除发生异常');
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
        $.Util.reloadGrid.call(grid, '${contextRoot}/redis/cache/category/search', params);
    }

    /*-- 与明细 Dialog 页面间回调的函数 --*/
    window.parent.reloadMasterGrid = window.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.parent.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && parent._LIGERDIALOG .success(msg);
    };

</script>
