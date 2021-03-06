<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    (function ($,win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var obj = null;
            var date = '${data}';
            console.log(date)
            // 页面主模块，对应于用户信息表区域
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                obj.init();
            }

            //返回上一页
            function goHis(){
                $('#contentPage').empty();
                $('#contentPage').load('${contextRoot}/ambulance/sortmanage');
            }
            jQuery.fn.rowspan = function (colname, tableObj) {
                var colIdx;
                for (var i = 0, n = tableObj.columns.length; i < n; i++) {
                    if (tableObj.columns[i]["columnname"] == colname) {
                        colIdx = i - 1 < 1 ? 0 : i - 1;
                        break;
                    }
                }
                return this.each(function () {
                    var that;
                    $('tr', this).each(function (row) {
                        $('td:eq(' + colIdx + ')', this).filter(':visible').each(function (col) {
                            if (that != null && $(this).html() == $(that).html()) {
                                rowspan = $(that).attr("rowSpan");
                                if (rowspan == undefined) {
                                    $(that).attr("rowSpan", 1);
                                    rowspan = $(that).attr("rowSpan");
                                }
                                rowspan = Number(rowspan) + 1;
                                $(that).attr("rowSpan", rowspan);
                                $(this).hide();
                            } else {
                                that = this;
                            }
                        });
                    });
                });
            }
            /* *************************** 函数定义结束******************************* */
            obj = {
                detailDialog:null,
                grid: null,
                $gohis:$('#gohis'),
                $time:$('#time'),
                init :function () {
                    var self = this;
                    self.$time.html(date+'排班情况')
                    if (this.grid) {
                        this.reloadGrid(1);
                    }else {
                        var gg = this.grid = $("#Schedule").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/schedule/level',
                            parms: {
                                date:date,
                                page:1,
                                size:100
                            },
                            method:'GET',
                            columns: [
                                {display: 'id', name: 'scheduleIds', width: '0%', hide: true},
                                {display: '日期', name: 'date', width: '20%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '归属地点', name: 'location', width: '20%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '车牌号码', name: 'carId', width: '10%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '主/副班', name: 'main', width: '10%', isAllowHide: false, align: 'center',editor:{type:"text"},
                                    render: function (row) {
                                        if (row.main == 'true'||row.main=='主') {
                                            return "主";
                                        } else {
                                            return "副";
                                        }

                                    }},
                                {display: '司机', name: 'driver', width: '10%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '医生', name: 'doctor', width: '10%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '护士', name: 'nurse', width: '10%', isAllowHide: false, align: 'center',editor:{type:"text"}},
                                {display: '操作', name: 'operation', width: '10%', isAllowHide: false, align: 'center',
                                    render: function (row, rowindex, value) {
                                        var html = '';
                                        var rowJson = JSON.stringify(row).replace(/"/g,'&quot;');
                                        if (!row._editing)
                                        {
//                                            html += '<a class="grid_towrite" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "scheDetailsJs:scheInfo:open",row.id,rowJson) +'"></a>';
                                            html += '<a class="grid_detail" style="width:30px" title="详情" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "scheDetailsJs:scheInfo:edit",row.scheduleIds,row.date,row.carId,row.main) + '">'+'</a>';

                                        }
                                        else
                                        {
//                                            html += '<a class="grid_hold" style="width:30px" title="保存" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "scheDetailsJs:scheInfo:lock",row.id,rowJson) + '"></a>';
                                            html += '<a class="grid_detail" style="width:30px" title="详情" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "scheDetailsJs:scheInfo:edit", row.scheduleIds,row.date,row.carId,row.main) + '"></a>';

                                        }
                                        return html;
                                    }
                                },
                            ],
                            validate: true,
                            pageSize:15,
                            dataAction:'local',
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            enabledEdit: true,
                            clickToEdit: false,
                            rownumbers:false,
                            onAfterShowData: function(s) {
                                console.log(s)
                                setTimeout(function() {
                                    $('#Schedule .l-grid-body-table tbody').rowspan('date', gg)
                                }, 0)
                            },
                            onSuccess: function(data, grid) {
                                var list = []
                                for(var i=0,length=data.detailModelList.length;i<length;i++) {
                                    var o = data.detailModelList[i];
                                    if(o.data) {
                                        for(var j=0,len=o.data.length; j<len; j++) {
                                            list.push($.extend({},o.data[j], {date: o.date}))
                                        }
                                    }
                                }
                                data.detailModelList = list

                            }
                        }))
                    }
                    this.bindEvents();
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                reloadGrid :function (curPage){
                    var values = {
                        date:date,
                        page:1,
                        size:100
                    }
                    Util.reloadGrid.call(this.grid, '${contextRoot}/schedule/level', values, curPage);
                },
                bindEvents:function () {
                    var self = this;
//                    $.subscribe('scheDetailsJs:scheInfo:open',function (event, id, row) {
//                        var fthisRow = JSON.parse(row);
//                        if(fthisRow.main=='true'){
//                            fthisRow.main = "主"
//                        }if(fthisRow.main=='false'){
//                            fthisRow.main = "副"
//                        }
//                        obj.grid.beginEdit(fthisRow);
//                    })
//                    $.subscribe('scheDetailsJs:scheInfo:lock',function (event, id, row) {
//                        var row = obj.grid.getSelectedRow();
//                        obj.grid.endEdit(row);
//                    })
                    $.subscribe('scheDetailsJs:scheInfo:edit',function (event,scheduleIds,date,carId,main) {
                        obj.detailDialog = $.ligerDialog.open({
                            height: 'auto',
                            width: 800,
                            title: '排班信息',
                            url: '${contextRoot}/schedule/getPage',
                            urlParms: {
                            id:scheduleIds,
                            date:date,
                            carId:carId,
                            main:main

                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        })
                    })

                    self.$gohis.click(function () {
                        goHis()
                    })
                },
            }



            /* ******************Dialog页面回调接口****************************** */
            win.closeDialog = function (type, msg) {
                obj.detailDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            win.closeMenuInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    obj.reloadData();
                }
                obj.detailDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        })
    })(jQuery,window)

</script>
