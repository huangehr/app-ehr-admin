<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/static-dev/base/avalon/avalon.js"></script>
<script>
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var obj = null;
            /* *************************** 函数定义 ******************************* */
            vm = avalon.define({
                $id:'avacontroller',
                data:{},
                jumpMenu:function (id) {
                    $.publish('urgentcommand:vehiclemMenu:open',[id,'modify'])
                }
            });
            function pageInit() {
                obj.init(1);
            }
            function Flip(pn) {
                obj.init(pn);
            }
            function choosele(num, cur) {
                if(num == cur) {
                    return " choose";
                } else {
                    return "";
                }
            }
            obj= {
                dictInfoDialog: null,
                $searchNm: $('#searchNm'),
                dataCount:null,
                $change:$(".change"),//编辑
                $be_On_duty:$(".be_On_duty"),//值班
                $delete:$(".delete"),//删除
                $temp:$(".temp"),//ul 容器
                $pageUl : $(".fenye"),

                init:function (pn) {
                    var self = this;
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadData(pn);
                        }
                    });

                    vm.data = [];
                    $.ajax({
                        type:"GET",
                        url: '${contextRoot}/ambulance/list',
                        data:{
                            page:pn,
                            size:"15"
                        },
                        dataType:"json",
                        error: function(XMLHttpRequest, textStatus, errorThrown) {

                        },
                        success:function (data) {
                            if(data.successFlg){
                                var detailModelList = data.detailModelList;
                                if (detailModelList && detailModelList.length>0 ){
                                    vm.data = detailModelList;
                                }else {
                                    $.Notice.success('暂无数据');
                                }
                                //绘制页码
                                self.dataCount = data.totalCount;
                                self.getPage(pn)
                                //绑定事件
                                self.bindEvents()
                            }else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })

                },
                reloadData:function (pn) {
                    var self = this;
                    var searchNm = $("#searchNm").val();
                    var values = {
                        filters: "id=" + searchNm,
                        page:1,
                        size:15
                    };
                    vm.data = [];
                    $.ajax({
                        type:"GET",
                        url: '${contextRoot}/ambulance/list',
                        data:values,
                        dataType:"json",
                        error: function(XMLHttpRequest, textStatus, errorThrown) {

                        },
                        success:function (data){
                            if(data.successFlg){
                                //清空分页
                                self.$pageUl.empty();

                                var detailModelList = data.detailModelList;

                                if (detailModelList && detailModelList.length>0 ){
                                    vm.data = detailModelList;
                                }else {
                                    $.Notice.success('暂无数据');
                                }

                                self.bindEvents()
                            }else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })

                },
                bindEvents: function () {
                    var self = this;
                    $.subscribe('urgentcommand:vehiclemMenu:open', function (event, id, mode) {
                        var title = '';
                        if (mode == 'modify') {
                            title = '修改菜单';
                        }
                        else {
                            title = '新增菜单';
                        }
                        obj.dictInfoDialog = $.ligerDialog.open({
                            height: 480,
                            width: 500,
                            title: title,
                            url: '${contextRoot}/ambulance/getPage',
                            urlParms: {
                                id: id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });
                    //删除操作
                    $(".delete").click(function () {
                        var that = $(this)
                        var id = that.attr('id')
                        $.ajax({
                            type:"POST",
                            url: '${contextRoot}/ambulance/delete',
                            data:{
                                ids:id
                            },
                            dataType:"json",
                            error: function(XMLHttpRequest, textStatus, errorThrown) {

                            },
                            success:function (data) {
                                if(data.successFlg){
                                    that.parents("li").remove();
                                }else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        })
                    });
                },
//                翻页
                getPage:function (pn) {
                    var  self = this;
                    var pageSize = 1; //每页显示条数
                    var pageCount = Math.ceil(self.dataCount / pageSize); //总页数
                    if(pn == 0 || pn > pageCount) {
                        return;
                    }
                    this.paintPage(pageCount, pn); //绘制页码
                },
                //绘制页码
                paintPage:function(number, currNum) {//number 总页数,currNum 当前页
                var pageUl = $(".fenye");
                pageUl.empty();
                var ulDetail = "";
                if(number == 1) {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:void(0)\">上一页</a></li>" +
                        "<li class=\"numb choose\"><a href=\"javascript:Flip(1)\">1</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:void(0)\">下一页</a></li>";
                } else if(number == 2) {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:Flip(1)\">上一页</a></li>" +
                        "<li class=\"numb" + choosele(currNum, 1) + "\"><a href=\"javascript:Flip(1)\">1</a></li>" +
                        "<li class=\"numb" + choosele(currNum, 2) + "\"><a href=\"javascript:Flip(2)\">2</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:Flip(2)\">下一页</a></li>";
                } else if(number == 3) {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:Flip(" + parseInt(currNum - 1) + ")\">上一页</a></li>" +
                        "<li class=\"numb" + choosele(currNum, 1) + "\"><a href=\"javascript:Flip(1)\">1</a></li>" +
                        "<li class=\"numb" + choosele(currNum, 2) + "\"><a href=\"javascript:Flip(2)\">2</a></li>" +
                        "<li class=\"numb" + choosele(currNum, 3) + "\"><a href=\"javascript:Flip(3)\">3</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:Flip(" + parseInt(currNum + 1) + ")\">下一页</a></li>";
                } else if(number == currNum && currNum > 3) {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:Flip(" + parseInt(currNum - 1) + ")\">上一页</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(" + parseInt(currNum - 2) + ")\">" + parseInt(currNum - 2) + "</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(" + parseInt(currNum - 1) + ")\">" + parseInt(currNum - 1) + "</a></li>" +
                        "<li class=\"numb choose\"><a href=\"javascript:Flip(" + currNum + ")\">" + currNum + "</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:Flip(" + currNum + ")\">下一页</a></li>";
                } else if(currNum == 1 && number > 3) {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:void(0)\">上一页</a></li>" +
                        "<li class=\"numb choose\"><a href=\"javascript:void(0)\">1</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(2)\">2</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(3)\">3</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:Flip(2)\">下一页</a></li>";
                } else {
                    ulDetail = "<li class=\"prev\"><a href=\"javascript:Flip(" + parseInt(currNum - 1) + ")\">上一页</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(" + parseInt(currNum - 1) + ")\">" + parseInt(currNum - 1) + "</a></li>" +
                        "<li class=\"numb choose\"><a href=\"javascript:Flip(" + currNum + ")\">" + currNum + "</a></li>" +
                        "<li class=\"numb\"><a href=\"javascript:Flip(" + parseInt(currNum + 1) + ")\">" + parseInt(currNum + 1) + "</a></li>" +
                        "<li class=\"next\"><a href=\"javascript:Flip(" + parseInt(currNum + 1) + ")\">下一页</a></li>";
                }
                    $(".fenye").append(ulDetail);
                }
            }
            /* *************************** 页面功能 **************************** */
            pageInit();
            (function ($,win) {
                /* ******************Dialog页面回调接口****************************** */
                win.closeDialog = function (type, msg) {
                    obj.dictInfoDialog.close();
                    if (msg)
                        $.Notice.success(msg);
                };
                win.closeMenuInfoDialog = function (callback) {
                    if(callback){
                        callback.call(win);
                        obj.reloadData();
                    }
                    obj.dictInfoDialog.close();
                };

            })(jQuery,window)

</script>
