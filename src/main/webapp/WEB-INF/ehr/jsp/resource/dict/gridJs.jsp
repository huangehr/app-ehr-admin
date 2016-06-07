<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var selectRowObj, isSaveSelectStatus = false;

            var curOprator = undefined;
            var master = {
                grid: undefined,
                dialog: undefined,
                urls: {
                    list: '${contextRoot}/resource/dict/list',
                    del: '${contextRoot}/resource/dict/delete',
                    gotoModify: '${contextRoot}/resource/dict/gotoModify'
                },
                //初始化
                init: function(){
                    var m = this;
                    m.rendBarTools();
                    m.rendFilters();
                    m.rendGrid();
                    m.publishFunc();
                },
                //初始化工具栏
                rendBarTools : function(){
                    var btn = [
                        {type: 'edit', clkFun: master.gotoModify, imgClz: 'image-create'}
                    ];
                    initBarBtn($('#retrieve_inner'), btn)
                },
                //初始化过滤
                rendFilters : function(){
                    var vo = [
                        {type: 'text', id: 'ipt_search', searchFun: master.searchFun}
                    ];
                    initFormFields(vo, $('#retrieve_inner'));
                },
                //初始化表格
                rendGrid : function(){
                    var m = master;
                    var columns = [
                        {display: '字典编码', name: 'code', width: '30%', align: 'left'},
                        {display: '字典名称', name: 'name', width: '40%', align: 'left'},
                        {display: '操作', name: 'operator', width: '30%', render: m.opratorRender}];

                    function onSelectRow(row){
                        selectRowObj = row;
                        $('#s_dictCode').val(selectRowObj.code);
                        em.searchFun();
                    }

                    function onBeforeShowData(data) {
                        $('#s_dictCode').val(-1);
                        if(data.detailModelList.length == 0)
                            em.searchFun();
                    }

                    function onAfterShowData(data) {
                        if (selectRowObj != null && isSaveSelectStatus) {
                            isSaveSelectStatus = false;
                            master.grid.select(selectRowObj);
                            if(!master.grid.isSelected(selectRowObj))
                                master.select(0);
                        }else
                            this.select(0);
                    }

                    m.grid = initGrid(
                            $('#leftGrid'), m.urls.list, {}, columns,
                                {checkbox: false, onSelectRow: onSelectRow, onAfterShowData: onAfterShowData, onBeforeShowData: onBeforeShowData});
                    m.grid.resizeColumns();
                },
                //操作栏渲染器
                opratorRender: function (row){
                    var vo = [
                        {type: 'edit', clkFun: "$.publish('dict:modify',['"+ row['code'] +"', 'modify'])"},
                        {type: 'del', clkFun: "$.publish('dict:del',['"+ row['code'] +"'])"}
                    ];
                    return initGridOperator(vo);
                },
                //查询点击事件
                searchFun : function () {
                    master.find(1);
                },
                //修改、新增点击事件
                gotoModify : function (event, id, mode) {
                    mode = mode || 'new';
                    id = id || '';
                    isSaveSelectStatus = true;
                    master.dialog = openDialog(master.urls.gotoModify, mode=='new'?'新增':'修改', 440, 400, {id: id, mode: mode});
                    curOprator = master;
                },
                //删除事件
                del : function (event, id) {
                    var m = master;
                    uniqDel(m.grid, m.find, m.urls.del, id, undefined, 'id');
                },
                //查询列表方法
                find : function (curPage) {
                    selectRowObj = null;
                    var vo = [{name: 'code', logic: '?', fields: 'code,name'}];
                    var params = {filters: covertFilters(vo, $('#retrieve'))}
                    reloadGrid(master.grid, curPage, params);
                },
                //公开方法
                publishFunc : function (){
                    var m = master;
                    $.subscribe('dict:modify', m.gotoModify);
                    $.subscribe('dict:del', m.del);
                }
            }

            var em = {
                grid: undefined,
                dialog: undefined,
                urls: {
                    list: '${contextRoot}/resource/dict/entry/list',
                    del: '${contextRoot}/resource/dict/entry/delete',
                    gotoModify: '${contextRoot}/resource/dict/entry/gotoModify'
                },
                //初始化
                init: function(){
                    var m = this;
                    m.rendBarTools();
                    m.rendFilters();
                    m.rendGrid();
                    m.publishFunc();
                },
                //初始化工具栏
                rendBarTools : function(){
                    var btn = [
                        {type: 'edit', clkFun: this.gotoModify}
                    ];
                    initBarBtn($('#entry_retrieve_inner'), btn)
                },
                //初始化过滤
                rendFilters : function(){
                    var vo = [
                        {type: 'text', id: 'searchNmEntry', searchFun: this.searchFun}
                    ];
                    initFormFields(vo, $('#entry_retrieve_inner'));
                },
                //初始化表格
                rendGrid : function(){
                    var m = em;
                    var columns = [
                        {display: 'ID', name: 'id', hide: true},
                        {display: '值域编码', name: 'code', width: '40%', align: 'left'},
                        {display: '值域名称', name: 'name', width: '30%', align: 'left'},
                        {display: '操作', name: 'operator', width: '30%', render: m.opratorRender}];

                    m.grid = initGrid($('#rightGrid'), m.urls.list, {}, columns, {delayLoad: true, checkbox: false});
                },
                //操作栏渲染器
                opratorRender: function (row){
                    var vo = [
                        {type: 'edit', clkFun: "$.publish('dict:entry:modify',['"+ row['id'] +"', 'modify'])"},
                        {type: 'del', clkFun: "$.publish('dict:entry:del',['"+ row['id'] +"'])"},
                    ];
                    return initGridOperator(vo);
                },
                //修改、新增点击事件
                gotoModify : function (event, id, mode) {
                    if(!getSelectDictId()){
                        $.Notice.warn("请先添加字典！");
                        return;
                    }
                    mode = mode || 'new';
                    id = id || '';
                    em.dialog = openDialog(em.urls.gotoModify, mode=='new'?'新增':'修改', 440, 400, {id: id, mode: mode});
                    curOprator = em;
                },
                //删除事件
                del : function (event, id) {
                    var m = em;
                    uniqDel(m.grid, m.find, m.urls.del, id, undefined, "id");
                },
                //查询点击事件
                searchFun : function () {
                    em.find(1);
                },
                //查询列表方法
                find : function (curPage) {
                    var vo = [
                        {name: 'code', logic: '?', fields: 'code,name'},
                        {name: 'dictCode', logic: '='}];
                    var params = {filters: covertFilters(vo, $('#entryRetrieve'))}
                    reloadGrid(em.grid, curPage, params);
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
            }();
            $(window).bind('resize', function() {
                resizeContent();
            });

            em.init();
            master.init();

            win.getSelectDictId = function () {
                var row = master.grid.getSelectedRow();
                return row['code'];
            }

            win.closeDialog = function(msg){
                curOprator.dialog.close();
                if(msg){
                    $.Notice.success(msg);
                    curOprator.find();
                }
            }

        });
    })(jQuery, window);

</script>