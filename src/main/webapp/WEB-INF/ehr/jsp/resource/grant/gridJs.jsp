<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var selectRowObj, isSaveSelectStatus = false;

            var master = {
                tree: undefined,
                urls: {
                    list: '${contextRoot}/resource/dict/list_test',
                    del: '${contextRoot}/resource/dict/del_test',
                    gotoModify: '${contextRoot}/resource/dict/gotoModify',
                    gotoAppGrant: '${contextRoot}/resource/grant/gotoAppGrant'
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
                //初始化表格
                rendTree : function(){
                    var m = master;

                    var data = [];

                    data.push({ id: 1, pid: 0, text: '1' });
                    data.push({ id: 2, pid: 1, text: '1.1' });
                    data.push({ id: 4, pid: 2, text: '1.1.2' });
                    data.push({ id: 5, pid: 2, text: '1.1.2' });

                    data.push({ id: 10, pid: 8, text: 'wefwfwfe' });
                    data.push({ id: 11, pid: 8, text: 'wgegwgwg' });
                    data.push({ id: 12, pid: 8, text: 'gwegwg' });

                    data.push({ id: 6, pid: 2, text: '1.1.3', ischecked: true });
                    data.push({ id: 7, pid: 2, text: '1.1.4' });
                    data.push({ id: 8, pid: 7, text: '1.1.5' });
                    data.push({ id: 9, pid: 7, text: '1.1.6' });

                    m.tree = $("#treeMenu").ligerTree({
                            idFieldName :'id',
                            parentIDFieldName :'pid',
                            data: data,
                            checkbox: false,
                            parentIcon: '',
                            childIcon: ''
                    });
                    $('#treeMenu').find('span').addClass('l-tree-text-height');
                    $("#treeMenuWrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
                },
                //查询列表方法
                find : function () {

                },
                gotoGrant: function () {
                    openDialog(master.urls.gotoAppGrant, "应用授权", 500, 660, {}, {});
                }
            }

            var em = {
                grid: undefined,
                urls: {
                    list: '${contextRoot}/resource/dict/entry/list_test',
                    del: '${contextRoot}/resource/dict/entry/del_test',
                    gotoModify: '${contextRoot}/resource/dict/entry/gotoModify'
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
                    var btn = [
                        {type: '选中允许', id: 'allowChecked', clkFun: this.gotoModify},
                        {type: '选中禁止', id: 'forbidChecked', clkFun: this.gotoModify},
                        {type: '全部允许', id: 'allowAll', clkFun: this.gotoModify},
                        {type: '全部禁止', id: 'forbidAll', clkFun: this.gotoModify}
                    ];
                    initBarBtn($('#entry_retrieve_inner'), btn)
                },
                //初始化表格
                rendGrid : function(){
                    var m = em;
                    var columns = [
                        {display: 'ID', name: 'id', hide: true},
                        {display: '序号', name: 'sort', width: '10%', align: 'left'},
                        {display: '字段名称', name: 'name', width: '20%', align: 'left'},
                        {display: '维度授权', name: 'name', width: '60%', align: 'left'},
                        {display: '操作', name: 'operator', width: '10%', render: m.opratorRender}];

                    m.grid = initGrid($('#rightGrid'), m.urls.list, {}, columns, {delayLoad: true});
                },
                //操作栏渲染器
                opratorRender: function (row){
                    var vo = [
                        {type: 'edit', clkFun: "$.publish('dict:entry:modify',['"+ row['id'] +"', 'modify'])"},
                        {type: 'del', clkFun: "$.publish('dict:entry:del',['"+ row['id'] +"'])"},
                    ];
                    return initGridOperator(vo);
                },
                //查询点击事件
                searchFun : function () {
                    em.find(1);
                },
                //修改、新增点击事件
                gotoModify : function (event, id, mode) {
                    mode = mode || 'new';
                    id = id || '';
                    openDialog(em.urls.gotoModify, mode=='new'?'新增':'修改', 440, 400, {id: id, mode: mode});
                },
                //删除事件
                del : function (event, id) {
                    var m = em;
                    batchDel(m.grid, m.find, m.urls.del, id);
//                    batchDel.apply(m, id);
                },
                //查询列表方法
                find : function (curPage) {
                    var params = {};
                    reloadGrid(this.grid, curPage, params);
                },
                //公开方法
                publishFunc : function (){
                    var m = em;
                    $.subscribe('dict:entry:modify', m.gotoModify);
                    $.subscribe('dict:entry:del', m.del);
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

        });
    })(jQuery, window);

</script>