var cateType = {};

cateType.list = {
    _url: $("#hd_url").val(),
    top: null,
    grid: null,
    columns: [],
    TypeSearch: null,
    init: function () {
        // this.top = $.Util.getTopWindowDOM();
        //资源分类 列名
        this.columns = [
            {display: '名称', name: 'name',width: "43%", align: 'left', id: 'tree_id'},
            {display: '说明', name: 'description',width: "43%", align: 'left'},
            {
                name: 'id', hide: true, render: function (rowdata) {
                var html = "<div id='" + rowdata.id + "' pid='" + rowdata.pid + "'></div>";
                return html;
            }
            },
            {
                display: '操作', isSort: false, width: "14%", align: 'center', render: function (rowdata, rowindex, value) {
                var html = "<a class='grid_edit' title='编辑' name='edit_click' style='' onclick='cateType.list.add(\"" + rowdata.id + "\", \"modify\")'></a> " +
                    "<a class='grid_delete' title='删除' name='delete_click' style='' onclick='cateType.list.deleted(\"" + rowdata.id + "\")'></a>";
                return html;
            }
            }
        ];
        this.TypeSearch = $("#inp_search").ligerTextBox({
            width: 240, isSearch: true, search: function () {
                cateType.list.getTypeList();
            }
        });

        this.getTypeList();
        this.event();
    },
    getTypeList: function () {
        var u = cateType.list;
        var codeName = $('#inp_search').val();
        $.ajax({
            url: u._url + "/rscategory/getTreeGridData",
            type: "get",
            dataType: "json",
            data: {codeName: codeName},
            success: function (data) {
                var envelop = eval(data);
                var result = envelop.detailModelList;
                if (result != null) {
                    cateType.list.setCateList(result);
                }
            }
        })
    },
    setCateList: function (data) {
        var u = cateType.list;
        var dataJson = [];
        //根据下拉框加载相应的数据
        dataJson = data;
        var gridData = {
            Total: dataJson != null ? dataJson.length : null,
            Rows: dataJson
        };
        u.rows = dataJson;
        // window.grid=u.grid=null;
        if (u.grid == null) {
            //$.LigerGridEx.config(
            u.grid = $("#div_cate_type_grid").ligerGrid({
                record: 'totalCount',
                root: 'detailModelList',
                pageSize: 15,
                pagesizeParmName: 'rows',
                heightDiff: -10,
                headerRowHeight: 40,
                rowHeight: 40,
                editorTopDiff: 41,
                allowAdjustColWidth: true,
                usePager: false,
                scrollToPage: false,
                columns: u.columns,
                data: gridData,
                height: "100%",
                rownumbers: false,
                checkbox: false,
                root: 'Rows',
                tree: {columnId: 'tree_id', height: '100%'}
            });
        }
        else {
            u.grid.reload(gridData);
        }

        var cateTypeDatas = u.grid.getData();
        u.grid.collapseAll();
        this.expandcateType();
        window.grid = u.grid;
    },

    // expandcateType: function () {
    //
    //     var cateTypePid = sessionStorage.getItem('cateTypePid');
    //     if ($.Util.isStrEmpty(cateTypePid)){
    //         return;
    //     }
    //     var Pid = $("#" + cateTypePid).attr('pid');
    //     var clickEle = $($($("#" + cateTypePid).parents('tr').children('td')[0]).find('.l-grid-tree-space'));
    //     if (!$.Util.isStrEquals($(clickEle[clickEle.length-1]).attr('class').indexOf('l-grid-tree-link-close'), -1)) {
    //         clickEle[clickEle.length-1].click();
    //     }
    //     while (Pid) {
    //         clickEle = $($($("#" + Pid).parents('tr').children('td')[0]).find('.l-grid-tree-space'));
    //         if (!$.Util.isStrEquals($(clickEle[clickEle.length-1]).attr('class').indexOf('l-grid-tree-link-close'), -1)) {
    //             clickEle[clickEle.length-1].click();
    //         }
    //         Pid = $("#" + Pid).attr('pid');
    //     }
    //     sessionStorage.removeItem('cateTypePid');
    // },
    expandcateType: function () {
        var Pid = sessionStorage.getItem('cateTypePid');
        if ($.Util.isStrEmpty(Pid)) return;

        while (Pid) {
            var clickEle = $($($("#" + Pid).parents('tr').children('td')[0]).find('.l-grid-tree-space'));
            if (!$.Util.isStrEquals($(clickEle[clickEle.length-1]).attr('class').indexOf('l-grid-tree-link-close'), -1)) {
                clickEle[clickEle.length-1].click();
            }
            Pid = $("#" + Pid).attr('pid');
        }
        sessionStorage.removeItem('cateTypePid');
    },

    showDialog: function (_tital, _url, _height, _width, callback) {
        cateType.list.dialog_cateType_detail = $.ligerDialog.open({
            title: _tital,
            url: _url,
            height: _height,
            width: _width,
            onClosed: callback
        });
    },
    add: function (id, type) {
        var _tital = type == "modify" ? "修改资源分类" : "新增资源分类";
        var _url = cateType.list._url + "/rscategory/typeupdate?id=" + id;
        var callback = function () {
            cateType.list.getTypeList();
        };
        cateType.list.showDialog(_tital, _url, 400, 500, callback);
    },
    deleted: function (id) {
        $.ajax({
            url: cateType.list._url + "/rscategory/getCateTypeByPid",
            type: "get",
            dataType: "json",
            data: {id: id},
            success: function (data) {
                if (data == null || data.length == 0) {
                    cateType.list.doDeleted(id, "是否确定删除数据！");
                } else {
                    $.Notice.error("存在子节点不允许删除!");
                }
            }
        })
    },
    doDeleted: function (id, _text) {
        $.Notice.confirm(_text, function (confirm) {
            if (confirm) {
                $.ajax({
                    url: cateType.list._url + "/rscategory/delteCateTypeInfo",
                    type: "get",
                    dataType: "json",
                    data: {id: id},
                    success: function (data) {
                        if (data != null) {

                            var _res = eval(data);
                            if (_res.successFlg) {
                                $.Notice.success("删除成功!");
                                cateType.list.getTypeList();
                            }
                            else {
                                $.Notice.error(_res.errorMsg);
                            }
                        }
                        else {
                            $.Notice.error('删除失败!');
                        }
                    }
                })
            }
        });
    },
    event: function () {
        $(".li_seach").on('keyup', 'input', function (e) {
            var name = $(this).attr('name');
            switch (name) {
                case'inp_search':
                    if (e.keyCode == 13) {
                        cateType.list.getTypeList();
                    }
                    break;
            }

        }).on('click', 'a', function () {
            var id = $(this).attr("id");
            switch (id) {
                case 'btn_Delete_relation':
                    var rows = cateType.list.grid.getSelecteds();
                    if (rows.length == 0) {
                        $.Notice.error("请选择要删除的内容！");
                        return;
                    }
                    else {
                        var ids = "";
                        for (var i = 0; i < rows.length; i++) {

                            ids += "," + rows[i].id;
                        }
                        ids = ids.substr(1);
                        cateType.list.deleted(ids);
                    }
                    break;
                case 'btn_Update_relation':
                    cateType.list.add("");

                    break;
            }
        })
    }
};

