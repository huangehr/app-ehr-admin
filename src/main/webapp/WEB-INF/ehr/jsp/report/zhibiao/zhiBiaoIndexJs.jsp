<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/mousepop/mouse_pop.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            var urls = {
                gotoImportLs: "${contextRoot}/tjQuota/import"
            }
            var Util = $.Util;
            var retrieve = null;
            var isFirstPage = true;
            var dictMaster = null;
            var typeTree = null;
            var orgId = '${orgId}';
            var quotaType = '${quotaTypeNo}';
            var searchVal = '${name}';

            var rsPageParams = JSON.parse(sessionStorage.getItem('rsPageParams'));
            sessionStorage.removeItem('rsPageParams');
            var searchParams = {
                quotaType:rsPageParams&&rsPageParams.quotaType || '',
                categorySearchNm:rsPageParams &&rsPageParams.categorySearchNm || '',
                resourceSearchNm:rsPageParams&&rsPageParams.resourceSearchNm || '',
                page:rsPageParams&&rsPageParams.page || 1,
                pageSize:rsPageParams&&rsPageParams.pageSize || 15,
            }

            //添加碎片
            function appendNav(str, url, data) {
                $('#navLink').append('<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
            }

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                dictMaster.init();
            }

            function reloadGrid(params) {
                if (isFirstPage){
                    dictMaster.resourceInfoGrid.options.newPage = 1;
                }
                if(searchParams.page >1){
                    dictMaster.resourceInfoGrid.options.newPage = searchParams.page;//只针对跳转页面返回时
                    searchParams.page = 1;//重置
                }
                dictMaster.resourceInfoGrid.setOptions({parms: params});
                dictMaster.resourceInfoGrid.loadData(true);
                isFirstPage = true;
            };

            <%--function onUploadSuccess(g, result){--%>
                <%--if(result)--%>
                    <%--openDialog(urls.gotoImportLs, "导入错误信息", 1000, 640, {result: result});--%>
                <%--else--%>
                    <%--parent._LIGERDIALOG.success("导入成功！");--%>
            <%--}--%>
            <%--$('#upd').uploadFile({url: "${contextRoot}/tjQuota/import", onUploadSuccess: onUploadSuccess});--%>

            //由跳转页面返回成员注册页面时的页面初始化-------------
            function treeNodeInit (id){
                if(!id){return}
                function expandNode (id){
                    var level = $($('#'+id).parent()).parent().attr('outlinelevel')
                    if(level){
                        var parentId = $($('#'+id).parent()).parent().attr('id')
                        $($($('#'+id).parent()).prev()).children(".l-expandable-close").click()//展开节点
                        expandNode(parentId);
                    }
                }
                expandNode(id);
                typeTree.selectNode(id);
            };

            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                typeTree: null,
                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $searchModel: $(".div_search_model"),
                $resourceInfoGrid: $("#div_resource_info_grid"),
                $status:$('#inp_status'),
                $search: $("#inp_search"),
                $searchNm: $('#inp_searchNm'),

                init: function () {
                    var self = this;
                    $('#div_tree').mCustomScrollbar({
                        axis:"yx"
                    });
                    self.getResourceBrowseTree();
                },

                getResourceBrowseTree: function () {
                    typeTree = this.$resourceBrowseTree.ligerSearchTree({
                        nodeWidth: 240,
                        url: '${contextRoot}/quota/getQuotaCategoryListTree',
                        checkbox: false,
                        idFieldName: 'id',
                        parentIDFieldName :'parentId',
                        textFieldName: 'name',
                        isExpand: false,
                        childIcon:null,
//                        data: $("#quotaTypeNo").val(),
                        parentIcon:null,
                        onSelect: function (e) {
                            quotaType = e.data.id;
                            dictMaster.reloadGrid(1);
                        },
                        onSuccess: function (data) {
                            if(data.length != 0){
                                $("#div_resource_browse_tree li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
//                                quotaType = data[0].id;
//                                dictMaster.reloadGrid(1);
                            }
                            if (quotaType) {
                                $('#'+quotaType).parent().prev().find('.l-box').trigger('click');
                                $('#'+quotaType).trigger('click');
                            }
                        }
                    });
                },
            };

            dictMaster = {
                dictInfoDialog: null,
                detailDialog:null,
                chartConfigDialog: null,
                extractDialog: null,
                grid: null,
                $searchNm: $('#searchNm'),
                init: function () {
                    var self = this;
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadGrid(1);
                        }
                    });
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        this.grid = $("#div_stdDict_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/tjQuota/getTjQuota',
                            parms: {
                                name: $("#searchNm").val(),
                                quotaType : quotaType
                            },
                            columns: [
                                {display: 'id', name: 'id', hide: true},
                                {display: '编码', name: 'code', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '统计方式', name: 'resultGetType', width: '7%', isAllowHide: false, align: 'center',
                                    render: function (row) {
                                        var value = row.resultGetType,
                                                name = '';
                                        if (value === '1') {
                                            name = '基础统计'
                                        }else if (value === '2') {
                                            name = '二次统计'
                                        }
                                        return name;
                                    }
                                },
                                {display: 'cron表达式', name: 'cron', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '执行时间', name: 'execTime', width: '14%', isAllowHide: false, align: 'left'},
                                {display: '执行方式', name: 'execTypeName', width: '7%', isAllowHide: false, align: 'center'},
                                {display: '状态', name: 'status', width: '5%', isAllowHide: false, align: 'center',
                                    render: function (row) {
                                        var sta = row.status,
                                            str = '';
                                        if (sta == '-1') {
                                            str = '已删除'
                                        }else if (sta == '0') {
                                            str = '不可用'
                                        }else if (sta == '1') {
                                            str = '正常'
                                        }
                                        return str;
                                    }
                                },
                                {display: '操作', name: 'operator', minWidth: 400, align: 'center',
                                    render: function (row) {
                                        var html = '';
                                        html += '<sec:authorize url="/tjQuota/updateDimensionTjQuota"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:weidu:config", row.code) + '">维度配置</a></sec:authorize>';
                                        html += '<sec:authorize url="/tjQuota/updateChartTjQuota"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:tubiao:config", row.code, row.name) + '">图表配置</a></sec:authorize>';
                                        html += '<sec:authorize url="/tjQuota/updateTjQuota"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a></sec:authorize>';
                                        if(row.status != -1){
                                            html += '<sec:authorize url="/tjQuota/deleteTjQuota"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a></sec:authorize>';
                                            /*
                                            由于初始执行是全量统计，数据量太大很耗时，故指定时间范围做增量统计比较妥当。
                                            暂定隐藏【初始执行】按钮。 -- 张进军 2018.1.16
                                            */
                                            <%--if(row.isInitExec == 0){--%>
                                                <%--html += '<sec:authorize url="/tjQuota/firstExecuteQuota"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:firstExecuteQuota", row.id, row.code) + '">初始执行</a></sec:authorize>';--%>
                                            <%--} else {--%>
                                            html += '<sec:authorize url="/tjQuota/executeTjQuota"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "zhibiao:execu", row.id, row.code, row.execType) + '">执行指标</a></sec:authorize>';
//                                            }
                                        }
                                        html += '<sec:authorize url="/tjQuota/queryTjQuotaResult"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:result:selectResult", row.id,row.code) + '">结果查询</a></sec:authorize>';
                                        html += '<sec:authorize url="/tjQuota/queryTjQuotaLog"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:log:quotaLog", row.code) + '">日志查询</a></sec:authorize>';
                                        return html;
                                    }
                                }
                            ],
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false
                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },
                reloadGrid: function (curPage) {
                    var searchNm = $("#searchNm").val();
                    searchVal = searchNm;
                    var values = {
                        name: searchNm,
                        quotaType : quotaType
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/tjQuota/getTjQuota', values, curPage);
                },
                bindEvents: function () {
                    $.subscribe('zhibiao:zhiBiaoInfo:open', function (event, id, mode) {
                        var title = '';
                        if (mode == 'modify') {
                            title = '修改指标';
                        }
                        else {
                            title = '新增指标';
                        }
                        isSaveSelectStatus = true;
                        dictMaster.dictInfoDialog = parent._LIGERDIALOG.open({
                            height: 650,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/tjQuota/getPage',
                            urlParms: {
                                id: id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('zhibiao:zhiBiaoGrid:delete', function (event, id) {
                        parent._LIGERDIALOG.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/tjQuota/deleteTjDataSave', {
                                    data: {tjQuotaId: parseInt(id)},
                                    success: function (data) {
                                        if(data.successFlg){
                                            parent._LIGERDIALOG.success('删除成功！');
                                            dictMaster.reloadGrid(Util.checkCurPage.call(dictMaster.grid, 1));
                                        }else{
                                            parent._LIGERDIALOG.error(data.errorMsg);
                                        }
                                    }
                                });
                            }
                        })
                    });

                    $.subscribe('zhibiao:weidu:config', function (event, code) {
                        dictMaster.detailDialog = parent._LIGERDIALOG.open({
                            title:'维度配置',
                            height: 625,
                            width: 800,
                            url: '${contextRoot}/zhibiao/zhiBiaoDetail',
                            isHidden: false,
                            opener: true,
                            load: true,
                            urlParms: {
                                quotaCode:code.trim()
                            }
                        });
                    });

                    $.subscribe('zhibiao:tubiao:config', function (event, code, name) {
                        dictMaster.chartConfigDialog = parent._LIGERDIALOG.open({
                            title:'图表配置',
                            height: 700,
                            width: 700,
                            url: '${contextRoot}/zhibiao/zhiBiaoChartConfigure',
                            isHidden: false,
                            opener: true,
                            load: true,
                            urlParms: {
                                quotaCode:code.trim(),
                                quotaName: name.trim()
                            }
                        });
                    });

                    // 初始执行指标
                    $.subscribe('zhibiao:firstExecuteQuota', function (event, id, quotaCode) {
                        parent._LIGERDIALOG.confirm('确认要初始执行所选指标吗？', function (r) {
                            if (r) {
                                var loading = parent._LIGERDIALOG.waitting("正在执行,需要点时间，请稍后...");
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/tjQuota/hasConfigDimension', {
                                    data: {quotaCode: quotaCode},
                                    success: function (data) {
                                        if(data){
                                            dataModel.updateRemote('${contextRoot}/tjQuota/firstExecuteQuota', {
                                                data: {tjQuotaId: parseInt(id)},
                                                success: function (data) {
                                                    if(data.successFlg){
                                                        parent._LIGERDIALOG.success('执行成功！');
                                                    }else{
                                                        parent._LIGERDIALOG.error(data.errorMsg);
                                                    }
                                                    loading.close();
                                                    dictMaster.reloadGrid();
                                                },
                                                error: function () {
                                                    parent._LIGERDIALOG.error('初始执行指标发生异常。');
                                                    loading.close();
                                                }
                                            });
                                        }else{
                                            parent._LIGERDIALOG.error("请先在维度配置中配置主维度");
                                            loading.close();
                                        }
                                    },
                                    error: function () {
                                        parent._LIGERDIALOG.error("验证指标主维度发生异常。");
                                        loading.close();
                                    }
                                });
                            }
                        })
                    });

                    // 执行指标
                    $.subscribe('zhibiao:execu', function (event, id, quotaCode, execType) {
                        if (execType === '2') { // 周期执行
                            executeQuota(id, quotaCode);
                        } else { // 单次执行
                            var htmlStr =
                                    '<div id="extractForm" data-role-form>' +
                                    '   <div class="f-mb5 f-ml5" style="color: #FF0000;">执行的是基础指标，不填起止日期，则默认统计昨天的。</div>' +
                                    '   <div class="m-form-group f-ml5 f-mr5">' +
                                    '       <div class="l-text-wrapper m-form-control">' +
                                    '           <input type="text" id="extractStartTime" data-attr-scan="extractStartTime" placeholder="起始日期">' +
                                    '       </div>' +
                                    '   </div>' +
                                    '   <div class="m-form-group f-ml5 f-mr5 f-mt10">' +
                                    '       <div class="l-text-wrapper m-form-control">' +
                                    '           <input type="text" id="extractEndTime" data-attr-scan="extractEndTime" placeholder="截止日期">' +
                                    '       </div>' +
                                    '   </div>' +
                                    '   <div class="m-form-group f-mt10 f-fr">' +
                                    '       <div id="executeGoOn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10">' +
                                    '           <span>继续</span>' +
                                    '       </div>' +
                                    '   </div>' +
                                    '</div>';
                            dictMaster.extractDialog = parent._LIGERDIALOG.open({
                                title: '填写日期',
                                content: htmlStr,
                                loadSuccess: function ($dlDom) {
                                    parent.startDateDom = $dlDom.find('#extractStartTime').ligerDateEditor({format: "yyyy-MM-dd"});
                                    parent.endDateDom = $dlDom.find('#extractEndTime').ligerDateEditor({format: "yyyy-MM-dd"});
                                    parent.validator = new parent.$.jValidation.Validation($dlDom.find('#extractForm'), {immediate: true});

                                    $dlDom.find('#executeGoOn').on('click', function (e) {
                                        if (!parent.validator.validate()) {
                                            return;
                                        }

                                        dictMaster.extractDialog.close();
                                        var startDate = parent.startDateDom.getFormatDate(parent.startDateDom.getValue());
                                        var endDate = parent.endDateDom.getFormatDate(parent.endDateDom.getValue());
                                        executeQuota(id, quotaCode, startDate, endDate);
                                    });
                                }
                            });
                        }
                    });

                    $.subscribe('zhibiao:result:selectResult', function (event, id,quotaCode) {
                        var url = '${contextRoot}/tjQuota/initialResult';
                        var urlParms = {
                            tjQuotaId:id,
                            quotaCode:quotaCode,
                            quotaType: quotaType,
                            name: searchVal
                        }
                        appendNav('结果查询', url, urlParms)
                    });

                    $.subscribe('zhibiao:log:quotaLog', function (event, quotaCode) {
                        var url = '${contextRoot}/tjQuota/initialQuotaLog';
                        var urlParms = {
                            quotaCode:quotaCode,
                            quotaType: quotaType,
                            name: searchVal
                        }
                        appendNav('日志查询', url, urlParms)
                    });

                }
            };
            /* ************************* 模块初始化结束 ************************** */

            // 执行指标
            function executeQuota (id, quotaCode, startDate, endDate) {
                parent._LIGERDIALOG.confirm('确认要执行所选指标吗？', function (r) {
                    if (r) {
                        var loading = parent._LIGERDIALOG.waitting("正在执行,需要点时间，请稍后...");
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote('${contextRoot}/tjQuota/hasConfigDimension', {
                            data: { quotaCode: quotaCode },
                            success: function (data) {
                                if(data){
                                    dataModel.updateRemote('${contextRoot}/tjQuota/execuQuota', {
                                        data: {
                                            tjQuotaId: id,
                                            startDate: startDate,
                                            endDate: endDate
                                        },
                                        success: function (data) {
                                            if(data.successFlg){
                                                parent._LIGERDIALOG.success('执行成功！');
                                            }else{
                                                parent._LIGERDIALOG.error(data.errorMsg);
                                            }
                                            loading.close();
                                        },
                                        error: function (data) {
                                            parent._LIGERDIALOG.error('执行指标发生异常。');
                                            loading.close();
                                        }
                                    });
                                }else{
                                    parent._LIGERDIALOG.error("请先在维度配置中配置主维度");
                                    loading.close();
                                }
                            },
                            error: function () {
                                parent._LIGERDIALOG.error("验证指标主维度发生异常。");
                                loading.close();
                            }
                        });
                    }
                });
            }

            /* ************************* dialog回调函数 ************************** */


            //新增修改所属成员类别为默认时，只刷新右侧列表；有修改所属成员类别时，左侧树重新定位，刷新右侧列表
            win.parent.reloadMasterUpdateGrid = function () {
                dictMaster.reloadGrid();
            };
            win.parent.closeDictInfoDialog = function (callback) {
                isFirstPage = false;
                dictMaster.dictInfoDialog.close();
            };
            //新增、修改（成员分类有修改情况）定位
            win.parent.locationTree = function(callbackParams){
                if(!callbackParams){
                    dictMaster.reloadGrid();
                    return
                }
                var select = function(id){
                    if(id){
                        var parentId = $('#'+id).parent().parent().attr("id");
                        $('#'+id+' >.l-body>.l-expandable-close').click()
                        select(parentId);
                    }
                }
                $("#inp_search").val(callbackParams.typeFilter);
                typeTree.s_search(callbackParams.typeFilter);
                select(callbackParams.quotaType);

            }

            win.parent.reloadMasterGrid = function () {
                dictMaster.reloadGrid();
            };
            win.parent.closeDialog = function (type, msg) {
                dictMaster.dictInfoDialog.close();
                if (msg)
                    parent._LIGERDIALOG.success(msg);
            };

            win.parent.closeChartConfigDialog = function () {
                dictMaster.chartConfigDialog.close();
                parent._LIGERDIALOG.success('保存成功！');
            }

            win.parent.closeConfigDialog = function () {
                dictMaster.chartConfigDialog.close();
            }

            win.parent.closeZhiBiaoInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    dictMaster.reloadGrid();
                }
                dictMaster.dictInfoDialog.close();
            };
            /* ************************* dialog回调函数结束 ************************** */

            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */

        });
    })(jQuery, window);

    $(function () {

        function onUploadSuccess(g, result) {
            if (result == 'suc')
                parent._LIGERDIALOG.success("导入成功");
            else {
                result = eval('(' + result + ')')
                var url = "${contextRoot}/tjQuota/downLoadErrInfo?f=" + result.eFile[1] + "&datePath=" + result.eFile[0];
                parent._LIGERDIALOG.open({
                    height: 80,
                    content: "请下载&nbsp;<a target='diframe' href='" + url + "'>导入失败信息</a><iframe id='diframe' name='diframe'> </iframe>",
                });
            }
        }

        $('#upd').uploadFile({
            url: "${contextRoot}/tjQuota/import",
            onUploadSuccess: onUploadSuccess
        });
    })
</script>