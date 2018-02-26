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
        var id = '${id}';
        var myIndex = '${indexNm}';
        var myType = '${indexType}';
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
            $inpId: $("#inp_id"),
            $myIndex: $("#myIndex"),
            $myType: $("#myType"),
            $quotaCode: $("#quotaCode"),
            $quotaName: $("#quotaName"),
            $result: $("#result"),
            $town: $("#town"),
            $townName: $("#townName"),
            $org: $("#org"),
            $orgName: $("#orgName"),
            $slaveKey1: $("#slaveKey1"),
            $slaveKey1Name: $("#slaveKey1Name"),
            $slaveKey2: $("#slaveKey2"),
            $slaveKey2Name: $("#slaveKey2Name"),
            $slaveKey3: $("#slaveKey3"),
            $slaveKey3Name: $("#slaveKey3Name"),
            $slaveKey4: $("#slaveKey4"),
            $slaveKey4Name: $("#slaveKey4Name"),
            $economic: $("#economic"),
            $economicName: $("#economicName"),
            $level: $("#level"),
            $levelName: $("#levelName"),
            $orgHealthCategoryPid: $("#orgHealthCategoryPid"),
            $orgHealthCategoryId: $("#orgHealthCategoryId"),
            $orgHealthCategoryName: $("#orgHealthCategoryName"),
            $orgHealthCategoryCode: $("#orgHealthCategoryCode"),
            $quotaDate: $("#quotaDate"),
            $year: $("#year"),
            $yearName: $("#yearName"),
            $areaLevel: $("#areaLevel"),
            $createTime: $("#createTime"),
            $updateBtn:$("#div_update_btn"),
            $cancelBtn:$("#div_cancel_btn"),
            weekDialog: null,
            init: function () {
                this.initForm();
                this.bindEvents();
                this.getZBInfo(this.setZBInfo , this);
                $("#inp_id").closest(".m-form-group").addClass("m-form-readonly");
                $("#myIndex").closest(".m-form-group").addClass("m-form-readonly");
                $("#myType").closest(".m-form-group").addClass("m-form-readonly");
            },
            parentSelected:function(pid, name){
                parentSelectedVal = pid;
            },
            setZBInfo: function ( res, me) {
                me.$inpId.val(res._id);
                me.$quotaCode.val(res.quotaCode);
                me.$quotaName.val(res.quotaName);
                me.$result.val(res.result);
                me.$town.val(res.town);
                me.$townName.val(res.townName);
                me.$org.val(res.org);
                me.$orgName.val(res.orgName);
                me.$slaveKey1.val(res.slaveKey1);
                me.$slaveKey1Name.val(res.slaveKey1Name);
                me.$slaveKey2.val(res.slaveKey2);
                me.$slaveKey2Name.val(res.slaveKey2Name);
                me.$slaveKey3.val(res.slaveKey3);
                me.$slaveKey3Name.val(res.slaveKey3Name);
                me.$slaveKey4.val(res.slaveKey4);
                me.$slaveKey4Name.val(res.slaveKey4Name);
                me.$economic.val(res.economic);
                me.$economicName.val(res.economicName);
                me.$level.val(res.level);
                me.$levelName.val(res.levelName);
                me.$orgHealthCategoryPid.val(res.orgHealthCategoryPid);
                me.$orgHealthCategoryId.val(res.orgHealthCategoryId);
                me.$orgHealthCategoryName.val(res.orgHealthCategoryName);
                me.$orgHealthCategoryCode.val(res.orgHealthCategoryCode);
                me.$quotaDate.val(res.quotaDate);
                me.$year.val(res.year);
                me.$yearName.val(res.yearName);
                me.$areaLevel.val(res.areaLevel);
                me.$createTime.val(res.createTime);

                console.log(res);
            },
            getZBInfo: function ( cb, me) {
                $.ajax({
                    url: '${contextRoot}/elasticSearch/detailById',
                    data: {
                        indexNm: myIndex,
                        indexType: myType,
                        id: id
                    },
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        if (data) {
                            cb && cb.call( this, data.obj, me);

                        } else {
                            $.Notice.error("信息获取失败");
                        }
                    }
                });
            },
            initForm: function () {
                var self = this;
                self.$inpId.ligerTextBox({width: 240});
                self.$myIndex.ligerTextBox({width: 240});
                self.$myType.ligerTextBox({width: 240});
                self.$quotaCode.ligerTextBox({width: 240});
                self.$quotaName.ligerTextBox({width: 240});
                self.$result.ligerTextBox({width: 240});
                self.$town.ligerTextBox({width: 240});
                self.$townName.ligerTextBox({width: 240});
                self.$org.ligerTextBox({width: 240});
                self.$orgName.ligerTextBox({width: 240});
                self.$slaveKey1.ligerTextBox({width: 240});
                self.$slaveKey1Name.ligerTextBox({width: 240});
                self.$slaveKey2.ligerTextBox({width: 240});
                self.$slaveKey2Name.ligerTextBox({width: 240});
                self.$slaveKey3.ligerTextBox({width: 240});
                self.$slaveKey3Name.ligerTextBox({width: 240});
                self.$slaveKey4.ligerTextBox({width: 240});
                self.$slaveKey4Name.ligerTextBox({width: 240});
                self.$economic.ligerTextBox({width: 240});
                self.$economicName.ligerTextBox({width: 240});
                self.$level.ligerTextBox({width: 240});
                self.$levelName.ligerTextBox({width: 240});
                self.$orgHealthCategoryPid.ligerTextBox({width: 240});
                self.$orgHealthCategoryId.ligerTextBox({width: 240});
                self.$orgHealthCategoryName.ligerTextBox({width: 240});
                self.$orgHealthCategoryCode.ligerTextBox({width: 240});
                self.$quotaDate.ligerTextBox({width: 240});
                self.$year.ligerTextBox({width: 240});
                self.$yearName.ligerTextBox({width: 240});
                self.$areaLevel.ligerTextBox({width: 240});
                self.$createTime.ligerTextBox({width: 240});
                self.$form.attrScan();
            },

            bindEvents: function () {
                var self = this;

                //新增/修改
                healthBusinessInfo.$updateBtn.click(function () {
                    var values = self.$form.Fields.getValues();
                    var data = JSON.stringify(values);
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                    dataModel.fetchRemote("${contextRoot}/elasticSearch/updateElasticSearch", {
                        data: {
                            id: id,
                            data: data,
                            index:myIndex,
                            type: myType
                        },
                        async: false,
                        type: 'post',
                        success: function (data) {
                            waittingDialog.close();
                            if (data.successFlg) {
                                closeZhiBiaoInfoDialog(function () {
                                    $.Notice.success('修改成功');
                                });
                            } else {
                                window.top.$.Notice.error(data.errorMsg);
                            }
                        }
                    });
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