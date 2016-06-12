(function ($, win) {

    var child = undefined;
    var el;
    var Util = $.Util;
    var gridOpts = {
        columns: [
            {display : '名称', name :'name',width : 210}
        ],
        allowAdjustColWidth : true,
        editorTopDiff : 41,
        headerRowHeight : 0,
        heightDiff : 0,
        pageSize: 15,
        pagesizeParmName : 'rows',
        record : "totalCount",
        root : "detailModelList",
        rowHeight : 30,
        height: 200,
        rownumbers :false,
        switchPageSizeApplyComboBox: false,
        width :"98%",
        url: undefined
    };

    var comboOpts = {
        condition: {
            inputWidth: 90 ,
            width:0,
            labelWidth:0,
            hideSpace:true,
            fields: [{ name: 'param', label:''}] //搜索框的字段, name 必须是服务器返回的字段
        },
        child: undefined,
        grid: undefined,
        valueField: 'id',
        textField: 'name',
        selectBoxHeight : 300,
        readonly: false,
        parms: {},
        onSelected: undefined,
        conditionSearchClick: function(g){
            var searchParm = g.rules.length > 0 ? g.rules[0].value : '';
            var parms = g.grid.get("parms");
            parms.searchParm = searchParm;
            g.grid.set({
                parms: parms,
                newPage: 1
            });
            g.grid.reload();
        }
    };



    function CustomCombo(el, url, options){
        var girdOptsCopy = $.extend({}, gridOpts);
        var opts = $.extend({}, comboOpts, options);
        girdOptsCopy.url = url;
        opts.grid = girdOptsCopy;
        this.options = opts;
        this.ligerComboBox = el.ligerComboBox(this.options)
        this._el = el;
    }

    CustomCombo.prototype.getLigerComboBox = function () {

        return this.ligerComboBox;
    };

    CustomCombo.prototype.setValue = function (v) {
        this.ligerComboBox.setValue(v);
        return this;
    };

    CustomCombo.prototype.setText = function (t) {
        this.ligerComboBox.setText(t);
        return this;
    };

    CustomCombo.prototype.setValueText = function (v, t) {
        this.ligerComboBox.setValue(v);
        this.ligerComboBox.setText(t);
        return this;
    };

    CustomCombo.prototype.reload = function (parms) {
        var manager = this.ligerComboBox;
        var grid = manager.getGrid();
        if(grid)
            grid.set({
                newPage: 1,
                parms: parms
            });
        manager.set({parms: parms});
        manager.reload();
        manager.clear();
    };

    CustomCombo.prototype.on = function (eventKey, callFunc) {
        $(this.getLigerComboBox().unselect).on(eventKey, callFunc);
    };

    $.fn.customCombo = function (url, parms, selectedCall, child, readOnly, opts) {
        el = this;

        if(!selectedCall)
            selectedCall = function(id, name){
                if(!name || !id)
                    return;
                $(el).blur();
                if(child){
                    var childManager = child.ligerGetComboBoxManager();
                    var parms = childManager.get("parms");
                    var grid = childManager.getGrid();
                    grid.set({
                        //parms: parms,
                        newPage: 1
                    });
                    parms.parentId = id;
                    parms.parentName = name;
                    childManager.set({
                        parms: parms,
                        newPage: 1
                    });
                    childManager.reload();
                    childManager.clear();
                }
            }
        opts = $.extend({}, {
            parms: parms,
            child: child,
            onSelected: selectedCall,
            readonly: readOnly || false
        }, opts);
        var me = new CustomCombo(el, url, opts);
        if(child)
            me.on("changeValue",function () {
                child.ligerGetComboBoxManager().clear();
            });
        return me;
    }
})(jQuery, window);
