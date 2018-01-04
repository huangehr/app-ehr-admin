<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($,win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var obj = null;

            //添加碎片
            function appendNav(str, url, data) {
                $('#navLink').append('<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").empty().load(url,data);
            }
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                obj.init();
            }
            /* *************************** 函数定义结束******************************* */

            /* *************************** 模块处理 ******************************* */
            obj= {
                detailDialog:null,
                grid: null,
                init:function () {
                    var self = this;
                    if (this.grid) {
                        this.reloadGrid(1);
                    }else {
                        this.grid = $("#sort_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/schedule/level',
                            parms: {
                                date:"",
                                page:1,
                                size:100
                            },
                            method:'GET',
                            columns: [
                                {display: '年度月份', name: 'yearMonth', width: '50%', isAllowHide: false, align: 'center'},
                                {display: '操作', name: 'operation', width: '50%', isAllowHide: false, align: 'center',
                                    render:function (row) {
                                        var html = '';
                                        html += '<a style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "Scheduling:SchedulingInfo:open", row.yearMonth) + '">查看排班情况</a>'
                                        return html;
                                    }
                                },
                            ],
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            rownumbers:false,
                            onSuccess: function(data) {
                                var list = []
                                for(var i=0, length = data.detailModelList.length; i < length; i++) {
                                    list.push({
                                        yearMonth: data.detailModelList[i],
                                    })
                                }
                                data.detailModelList = list
                            }
                        }))
                    }
                    this.bindEvents();
                },
                reloadGrid:function (curPage) {
                    var values = {
                        date:"",
                        page:1,
                        size:100
                    }
                    Util.reloadGrid.call(this.grid, '${contextRoot}/schedule/level', values, curPage);
                },
                bindEvents:function () {
                    var self = this;
                    $.subscribe('urgentcommand:importSch:open', function (event) {
                        obj.detailDialog = parent._LIGERDIALOG.open({
                            height: 400,
                            width: 512,
                            title: '导入排班',
                            url: '${contextRoot}/schedule/getImport',
                            urlParms: {},
                            isHidden: false,
//                            opener: true,
//                            load: true
                        });
                    })
                    $.subscribe('Scheduling:SchedulingInfo:open',function(event, yearMonth){
                        var url = '${contextRoot}/schedule/initial?date='+yearMonth;
                        appendNav('排班情况', url, '')
                    });

                    $(document).on('click', '.go-back', function () {
                        win.location.reload();
                    });



                }
            }

            /* ******************Dialog页面回调接口****************************** */

            win.parent.closeDialog = function (type, msg) {
                obj.detailDialog.close();
                if (msg)
                    parent._LIGERDIALOG.success(msg);
            };
            win.parent.closeMenuInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    obj.reloadGrid();
                }
                obj.detailDialog.close();
            };


            /* *************************** 页面功能 **************************** */
            pageInit();
        })
    })(jQuery,window)

    <%--function getUrl() {--%>
        <%--$('#contentPage').empty();--%>
        <%--$('#contentPage').load('${contextRoot}/organization/initial');--%>
    <%--}--%>
</script>