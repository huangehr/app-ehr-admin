<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;

            // 表单校验工具类
            var jValidation = $.jValidation;

            var urls = {
                cdaDocument: '${contextRoot}/template/getCDAListByVersionAndKey',
                update: '${contextRoot}/template/update'
            }
            var addArchiveTplInfo = null;
            var mode = '${mode}';
            var model = ${model};
            var version = parent.getVersion();
            var msg = mode == 'new' ? '新增' : mode=='copy'? '复制' : "修改";
            var firstInit = true;
            /* ************************** 变量定义结束 **************************** */

            /* *************************** 函数定义 ******************************* */

            function pageInit() {
                addArchiveTplInfo.init();
            }

            /* ************************** 函数定义结束 **************************** */

            /* *************************** 模块初始化 ***************************** */

            addArchiveTplInfo = {
                $form: $("#div_addArchiveTpl_form"),
                $versionNo: $("#inp_versionNo"),
                $org: $("#inp_org"),
                $title: $("#inp_title"),

                versionNo: '',
                orgCode: '',
                cda: '',

                $dataset: $("#inp_dataset"),
                $addBtn: $("#div_add_btn"),
                $cancelBtn: $("#div_cancel_btn"),
                init: function () {
                    this.initForm();
                    this.bindEvents();
                },
                initForm: function () {
                    var self = this;
                    self.$title.ligerTextBox({width: 240});
                    this.initCombo(self.$dataset, urls.cdaDocument, {});
                    self.versionNo = self.$versionNo.ligerComboBox({
                        url: '${contextRoot}/adapter/versions',
                        valueField: 'version',
                        textField: 'versionName',
                        dataParmName: 'detailModelList',
                        width: 240,
                        onSelected: function (value) {
                            var parms = {
                                version: value,
                                searchName: ""
                            }
                            self.cda.reload(parms);
                            if(firstInit){
                                if(model.cdaDocumentId){
                                    self.cda.setValue(model.cdaDocumentId);
                                    self.cda.setText(model.cdaDocumentName);
                                }
                                firstInit = false;
                            }
                        }
                    });

                    this.$org.addressDropdown({
                        lazyLoad: mode!='new' || (mode=='new' && !Util.isStrEmpty(model.organizationCode)),
                        width: 240,
                        selectBoxWidth: 240,
                        tabsData: [
                            {name: '省份', code:'id',value:'name', url: '${contextRoot}/address/getParent', params: {level: '1'}},
                            {name: '城市', code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                            {
                                name: '医院', code:'orgCode',value:'fullName', url: '${contextRoot}/address/getOrgs', beforeAjaxSend: function (ds, $options) {
                                var province = $options.eq(0).attr('title'),
                                        city = $options.eq(1).attr('title');
                                ds.params = $.extend({}, ds.params, {
                                    province: province,
                                    city: city
                                });
                            }
                            }
                        ]
                    });

                    $('#inp_versionNo_wrap').addClass('u-ui-readonly');
                    if(mode=='new' && !Util.isStrEmpty(model.organizationCode))
                        $('#inp_org_wrap').addClass('u-ui-readonly');

                    this.$form.attrScan();

                    this.$form.Fields.fillValues({
                        id: model.id,
                        title: mode=='copy'? '': model.title,
//                            cdaVersion: model.cdaVersion,
                        organizationCode: [model.province, model.city, model.organizationCode]
                    });

                    var versionMgr = this.$versionNo.ligerGetComboBoxManager();
                    versionMgr.selectValue(version.v);
                    versionMgr.setText(version.n);

                    $('#oldTitle').val(model.title);
                    $('#inp_versionNo').focus();

                    var staged = $.Util.getUrlQueryString('staged');
                    debugger
                    if (Boolean.valueOf(staged)){
                        this.$addBtn.hide();
                    }
                },
                initCombo : function (target, url, parms, value, text, parentValue){
                    this.cda = target.customCombo(url, parms);
                    if(!Util.isStrEmpty(value)){
                        this.cda.setValue(value);
                        this.cda.setText(text);
                    }
                },
                bindEvents: function () {
                    var self = this;
                    var validator = new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                            var oldTitle =$('#oldTitle').val();
                            var values = addArchiveTplInfo.$form.Fields.getValues();
                            var newTitle = values.title;
                            var version = values.cdaVersion;
                            var orgCode = values.organizationCode.keys[2];
                            if(mode=='modify'&&Util.isStrEquals(oldTitle,newTitle)){
                                return true;
                            }else{
                                if(Util.isStrEmpty(orgCode))
                                    return true;
                                return checkTitle(elm, version, newTitle, orgCode);
                            }
                        }
                    })

                    function checkTitle(elm,version,newTitle,orgCode){
                        if(Util.isStrEquals($(elm).attr('id'),'inp_title')){
                            var result = new jValidation.ajax.Result();
                            var dataModel = $.DataModel.init();
                            dataModel.fetchRemote("${contextRoot}/template/validateTitle", {
                                data: {version:version,title: newTitle, orgCode: orgCode},
                                async: false,
                                success: function (data) {
                                    if (data.successFlg) {
                                        result.setResult(false);
                                        result.setErrorMsg('当前版本下，该模板名称已存在！');
                                    } else {
                                        result.setResult(true);
                                    }
                                }
                            });
                            return result;
                        };
                    }
                    self.$addBtn.click(function () {
                        if (validator.validate()) {
                            var TemplateModel = self.$form.Fields.getValues();
                            TemplateModel.organizationCode = TemplateModel.organizationCode.keys[2];
                            var dataModel = $.DataModel.init();

                            dataModel.createRemote(urls.update, {
                                data: {
                                    id: TemplateModel.id,
                                    model: JSON.stringify(TemplateModel),
                                    extParms: '{"mode":"'+mode+'"}'
                                },
                                async: false,
                                success: function (data) {
                                    if (data.successFlg) {
                                        $.Notice.success( msg + '成功');
                                        parent.reloadGrids();
                                        parent.closeDialog();
                                    } else if(data.errorMsg){
                                        $.Notice.error(data.errorMsg);
                                    }else {
                                        $.Notice.error( msg + '失败');
                                    }
                                },
                                error: function (data) {
                                    $.Notice.error( msg + '失败');
                                }
                            });
                        }
                    });

                    self.$cancelBtn.click(function () {
                        parent.closeDialog();
                    });
                }

            };

            /* ************************* 模块初始化结束 ************************** */

            /* *************************** 页面初始化 **************************** */

            pageInit();

            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>