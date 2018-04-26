<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var isFirstPage = false;
            var questionType = '';

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid(params) {
                params = {
                    redicUrl:'/basic/api/v1.0/admin/surveyQuestion/list',
                    postOrGet:'post',
                    paramJson:'{"title":"","lable":"","page":"1","rows":"15"}',
                    title:retrieve.$searchNm.val(),
                    questionType:questionType
                }
                if (isFirstPage) {
                    this.grid.options.newPage = 1;
                }
                this.grid.setOptions({parms: params});
                this.grid.loadData(true);
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $("#inp_searchNm"),//标题
                $status: $("#sel_status"),//状态
                $addBtn: $('.div-add-btn'),//新增问题
                $patchDeleteBtn: $(".div-pldelete-btn"),//批量删除
                init: function () {
                    _this = this;
                    this.$searchNm.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            isFirstPage = true;
                            master.reloadGrid();//参数：标签/提交人+消息通知状态
                        }
                    })
                    //状态复选框，选择时也刷新列表
                    _this.statusBox = _this.$status.ligerComboBox({
                        width: 180,
                        data: [
                            {text: '全部', statusId: ''},
                            {text: '单选', statusId: '0'},
                            {text: '多选', statusId: '1'},
                            {text: '问答', statusId: '2'}
                        ],
                        initIsTriggerEvent: false,
                        valueFieldID: 'statusId',
                        valueField: 'statusId',
                        onSelected: function (newvalue) {
                            questionType = newvalue;
                            if (!master || !master.grid) {
                                return
                            }
                            isFirstPage = true;
                            master.reloadGrid();//参数：标签/提交人+消息通知状态
                        },
                    });

                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                    self.$addBtn.click(function () {
                        location.href = '${contextRoot}/survey/addQuestion?id=&mode=add';
                    });

                    self.$patchDeleteBtn.click(function(){
                        var checkRowsList = master.grid.getCheckedRows();
                        if(checkRowsList.length==0){
                            $.Notice.error("未选择项！");
                            return false;
                        }
                        var ids = "";
                        for(var i=0;i<checkRowsList.length;i++){
                            ids+=checkRowsList[i].id+";";
                        }
                        $.ligerDialog.confirm('是否确认批量删除已选问题？删除后无法恢复', function (yes) {
                            if (yes) {
                                master.delRecords(ids);
                            }
                        });
                    })
                }
            };
            master = {
                infoDialog: null,
                grid: null,
                init: function () {

                    this.grid = $("#div_question_list").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/survey/allMethod',
                        checkbox: true,
                        parms: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/list',
                            postOrGet:'post',
                            paramJson:'{"title":"","lable":"","page":"1","rows":"15"}'
                        },
                        columns: [
                            {display: 'ID', name: 'id', hide: true},
                            {display: '标题', name: 'title', width: '20%', align: "center"},
                            {display: '类型', name: 'questionType', width: '10%', align: "center",
                                render: function (row) {
                                    if (Util.isStrEquals(row.questionType, 0)) {
                                        return "单选";
                                    } else if (Util.isStrEquals(row.questionType, 1)) {
                                        return "多选";
                                    }
                                    return "问答";
                                }
                            },
                            {display: '问题说明', name: 'comment', width: '40%', align: "center"},
                            {
                                display: '操作', name: 'operator', width: '30%', align: "center", isSort: false,
                                render: function (row) {
                                    var html = '';
                                    html += '<a  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "info:view", row.id, row.questionType) + '">查看</a>';
                                    html += '<a  style="margin-left:10px;"href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "info:edit", row.id) + '">编辑</a>';
                                    html += '<a  style="margin-left:10px;" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "info:del", row.id) + '">删除</a>';
                                    return html;
                                }
                            }
                        ],
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
                            var checkRowsList = master.grid.getCheckedRows();
                            if(checkRowsList.length==0){
                                $(".div-pldelete-btn").removeClass("active");
                            }else{
                                $(".div-pldelete-btn").addClass("active");
                            }
                            //修改行checked值
                            if(checked)
                                data.checked ="1";
                            else
                                data.checked ="0";
                        },
                        onCheckAllRow:function(checked,gridElement){
                            if(checked){
                                $(".div-pldelete-btn").addClass("active");
                            }else{
                                $(".div-pldelete-btn").addClass("active");
                            }
                        },
                        onSuccess: function(data, grid) {
                            data.detailModelList = data.obj.content
                        }

                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function (msg) {
                    if (msg) {
                        //如果是新增，直接刷新页面
                        master.grid.loadData();
                    } else {
                        //如果是查询
                        retrieve.$element.attrScan();
                        var values = retrieve.$element.Fields.getValues();
                        reloadGrid.call(this, values);
                    }
                },
                bindEvents: function () {
                    var self = this;
                    $.subscribe('info:view', function (event, id, type) {
                        self.infoDialog = $.ligerDialog.open({
                            height: 430,
                            width: 600,
                            title: '问题查看',
                            url:'${contextRoot}/survey/seeQuestion',
                            urlParms:{"questionId": id,"type": type}
                        })
                    });

                    $.subscribe('info:edit', function (event, id) {
                        self.infoDialog = $.ligerDialog.open({
                            height: 430,
                            width: 600,
                            urlParms: {"questionId": id,"mode":""},
                            title: '编辑问题',
                            url:'${contextRoot}/survey/editQuestion'
                        })
                    });

                    $.subscribe('info:del', function (event, id) {
                        $.ligerDialog.confirm('是否确认删除该问题？删除后无法恢复', function (yes) {
                            if (yes) {
                                self.delRecord(id);
                            }
                        });
                    })
                },
                delRecord: function (ids) {
                    var self = this;
                    var parms = {
                        id : ids
                    }
                    var value = JSON.stringify(parms);
                    $.ajax({
                        url:  "${contextRoot}/survey/allMethod",
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/delQuestion',
                            postOrGet:'get',
                            paramJson:value
                        },
                        method: "get",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                window.reloadMasterGrid("删除成功");
                                $(".div-pldelete-btn").removeClass("active");
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                delRecords: function (ids) {
                    var self = this;
                    var parms = {
                        ids : ids
                    }
                    var value = JSON.stringify(parms);
                    $.ajax({
                        url:  "${contextRoot}/survey/allMethod",
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/delQuestions',
                            postOrGet:'get',
                            paramJson:value
                        },
                        method: "get",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                window.reloadMasterGrid("删除成功");
                                $(".div-pldelete-btn").removeClass("active");
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterGrid = function (msg) {
                if (msg) {
                    $.Notice.success(msg);
                }
                master.reloadGrid(msg);
            };
            win.closeInfoDialog = function () {
                master.infoDialog.close();
            };
            win.closeParentInfoDialog = function () {
                master.infoDialog.close();
                master.reloadGrid();
            };
            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>