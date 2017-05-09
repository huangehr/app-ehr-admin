<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var adapterGrid = null;
            var adapterDataSet = null;
            var adapterType = 21;
            var searchOrg;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $startDate:$("#inp_start_date"),
                $endDate:$("#inp_end_date"),
                $addDetail: $('#btn_detail'),
                init: function () {
                    var self = this;
                    self.$startDate.ligerDateEditor({format: "yyyy-MM-dd"});
                    self.$endDate.ligerDateEditor({format: "yyyy-MM-dd"});
                    self.$element.show();
                    self.$element.attrScan();
                    self.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                    //趋势分析详情
                    retrieve.$addDetail.click(function () {
                        debugger
                        var url = '${contextRoot}/report/analysisList';
                        $("#contentPage").load(url);
                    });
                }
            };

            /* *************************** 页面功能 **************************** */
            pageInit();

        });
    })(jQuery, window);

</script>