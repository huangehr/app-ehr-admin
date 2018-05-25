<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/modifyAndupload.js"></script>

<script>
    (function ($,win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var obj = null;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
//                obj.init()
                obj.bindEvent();
            }
            var urls = {
                gotoImportLs: "${contextRoot}/device/gotoImportLs"
            }
            function onUploadSuccess(g, result){
                debugger;
                if(result){
                    var defaultOpts = {
                        height: 640,
                        width:1100 ,
                        title: "导入错误信息",
                        url: urls.gotoImportLs,
                        urlParms: {result: result},
//                        load: true,
                        isHidden: false
                    };
                    var dialog = parent._LIGERDIALOG.open(defaultOpts);
                    parent.closeDialog();
                }
                else{
                    $.Notice.success("导入成功！",function () {
                        parent.closeDialog();
                    });
                }
            }
            $('#import_button').uploadFile({url: "${contextRoot}/device/importDevice",onUploadSuccess: onUploadSuccess});

            /* *************************** 函数定义结束******************************* */
            obj = {
                $importbutton : $('#import_button'),
                $cancelbutton : $('#cancelbutton'),
                $div_btn:$('.div_btn'),
                $div_download:$('.div_download'),
                $fileShow:$('#thelist'),
                bindEvent:function () {
                    var self = this;
                    self.$importbutton.click(function () {
                        self.$importbutton;
                    })

                    obj.$div_download.click(function () {
                        window.location.href = "<%=request.getContextPath()%>/template/设备导入模板.xls";
                    })
                    //关闭dailog的方法
                    obj.$cancelbutton.click(function(){
                        parent.closeDialog();
                    })
                }
            }
            /* *************************** 页面功能 **************************** */
            pageInit();
        })

    })(jQuery,window)
</script>
