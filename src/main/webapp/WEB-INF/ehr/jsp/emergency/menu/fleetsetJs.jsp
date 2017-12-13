<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/gridTools.js"></script>

<script>
    (function ($, win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var dictMaster = null;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                dictMaster.init();
            }
            dictMaster = {
                dictInfoDialog: null,
                detailDialog:null,
                grid: null,
                init: function () {
                    var self = this;
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        this.grid = $("#standby_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/location/list',
                            parms: {
                               page:1,
                               size:100
                            },
                            method:'GET',
                            columns: [
                                {display: 'id', name: 'id', width: '0.1%', hide: true},
                                {display: '地点', name: 'initAddress', width: '30%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '经度', name: 'initLatitude', width: '15%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '纬度', name: 'initLongitude', width: '15%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '所属片区', name: 'district', width: '30%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '操作', name: 'operator', width: '10%', align: 'center',render: function (row, rowindex, value) {
                                    var html = '';
                                    if (!row._editing)
                                    {
                                        html += '<a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:appInfo:open", row.id) + '"></a>';
                                        html += '<a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "app:appInfo:delete", row.id) + '">'+'</a>';

                                    }
                                    else
                                    {
                                        html += '<a class="grid_hold" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:appInfo:keep", row.id) + '"></a>';
                                        html += '<a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "app:appInfo:delete", row.id) + '"></a>';

                                    }
                                    return html;
                                    }

                                }
                            ],
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            enabledEdit: true,
                            clickToEdit: false,
                            height:"75%",
                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },

                reloadGrid: function (curPage) {
                    var searchNm = $("#searchNm").val();
                    var values = {
                        page:1,
                        size:100
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/location/list', values, curPage);
                },
                beginEdit:function () {
                    var row = dictMaster.grid.getSelectedRow();
                    dictMaster.grid.beginEdit(row);
                },
                endEdit:function () {
                    var row = dictMaster.grid.getSelectedRow();
                    dictMaster.grid.endEdit(row);
                },
                bindEvents:function () {
                    var self = this;
                    $.subscribe('app:appInfo:open',function(event, id){
                        self.beginEdit();
                    });
                    $.subscribe('app:appInfo:keep',function(event, id){
                        self.endEdit();
                    });
                    $.subscribe('app:appInfo:delete',function(event,appId){
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.fetchRemote('${contextRoot}/location/delete', {
                                    data: {ids: appId},
                                    type: 'POST',
                                    error: function(XMLHttpRequest, textStatus, errorThrown) {

                                    },
                                    success: function (data) {
                                        if (data.successFlg) {
                                            $.Notice.success('操作成功。');
                                            dictMaster.reloadGrid();
                                        } else {
                                            window.top.$.Notice.error(data.errorMsg)
                                        }
                                    }
                                });
                            }
                        });
                    });
                }

            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
