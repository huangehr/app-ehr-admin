<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
//        $(function () {
            /* ************************** 变量定义 ******************************** */
            var versionNum = '${versionNum}';
            var versionCode = '${versionCode}';
            var orgCode = '${orgCode}';
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
            var version = getVersion();
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
                $type: $("#inp_type"),
                $title: $("#inp_title"),

                versionNo: '',
                orgCode: '',
                cda: '',
                category:'',
                name:'',


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
                    <%--self.versionNo = self.$versionNo.ligerComboBox({--%>
                    <%--url: '${contextRoot}/adapter/versions',--%>
                    <%--valueField: 'version',--%>
                    <%--textField: 'versionName',--%>
                    <%--dataParmName: 'detailModelList',--%>
                    <%--width: 240,--%>
                    <%--onSelected: function (value) {--%>
                    <%--var parms = {--%>
                    <%--version: value,--%>
                    <%--searchName: ""--%>
                    <%--}--%>
                    <%--self.cda.reload(parms);--%>
                    <%--if(firstInit){--%>
                    <%--if(model.cdaDocumentId){--%>
                    <%--self.cda.setValue(model.cdaDocumentId);--%>
                    <%--self.cda.setText(model.cdaDocumentName);--%>
                    <%--}--%>
                    <%--firstInit = false;--%>
                    <%--}--%>
                    <%--}--%>
                    <%--});--%>
                    self.versionNo = self.$versionNo.ligerTextBox({width: 240,disabled:true});
                    self.versionNo.setValue(versionNum);

                    this.initCombo(self.$dataset, urls.cdaDocument, {
                        version: versionCode
                    });
                    self.$type.ligerComboBox({
                        width : 240,
                        valueField: 'id',
                        textField: 'text',
                        data:[
                            { text: '门诊', id: 'clinic' },
                            { text: '住院', id: 'resident'},
                            { text: '体检', id: 'medicalExam'},
                            { text: '通用', id : 'universal'}
                        ],
                        onSelected: function (value ,text){
                           this.category = value;
                        }
                    });
                    $('#inp_versionNo_wrap').addClass('u-ui-readonly');
                    if(mode=='new' && !Util.isStrEmpty(model.type))
//                        $('#inp_org_wrap').addClass('u-ui-readonly');
//                    this.$form.liger.get('div_addArchiveTpl_form');
                        this.$form.ligerForm();//初始化表单
                    this.$form.attrScan();
                    this.$form.Fields.fillValues({
                        id: model.id,
                        title: mode == 'copy'? '': model.title,
//                            cdaVersion: model.cdaVersion,
                        type: model.type
                    });
                    $("#inp_dataset").ligerGetComboBoxManager().setValue(model.cdaDocumentId);
                    $("#inp_dataset").ligerGetComboBoxManager().setText(model.cdaDocumentName);

                    self.name = model.cdaDocumentName;
//                    var versionMgr = this.$versionNo.ligerGetTextBoxManager();
//                    versionMgr.selectValue(version.v);
//                    versionMgr.setText(version.n);

                    $('#oldTitle').val(model.title);
                    $('#inp_versionNo').focus();
                    if (!${staged}){
                        this.$addBtn.hide();
                    }
                },
                initCombo : function (target, url, parms, value, text, parentValue){
                    this.cda = target.customCombo(url, parms,function (value,text) {
                        addArchiveTplInfo.name = text;
                    });
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
                            var orgCode = values.type;
                            if(mode=='modify'&&Util.isStrEquals(oldTitle,newTitle)){
                                return true;
                            }else{
                                if(Util.isStrEmpty(orgCode))
                                    return true;
                                return checkTitle(elm, version, newTitle);
                            }
                        }
                    })

                    function checkTitle(elm,version,newTitle){
                        if(Util.isStrEquals($(elm).attr('id'),'inp_title')){
                            var result = new jValidation.ajax.Result();
                            var dataModel = $.DataModel.init();
                            dataModel.fetchRemote("${contextRoot}/template/validateTitle", {
                                data: {version:version,title: newTitle},
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
                        debugger
                        if (validator.validate()) {
                            var TemplateModel = self.$form.Fields.getValues();
                            TemplateModel.type = TemplateModel.type;
                            var dataModel = $.DataModel.init();
//                            TemplateModel['type'] = TemplateModel.type;
                            TemplateModel.cdaVersion = versionCode;
                            var parmes = $.extend({},TemplateModel,{cdaDocumentName:addArchiveTplInfo.name});
                            dataModel.createRemote(urls.update, {
                                data: {
                                    id: TemplateModel.id,
                                    model: JSON.stringify(parmes),
                                    extParms: '{"mode":"'+mode+'"}'
                                },
                                async: false,
                                success: function (data) {
                                    if (data.successFlg) {
                                        $.Notice.success( msg + '成功');
                                        reloadGrids();
                                        closeDialog();
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
                        closeDialog();
                    });
                }

            };

            /* ************************* 模块初始化结束 ************************** */

            /* *************************** 页面初始化 **************************** */

            pageInit();

            /* ************************* 页面初始化结束 ************************** */
//        });
    })(jQuery, window);
</script>