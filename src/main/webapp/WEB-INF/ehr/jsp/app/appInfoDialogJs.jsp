<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var appInfoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
		var catalogDictId = 1;
		var statusDictId = 2;
		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            appInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        var trees;
        appInfoForm = {
			$form: $("#div_app_info_form"),
			$name: $("#inp_app_name"),
            $code: $("#inp_app_code"),
			$orgCode:$('#inp_org_code'),
			$catalog: $("#inp_dialog_catalog"),
			$status: $("#inp_dialog_status"),
			$tags: $("#inp_tags"),
			$appId: $("#inp_app_id"),
			$secret: $("#inp_app_secret"),
			$url: $("#inp_url"),
			$description: $("#inp_description"),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $jryycyc:$("#jryycyc"),//cyctodo
            init: function () {
                this.cycToDo()//复制完记得删掉阿亮
                $('.listree a').hide();
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$name.ligerTextBox({width:240});
				this.initDDL(catalogDictId, this.$catalog);
				this.initDDL(statusDictId, this.$status);
				this.$orgCode.customCombo('${contextRoot}/organization/orgCodes',{})
                this.$tags.ligerTextBox({width:240});
				this.$code.ligerTextBox({width:240});
				this.$appId.ligerTextBox({width:240});
				this.$secret.ligerTextBox({width:240});
				this.$url.ligerTextBox({width:240, height: 50 });
                this.$description.ligerTextBox({width:240, height: 120 });
                var mode = '${mode}';
				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					appInfoForm.$form.addClass('m-form-readonly');
                    $('#div_app_info_form textarea').attr("disabled","disabled");
                    $(".m-form-control .l-text-trigger-cancel").remove();
					$("#btn_save").hide();
					$("#btn_cancel").hide();
					//$("input,select", this.$form).prop('disabled', false);
				}
                this.$form.attrScan();
                if(mode !='new'){
                    var app = ${model};
                    this.$form.Fields.fillValues({
						sourceType: app.sourceType,
                        name:app.name,
                        catalog: app.catalog,
                        status:app.status,
                        tags:app.tags,
                        id:app.id,
                        secret:app.secret,
                        url:app.url,
                        description:app.description,
                        code: app.code
                    });
					$("#inp_org_code").ligerGetComboBoxManager().setValue(app.org);
					$("#inp_org_code").ligerGetComboBoxManager().setText(app.orgName);
                    if(app.roleJson){
                        var roleArr = eval('('+ app.roleJson +')');
                        for(var k in roleArr){
                            $("#"+ k, trees.tree).find(".l-checkbox").click()
                        }
                    }
                }
                this.$form.show();
            },
            initDDL: function (dictId, target) {
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value'
                });
            },
            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
                    onElementValidateForAjax:function(elm){
                    }
                });
                this.$btnSave.click(function () {
                    if(validator.validate()){
                        var role = '';
                        var roleDom = $(".listree li a");
                        $.each(roleDom, function (i, v) {
                            role += ',' + $(v).attr('data-id');
                        })
                        role = role.length>0? role.substring(1) : role;
                        if('${mode}' == 'new'){
                            var values = self.$form.Fields.getValues();
                            values.role = role;
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/createApp",{data: $.extend({}, values),
                                success: function(data) {
                                    if (data.successFlg) {
                                        win.parent.closeDialog(function () {
                                        });
                                    } else {
                                        window.top.$.Notice.error(data.errorMsg);
                                    }
                                }});
                        }else{
                            var values = self.$form.Fields.getValues();
                            values.role = role;
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/updateApp",{data: $.extend({}, values),
                                success: function(data) {
                                    if (data.successFlg) {
                                        win.parent.closeDialog(function () {
                                        });
                                    } else {
                                        window.top.$.Notice.error(data.errorMsg);
                                    }
                                }});
                        }
                    }else{
                        return;
                    }
                });

                this.$btnCancel.click(function () {
					win.closeDialog();
                });
            },
            cycToDo:function(){
                var treeData;
                $.ajax({
                    dataType: 'json',
                    async: false,
                    url: '${contextRoot}/app/roles/tree',
                    success: function (data) {
                        treeData = data.detailModelList;
                    }
                })
                var self=this;
                trees=self.$jryycyc.ligerComboBox({
                    width : 240,
                    selectBoxWidth: 238,
                    selectBoxHeight: 500, textField: 'text', treeLeafOnly: false,
                    tree: {
                        data: treeData, idFieldName:'id', textFieldName: 'name', onClick:function(e){
                        self.listTree(trees);
                    }}
                })

                function removeSclBox(){
                    setTimeout(function(){
                        $(trees.tree).prev(".mCustomScrollBox").hide()
                    },100)
                }
                self.$jryycyc.on("click", removeSclBox);
                $('#roleDiv div.l-trigger-icon').on("click",removeSclBox);
                self.listTreeClick(trees);
            },//树形结构todo
            listTree:function(trees){
                var self=this;
                var dataAll=trees.treeManager.data//获取所有选中的值
                var dateTreeEd=trees.treeManager.getChecked()//获取所有选中的值
                var liHtml="";//li拼接
                var obj=self.$jryycyc.closest(".m-form-group");//父容器
                $.each(dateTreeEd,function(i,v){
                    if((v.data.children==undefined || v.data.children.length<=0) &&  v.data.type!=0){
                        var parentText = $(trees.treeManager.getParentTreeItem( trees.treeManager.getNodeDom(v))).find('.l-body:first').find('span').html();
                        tit = parentText+":"+v.data.name
                        liHtml+='<li ><a href="javascript:void(0);" data-id="'+v.data.id+'"  data-index="'+v.data.treedataindex+'" >X</a>'+tit+'</li>';
                    }
                })
                if(obj.find(".listree").length==0){
                    obj.append('<div class="listree"></div>')
                }
                $(".listree").html(liHtml);

            },listTreeClick:function(trees){
                $("body").delegate(".listree a","click",function(){
                    $("li#"+$(this).attr("data-id"), trees.tree).find(".l-checkbox").click()
                })//删除操作
            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>