<%@ page import="java.util.Date" %>
<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/19
  Time: 10:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%--<script src="${contextRoot}/develop/Scripts/cdaJs.js?tim=<%=new Date()%>"></script>--%>
<script >
    /**
     * Created by AndyCai on 2015/11/19.
     */
    var cda = {};
    var Util = $.Util;
    cda.list = {
        _url: $("#hd_url").val(),
        _dialog: null,
        grid: null,
        columns: [],
        rows: null,
        enableData: [],
        relationGrid: null,
        relationColumns: [],
        cdaSearch: null,
        relationSearch: null,
        relationIds: "",//关系IDs
        manager: null,
        versionStage: null,
        dialog_cda_detail:null,
        init: function () {
//      this.top = $.Util.getTopWindowDOM();
            //CDA 列名
            this.columns = [
                {display: 'CDA编码', name: 'code', align: 'left'},
                {display: '名称', name: 'name', align: 'left'},
                {display: '说明', name: 'description', align: 'left'},
                {
                    display: '操作', isSort: false, minWidth: 180, render: function (rowdata, rowindex, value) {

                    var html = '';
                    <sec:authorize url="/cda/cdaRelationship">
                    html += "<a class='label_a' title='关联' onclick='cda.list.updateCdaInfo(\"" + rowdata.id + "\",\"btn_relationship\")'>关联</a> ";
                    </sec:authorize>

                    <sec:authorize url="/cda/SaveCdaInfo">
                    html += "<a class='grid_edit' style='margin-left:10px;' title='编辑' onclick='cda.list.updateCdaInfo(\"" + rowdata.id + "\",\"btn_basic\")'></a> ";
                    </sec:authorize>

                    <sec:authorize url="/cda/deleteCdaInfo">
                    html += "<a class='grid_delete'style='' title='删除' onclick='cda.list.deleteCda(\"" + rowdata.id + "\")'></a>";
                    </sec:authorize>
                    return html;
                }
                }
            ];
            this.relationColumns = [
                {display: '代码', name: 'dataset_code', align: 'left'},
                {display: '名称', name: 'dataset_name', align: 'left'},
                {display: '描述', name: 'summary', align: 'left'},
                {
                    display: '操作', isSort: false, render: function (rowdata, rowindex, value) {

                    var html = "<a href='#' onclick='cda.list.deleteRelation(\"" + rowdata.id + "\")'>删除</a>";
                    return html;
                }
                }];

            this.cdaSearch = $("#searchNm").ligerTextBox({
                width: 240, isSearch: true, search: function () {
                    // var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();
                    cda.list.getCDAList(1);
                }
            });
            $("#searchNm").keyup(function (e) {

                if (e.keyCode == 13) {
                    //var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();
                    cda.list.getCDAList(1);
                }
            });

            this.relationSearch = $("#searchNmEntry").ligerTextBox({
                width: 240, isSearch: true, search: function () {
                    var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();
                    versionCode = versionCode.split("|")[0];
                    var cdaid = $("#hdId").val();
                    cda.list.getRelationShipList(versionCode, cdaid);
                }
            });
            $("#searchNmEntry").keyup(function (e) {
                if (e.keyCode == 13) {
                    var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();

                    cda.list.getRelationShipList(versionCode, cdaid);
                }
            });

            cda.list.setCss();
            //$(window).resize(function () {  cda.list.setCss(); });
            cda.list.getVersionList();
            cda.list.event();

            $("#div_left_tree").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
        },
        getStagedByValue: function () {
            var _value = $("#cdaVersion").ligerGetComboBoxManager().getValue();
            if (!_value && _value == "") return false;
            var data = $("#cdaVersion").ligerComboBox().data;
            for (var i = 0; i < data.length; i++) {
                if (data[i].id == _value) {
                    return data[i].inStage;
                }
            }
            return false;
        },
        setCss: function () {

            var _height = $(".l-layout-content").outerHeight() - 40;
            $(".f-p10").css({

                "height": _height
            });
            $("#div_left .l-text").css({
                "margin-left": 50, "margin-top": -20
            });
            $("#div_right .l-text").css({
                "margin-left": 100, "margin-top": -20
            });
        },
        getVersionList: function () {
            var u = cda.list;
            $.ajax({
                url: u._url + "/cdaVersion/getVersionList",
                type: "post",
                dataType: "json",
                data: {page: "1", rows: "100"},
                success: function (data) {
                    var cdaVersionList = data.detailModelList;
                    var option = [];
                    for (var i = 0; i < cdaVersionList.length; i++) {
                        option.push({
                            text: cdaVersionList[i].versionName,
                            id: cdaVersionList[i].version,
                            inStage: cdaVersionList[i].inStage
                        });
                    }
                    var select = $("#cdaVersion").ligerComboBox({

                        data: option,
                        onSelected: function (value, text) {
                            u.versionStage = u.getStagedByValue();
                            var typeid = $("#hdType").val();
                            if (!$.Util.isStrEmpty(typeid)) {
                                cda.list.getCDAList(1);
                            }
                            cda.list.getTypeTree();
                        }
                    });
                    //cda.list.getTypeTree();
                    var manager = $("#cdaVersion").ligerGetComboBoxManager();
                    manager.selectItemByIndex(0);
                },
                complete: function () {
                }
            });
        },
        getCDAList: function (curPage) {
            var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();

            var typeid = $("#hdType").val();
            var u = cda.list;
            if (u.grid == null) {
                u.grid = $("#div_cda_grid").ligerGrid($.LigerGridEx.config({
                    url: u._url + "/cda/GetCdaListByKey",
                    // 传给服务器的ajax 参数
                    parms: {
                        strKey: u.cdaSearch.getValue(),
                        strVersion: versionCode,
                        strType: typeid
                    },
                    async: true,
                    columns: u.columns,
                    pageSizeOptions: [10, 15, 20, 30, 40, 50],
                    pageSize: 15,
                    rownumbers: true,
                    checkbox: true,
                    usePager: true,
                    height: "100%",
                    onSelectRow: function (rowdata, rowid, rowobj) {
                    },
                    onAfterShowData: function (currentData) {

                    }
                }));
                u.grid.adjustToWidth();
                window.grid = u.grid;
                $(".l-grid-body2").css({
                    'overflow-x': 'hidden'
                });
            }
            else {
                u.grid.set({
                    //url: u._url + "/cda/GetCdaListByKey",
                    // 传给服务器的ajax 参数
                    parms: {
                        strKey: u.cdaSearch.getValue(),
                        strVersion: versionCode,
                        strType: typeid
                    }
                });
                if(curPage)
                    u.grid.options.newPage = curPage;

                u.grid.reload();
            }
        },

        getTypeTree: function () {
            var flag = true;
            var u = cda.list;
            var typeTree = $("#div_typeTree").ligerTree({
                nodeWidth: 260,
                url: u._url + '/cdatype/getCDATypeListByParentId?ids=',//参数ids值为测试值
                isLeaf: function (data) {
                    if (!data) return false;
                    return data.type == "employee";
                },
                delay: function (e) {
                    var data = e.data;
                    return {url: u._url + '/cdatype/getCDATypeListByParentId?ids=' + data.id}
                },
                checkbox: false,
                idFieldName: 'id',
                textFieldName: 'name',
                slide: false,
                childIcon:null,
                parentIcon:null,
                onSelect: function (data) {
                    var id = data.data.id;
                    $("#hdType").val(id);
                    $("#hdTypeName").val(data.data.name);
                    cda.list.getCDAList(1);
                },
                onSuccess: function (data) {
                    var cdaTypes = data
                    if (flag) {
                        flag = false;
                        $("#div_typeTree").css({});
                        var id = data[0].id;
                        $("#hdType").val(id);
                        cda.list.getCDAList(1);
                        //$(".l-body").removeClass("l-selected");
                        $("#" + id + " div:first").addClass("l-selected");
                    }
                    $("#div_typeTree li div span").css({
                        "line-height": "22px",
                        "height": "22px"
                    });
                }

            });
        },

        getRelationShipList: function (versionCode, cdaid) {
            var u = cda.list;
            var strkey = u.relationSearch.getValue();

            if (u.relationGrid == null) {
                u.relationGrid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
                    url: u._url + "/cda/getRelationByCdaId",
                    // 传给服务器的ajax 参数
                    parms: {cdaId: cdaid, strVersionCode: versionCode, strkey: strkey},
                    columns: u.relationColumns,
                    pageSizeOptions: [10, 15, 20, 30, 40, 50],
                    pageSize: 20,
                    rownumbers: true,
                    checkbox: true,
                    usePager: true
                }));
            }
            else {
                u.relationGrid.set({
                    url: u._url + "/cda/getRelationByCdaId",
                    // 传给服务器的ajax 参数
                    parms: {cdaId: cdaid, strVersionCode: versionCode, strkey: strkey}
                });
                u.relationGrid.reload();
            }
        },

        showDialog: function (_tital, _url, _height, _width, callback) {

            cda.list.dialog_cda_detail = parent._LIGERDIALOG.open({
                title: _tital,
                url: _url,
                height: _height,
                width: _width,
                onClosed: callback
            });
        },

        addCdaInfo: function () {
            var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();

            var typeId = $("#hdType").val();
            var typeName = $("#hdTypeName").val();
            var _tital = "CDA新增";
            var _url = cda.list._url + "/cda/cdaBaseInfo?id=&versioncode=" + versionCode + "&typeid=" + typeId + "&typename=" + typeName + "&click_name=btn_basic" + "&staged=" + cda.list.versionStage;
            var callback = function () {
                cda.list.getCDAList();
            };
            cda.list.showDialog(_tital, _url, 450, 500, callback);
        },
        updateCdaInfo: function (cdaid, click_name) {
            var _height = 600;
            var _width = 955;
            var _tital = "数据集关联";
            var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();

            var _url = cda.list._url + "/cda/cdaRelationship?id=" + cdaid + "&versioncode=" + versionCode + "&click_name=" + click_name + "&staged=" + cda.list.versionStage;
            if (click_name == "btn_basic") {
                _tital = "CDA编辑";
                _height = 450;
                _width = 500;
                _url = cda.list._url + "/cda/cdaBaseInfo?id=" + cdaid + "&versioncode=" + versionCode + "&click_name=" + click_name + "&staged=" + cda.list.versionStage;
            }

            var callback = function () {
                cda.list.getCDAList();
            };
            cda.list.showDialog(_tital, _url, _height, _width, callback);
        },
        deleteCda: function (ids) {

            if (!cda.list.versionStage) {
                parent._LIGERDIALOG.error("已发布版本不可删除，请确认!");
                return;
            }

            if (ids == null || ids == "") {
                parent._LIGERDIALOG.error("请先选择需要删除的CDA!");
                return;
            }
            var strVersionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();

            parent._LIGERDIALOG.confirm('删除CDA将连同一起删除CDA数据集关系,是否确定删除该CDA?', function (confirm) {
                if (confirm) {
                    $.ajax({
                        url: cda.list._url + "/cda/deleteCdaInfo",
                        type: "get",
                        dataType: "json",
                        data: {ids: ids, strVersionCode: strVersionCode},
                        success: function (data) {
                            if (data != null) {

                                var _res = eval(data);
                                if (_res.successFlg) {
                                    parent._LIGERDIALOG.success("删除成功!");
                                    cda.list.getCDAList(Util.checkCurPage.call(cda.list.grid, ids.split(',').length));
                                }
                                else {
                                    parent._LIGERDIALOG.error(_res.errorMsg);
                                }
                            }
                            else {
                                parent._LIGERDIALOG.error('删除失败!');
                            }
                        }
                    })
                }
            });

        },
        event: function () {

            $("#btn_create").click(function () {
                if (!cda.list.versionStage) {
                    parent._LIGERDIALOG.error("已发布版本不可新增，请确认!");
                    return;
                }
                cda.list.addCdaInfo();
            });
            $("#btn_Delete").click(function () {

                console.log(cda.list.versionStage);
                if (!cda.list.versionStage) {
                    parent._LIGERDIALOG.error("已发布版本不可删除，请确认!");
                    return;
                }

                var rows = cda.list.grid.getSelecteds();
                if (rows.length == 0) {
                    parent._LIGERDIALOG.error("请选择要删除的内容！");
                    return;
                }
                else {
                    var ids = "";
                    for (var i = 0; i < rows.length; i++) {
                        ids += "," + rows[i].id;
                    }
                    ids = ids.substr(1);
                    cda.list.deleteCda(ids, '0');
                }
            });
            $("#btn_test").click(function () {
                $.ajax({
                    url: cda.list._url + "/cda/getOrgType",
                    type: "get",
                    dataType: "json",
                    data: null,
                    success: function (data) {
                        if (data != null) {

                            var _res = eval(data);
                            if (_res.successFlg) {
                                parent._LIGERDIALOG.success("操作成功！");
                            }
                            else {
                                parent._LIGERDIALOG.error(_res.errorMsg);
                            }
                        }
                        else {
                            parent._LIGERDIALOG.error('删除失败!');
                        }
                    }
                })
            });
        }
    };

    cda.attr = {
        top: null,
        relationIds: "",
        cda_form: $("#div_cda_info_form"),

        init: function () {
            this.top = $.Util.getTopWindowDOM();
            var versionCode = $.Util.getUrlQueryString('versioncode');
            $("#hdversion").val(versionCode);
            var cdaId = $.Util.getUrlQueryString('id');
            $("#hdId").val(cdaId);
            var btn_name = $.Util.getUrlQueryString('click_name');
            if (cdaId == "") {
                var typeId = $.Util.getUrlQueryString('typeid');
                $("#hdTypeId").val(typeId);
                var typeName = $.Util.getUrlQueryString('typename');
                $("#hdTypeName").val(typeName);
            }

            var staged = $.Util.getUrlQueryString('staged');
            if (staged != 'false') {
                $("#btn_save").show();
            }
            cda.attr.event(btn_name);

        },
        getCdaType: function (cdaId) {
            var u = cda.list;
            $.ajax({
                url: u._url + "/cdatype/GetCdaTypeList",
                type: "post",
                dataType: "json",
                data: {strKey: "", page: 1, rows: 0},
                success: function (data) {
                    var result = eval(data.detailModelList);
                    var option = [];
                    if (result != null) {
                        for (var i = 0; i < result.length; i++) {
                            option.push({
                                text: result[i].name,
                                id: result[i].id
                            });
                        }
                    }
                    else {
                        option.push({
                            text: "请先维护CDA类目",
                            id: ""
                        });
                    }

                    var select = $("#ipt_type").ligerComboBox({
                        data: option
                    });
                    if (cdaId == "") {
                        select.setValue($("#hdTypeId").val());
                    }
                    //if (option.length > 0) {
                    //    select.setValue(option[0].id);
                    //}
                },
                complete: function () {
                    //cda.attr.getStandardSource();
                }
            });
        },
        //加载标准来源下拉框

        getStandardSource: function () {
            var u = cda.list;
            if (u._url == "" || u._url == null) {
                u._url = $("#hd_url").val();
            }
            var cdaVersion = $("#hdversion").val();
            $.ajax({
                url: u._url + "/standardsource/getStdSourceList",
                type: "post",
                dataType: "json",
                data: {strVersionCode: cdaVersion},
                success: function (data) {
                    //var result = eval(data.result);
                    var result = data.detailModelList;

                    var option = [];
                    if (result != null) {
                        for (var i = 0; i < result.length; i++) {
                            option.push({
                                text: result[i].name,
                                id: result[i].id
                            });
                        }
                    }
                    else {
                        option.push({
                            text: "请先维护标准来源",
                            id: ""
                        });
                    }

                    var select = $("#ipt_select").ligerComboBox({
                        data: option
                    });
                    if (option.length > 0) {
                        select.setValue(option[0].id);
                    }
                },
                complete: function () {

                    cda.attr.getCDAInfo();
                }
            });
        },
        //获取CDA明细
        getCDAInfo: function () {
            var u = cda.list;
            var versionCode = $("#hdversion").val();
            var id = $("#hdId").val();
            if (id == "") {
                return;
            }
            $.ajax({
                url: u._url + "/cda/getCDAInfoById",
                type: "get",
                dataType: "json",
                data: {strId: id, strVersion: versionCode},
                success: function (data) {
                    var result = eval(data);
                    var info = result.detailModelList[0];
                    if (info != null) {
                        cda.attr.cda_form.attrScan();
                        cda.attr.cda_form.Fields.fillValues(info);
                    }
                    else {
                        parent._LIGERDIALOG.error(result.errorMsg);
                    }
                }
            })
        },
        //保存CDA信息
        save: function () {
            var versionCode = $("#hdversion").val();
            var id = $("#hdId").val();
            var user_id = $("#hd_user").val();
            cda.attr.cda_form.attrScan();
            var dataJson = eval("[" + cda.attr.cda_form.Fields.toJsonString() + "]");
            dataJson[0]["versionCode"] = versionCode;
            dataJson[0]["id"] = id;

            $.ajax({
                url: cda.list._url + "/cda/SaveCdaInfo",
                type: "post",
                dataType: "json",
                data: {cdaJson: JSON.stringify(dataJson[0]), version: versionCode},
                success: function (data) {
                    if (data != null) {
                        var _res = eval(data);
                        if (_res.successFlg) {
                            parent._LIGERDIALOG.alert("保存成功!", "提示", "success", function () {
                                cda.list.dialog_cda_detail.close();
//                  cda.list.top.dialog_cda_detail.close();
                            }, null);
                        }
                        else {
                            parent._LIGERDIALOG.error(_res.errorMsg);
                        }
                    }
                    else {
                        // alert($.i18n.prop('message.save.failure'));
                    }
                }
            })
        },
        /*保存数据集关联关系*/
        saveRelationship: function () {
            var u = cda.attr;

            u.relationIds = "";
            for (var i = 0; i < u.top.list_dataset_storage.length; i++) {
                var datasets = u.top.list_dataset_storage[i];
                if (i == 0) {
                    u.relationIds += datasets.id;
                } else {
                    u.relationIds += "," + datasets.id;
                }
                //u.relationIds += u.top.list_dataset_storage[i].id + ",";
            }
            //u.relationIds=u.relationIds.substring(0,strSetId.length-1);

            var cdaId = $("#hdId").val();
            var strVersionCode = $("#hdversion").val();
            var xmlInfo = kindEditor.editor.text();
            $.ajax({
                url: cda.list._url + "/cda/SaveRelationship",
                type: "post",
                dataType: "json",
                data: {strDatasetIds: u.relationIds, strCdaId: cdaId, strVersionCode: strVersionCode, xmlInfo: xmlInfo},
                success: function (data) {
                    if (data.successFlg) {
                        parent._LIGERDIALOG.alert("保存成功!", "提示", "success", function () {
                            cda.list.dialog_cda_detail.close();
//                cda.list.top.dialog_cda_detail.close();
                        }, null);
                    }
                    else {
                        parent._LIGERDIALOG.error("保存失败");
                    }
                }
            });
        },
        getALLRelationByCdaId: function (cdaid) {
            var strVersionCode = $("#hdversion").val();
            $.ajax({
                url: cda.list._url + "/cda/getDatasetByCdaId",
                type: "get",
                dataType: "json",
                data: {strCdaId: cdaid, strVersionCode: strVersionCode},
                success: function (data) {
                    cda.attr.top.list_dataset_storage = [];
                    if (data != null) {
                        var _res = eval(data);
                        cda.attr.top.list_dataset_storage = _res.detailModelList;
                    }
                },
                complete: function () {
                    list.dataset(strVersionCode, cdaid);
                }
            })
        },
        //获取基本信息页面
        getBaseInfo: function () {
            cda.attr.getStandardSource();
            cda.attr.attrEvent();
        },
        //获取关联关系页面
        getRelationshipView: function () {
            cda.attr.top.list_dataSet_callback = function () {
                cda.attr.saveRelationship();
            }
            var versionId = $("#hdversion").val();
            cda.attr.top.get_relation_xml = function (setId, VersionCode) {
                cda.attr.getXMLInfoByDataSetId(setId, VersionCode);
            }

            cda.attr.top.versionCode = versionId;

            var cdaId = $("#hdId").val();
            cda.attr.showEditBox();
            cda.attr.getALLRelationByCdaId(cdaId);
            cda.attr.attrEvent();
            cda.attr.getXMLFileByCdaId();
        },
        showEditBox: function () {
//      formKindEditor.init();
            var data = "<root><name></name></root>"
            kindEditor.editor.text(data);

        },
        getXMLInfoByDataSetId: function (setId, VersionCode) {
            var wait = $.Notice.waitting();
            $.ajax({
                url: cda.list._url + "/std/dataset/getXMLInfoByDataSetId",
                type: "get",
                dataType: "json",
                data: {setId: setId, versionCode: VersionCode},
                success: function (data) {
                    if (data.successFlg) {
                        kindEditor.editor.text(data.obj);
                    }
                    wait.close();
                },
                error: function (request) {
                    parent._LIGERDIALOG.error("请求数据错误!");
                    wait.close();
                }

            })
        },
        getXMLFileByCdaId: function () {
            var cdaid = $("#hdId").val();
            var versionCode = $("#hdversion").val();
            $.ajax({
                url: cda.list._url + "/cda/getCdaXmlFileInfo",
                type: "get",
                dataType: "json",
                data: {cdaId: cdaid, versionCode: versionCode},
                success: function (data) {
                    if (data.successFlg) {
                        kindEditor.editor.text(data.obj);
                    }
                },
                error: function (requert) {
                    parent._LIGERDIALOG.error("请求数据错误!");
                }
            })
        },
        event: function (btn_name) {

            switch (btn_name) {
                case"btn_basic":
                    var cdaId = $("#hdId").val();
                    cda.attr.getCdaType(cdaId);
                    cda.attr.getBaseInfo();
                    break;
                case"btn_relationship":
                    cda.attr.getRelationshipView();
                    break;
            }

        },
        attrEvent: function () {
            // 表单校验工具类
            var jValidation = $.jValidation;
            var validator = new jValidation.Validation(cda.attr.cda_form, {immediate: true, onSubmit: false});
            $(".div_toolbar").on('click', 'div', function () {
                var _name = $(this).attr("name");
                switch (_name) {
                    case'btn_save':
                        if (validator.validate()) {
                            cda.attr.save();
                        }
                        break;
                    case'btn_close':

                        cda.list.dialog_cda_detail.close();
//              cda.list.top.dialog_cda_detail.close();
                        break;
                    case'btn-submit':
                        cda.attr.saveRelationship();
                        break;
                }
            });
        }
    };

    var kindEditor = {
        editor: {},
        editorItems: ['undo', 'redo', '|', 'forecolor', 'hilitecolor', 'bold', 'italic',
            'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'fontname',
            'fontsize'],
        bulidKindEditor: function (targe) {
            this.editor = KindEditor.create(targe, {
                items: kindEditor.editorItems,
                resizeType: 0,

            });
            return this.editor;
        }

    };
    //  var formKindEditor = {
    //    editor: {},
    //    content: top.win_editor_storage,
    //
    //    init: function () {
    //      var editor = kindEditor.bulidKindEditor("textarea[name='txb_Immed_Temp']")
    //      editor.html(formKindEditor.content);
    //      //formKindEditor.event(editor);
    //    }
    //  }


    $(function(){
        cda.list.init();
    })
</script>
