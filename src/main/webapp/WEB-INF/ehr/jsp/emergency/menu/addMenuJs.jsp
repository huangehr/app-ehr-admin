<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>


    (function ($,win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，变量

        /* ************************** 变量定义结束 ******************************** */


        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            menuInfo.bindEvents();

        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        menuInfo={

            $div_update_btn:$('#div_update_btn'),
            $div_cancel_btn:$('#div_cancel_btn'),
            $license_Plate_input :$('#license_Plate_input'),
            $personnel_phone_input :$('#personnel_phone_input'),
            $inpMonitorType :$('#inpMonitorType'),
            $areaType :$('#areaType'),


            bindEvents:function () {
                var self = this;
                self.$div_update_btn.click(function () {
                    var place = self.$license_Plate_input.val();
                    var longitude = self.$personnel_phone_input.val();
                    var latitude = self.$inpMonitorType.val();
                    var area = self.$areaType.val();
                    var trun = {
                        district:area,
                        initAddress:place,
                        initLatitude:latitude,
                        initLongitude:longitude
                    }
                    var parameter = JSON.stringify(trun);
                    $.ajax({
                        type:"POST",
                        url: '${contextRoot}/location/save',
                        data:{
                            location:parameter
                        },
                        dataType:"json",
                        error: function(XMLHttpRequest, textStatus, errorThrown) {

                        },
                        success:function (data) {
                            if(data.successFlg){
                                debugger
                                closeMenuInfoDialog(function () {

                                    $.Notice.success('更新成功');
                                });
                            }else {
                                closeMenuInfoDialog(function () {
                                    debugger
                                    window.top.$.Notice.error(data.errorMsg);
                                });
                            }
                        }
                    })
                });
                //关闭dailog的方法
                self.$div_cancel_btn.click(function(){
                    closeDialog();
                })
            }
        }
        /* *************************** 模块初始化结束 ***************************** */



        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */

    })(jQuery,window)
</script>

