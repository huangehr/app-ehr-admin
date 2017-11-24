<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {
            var Util = $.Util;
            var master = null;
            var userGrid = null;
            var configUserGrid = null;
            var configModel = null;
            var obj = '${obj}';
            var id = '${id}';
			var isFirstPage = false;
			var dataModel = $.DataModel.init();

            function pageInit() {
                master.configInit();
            }

            function reloadGrid(value) {
                var grid = configUserGrid;
                grid.options.newPage = 1
                grid.setOptions({parms: {searchNm: value}});
                grid.loadData(true);
				isFirstPage = false;
            }

            master = {
                $userSearch: $("#inp_user_search"),
                $userGrid: $("#div_user_grid"),
                $configUserGrid: $("#div_config_user_grid"),
                configInit: function () {
                    var self = this;
                    self.$userSearch.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
							isFirstPage = true;
                            self.reloadUserGrid(self.$userSearch.val(), 'app/searchApps', 'user');
                        }
                    });
                    configUserGrid = self.$configUserGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/resource/reportCategory/selectAppList',
                        parms: {searchNm: obj},
                        width: $(".f-mw50").width(),
                        height: 450,
                        isScroll: true,
                        async: false,
                        columns: [{display: '应用名称', name: 'name', width: '100%'}],
                        onAfterShowData: function (data) {
                            if (data.successFlg) {
                                configModel = data.detailModelList;
                            } else {
                                $.Notice.error('获取失败');
                            }
                        }
                    }));

                    userGrid = self.$userGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/app/searchApps',
                        parms: {searchNm: ''},
                        width: $(".f-mw50").width(),
                        height: 450,
                        isScroll: true,
                        async: false,
                        checkbox: true,
                        columns: [{display: '应用名称', name: 'name', width: '100%'}],
                        onCheckRow: function (checked, data, rowid, rowdata) {
                            var appidArr = obj.split(',');
                            var url = checked ? (function () {
                                    appidArr.push(data.id);
                                    return 'saveInfo'
                                })(): (function () {
                                    var index = appidArr.indexOf(data.id);
                                    appidArr.splice(index,1);
                                    return 'deleteInfo'
                                })();
                            dataModel.updateRemote("${contextRoot}/resource/reportCategoryApp/" + url, {
                                data: {categoryId: id, appId: data.id},
                                type: 'GET',
                                success: function (data) {
                                    reloadGrid.call(this, appidArr.join(','));
                                    self.changeTotalCount();
                                }
                            });
                        },
                        isChecked: function (row) {
                            var bo = false;
                            if (configModel && configModel.length > 0) {
                                for (var i = 0; i < configModel.length; i++) {
                                    if (Util.isStrEquals(row.id, configModel[i].id)) {
                                        bo = true
                                    }
                                }
                            }
                            return bo;
                        }
                    }));
                    self.$userGrid.find('.l-grid-hd-cell-checkbox').removeClass('l-grid-hd-cell-checkbox');
                    self.changeTotalCount();
                    self.clicks();
                },
                changeTotalCount:function () {
                    $("#div_user_grid .l-bar-message").css({"left":"56%"}).html("共"+userGrid.data.totalCount+"条");
                    $("#div_config_user_grid .l-bar-message").css({"left":"56%"}).html("共"+configUserGrid.data.totalCount+"条");
                },
                reloadUserGrid: function (value, url, type) {
                    reloadGrid.call(this, '${contextRoot}/' + url, value, type);
                    master.changeTotalCount();
                },
                clicks: function () {
                    //修改用户信息
                    var self = this;
                }

            };

            pageInit();
        })
    })(jQuery, window)
</script>