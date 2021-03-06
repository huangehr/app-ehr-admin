<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $('#ipt_search'),
                $searchType: $('#ipt_search_type'),
                $addBtn: $('#btn_add'),
                $searchBtn:$('#btn_search'),

                init: function () {
                    this.$searchNm.ligerTextBox({width: 240});
                    this.$searchType.ligerComboBox({
                        url: "${contextRoot}/dict/searchDictEntryList",
                        dataParmName: 'detailModelList',
                        urlParms: {dictId: 22},
                        valueField: 'code',
                        textField: 'value'
                    });
                    this.$element.show();

                    this.$element.attrScan();
                    window.form = this.$element;
                    this.bindEvents();
                },
                bindEvents: function () {
                    $.subscribe('stdInfo:stdInfoGrid:delete',function(event,ids) {
                        var delRowLen = 1;
                        if(!ids){
                            var rows = master.grid.getSelectedRows();
                            if(rows.length==0){
                                parent._LIGERDIALOG.warn('请选择要删除的数据行！');
                                return;
                            }
                            delRowLen = rows.length;
                            for(var i=0;i<rows.length;i++){
                                ids += ',' + rows[i].id;
                            }
                            ids = ids.length>0 ? ids.substring(1, ids.length) : ids;
                        }

                        parent._LIGERDIALOG.confirm('确认要删除所选数据？', function (r) {
                            if(r){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/standardsource/delStdSource',{
                                    data:{id:ids},
                                    success:function(data){
										if(data.successFlg){
											parent._LIGERDIALOG.success( '操作成功！');
											master.reloadGrid(Util.checkCurPage.call(master.grid, delRowLen));
										}else{
											parent._LIGERDIALOG.error(data.errorMsg);
										}
                                    }
                                });
                            }
                        })
                    });
                }
            };

            master = {
                stdInfoDialog: null,
                grid: null,
                init: function () {

                    var searchNm = $("#ipt_search").val();

                    this.grid = $("#div_std_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/standardsource/searchStdSource',
                        parms: {
                            searchNm: searchNm
                        },
                        columns: [
                            { display: 'id', name: 'id', width: '0.1%', hide:true },
                            { display: '类型代码', name: 'sourceType',hide:true, width: '0.1%', isAllowHide: false },
                            { display: '类型', name: 'sourceValue',width: '13%', isAllowHide: false },
                            { display: '编码', name: 'code',width: '20%',align:'left', isAllowHide: false },
                            { display: '名称',name: 'name', width: '35%',align:'left',isAllowHide: false },
                            { display: '创建时间',name: 'createDate', width: '20%',isAllowHide: false },
                            { display: '操作', name: 'operator', minWidth: 120, render: function (row) {
//								var html ='<div class="grid_edit"  style="" title="修改" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "std:stdInfo:open", row.id,'modify') + '"></div>'
//										+'<div class="grid_delete"  style="" title="删除"' +
//										' onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "stdInfo:stdInfoGrid:delete", row.id) + '"></div>';
								var html = '';
                                <sec:authorize url="/standardsource/updateStdSource">
                                html += '<a class="grid_edit" title="编辑" href="#" onclick="javascript:'+Util.format("$.publish('{0}',['{1}','{2}'])","std:stdInfo:open", row.id,'modify')+'"></a>';
                                </sec:authorize>

                                <sec:authorize url="/standardsource/delStdSource">
                                html += '<a class="grid_delete" title="删除" href="#" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","stdInfo:stdInfoGrid:delete", row.id)+'"></a>';
                                </sec:authorize>
                                return html;
                            }}
                        ],
                        allowHideColumn:false,
                        selectRowButtonOnly: false,
                        validate : true,
                        unSetValidateAttr:false,
                        checkbox : true,
                        onDblClickRow : function (row){
                            <%--var mode = 'view';--%>
                            <%--this.stdInfoDialog = parent._LIGERDIALOG.open({--%>
                                <%--height:440,--%>
                                <%--width: 400,--%>
                                <%--title : '标准来源基本信息',--%>
                                <%--url: '${contextRoot}/standardsource/template/stdInfo',--%>
                                <%--urlParms: {--%>
                                    <%--id: row.id,--%>
                                    <%--mode:mode--%>
                                <%--},--%>
                                <%--isHidden: false--%>
                            <%--});--%>
                        }
                    }));
                    this.bindEvents();
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                reloadGrid: function (curPage) {
                    var values = retrieve.$element.Fields.getValues();
                    Util.reloadGrid.call(this.grid, '', values, curPage);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        self.reloadGrid(1);
                    });

                    $.subscribe('std:stdInfo:open',function(event,id,mode){

                        var title = '';

                        //只有new 跟 modify两种模式会到这个函数
                        if(mode == 'modify'){
                            title = '修改标准来源';
                        }
                        else{
                            title = '新增标准来源';
                        }

                        self.stdInfoDialog = parent._LIGERDIALOG.open({
                            height:440,
                            width: 460,
                            title : title,
                            url: '${contextRoot}/standardsource/template/stdInfo',
                            urlParms: {
                                id: id,
                                mode:mode
                            },
                            isHidden: false,
                            opener: true,
                            load:true
                        });
                    });
                }
            };

            /* ******************Dialog页面回调接口****************************** */
            win.parent.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeDialog = function (msg) {
                master.stdInfoDialog.close();
                if(msg)
                    parent._LIGERDIALOG.success(msg);
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>