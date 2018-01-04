<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var retrieve = null;
            var master = null;

            var settledWayDictId = 8;
            var orgTypeDictId = 7;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid(url, params) {
                this.grid.setOptions({parms: params});
                this.grid.loadData(true);
            }

            //添加碎片
            function appendNav(str, url, data) {
                $('#navLink').append('<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
            }
            function onUploadSuccess(g, result){
                if(result)
                    openDialog("${contextRoot}/orgImport/gotoImportLs", "导入错误信息", 1000, 640, {result: result});
                else
                    $.Notice.success("导入成功！");
            }
            $('#upOrg').uploadFile({url: "${contextRoot}/orgImport/importOrg", onUploadSuccess: onUploadSuccess, str: '导入机构'});
            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchParm: $('#inp_search'),
                $settledWay: $('#inp_settledWay'),
                $orgType: $('#inp_orgType'),
                $searchBtn: $('#btn_search'),
                $newRecordBtn: $('#div_new_record'),
                $location: $('#inp_orgArea'),

                addOrgInfoDialog: null,
                orgDataGrantDialog:null,

                init: function () {
                    this.initDDL(settledWayDictId, this.$settledWay);
                    this.initDDL(orgTypeDictId, this.$orgType);

                    this.$searchParm.ligerTextBox({width: 240});

                    this.$location.addressDropdown({
                        tabsData: [
                            {
                                name: '省份',
                                code: 'id',
                                value: 'name',
                                url: '${contextRoot}/address/getParent',
                                params: {level: '1'}
                            },
                            {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                            {name: '县区', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'}
                        ],
                        placeholder:"请选择地区"
                    });
                    this.bindEvents();

                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },
                initDDL: function (dictId, target) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();

                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList", {
                        data: {dictId: dictId},
                        success: function (data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                width: '180',
                                data: [].concat(data.detailModelList)
                            });
                        }
                    });
                },
                bindEvents: function () {
                    var self = this;
                    self.$searchBtn.click(function () {
                        master.grid.options.newPage = 1;
                        master.reloadGrid();
                    });
                    self.$newRecordBtn.click(function () {
                        self.addOrgInfoDialog = parent._LIGERDIALOG.open({
                            height: 580,
                            width: 1050,
                            title: '新增机构信息',
                            url: '${contextRoot}/organization/dialog/create',
                            isHidden: false,
                            opener: true,
                            load:true,
                            isDrag:true,
                            show:false,
                        })
                    });
                }
            };
            master = {
                orgInfoDialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_org_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/organization/searchOrgs',
                        parms: {
                            searchParm: '',
                            searchType: '',
                            orgType: '',
                            province: '',
                            city: '',
                            district: ''
                        },
                        columns: [
                            {display: '机构类型', name: 'orgTypeName', width: '6%', align: "left"},
                            {display: '机构代码', name: 'orgCode', width: '8%', align: "left"},
                            {display: '机构全名', name: 'fullName', width: '15%', align: "left"},
                            {display: '联系人', name: 'admin', width: '7%', align: "left"},
                            {display: '联系方式', name: 'tel', width: '8%', align: "left"},
                            {display: '机构地址', name: 'locationStrName', width: '18%', align: "left"},
                            {
                                display: '是否生/失效',
                                name: 'activityFlagName',
                                width: 85,
                                isAllowHide: false,
                                render: function (row) {
                                    var html = '';
                                    if (row.activityFlag == 1) {
                                        html += '<sec:authorize url="/organization/activity"><a class="grid_on" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "org:orgInfoDialog:activityFlg", row.orgCode, '1','失效') + '"></a></sec:authorize>';

                                    } else {
                                        html += '<sec:authorize url="/organization/activity"><a class="grid_off" title="未生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "org:orgInfoDialog:activityFlg", row.orgCode, '0','生效') + '"></a></sec:authorize>';

                                    }
                                    return html;
                                }
                            },
                            {display: '入驻方式', name: 'settledWayName', width: '0.1%',hide: true, isAllowHide: false},
                            {
                                display: '操作', name: 'operator', minWidth: 286, render: function (row) {
                                var html = '';
                                <%--html += '<sec:authorize url="/organization/resource/initial"><a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "org:resource:list", row.orgCode,row.id, row.fullName) + '">视图授权</a></sec:authorize>';--%>
                                html += '<sec:authorize url="/organization/upAndDownOrg"><a class="label_a"  style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "org:orgInfoDialog:deptMember", row.orgCode, row.id, row.fullName,row.orgType) + '">部门管理</a></sec:authorize>';
                                html += '<sec:authorize url="/organization/upAndDownMember"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "org:orgInfoDialog:upAndDownMember", row.orgCode, row.id, row.fullName) + '">人员关系</a></sec:authorize>';
                                html += '<sec:authorize url="/orgTemplate/initial"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "org:orgInfoDialog:modelConfig", row.orgCode, row.orgTypeName, row.fullName) + '">模板配置</a></sec:authorize>';
                                html += '<sec:authorize url="/organization/dialog/orgInfo"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "org:orgInfoDialog:modify", row.orgCode, 'modify') + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/organization/delete"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "org:orgInfoDialog:del", row.orgCode, 'del') + '"></a></sec:authorize>';
                                return html;
                            }
                            },
                            {name: 'activityFlag', hide: true, width: '0.1%', align: "center"},
                            {name: 'settledWay', hide: true, width: '0.1%', align: "center"}
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        onDblClickRow: function (row) {
                            var mode = 'view';
                            var wait = parent._LIGERDIALOG.waitting("请稍后...");
                            row.orgInfoDialog = parent._LIGERDIALOG.open({
                                height: 600,
                                width: 1050,
                                title: '机构基本信息',
                                url: '${contextRoot}/organization/dialog/orgInfo',
                                load: true,
                                urlParms: {
                                    orgCode: encodeURIComponent(row.orgCode),
                                    mode: mode
                                },
                                isHidden: false,
                                show: false,
                                onLoaded:function() {
                                    wait.close(),
                                    row.orgInfoDialog.show()
                                }
                            });
                            row.orgInfoDialog.hide();
                        }
                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                    this.bindEvents();
                },
                activity: function (orgCode, activityFlag) {
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/organization/activity', {
                        data: {orgCode: orgCode, activityFlag: activityFlag},
                        success: function (data) {
                            if (data.successFlg) {
                                master.reloadGrid();
                            }
                        }
                    });
                },
                reloadGrid: function () {
                    retrieve.$element.attrScan();
                    var orgAddress = retrieve.$element.Fields.location.getValue();
                    var values = $.extend({}, retrieve.$element.Fields.getValues(),
                            {province: (orgAddress.names[0] == null ? '' : orgAddress.names[0])},
                            {city: (orgAddress.names[1] == null ? '' : orgAddress.names[1])},
                            {district: (orgAddress.names[2] == null ? '' : orgAddress.names[2])});

                    reloadGrid.call(this, '${contextRoot}/organization/searchOrgs', values);
                },
                delRecord: function (orgCode) {
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/organization/deleteOrg", {
                        data: {orgCode: orgCode},
                        success: function (data) {
                            if (data.successFlg) {
                                parent._LIGERDIALOG.success('操作成功。');
                                master.reloadGrid();
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        }
                    });
                },
                bindEvents: function () {
                    var self = this;
                    $.subscribe('org:orgInfoDialog:modify', function (event, orgCode, mode) {
                        var title = '修改机构信息';
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        self.orgInfoDialog = parent._LIGERDIALOG.open({
                            isHidden: false,
                            height: 600,
                            width: 1050,
                            title: title,
                            url: '${contextRoot}/organization/dialog/orgInfo',
                            load: true,
                            urlParms: {
                                orgCode: encodeURIComponent(orgCode),
                                mode: mode
                            },
                            show: false,
                            onLoaded:function() {
                                wait.close(),
                                self.orgInfoDialog.show()
                            }
                        });
                        self.orgInfoDialog.hide();
                    });
                    $.subscribe('org:orgInfoDialog:activityFlg', function (event, orgCode, activityFlg,msg) {
                        parent._LIGERDIALOG.confirm('是否对该机构进行'+msg+'操作', function (yes) {
                            if (yes) {
                                self.activity(orgCode, activityFlg);
                            }
                        });

                    });
                    $.subscribe('org:orgInfoDialog:del', function (event, orgCode, activityFlg) {
                        parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                            if (yes) {
                                self.delRecord(orgCode);
                            }
                        });

                    });
                    $.subscribe('org:orgInfoDialog:modelConfig', function (event, orgCode, orgType, orgName) {
                        var url = '${contextRoot}/template/initial?treePid=1&treeId=12';
                        var orgData = {
                            orgCode: orgCode,
                            orgType: orgType,
                            orgName: orgName
                        }
                        appendNav("模板配置", url, {'dataModel': JSON.stringify(orgData)});
                    });
                    $.subscribe('org:orgInfoDialog:deptMember', function (event, orgCode, orgId, orgName,orgType) {
                        var url = '${contextRoot}/deptMember/initialDeptMember';
                        var orgData = {
                            mode:'',
                            orgCode: orgCode,
                            orgId: orgId,
                            orgName: orgName,
                            orgType:orgType
                        }
                        appendNav("部门管理", url, orgData);
                    });
                    //视图授权页面跳转
                    $.subscribe('org:resource:list', function (event, orgCode, orgId,orgName) {
//					rolesMaster.savePageParamsToSession();
                        var data = {
                            'orgCode':orgCode,
                            'orgId':orgId,
                            'orgName':orgName,
                            'categoryIds':'',
                            'sourceFilter':'',
                        }
                        var url = '${contextRoot}/organization/resource/initial?';
                        $("#contentPage").empty();
                        $("#contentPage").load(url,{backParams:JSON.stringify(data)});
                    });

                    $(document).on('click', '.go-back', function () {
                        win.location.reload();
                    });
                    $.subscribe('org:orgInfoDialog:upAndDownMember', function (event, orgCode, orgId, orgName) {
                        var url = '${contextRoot}/upAndDownMember/initialUpAndDownMember';
                        var orgData = {
                            orgCode: orgCode,
                            orgId: orgId,
                            orgName: orgName
                        }
                        appendNav("人员关系", url, orgData);
                    });
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeDialog = function () {
                master.orgInfoDialog.close();
            };
//            win.parent.showAddOrgInfoDialogSuccPop = function () {
//                parent._LIGERDIALOG.success('保存成功');
//            };
            win.parent.closeAddOrgInfoDialog = function (callback) {
                if (callback) {
                    callback.call(win);
                    master.reloadGrid();
                }
                if (!Util.isStrEmpty(retrieve.addOrgInfoDialog)){
                    retrieve.addOrgInfoDialog.close();
                }else {
                    master.orgInfoDialog.close();
                }

            };
            win.closeOrgCreateDialog = function (callback) {
                if (callback) {
                    callback.call(win);
                    master.reloadGrid();
                }
                    master.orgCreateDialog.close();

            };
            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>