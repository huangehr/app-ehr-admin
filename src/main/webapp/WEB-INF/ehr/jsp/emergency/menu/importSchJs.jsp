<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($,win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var obj = null;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                obj.init()
                obj.bindEvent();
            }
            var urls = {
                gotoImportLs: "${contextRoot}/doctorImport/gotoImportLs"
            }
            function onUploadSuccess(g, result){
                if(result){
                    console.log(result)
//                    openDialog(urls.gotoImportLs, "导入错误信息", 1000, 640, {result: result});
                }
                else{

                    $.Notice.success("导入成功！");
                }
            }
            $('#importbutton').uploadFile({url: "${contextRoot}/schedule/import",onUploadSuccess: onUploadSuccess});

            /* *************************** 函数定义结束******************************* */
            obj = {
                detailDialog:null,
                $importbutton : $('#importbutton'),
                $cenclebutton : $('#cenclebutton'),
                $div_btn:$('.div_btn'),
//                $uploader:$('#div_file_picker'),
                $div_download:$('.div_download'),
                $fileShow:$('#thelist'),
                init:function () {
                    var self = this;
                    //实例化选择文件
//                    self.$uploader.instance = self.$uploader.webupload({});
//
//                    self.$uploader.instance.on( 'fileQueued', function( file ) {
//                        self.$fileShow.attr('id',file.id);
//                        self.$fileShow.val(file.name+'导入...')
//                    });
                },

                onUploadSuccess :function (g, result){
                    var self = this;
                    debugger;
                    if(result){
                        console.log(self)
                        console.log(g)
                        openDialog(self.urls.gotoImportLs, "导入错误信息", 1000, 640, {result: result});
                    }
                    else{
                        var waittingDialog = $.ligerDialog.waitting('导入成功,请稍候...');
                        var dataModel = $.DataModel.init();//ajax 初始化
                        dataModel.updateRemote("${contextRoot}/ambulance/save", {
                            data: {ambulance: addModel},
                            type:"POST",
                            success: function (data) {
                                waittingDialog.close();
                                if (data.successFlg){
//                                页面回调
                                    debugger
                                } else {
                                    waittingDialog.close();
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        })
                    }
            },

                bindEvent:function () {
                    var self = this;
                    self.$importbutton.click(function () {
                        self.$importbutton
                    })

                    obj.$div_download.click(function () {
                        window.location.href = "<%=request.getContextPath()%>/template/排班表.xls";
                    })
                    //关闭dailog的方法
                    obj.$cenclebutton.click(function(){
                        closeDialog();
                    })
                }
            }
            /* *************************** 页面功能 **************************** */
            pageInit();
        })

    })(jQuery,window)
</script>