cateType.attr = {
    cateTypePid: "",
    type_form: $("#div_catetype_info_form"),
    validator: null,
    parent_select: null,
    init: function () {
        this.getCateTypeInfo();
        this.event();
        this.validator = new $.jValidation.Validation(this.type_form, {
            immediate: true, onSubmit: false,
            onElementValidateForAjax: function (elm) {
            }
        });
    },
    getParentType: function (initValue, initText) {
        cateType.attr.parent_select = $("#ipt_select").ligerComboBox({
            url: cateType.list._url + "/rscategory/getCateTypeExcludeSelfAndChildren?strId=" + $("#hdId").val(),
            valueField: 'id',
            textField: 'name',
            dataParmName: 'detailModelList',
            selectBoxWidth: 240,
            keySupport: true,
            width: 240,
            initValue: initValue,
            initText: initText
        });
        cateType.attr.parent_select.setValue(initValue);
        cateType.attr.parent_select.setText(initText);
    },
    getCateTypeInfo: function () {
        var u = cateType.list;
        var id = $("#hdId").val();
        if (id == "") {
            cateType.attr.getParentType("", "");
            return;
        }
        //加载编辑数据
        $.ajax({
            url: u._url + "/rscategory/getCateTypeById",
            type: "get",
            dataType: "json",
            data: {strIds: id},
            success: function (data) {
                var envelop = eval(data);
                var info = envelop.obj;
                if (info != null) {
                    $("#txt_name").val(info.name);
                    $("#txt_description").val(info.description);
                    var initValue = info.pid;
                    var initText = info.pname;
                    cateType.attr.getParentType(initValue, initText);
                }
                else {
                    $.Notice.error(result.errorMsg);
                }
            }
        })
    },
    save: function () {
        if (!this.validator.validate()) {
            return;
        }
        var id = $("#hdId").val();
        cateType.attr.type_form.attrScan();
        var dataJson = cateType.attr.type_form.Fields;
        var saveJson = {};
        saveJson.id = id;
        saveJson.pid = dataJson.pid.getValue();
        saveJson.name = dataJson.name.getValue();
        saveJson.description = dataJson.description.getValue();
        var _url = cateType.list._url + "/rscategory/saveCateType";
        $.ajax({
            url: _url,
            type: "POST",
            dataType: "json",
            data: {dataJson: JSON.stringify(saveJson)},
            success: function (data) {
                if (data != null) {
                    var _res = eval(data);
                    if (_res.successFlg) {
                        var cateTypePid = dataJson.pid.getValue();
                        sessionStorage.setItem("cateTypePid", cateTypePid);
                        $.ligerDialog.alert("保存成功", "提示", "success", function () {
                            parent.cateType.list.dialog_cateType_detail.close();
                        }, null);
                    }
                    else {
                        $.Notice.error(_res.errorMsg);
                    }
                }
                else {
                    $.Notice.error("保存失败！")
                }
            }
        })
    },
    event: function () {
        $("#btn_save").click(function () {
            cateType.attr.save();
        });
        $("#btn_close").click(function () {
            parent.cateType.list.dialog_cateType_detail.close();
        });
    }
}


