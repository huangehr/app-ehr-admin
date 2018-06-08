<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>
    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var info = null;

        // 表单校验工具类
        var receiveModel = "";
        /* ************************** 变量定义结束 ******************************** */
        var receiveDetail = JSON.parse('${receiveDetail}');
        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            info.init();
        }

        /* *************************** 函数定义结束******************************* */


        /* *************************** 模块初始化 ***************************** */
        info = {
            $form: $("#div_info_form"),
            $cancelBtn: $("#div_cancel_btn"),
            $hospital: $("#hospital"),
            $visitTime: $("#visitTime"),
            $totalVisit: $("#totalVisit"),
            $visitIntime: $("#visitIntime"),
            $visitIntimeRate: $("#visitIntimeRate"),
            $visitIntegrity: $("#visitIntegrity"),
            $visitIntegrityRate: $("#visitIntegrityRate"),
            infoGrid:null,
            init: function () {
                var self = this;
                self.$hospital.text(receiveDetail.orgName+"("+receiveDetail.orgCode+")");
                self.$visitTime.html(receiveDetail.startDate+" - "+receiveDetail.endDate);
                self.$totalVisit.html(receiveDetail.totalVisit);
                self.$visitIntime.html(receiveDetail.visitIntime);
                self.$visitIntimeRate.html(receiveDetail.visitIntimeRate);
                self.$visitIntegrity.html(receiveDetail.visitIntegrity);
                self.$visitIntegrityRate.html(receiveDetail.visitIntegrityRate);
                self.infoGrid = $("#div_info_grid").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/packetNumList',
                    // 传给服务器的ajax 参数
                    pageSize:15,
                    method:'get',
                    parms: {
                        orgCode: receiveDetail.orgCode,
                        eventDateStart: receiveDetail.startDate,
                        eventDateEnd: receiveDetail.endDate
                    },
                    columns: [
                        {display: '接收时间', name: 'receiveDate', width: '50%',align: 'left'},
                        {display: '档案数', name: 'packetCount', width: '50%', align: 'left'}
                    ],
                    height:"300px",
                    selectRowButtonOnly: false,
                    validate: true,
                    unSetValidateAttr: false,
                    allowHideColumn: false
                }));
                self.infoGrid.adjustToWidth();
                self.bindEvents();
            },
            bindEvents: function () {
                var self = this;

                //关闭dailog的方法
                info.$cancelBtn.click(function(){
                    win.dialogClose();
                    //dialog.close();
                })
            }
        };

        /* *************************** 模块初始化结束 ***************************** */

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */


    })(jQuery, window);
</script>