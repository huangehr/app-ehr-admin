<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/static-dev/base/avalon/avalon.js"></script>

<script>

    (function ($,win) {
        //扩展
        $.fn.parseForm = function() {
            var serializeObj = {};
            var array = this.serializeArray();
            var str = this.serialize();
            $(array).each(function() {
                if(serializeObj[this.name]) {
                    if($.isArray(serializeObj[this.name])) {
                        serializeObj[this.name].push(this.value);
                    } else {
                        serializeObj[this.name] = [serializeObj[this.name], this.value];
                    }
                } else {
                    serializeObj[this.name] = this.value;
                }
            });
            return serializeObj;
        };
        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var menuInfo = null;
        var dataModel = $.DataModel.init();
        var id = '${id}';
        var date = '${date}';
        var carId = '${carId}';
        var main = '${main}';
        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            menuInfo.init(id,date,carId,main);

        }
//avalon初始化
        vm = avalon.define({
            $id:'avacontroller',
            data:{}
        });
        /* *************************** 函数定义结束******************************* */
        $(function () {

            menuInfo = {
                $edit:$('#edit'),
                $cancel:$('#cancel'),
                $date:$('#date'),
                $car:$('#car'),
                $main:$('#main'),
                $mayEdit:$('.mayEdit'),
                $sex :$('.sex'),
                init:function (pn,date,carId,main) {
                    var self =  this;
                    self.$date.val(date);
                    self.$car.val(carId);
                    if(main=='true'){
                        self.$main.val("主车");
                    }else {
                        self.$main.val("副车");

                    }
                    $.ajax({
                        type:"GET",
                        url: '${contextRoot}/schedule/list',
                        data:{
                            filters:"id=" + pn,
                            page:1,
                            size:"100"
                        },
                        dataType:"json",
                        error: function(XMLHttpRequest, textStatus, errorThrown) {

                        },
                        success:function (data) {
                            if(data.successFlg){
                                var detailModelList = data.detailModelList;
                                //事件执行
                                self.bindEvents(detailModelList);
                                if (detailModelList && detailModelList.length>0 ){
                                    vm.data = detailModelList;
                                    $.each(detailModelList, function (k, o) {
                                        o.gender ? $('#' + o.id).val(o.gender) : $('#' + o.id).val('1');
                                    })
                                }
                            }else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })
                },

                //绑定事件
                bindEvents:function (parameter) {
                    var self = this;
                    var change = true;
                    self.$edit.click(function () {

                        if(change){

                            $('.mayEdit').attr("disabled",false);
                        }else {
                            var list =[];
                            $.each(parameter, function (k, o) {
                                var obj={id:o.id};
                                list.push($.extend({},obj,$('#form' + o.id).parseForm()))
//                                list.push($('#form' + o.id).parseForm());
                                console.log(list)
                            })
                            console.log(list)
                            $.ajax({
                                type:"POST",
                                url: '${contextRoot}/schedule/bathUpdate',
                                data:{
                                    schedules:JSON.stringify(list)
                                },
                                error: function(XMLHttpRequest, textStatus, errorThrown) {

                                },
                                success:function (data) {
                                    if(data.successFlg){
                                        closeMenuInfoDialog(function () {
                                            $.Notice.success('编辑成功');
                                        });

                                    }else {
                                        $.Notice.error(data.errorMsg);
                                    }
                                }
                            })

                        }
                        change = !change;
                    })
                    self.$cancel.click(function () {
                        closeDialog();
                    })
                }
            }

        })
        /* *************************** 页面功能 **************************** */
        pageInit();


    })(jQuery,window)


</script>
