<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>

<script>
    ~(function (w, $) {
        $(function () {
            var url = '${contextRoot}/resource/resourceManage/resources/tree';
            var SV = {
                id: '${id}',
                supplyTree: null,
                $supplyTree: $('#supplyTree'),
                $settingSearchNm: $('#settingSearchNm'),
                $btnClose: $('#btnClose'),
                $dataType: $('[name=dataType]:input'),
                type: 1,
                init: function () {
                    this.initWidget();
                    this.bindEvent();
                },
                initWidget: function () {
                    var me = this;
                    me.$supplyTree.mCustomScrollbar({
                        axis: "y"
                    });
                    me.$settingSearchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            me.supplyTree.s_search(me.$settingSearchNm.val());
                        }
                    });
                    me.supplyTree = $("#supplyTree").ligerSearchTree({
                        url: url,
                        parms: {filters: '', dataSource: me.type},
                        checkbox: false,
                        textFieldName: 'name',
                        idFieldName: 'id',
                        isExpand: false,
                        slide: false,
                        attribute: 'detailModelList',
                        onSelect: function (obj) {
                            if(!!!obj.data.children) {
                                var id = me.type == 1 ? obj.data.code : obj.data.id,
                                    name = obj.data.name, code = obj.data.code;
                                $.ligerDialog.confirm('确认选择“' + name + '”视图吗？',function(yes){
                                    if (yes) {
                                        closeselViewDialog('', id, me.type, name, code);
                                    }
                                })
                            }
                        },
                        onSuccess: function (data) {
                            var arr = [];
                            if (data.successFlg) {
                                data.detailModelList && (function () {
                                    arr = data.detailModelList;
                                    $.each(arr, function(key, obj) {
                                        obj.detailList && (function (obj) {
                                            obj.children = obj.detailList;
                                        })(obj);
                                    });
                                })();
                                me.supplyTree.setData(arr);
                            } else {

                            }
                        }
                    });
                },
                bindEvent: function () {
                    var me = this;
                    // 关闭
                    me.$btnClose.click(function () {
                        closeselViewDialog();
                    });
                    me.$dataType.on('change', function () {//1: 档案视图 ; 2:  指标视图
                        var t = parseInt($(this).val());
                        me.type = t;
                        me.supplyTree.loadData(null, url, {filters: '', dataSource: t});
                        me.supplyTree.reload();
                    });
                }
            };
            SV.init();
        });
    })(window, jQuery);
</script>