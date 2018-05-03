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
            var grid, editDialog;
            var urls = {
                list: '${contextRoot}/resource/meta/list',
                del: '${contextRoot}/resource/meta/delete',
                active: '${contextRoot}/resource/meta/active',
                gotoModify: '${contextRoot}/resource/meta/gotoModify',
                upload: "${contextRoot}/resource/meta/import",
                gotoImportLs: "${contextRoot}/resource/meta/gotoImportLs"
            }

            //跳转新增修改
            var gotoModify = function (event, id, mode) {
                mode = mode || 'new';
                id = id || '';
                editDialog = parent._LIGERDIALOG.open({
//                    urls.gotoModify, mode=='new'?'新增':'修改', 440, 620, {id: id, mode: mode}
                    height: 440,
                    width: 620,
                    title: mode=='new'?'新增':'修改',
                    url: urls.gotoModify,
                    urlParms: {
                        id: id, mode: mode
                    }
                });
            }


            var del = function (event, id) {
                batchDel(grid, find, urls.del, id, undefined, undefined, '失效', '确定进行失效操作？');
            }

            var active = function (event, id) {
                batchDel(grid, find, urls.active, id, undefined, undefined, '生效', '确定进行生效操作？');
            }

            var uploadDialog;
            //初始化工具栏
//            var barTools = function(){

                var btn = [
					<sec:authorize url="/resource/meta/gotoModify">
                    {type: 'edit', clkFun: gotoModify}
					</sec:authorize>
                ];
                initBarBtn($('.m-retrieve-inner'), btn)
                function onUploadSuccess(g, result){
                    if(result) {
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        var rowDialog = parent._LIGERDIALOG.open({
                            height: 640,
                            width: 1000,
                            isDrag: true,
                            //isResize:true,
                            title: '导入错误信息',
                            url: urls.gotoImportLs,
//                        load: true
                            urlParms: {
                                result: result
                            },
                            isHidden: false,
                            show: false,
                            onLoaded: function () {
                                wait.close(),
                                    rowDialog.show()
                            }
                        });
                        rowDialog.hide();
                    } else {
                        parent._LIGERDIALOG.success("导入成功！");
                    }
                }

                $('#upd').uploadFile({url: "${contextRoot}/resource/meta/import", onUploadSuccess: onUploadSuccess});

//            };


            function opratorRender(row){
                var vo = [
					<sec:authorize url="/resource/meta/gotoModify">
					{type: 'edit', clkFun: "$.publish('meta:modify',['"+ row['id'] +"', 'modify'])"}
					</sec:authorize>
				];
					if(row.valid==1)
                    vo.push(<sec:authorize url="/resource/meta/delete">{type: 'lock', clkFun: "$.publish('meta:del',['"+ row['id'] +"'])"}</sec:authorize>);
                else
                    vo.push(<sec:authorize url="/resource/meta/active">{type: 'active', clkFun: "$.publish('meta:active',['"+ row['id'] +"'])"}</sec:authorize>);
                return initGridOperator(vo);
            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '资源标准编码', name: 'id', width: '10%', align: 'left'},
                    {display: '业务领域', name: 'domainName', width: '10%', align: 'left'},
                    {display: '内部标识符', name: 'stdCode', width: '15%', align: 'left'},
                    {display: '数据元名称', name: 'name', width: '10%', align: 'left'},
                    {display: '数据来源', name: 'dataSource', width: '10%', align: 'left', render: function (row) {
                        return row.dataSource ==1 ? '档案数据' : '统计数据';
                    }},
                    {display: '类型', name: 'columnTypeName', width: '10%', align: 'left'},
                    {display: '关联字典', name: 'dictName', width: '10%', align: 'left'},
                    {display: '是否可为空', name: 'nullAble', width: '10%', align: 'left', render: function (row) {
                        return row.nullAble ==1 ? '是' : '否';
                    }},
                    {display: '操作', name: 'operator', minWidth: 120, render: opratorRender}];

                grid = initGrid($('#gtGrid'), urls.list, {}, columns, {delayLoad: true, checkbox: false});
                searchFun();
            };

            var searchFun = function () {
                find(1);
            }

            //初始化过滤
            var filters = function(){
                var vo = [
                    {type: 'text', id: 'ipt_search'},
                    {type: 'select', id: 'ipt_search_type', opts:{width: 140}, dictId: 30},
                    {type: 'select', id: 'ipt_search_null_able', opts:{width: 140}, dictId: 18},
                    {type: 'select', id: 'ipt_search_is_valid', opts:{width: 140, cancelable: false,
                        data:[{value: '有效', code: '1'}, {value: '无效', code: '0'}]}},
                    {type: 'select', id: 'ipt_search_data_source', opts:{width: 140, cancelable: true,
                        data:[{value: '档案数据', code: '1'}, {value: '统计数据', code: '2'}]}},
                    {type: 'searchBtn', id: 'search_btn', searchFun: searchFun}
                ];
                initFormFields(vo, $('.m-retrieve-inner'));
                $('#ipt_search_is_valid').ligerGetComboBoxManager().selectValue('1');
            };

            //查询列表
            var find = function (curPage) {
                var vo = [
                    {name: 'stdCode', logic: '?', fields: 'id,name'},
                    {name: 'columnType', logic: '='},
                    {name: 'nullAble', logic: '=', cover: function (v) {
                        if(v=='true')
                            return 1;
                        return 0;
                    }},
                    {name: 'valid', logic: '='},
                    {name: 'dataSource', logic: '='}
                ];

                var params = {filters: covertFilters(vo, $('#searchForm'))};
                reloadGrid(grid, curPage, params);
            };

            var publishFunc = function (){
                $.subscribe('meta:modify', gotoModify);
                $.subscribe('meta:del', del);
                $.subscribe('meta:active', active);
            };

            win.parent.closeDialog = function(msg){
                if(editDialog){
                    editDialog.close();
                    if(msg){
                        parent._LIGERDIALOG.success(msg);
                        find();
                    }
                }
            }
            var pageInit = function(){
                publishFunc();
                filters();
//                barTools();
                rendGrid();
            }();
        });
    })(jQuery, window);

</script>