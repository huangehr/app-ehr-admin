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

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            info.init();
        }

        /* *************************** 函数定义结束******************************* */


        /* *************************** 模块初始化 ***************************** */
        info = {
            $form: $("#div_patient_info_form"),
            $realName: $("#inp_realName"),
            $idCardNo: $("#inp_idCardNo"),
            $patientNation: $("#inp_patientNation"),
            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
            },
            initForm: function () {
                var self = this;
                self.$realName.ligerTextBox({width: 240});
                self.$idCardNo.ligerTextBox({width: 240});
                self.$resetArea.hide();
                self.$form.attrScan();
                self.$resetArea.show();
                self.$form.Fields.fillValues({
                    name: receiveModel.name,
                    idCardNo: receiveModel.idCardNo,
                    nativePlace: receiveModel.nativePlace,
                    residenceType: receiveModel.residenceType,
                    telephoneNo: receiveModel.telephoneNo,
                    email: receiveModel.email
                });
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