<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>
    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var healthBusinessInfo = null;
        var initCode = "";
        var initName = "";
        var jValidation = $.jValidation;  // 表单校验工具类
        var dataModel = $.DataModel.init();
        var id = ${id};
        var parentSelectedVal = "";
        var validator = null;


        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            healthBusinessInfo.init();
        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        healthBusinessInfo = {
            $form: $("#div_patient_info_form"),
            $inpCode: $("#inp_code"),
            $inpName: $("#inp_name"),
            $inpParentId: $("#inp_parent_id"),
            $introduction:$("#inp_introduction"),
            $healthId:$("#health_id"),
            $updateBtn:$("#div_update_btn"),
            $cancelBtn:$("#div_cancel_btn"),
            $weekDialog:$("#div_weekDialog"),
            $div_week_confirm_btn: $('#div_week_confirm_btn'),
            weekDialog: null,
            init: function () {
                this.initForm();
                this.bindEvents();
                if (id != '-1') {
                    this.getZBInfo(this.setZBInfo , this);
                }
            },
            parentSelected:function(pid, name){
                parentSelectedVal = pid;
            },
            setZBInfo: function ( res, me) {
                initCode = res.code;
                initName = res.name;
                me.$inpCode.val(res.code);
                me.$inpName.val(res.name);
//                me.$inpParentId.val(res.parentId);
                me.$inpParentId.ligerGetComboBoxManager().setValue(res.parentId);
                me.$inpParentId.ligerGetComboBoxManager().setText(res.parentId);
                me.$introduction.val(res.note);
                me.$healthId.val(id);

                console.log(res);
            },
            getZBInfo: function ( cb, me) {
                $.ajax({
                    url: '${contextRoot}/health/detailById',
                    data: {
                        id: id
                    },
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        if (data) {
                            cb && cb.call( this, data, me);

                        } else {
                            $.Notice.error("信息获取失败");
                        }
                    }
                });
            },
            initForm: function () {
                var self = this;
                self.$inpCode.ligerTextBox({width: 240});
                self.$inpName.ligerTextBox({width: 240});
//                self.$inpParentId.ligerTextBox({width: 240});
                this.$introduction.ligerTextBox({width:240,height:100 });
                var combo1 = self.$inpParentId.customCombo('${contextRoot}/health/getHealthBusinessList',{},self.parentSelected,null,null,{valueField: 'id',
                    textField: 'id'});
                self.$inpParentId.parent().css({
                    width:'240'
                }).parent().css({
                    display:'inline-block',
                    width:'240px'
                });
                self.$form.attrScan();
            },

            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    if (Util.isStrEquals($(elm).attr('id'),'inp_parent_id')) {
                        debugger
                        var result = new jValidation.ajax.Result();
                        var parentId = self.$inpParentId.val();
                        if (id == parentId) {
                            result.setResult(false);
                            result.setErrorMsg("您选的父级ID不合法");
                        } else {
                            result.setResult(true);
                        }
                        return result;
                    }
                    if(Util.isStrEquals($(elm).attr('id'),'inp_code')){
                        var result = new jValidation.ajax.Result();
                        var code = self.$inpCode.val();
                        if(code==initCode){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/health/hasExistsCode", {
                            data: {code:code},
                            async: false,
                            success: function (data) {
                                if (data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("编码已存在");
                                }
                            }
                        });
                        return result;
                    }
                    if(Util.isStrEquals($(elm).attr('id'),'inp_name')){
                        var result = new jValidation.ajax.Result();
                        var name = self.$inpName.val();
                        if(name==initName){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/health/hasExistsName", {
                            data: {name:name},
                            async: false,
                            success: function (data) {
                                if (data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("名称已存在");
                                }
                            }
                        });
                        return result;
                    }
                }});

                //新增/修改
                healthBusinessInfo.$updateBtn.click(function () {
                    if(validator.validate()){

                        var values = self.$form.Fields.getValues();
                        values.code = $("#inp_code").val();
                        values.name = $("#inp_name").val();
                        values.parentId = $("#inp_parent_id").val();
                        values.note = $("#inp_introduction").val();
                        var mode = "new";
                        if (id != '-1') {
                            values.id = id.toString();
                            mode = "modify";
                        }
                        dataModel.fetchRemote("${contextRoot}/health/addOrUpdateHealthBusiness", {
                            data: {jsonDate:JSON.stringify(values), mode:mode},
                            async: false,
                            type: 'post',
                            success: function (data) {
                                if (data.successFlg) {
                                    closeZhiBiaoInfoDialog(function () {
                                        if(id != '-1'){//修改
                                            $.Notice.success('修改成功');
                                        }else{
                                            $.Notice.success('新增成功');
                                        }
                                    });
                                } else {
                                    window.top.$.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else{
                        return
                    }
                });

                //关闭dailog的方法
                healthBusinessInfo.$cancelBtn.click(function(){
                    closeDialog();
                })
            }
        };

        /* *************************** 模块初始化结束 ***************************** */

        /* ******************Dialog页面回调接口****************************** */
        win.weekDialogBack = function (execTypeBack,execTimeBack,cronBack) {
            win.execTypeB = execTypeBack;
            win.execTimeB = execTimeBack;
            win.cronB = cronBack;
            zhiBiaoInfo.weekDialog.close();
        };

        win.closeWeekDialog = function () {
            zhiBiaoInfo.weekDialog.close();
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */


    })(jQuery, window);
</script>