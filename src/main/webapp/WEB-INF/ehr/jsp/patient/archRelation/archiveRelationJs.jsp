<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var dictId = 65;
			var isFirstPage = true;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }
			function reloadGrid (params) {
				if (isFirstPage){
					this.grid.options.newPage = 1;
				}
				this.grid.setOptions({parms: params});
				this.grid.loadData(true);
				isFirstPage = true;
			}

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchOrg: $('#inp_org'),
                $searchProfileId: $('#inp_profileId'),
                $searchName: $('#inp_name'),
                $searchStatus: $('#ipt_status'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),

                init: function () {
                    this.initDDL(dictId, $('#ipt_status'));
					this.$searchProfileId.ligerTextBox({width: 140});
                    this.$searchName.ligerTextBox({width: 140});
                    this.$searchOrg.ligerTextBox({width: 170});

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
                                width: '100',
                                data: [].concat(data.detailModelList)
                            });
                        }
                    });
                }
            };

            master = {
                archiveRelativeInfoDialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_archiveRelative_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/userCards/searchArchiveRelation',
                        parms: {
                            orgIdOrOrgName: '',
                            nameOrIdCard: '',
                            profileId:'',
                            status: ''
                        },
                        columns: [
                            { display: '机构编码',name: 'orgCode', width: '8%',isAllowHide: false},
                            { display: '机构名称',name: 'orgName', width: '8%',isAllowHide: false},
                            { display: '姓名', name: 'name', width: '5%', minColumnWidth: 60,},
                            { display: '身份证号码', name: 'idCardNo', width: '12%', minColumnWidth: 60,},
                            { display: '就诊卡类别',name: 'cardTypeName', width: '5%',isAllowHide: false},
                            { display: '卡号',name: 'cardNo', width: '8%',isAllowHide: false},
                            { display: '就诊事件号',name: 'eventNo', width: '8%',isAllowHide: false},
                            { display: '就诊时间',name: 'eventDate', width: '8%',isAllowHide: false},
                            { display: '就诊类型', name: 'eventType',width: '5%',render:function(row){
                                if (Util.isStrEquals(row.eventType,'0')) {
                                    return '门诊';
                                } else if (Util.isStrEquals(row.eventType,'1')) {
                                    return '住院';
                                }else if (Util.isStrEquals(row.eventType,'2')) {
                                    return '体检';
                                }else{
                                    return '未审核';
                                }
                            }
                            },
                            { display: '关联档案号', name: 'profileId',width: '8%', align:'left' },
                            { display: '关联档案ID', name: 'applyId',width: '8%', align:'left' },
                            { display: '关联状态', name: 'status',width: '8%',render:function(row){
                                if (Util.isStrEquals(row.status,'0')) {
                                    return '未关联';
                                } else {
                                    return '已关联';
                                }
                            }
                            },
                            { display: '操作', name: 'operator', width: '12%', render: function (row) {
                                var html = '';
                                html += '<sec:authorize url="/userCards/archiveRelationInfo"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "userCards/archiveRelationInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
                                html += '<sec:authorize url="/userCards/del"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "userCards/archiveRelationInfo:delete", row.id) + '"></a></sec:authorize>';
                                return html;
                            }}
                        ],
						pageSize:20,
						enabledSort:true,
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false

                    }));

                    this.bindEvents();
                    this.grid.adjustToWidth();
                },

                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
                },

                bindEvents: function () {
					//检索按钮
					retrieve.$searchBtn.click(function () {
						master.reloadGrid();
					});

                    //新增按钮
                    retrieve.$addBtn.click(function(){
                        $.publish("userCards/archiveRelationInfo:open",['','new']);
                    });
                    //新增、修改、查看统一定制方法
                    $.subscribe('userCards/archiveRelationInfo:open',function(event,id,mode){
                        isFirstPage = false;
                        var title = '';
                        if(mode == 'modify'){title = '修改档案关联信息';};
                        if(mode == 'new'){title = '新增档案关联信息';};
                        if(mode == 'view'){title = '查看档案关联信息';}
                        master.archiveRelativeInfoDialog = $.ligerDialog.open({
                            height:540,
                            width: 550,
                            title : title,
                            url: '${contextRoot}/userCards/archRelationInfoInitial',
                            urlParms: {
                                id: id,
                                mode:mode
                            },
                            isHidden: false,
                            opener: true,
                            load:true
                        });
                    });

                    //删除
                    $.subscribe('userCards/archiveRelationInfo:delete',function(event,id){
                        isFirstPage = false;
                        $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                            if (yes) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/userCards/deleteArchiveRelation', {
                                    data: {id: id},
                                    success: function (data) {
                                        if (data.successFlg) {
                                            $.Notice.success('操作成功。');
                                            master.reloadGrid();
                                        } else {
                                            $.Notice.open({type: 'error', msg: '操作失败。'});
                                        }
                                    }
                                });
                            }
                        });
                    });

                },
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.closeDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.archiveRelativeInfoDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>