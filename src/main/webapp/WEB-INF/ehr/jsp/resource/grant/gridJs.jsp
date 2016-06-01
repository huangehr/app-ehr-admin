<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>

    (function ($, win) {
        $(function () {

            var openedDialog, curOprator;
            var selectRowObj, isSaveSelectStatus = false;
            var resourceId = '${dataModel}';
            
            var master = {
                tree: undefined,
                dialog: undefined,
                urls: {
                    gotoAppGrant: '${contextRoot}/resource/grant/gotoAppGrant',
                    tree: '${contextRoot}/resource/grant/tree'
                },
                //初始化
                init: function(){
                    var m = this;
                    $('#btn_goto_grant').click(m.gotoGrant);
                    m.rendFilters();
                    m.rendTree();
                },
                //初始化过滤
                rendFilters : function(){
                    var vo = [
                        {type: 'text', id: 'ipt_search', searchFun: master.searchFun}
                    ];
                    initFormFields(vo, $('#retrieve_inner'));
                },
                searchFun: function(){
                    var p = $('#ipt_search').val();
                    master.tree.s_search(p);
                },
                //初始化表格
                rendTree : function(){

                    var m = master;
                    m.tree = initTree($("#treeMenu"),
                            {
                                url:  m.urls.tree + "?resourceId="+resourceId,
                                delay: true,
                                needCancel: false,
                                btnClickToToggleOnly: false,
                                selectable: function (data) {
                                    return this.isLeaf(data);
                                },
                                isLeaf : function(data) {
                                    return !data.children || data.children.length==0;
                                },
                                onSelect: function (e) {
                                    em.find(e.data.id, e.data.otherPro.appResourceId);
                                }
                            });
                    $("#treeMenuWrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
                },
                //查询列表方法
                find : function () {
                    var m = master;
                    m.tree.reload();
                },
                gotoGrant: function () {
                    curOprator = master;
                    this.dialog = openedDialog = openDialog(master.urls.gotoAppGrant, "应用授权", 500, 660, {resourceId: resourceId}, {});
                }
            }

            var em = {
                grid: undefined,
                dialog: undefined,
                params: {},
                urls: {
                    list: '${contextRoot}/resource/grant/list',
                    gotoModify: '${contextRoot}/resource/grant/gotoModify',
                    lock: '${contextRoot}/resource/grant/lock'
                },
                //初始化
                init: function(){
                    var m = this;
                    m.rendBarTools();
                    m.rendGrid();
                    m.publishFunc();
                },
                //初始化工具栏
                rendBarTools : function(){
                    function lock(type, isLock){
                        var m = em, g = em.grid;
                        var ids = [];
                        if(type==1){
                            var rows = g.getSelectedRows();
                            if(rows.length==0){
                                $.Notice.warn("请选择数据！");
                                return;
                            }
                            $.each(rows, function (i, v) {
                                ids.push(v.id);
                            })
                        }else{
                            if(g.getData().length==0){
                                $.Notice.warn("没有数据！");
                                return;
                            }
                        }

                        var dialog = $.ligerDialog.waitting('正在处理中,请稍候...');
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote(m.urls.lock, {
                            data: {ids: ids.join(","), valid: isLock, type: type},
                            success: function (data) {
                                if (data.successFlg) {
                                    $.Notice.success('操作成功！');
                                    m.find();
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            },
                            complete: function () {
                                dialog.close();
                            },
                            error: function(){
                                $.Notice.error('请求错误！');
                            }
                        });
                    }
                    var btn = [
                        {type: '选中允许', id: 'allowChecked', clkFun: function(){
                            lock(1, 1);
                        }},
                        {type: '选中禁止', id: 'forbidChecked', clkFun: function () {
                            lock(1, 0);
                        }},
                        {type: '全部允许', id: 'allowAll', clkFun: function () {
                            lock(2, 1);
                        }},
                        {type: '全部禁止', id: 'forbidAll', clkFun: function () {
                            lock(2, 0);
                        }}
                    ];
                    initBarBtn($('#entry_retrieve_inner'), btn)
                },
                //初始化表格
                rendGrid : function(){
                    var m = em;
                    var columns = [
                        {display: 'ID', name: 'id', hide: true},
//                        {display: '序号', name: 'sort', width: '10%', align: 'left'},
                        {display: '字段名称', name: 'resourceMetadataName', width: '30%', align: 'left'},
                        {display: '维度授权', name: 'dimensionValue', width: '50%', align: 'left'},
                        {display: '是否有效', name: 'valid', width: '10%', align: 'left', render: function (row) {
                            return row.valid==1? '是': '否';
                        }},
                        {display: '操作', name: 'operator', width: '10%', render: m.opratorRender}];

                    m.grid = initGrid($('#rightGrid'), m.urls.list, {}, columns, {delayLoad: true, rownumbers: true, usePager: false});
                },
                //操作栏渲染器
                opratorRender: function (row){
                    var vo = [
                        {type: 'edit', clkFun: "$.publish('grant:meta:modify',['"+ row['id'] +"', 'modify'])"}
                    ];
                    return initGridOperator(vo);
                },
                //修改、新增点击事件
                gotoModify : function (event, id, mode) {
                    id = id || '';
                    curOprator = em;
                    var params = {id: id, mode: mode};
                    em.dialog = openedDialog = openDialog(em.urls.gotoModify, '维度授权', 500, 250, params);
                },
                //查询列表方法
                find : function (appId, appResourceId) {
                    var params = !appId? em.params: (em.params = {filters: "appId="+ appId +";appResourceId="+ appResourceId, page:1, rows: 999});
                    reloadGrid(this.grid, 1, params);
                },
                //公开方法
                publishFunc : function (){
                    var m = em;
                    $.subscribe('grant:meta:modify', m.gotoModify);
                }
            }

            var resizeContent = function(){
                var contentW = $('#grid_content').width();
                var leftW = $('#div_left').width();
                $('#div_right').width(contentW-leftW-20);

                var contentH = $('.l-layout-center').height();
                $('#treeMenuWrap').height(contentH - 189);
            }();

            //窗体改变大小事件
            $(window).bind('resize', function() {
                resizeContent();
            });

            em.init();
            master.init();

            win.closeDialog = function (msg) {
                openedDialog.close();
                if(msg){
                    $.Notice.success(msg);
                    curOprator.find();
                }
            }

            win.getTreeData = function () {

                return cloneData(master.tree.getData()) || [];
            }

            function cloneData(data){
                if(!data || data.length==0)
                    return undefined;
                var newData = [];
                $.each(data, function (i, v) {
                    newData.push({id: v.id, name: v.name, children: cloneData(v.children)})
                })
                return newData;
            }
        });
    })(jQuery, window);

</script>