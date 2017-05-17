<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
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
						<sec:authorize url="/resource/dict/gotoModify">
						{type: 'edit', clkFun: master.gotoModify, imgClz: 'image-create'}
						</sec:authorize>
					];
                    initBarBtn($('#retrieve_inner'), btn)
                },
                //初始化过滤
                rendFilters : function(){
                    var vo = [{type: 'text', id: 'ipt_search', searchFun: master.searchFun}];
                    initFormFields(vo, $('#retrieve_inner'));
                },
                //初始化表格
                rendGrid : function(){
                    var m = master;
                    var columns = [
                        {display: '字典id', name: 'id', hide: true},
                        {display: '字典编码', name: 'code', width: '30%', align: 'left'},
                        {display: '字典名称', name: 'name', width: '40%', align: 'left'},
                        {display: '操作', name: 'operator', width: '30%', render: m.opratorRender}];

                    function onSelectRow(row){
                        selectRowObj = row;
                        $('#s_dictId').val(selectRowObj.id);
                        em.searchFun();
                    }

                    function onBeforeShowData(data) {
                        $('#s_dictId').val(-1);
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
//                    m.grid.resizeColumns();
                },
                //操作栏渲染器
                opratorRender: function (row){
                    var vo = [
						<sec:authorize url="/resource/dict/gotoModify">
                        {type: 'edit', clkFun: "$.publish('dict:modify',['"+ row['id'] +"', 'modify'])"},
						</sec:authorize>
						<sec:authorize url="/resource/dict/delete">
                        {type: 'del', clkFun: "$.publish('dict:del',['"+ row['id'] +"'])"}
						</sec:authorize>
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
                    master.dialog = openDialog(master.urls.gotoModify, mode=='new'?'新增':'修改', 440, 360, {id: id, mode: mode});
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
						<sec:authorize url="/resource/dict/entry/gotoModify">
						{type: 'edit', clkFun: this.gotoModify}
						</sec:authorize>
					];
                    initBarBtn($('#entry_retrieve_inner'), btn);

                    function onUploadSuccess(g, result){
                        if(result=='suc')
                            $.Notice.success("导入成功");
                        else{
                            result = eval('(' + result + ')')
                            var url = "${contextRoot}/resource/dict/downLoadErrInfo?f="+ result.eFile[1] + "&datePath=" + result.eFile[0];
                            $.ligerDialog.open({
                                height: 80,
                                content: "请下载&nbsp;<a target='diframe' href='"+ url +"'>导入失败信息</a><iframe id='diframe' name='diframe'> </iframe>",
                            });
                        }
                    }
                    function onDlgClose(){
                        master.searchFun();
                    }
                    $('#upd').uploadFile({url: "${contextRoot}/resource/dict/import", onUploadSuccess: onUploadSuccess, onDlgClose: onDlgClose});
                },
                //初始化过滤
                rendFilters : function(){
                    var vo = [{type: 'text', id: 'searchNmEntry', searchFun: this.searchFun}];
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
						<sec:authorize url="/resource/dict/entry/gotoModify">
                        {type: 'edit', clkFun: "$.publish('dict:entry:modify',['"+ row['id'] +"', 'modify'])"},
						</sec:authorize>
						<sec:authorize url="/resource/dict/entry/delete">
                        {type: 'del', clkFun: "$.publish('dict:entry:del',['"+ row['id'] +"'])"}
						</sec:authorize>
                    ];
                    return initGridOperator(vo);
                },
                //修改、新增点击事件
                gotoModify : function (event, id, mode) {
                    if(!getSelected() || getSelected().length==0){
                        $.Notice.warn("请先添加字典！");
                        return;
                    }
                    mode = mode || 'new';
                    id = id || '';
                    em.dialog = openDialog(em.urls.gotoModify, mode=='new'?'新增':'修改', 440, 360, {id: id, mode: mode});
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
                        {name: 'dictId', logic: '='}];
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

            win.getSelected = function () {
                return master.grid.getSelectedRow();
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