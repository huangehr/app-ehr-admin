(function ($, win) {

    function indexOf(source, item){
        for(var i=0; i<source.length; i++){
            if(source[i] == item){
                return i;
            }
        }
        return -1;
    }

    function remove(source, item){
        var rmId = indexOf(source, item);
        if(rmId == -1)
            return source;
        return source.slice(0, rmId).concat(source.slice(rmId+1, source.length));
    }

    $.fn.ligerSearchTree = function (options)
    {
        return $.ligerui.run.call(this, "ligerSearchTree", arguments);
    };

    $.ligerui.controls.SearchTree = function (element, options)
    {
        var customOnSuccess = options.onSuccess;
        options.onSuccess = function (data) {
            var g = this;
            g._checkNextSearch(data);
            if(customOnSuccess)customOnSuccess.call(this, data);
        }
        var onExpand = options.onExpand;
        options.onExpand = function (e) {
            var g = this;
            g._checkNextSearch(e.data.children);
            if(onExpand)onExpand.call(this, e);
        }
        var onBeforeExpand = options.onBeforeExpand;
        options.onBeforeExpand = function (e) {
            var g = this, p= this.options;
            debugger
            var dataIndex = g._getDataIndexByDom(e.target);
            if(dataIndex!=-1) g._addCache(dataIndex);
            if(onBeforeExpand)onBeforeExpand.call(this, e);
        }
        $.ligerui.controls.SearchTree.base.constructor.call(this, element, options);
    };

    var options = {
        _searching: false,
        _searchData: {},
        _searchCache: {},
        allCheckDom: undefined,
        onUnSelect: function () {}
    }

    $.ligerDefaults.SearchTree = $.extend({}, $.ligerDefaults.Tree, options);

    $.ligerui.controls.SearchTree.ligerExtend($.ligerui.controls.Tree, {
        s_search: function (param) {
            var g= this;
            g.f_onSimQueryNode(g, param);
        },
        s_searchForLazy: function (seq) {
            var g= this, p= this.options;

            seq = $.isArray(seq)? seq : [seq];
            if(seq.length==0)
                return;
            p._searching = true;
            var s = [];
            $.each(seq, function (i, v) {
                var ids = v.split(',');
                var dataIndex = g._getTreeDataIndex(ids[0]);
                p._searchData[dataIndex] = {nextIndex: 1, seq: ids};
                s.push(dataIndex);
            })
            g._search(s);
        },
        removeData : function (treeNode) {
            var g = this, p = this.options;
            treeNode = g.getNodeDom(treeNode);
            var parentNode = g.getParentTreeItem(treeNode);

            var treedataindex = parseInt($(treeNode).attr("treedataindex"));
            var treenodedata = g._getDataNodeByTreeDataIndex(g.data, treedataindex);
            //清除数据
            var parentData;
            if(parentData = g._getDataNodeByTreeDataIndex(g.data, g.getParent(treeNode)))
                parentData.children = remove(parentData.children, treenodedata);
            else
                g.data = remove(g.data, treenodedata);

            $(treeNode).remove();
            g._updateStyle(parentNode ? $("ul:first", parentNode) : g.tree);
        },
        isAllChecked: function () {
            var g= this;
            return !g.isEmpty() && $('.l-box.l-checkbox.l-checkbox-unchecked', g.tree).length==0;
        },
        isNoChecked: function () {
            var g= this;
            return $('.l-box.l-checkbox.l-checkbox-checked', g.tree).length==0;
        },
        isEmpty: function () {
            debugger
            var g= this;
            return $('.l-body', g.tree).length == 0;
        },
        isExist: function (id, outlinelevel) {

        },
        _removeCache: function (dataIndex) {
            var g= this, p= options;
            p._searchCache[dataIndex] = undefined;
        },
        _addCache: function (dataIndex) {
            var p= options;
            p._searchCache[dataIndex] = true;
        },
        _dataInSearch: function (dataIndex) {
            var p= options;
            if(p._searchCache[dataIndex]){
                p._searchCache[dataIndex] = undefined;
                return true;
            }
            return false;
        },
        _search: function (dataIndexs) {
            var g= this, p= this.options;
            dataIndexs = $.isArray(dataIndexs) ? dataIndexs : [dataIndexs];
            $.each(dataIndexs, function (i, v) {
                var dom = $(g.getNodeDom(v));
                if(dom.length>0){
                    dom = $(".l-expandable-close", dom);
                    if(dom.length>0)
                        dom[0].click();
                }
            })
        },
        _checkNextSearch: function (data) {
            var g = this, p= this.options;
            if(data && $.isArray(data) && data.length>0){
                var parentDom = $( g.getParentTreeItem(data[0]));
                if(parentDom.length>0){
                    var dataIndex = parentDom.attr('treedataindex');
                    if(!g._dataInSearch(dataIndex)) return;
                    var s= p._searchData[dataIndex];
                    if(s && s.nextIndex < s.seq.length){
                        var nextDataIndex = g._getTreeDataIndex(s.seq[s.nextIndex], parentDom);
                        p._searchData[dataIndex] = undefined;
                        s.nextIndex++;
                        p._searchData[nextDataIndex] = s;
                        g._search(nextDataIndex);
                    }
                }
            }
        },
        _getTreeDataIndex: function (id, parent) {
            var g= this;
            var dom = $('#'+id, parent || g.tree);
            if(dom.length>0){
                return parseInt(dom.attr("treedataindex"));
            }
            return -1;
        },
        _getDataIndexByDom: function (dom) {
            var g= this;
            dom = $(dom);
            if(dom.length>0){
                return parseInt(dom.attr("treedataindex"));
            }
            return -1;
        },
        _getDataById: function (id, parent) {
            var g= this;
            var dataIndex = g._getTreeDataIndex(id, parent);
            if(dataIndex!=-1){
                return g._getDataNodeByTreeDataIndex(g.data, dataIndex);
            }
            return null;
        },


        _setTreeEven: function ()
        {
            var g = this, p = this.options;
            if (g.hasBind('contextmenu'))
            {
                g.tree.bind("contextmenu", function (e)
                {
                    var obj = (e.target || e.srcElement);
                    var treeitem = null;
                    if (obj.tagName.toLowerCase() == "a" || obj.tagName.toLowerCase() == "span" || $(obj).hasClass("l-box"))
                        treeitem = $(obj).parent().parent();
                    else if ($(obj).hasClass("l-body"))
                        treeitem = $(obj).parent();
                    else if (obj.tagName.toLowerCase() == "li")
                        treeitem = $(obj);
                    if (!treeitem) return;
                    var treedataindex = parseInt(treeitem.attr("treedataindex"));
                    var treenodedata = g._getDataNodeByTreeDataIndex(g.data, treedataindex);
                    return g.trigger('contextmenu', [{ data: treenodedata, target: treeitem[0] }, e]);
                });
            }
            g.tree.click(function (e)
            {
                debugger
                var obj = (e.target || e.srcElement);
                var treeitem = null;
                if (obj.tagName.toLowerCase() == "a" || obj.tagName.toLowerCase() == "span" || $(obj).hasClass("l-box"))
                    treeitem = $(obj).parent().parent();
                else if ($(obj).hasClass("l-body"))
                    treeitem = $(obj).parent();
                else
                    treeitem = $(obj);
                if (!treeitem) return;
                var treedataindex = parseInt(treeitem.attr("treedataindex"));
                var treenodedata = g._getDataNodeByTreeDataIndex(g.data, treedataindex);
                var treeitembtn = $("div.l-body:first", treeitem).find("div.l-expandable-open:first,div.l-expandable-close:first");
                var clickOnTreeItemBtn = $(obj).hasClass("l-expandable-open") || $(obj).hasClass("l-expandable-close");
                if (!$(obj).hasClass("l-checkbox") && !clickOnTreeItemBtn)
                {
                    if (!$(">div:first", treeitem).hasClass("l-unselectable"))
                    {
                        if ($(">div:first", treeitem).hasClass("l-selected") && p.needCancel)
                        {
                            if (g.trigger('beforeCancelSelect', [{ data: treenodedata, target: treeitem[0] }]) == false)
                                return false;

                            $(">div:first", treeitem).removeClass("l-selected");
                            g.trigger('cancelSelect', [{ data: treenodedata, target: treeitem[0] }]);
                        }
                        else
                        {
                            if (g.trigger('beforeSelect', [{ data: treenodedata, target: treeitem[0] }]) == false)
                                return false;
                            $(".l-body", g.tree).removeClass("l-selected");
                            $(">div:first", treeitem).addClass("l-selected");
                            g.trigger('select', [{ data: treenodedata, target: treeitem[0] }])
                        }
                    } else {
                        //add by lincl
                        g.trigger('unSelect', [{ data: treenodedata, target: treeitem[0], dom: obj }])
                    }
                }
                //chekcbox even
                if ($(obj).hasClass("l-checkbox"))
                {
                    if (p.autoCheckboxEven)
                    {
                        //状态：未选中
                        if ($(obj).hasClass("l-checkbox-unchecked"))
                        {
                            $(obj).removeClass("l-checkbox-unchecked").addClass("l-checkbox-checked");
                            $(".l-children .l-checkbox", treeitem)
                                .removeClass("l-checkbox-incomplete l-checkbox-unchecked")
                                .addClass("l-checkbox-checked");
                            g.trigger('check', [{ data: treenodedata, target: treeitem[0] }, true]);
                        }
                        //状态：选中
                        else if ($(obj).hasClass("l-checkbox-checked"))
                        {
                            $(obj).removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
                            $(".l-children .l-checkbox", treeitem)
                                .removeClass("l-checkbox-incomplete l-checkbox-checked")
                                .addClass("l-checkbox-unchecked");
                            g.trigger('check', [{ data: treenodedata, target: treeitem[0] }, false]);
                        }
                        //状态：未完全选中
                        else if ($(obj).hasClass("l-checkbox-incomplete"))
                        {
                            $(obj).removeClass("l-checkbox-incomplete").addClass("l-checkbox-checked");
                            $(".l-children .l-checkbox", treeitem)
                                .removeClass("l-checkbox-incomplete l-checkbox-unchecked")
                                .addClass("l-checkbox-checked");
                            g.trigger('check', [{ data: treenodedata, target: treeitem[0] }, true]);
                        }
                        g._setParentCheckboxStatus(treeitem);
                    }
                    else
                    {
                        //状态：未选中
                        if ($(obj).hasClass("l-checkbox-unchecked"))
                        {
                            $(obj).removeClass("l-checkbox-unchecked").addClass("l-checkbox-checked");
                            //是否单选
                            if (p.single)
                            {
                                $(".l-checkbox", g.tree).not(obj).removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
                            }
                            g.trigger('check', [{ data: treenodedata, target: treeitem[0] }, true]);
                        }
                        //状态：选中
                        else if ($(obj).hasClass("l-checkbox-checked"))
                        {
                            $(obj).removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
                            g.trigger('check', [{ data: treenodedata, target: treeitem[0] }, false]);
                        }
                    }
                }
                //状态：已经张开
                else if (treeitembtn.hasClass("l-expandable-open") && (!p.btnClickToToggleOnly || clickOnTreeItemBtn))
                {
                    if (g.trigger('beforeCollapse', [{ data: treenodedata, target: treeitem[0] }]) == false)
                        return false;
                    treeitembtn.removeClass("l-expandable-open").addClass("l-expandable-close");
                    if (p.slide)
                        $("> .l-children:first", treeitem).slideToggle('fast');
                    else
                        $("> .l-children:first", treeitem).hide();
                    $("> div ." + g._getParentNodeClassName(true), treeitem)
                        .removeClass(g._getParentNodeClassName(true))
                        .addClass(g._getParentNodeClassName());
                    g.trigger('collapse', [{ data: treenodedata, target: treeitem[0] }]);
                }
                //状态：没有张开
                else if (treeitembtn.hasClass("l-expandable-close") && (!p.btnClickToToggleOnly || clickOnTreeItemBtn))
                {
                    if (g.trigger('beforeExpand', [{ data: treenodedata, target: treeitem[0] }]) == false)
                        return false;

                    $(g.toggleNodeCallbacks).each(function ()
                    {
                        if (this.data == treenodedata)
                        {
                            this.callback(treeitem[0], treenodedata);
                        }
                    });
                    treeitembtn.removeClass("l-expandable-close").addClass("l-expandable-open");
                    var callback = function ()
                    {
                        g.trigger('expand', [{ data: treenodedata, target: treeitem[0] }]);
                    };
                    if (p.slide)
                    {
                        $("> .l-children:first", treeitem).slideToggle('fast', callback);
                    }
                    else
                    {
                        $("> .l-children:first", treeitem).show();
                        callback();
                    }
                    $("> div ." + g._getParentNodeClassName(), treeitem)
                        .removeClass(g._getParentNodeClassName())
                        .addClass(g._getParentNodeClassName(true));
                }
                g.trigger('click', [{ data: treenodedata, target: treeitem[0] }]);
            });

            //节点拖拽支持
            if ($.fn.ligerDrag && p.nodeDraggable)
            {
                g.nodeDroptip = $("<div class='l-drag-nodedroptip' style='display:none'></div>").appendTo('body');
                g.tree.ligerDrag({
                    revert: true, animate: false,
                    proxyX: 20, proxyY: 20,
                    proxy: function (draggable, e)
                    {
                        var src = g._getSrcElementByEvent(e);
                        if (src.node)
                        {
                            var content = "dragging";
                            if (p.nodeDraggingRender)
                            {
                                content = p.nodeDraggingRender(draggable.draggingNodes, draggable, g);
                            }
                            else
                            {
                                content = "";
                                var appended = false;
                                for (var i in draggable.draggingNodes)
                                {
                                    var node = draggable.draggingNodes[i];
                                    if (appended) content += ",";
                                    content += node.text;
                                    appended = true;
                                }
                            }
                            var proxy = $("<div class='l-drag-proxy' style='display:none'><div class='l-drop-icon l-drop-no'></div>" + content + "</div>").appendTo('body');
                            return proxy;
                        }
                    },
                    onRevert: function () { return false; },
                    onRendered: function ()
                    {
                        this.set('cursor', 'default');
                        g.children[this.id] = this;
                    },
                    onStartDrag: function (current, e)
                    {
                        if (e.button == 2) return false;
                        this.set('cursor', 'default');
                        var src = g._getSrcElementByEvent(e);
                        if (src.checkbox) return false;
                        if (p.checkbox)
                        {
                            var checked = g.getChecked();
                            this.draggingNodes = [];
                            for (var i in checked)
                            {
                                this.draggingNodes.push(checked[i].data);
                            }
                            if (!this.draggingNodes || !this.draggingNodes.length) return false;
                        }
                        else
                        {
                            this.draggingNodes = [src.data];
                        }
                        this.draggingNode = src.data;
                        this.set('cursor', 'move');
                        g.nodedragging = true;
                        this.validRange = {
                            top: g.tree.offset().top,
                            bottom: g.tree.offset().top + g.tree.height(),
                            left: g.tree.offset().left,
                            right: g.tree.offset().left + g.tree.width()
                        };
                    },
                    onDrag: function (current, e)
                    {
                        var nodedata = this.draggingNode;
                        if (!nodedata) return false;
                        var nodes = this.draggingNodes ? this.draggingNodes : [nodedata];
                        if (g.nodeDropIn == null) g.nodeDropIn = -1;
                        var pageX = e.pageX;
                        var pageY = e.pageY;
                        var visit = false;
                        var validRange = this.validRange;
                        if (pageX < validRange.left || pageX > validRange.right
                            || pageY > validRange.bottom || pageY < validRange.top)
                        {

                            g.nodeDropIn = -1;
                            g.nodeDroptip.hide();
                            this.proxy.find(".l-drop-icon:first").removeClass("l-drop-yes l-drop-add").addClass("l-drop-no");
                            return;
                        }
                        for (var i = 0, l = g.nodes.length; i < l; i++)
                        {
                            var nd = g.nodes[i];
                            var treedataindex = nd['treedataindex'];
                            if (nodedata['treedataindex'] == treedataindex) visit = true;
                            if ($.inArray(nd, nodes) != -1) continue;
                            var isAfter = visit ? true : false;
                            if (g.nodeDropIn != -1 && g.nodeDropIn != treedataindex) continue;
                            var jnode = $("li[treedataindex=" + treedataindex + "] div:first", g.tree);
                            var offset = jnode.offset();
                            var range = {
                                top: offset.top,
                                bottom: offset.top + jnode.height(),
                                left: g.tree.offset().left,
                                right: g.tree.offset().left + g.tree.width()
                            };
                            if (pageX > range.left && pageX < range.right && pageY > range.top && pageY < range.bottom)
                            {
                                var lineTop = offset.top;
                                if (isAfter) lineTop += jnode.height();
                                g.nodeDroptip.css({
                                    left: range.left,
                                    top: lineTop,
                                    width: range.right - range.left
                                }).show();
                                g.nodeDropIn = treedataindex;
                                g.nodeDropDir = isAfter ? "bottom" : "top";
                                if (pageY > range.top + 7 && pageY < range.bottom - 7)
                                {
                                    this.proxy.find(".l-drop-icon:first").removeClass("l-drop-no l-drop-yes").addClass("l-drop-add");
                                    g.nodeDroptip.hide();
                                    g.nodeDropInParent = true;
                                }
                                else
                                {
                                    this.proxy.find(".l-drop-icon:first").removeClass("l-drop-no l-drop-add").addClass("l-drop-yes");
                                    g.nodeDroptip.show();
                                    g.nodeDropInParent = false;
                                }
                                break;
                            }
                            else if (g.nodeDropIn != -1)
                            {
                                g.nodeDropIn = -1;
                                g.nodeDropInParent = false;
                                g.nodeDroptip.hide();
                                this.proxy.find(".l-drop-icon:first").removeClass("l-drop-yes  l-drop-add").addClass("l-drop-no");
                            }
                        }
                    },
                    onStopDrag: function (current, e)
                    {
                        var nodes = this.draggingNodes;
                        g.nodedragging = false;
                        if (g.nodeDropIn != -1)
                        {
                            for (var i = 0; i < nodes.length; i++)
                            {
                                var children = nodes[i].children;
                                if (children)
                                {
                                    nodes = $.grep(nodes, function (node, i)
                                    {
                                        var isIn = $.inArray(node, children) == -1;
                                        return isIn;
                                    });
                                }
                            }
                            for (var i in nodes)
                            {
                                var node = nodes[i];
                                if (g.nodeDropInParent)
                                {
                                    g.remove(node);
                                    g.append(g.nodeDropIn, [node]);
                                }
                                else
                                {
                                    g.remove(node);
                                    g.append(g.getParent(g.nodeDropIn), [node], g.nodeDropIn, g.nodeDropDir == "bottom")
                                }
                            }
                            g.nodeDropIn = -1;
                        }
                        g.nodeDroptip.hide();
                        this.set('cursor', 'default');
                    }
                });
            }
        },
    });
})(jQuery, window);
