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
    function isStrEmpty(str) {
        return str == null || !str || typeof str == undefined || str == '';
    }
    function isJson(obj){

        return typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length;
    }

    $.fn.ligerSearchTree = function (options)
    {
        return $.ligerui.run.call(this, "ligerSearchTree", arguments);
    };

    $.ligerui.controls.SearchTree = function (element, options)
    {

        var onSuccess = options.onSuccess;
        options.onSuccess = function (data) {
            var g = this;

            g._checkNextSearch(data);
            g.refreshAllCheckedDomStatus(true);
            if(onSuccess) onSuccess.call(this, data);
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
            var dataIndex = g._getDataIndexByDom(e.target);
            if(dataIndex!=-1) g._addCache(dataIndex);
            if(onBeforeExpand)onBeforeExpand.call(this, e);
        }

        var onCheck = options.onCheck;
        options.onCheck = function (e, checked) {
            var g = this, p= this.options;
            if(onCheck) onCheck.call(this, e, checked);
            g.refreshAllCheckedDomStatus(checked);
        }

        var onAfterSSearch = options.onAfterSSearch;
        options.onAfterSSearch = function (e) {
            var g = this
            if(onAfterSSearch) onAfterSSearch.call(this, e);
            g.refreshAllCheckedDomStatus(true);
        }

        var onUnSelect = options.onUnSelect;
        options.onUnSelect = function (e) {
            var g = this, p= this.options;
            if(onUnSelect) onUnSelect.call(this, e);
            if(!p.isSelectToChecked) return;
            var checkbox;
            if((checkbox=$(e.dom).prev()).hasClass('l-checkbox')){
                checkbox.trigger("click");
            }
        }

        $.ligerui.controls.SearchTree.base.constructor.call(this, element, options);
    };

    var options = {
        _searching: false,
        _searchData: {},
        _searchCache: {},
        allCheckDom: undefined,
        onUnSelect: function () {},
        onAfterSSearch: function() {},

        allCheckDom: undefined,     //全选的节点
        onAllChecked: function() {},  //全选事件
        onAllCancelChecked: function() {},  //取消全选事件
        isSelectToChecked: false,

        renderAll: false,   //weitrue时，  delay为true  同样渲染所有节点，但是是隐藏的
        rusultTree: undefined,  // 将选中的数据集放到该树中

        parentTreeDom: undefined,//作废
        childTree: undefined,     //作废
        onBeforeShowData: function(data) {return data;}

    }






    $.ligerDefaults.SearchTree = $.extend({}, $.ligerDefaults.Tree, options);

    $.ligerui.controls.SearchTree.ligerExtend($.ligerui.controls.Tree, {
        //查询
        s_search: function (queryNm) {
            var g= this;
            if (!isStrEmpty(queryNm)) {
                g.hide($(g.element).find("li")); //先隐藏所有节点
                var liArr = $('span[title*="' + queryNm + '"]', g.tree).closest('li');//查询出符合条件的结果集
                var parent;
                if(liArr.length>0){
                    for (var i = 0; i < liArr.length; i++) {
                        $(liArr[i]).show();
                        parent = $(liArr[i]);
                        while((parent = g.getParentTreeItem(parent))!=null){
                            g.expandNode($(parent));
                        }
                    }
                }
            } else {//查询条件为空，则显示所有节点
                g.show($(g.element).find("li"));
            }
            g.trigger("afterSSearch", [g, queryNm]);
        },
        //异步查询 seq为树形id数组["1,1.2,1.2.3", "2,2.3,2.3.5"]
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
        //清除数据
        removeData : function (treeNode) {
            var g = this, p = this.options;
            treeNode = g.getNodeDom(treeNode);
            var parentNode = g.getParentTreeItem(treeNode);

            var treedataindex = parseInt($(treeNode).attr("treedataindex"));
            var treenodedata = g._getDataNodeByTreeDataIndex(g.data, treedataindex);
            //清除数据
            var parentData;
            if(parentData = g._getDataNodeByTreeDataIndex(g.data, $(parentNode).attr('treedataindex')))
                parentData.children = remove(parentData.children, treenodedata);
            else
                g.data = remove(g.data, treenodedata);

            $(treeNode).remove();
            g._updateStyle(parentNode ? $("ul:first", parentNode) : g.tree);
        },

        expandNode: function (node) {
            $(".l-expandable-close:first", node).addClass('l-expandable-open').removeClass('l-expandable-close');
            $('.l-children:first', node).show();
            $(node).show();
        },
        refreshStatusFromResultTree: function (data) {
            var g= this;
            data = data || g.getData();

        },
        _initAllCheckedDom: function(){
            var g= this, p= this.options, dom = p.allCheckDom;
            if(!dom) return;
            dom.mouseover(function () {
                $(this).parent().addClass('l-over');
            })
            dom.mouseout(function () {
                $(this).parent().removeClass('l-over');
            });
            dom.click(function (e, data) {
                var clz = $(this).attr('class');
                if(clz.indexOf('l-checkbox-checked') != -1)
                    g.unCheckAll(true);
                else
                    g.checkAll(true);
            });
        },
        unCheckAll: function (isTriggerAllCancelEvt) {
            var g= this, p= this.options;
            if(p.allCheckDom)
                $(p.allCheckDom).removeClass('l-checkbox-checked l-checkbox-incomplete').addClass('l-checkbox-unchecked');

            g.selectNode(function (e) {
                if( $(g.getNodeDom(e)).is(':visible'))
                    g.cancelSelect(e);
                return false;
            });
            if(isTriggerAllCancelEvt==undefined || isTriggerAllCancelEvt==true) g.trigger('allCancelChecked', g);
        },
        checkAll: function (isTriggerAllCheckEvt) {
            var g= this, p= this.options;
            if(p.allCheckDom)
                $(p.allCheckDom).removeClass('l-checkbox-incomplete l-checkbox-unchecked').addClass('l-checkbox-checked');

            g.selectNode(function (e) {
                return ! $(g.getNodeDom(e)).is(':hidden');
            })
            if(isTriggerAllCheckEvt==undefined || isTriggerAllCheckEvt==true) g.trigger('allChecked', g);
        },
        refreshAllCheckedDomStatus: function(checked){
            var g= this, p= this.options, allCheckDom = p.allCheckDom;
            if(!allCheckDom) return;
            if(g.isAllChecked())
                allCheckDom.addClass('l-checkbox-checked').removeClass('l-checkbox-unchecked l-checkbox-incomplete');
            else if(g.isEmpty() || g.isNoChecked())
                allCheckDom.addClass('l-checkbox-unchecked').removeClass('l-checkbox-incomplete l-checkbox-checked');
            else
                allCheckDom.addClass('l-checkbox-incomplete').removeClass('l-checkbox-unchecked l-checkbox-checked');
        },
        getDataByNode: function (treenode) {
            var g= this;
            var dataindex = g._getDataIndexByDom(treenode);
            if(dataindex==-1) return {};
            return g._getDataNodeByTreeDataIndex(g.data, dataindex);
        },
        /*****************************************************************************************/
        /**    判断方法                                                                        **/
        /*****************************************************************************************/
        isAllChecked: function () {
            var g= this;
            return !g.isEmpty() && $('.l-box.l-checkbox.l-checkbox-unchecked:visible', g.tree).length==0;
        },
        isNoChecked: function () {
            var g= this;
            return $('.l-box.l-checkbox.l-checkbox-checked:visible', g.tree).length==0;
        },
        isEmpty: function () {
            var g= this;
            return $('.l-body:visible', g.tree).length == 0;
        },
        isExist: function (parentDom, id, outlinelevel) {
            return $(parentDom).find('li[id="'+ id +'"][outlinelevel='+ outlinelevel +']').length>0;
        },


        /*****************************************************************************************/
        /**    异步查询方法                                                                     **/
        /*****************************************************************************************/
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


        /*****************************************************************************************/
        /**    重写原方法                                                                     **/
        /*****************************************************************************************/
        _init: function ()
        {
            $.ligerui.controls.Tree.base._init.call(this);
            var g = this, p = this.options;
            if (p.single) p.autoCheckboxEven = false;
            g._initAllCheckedDom();
        },
        //parm [nodeParm] dom节点(li)、节点数据 或者节点 dataindex
        cancelSelect: function (nodeParm, isTriggerEvent)
        {
            var g = this, p = this.options;
            var domNode = g.getNodeDom(nodeParm);
            var treeitem = $(domNode);
            var treedataindex = parseInt(treeitem.attr("treedataindex"));
            var treenodedata = g._getDataNodeByTreeDataIndex(g.data, treedataindex);
            var treeitembody = $(">div:first", treeitem);
            if (p.checkbox)
                $(".l-checkbox", treeitembody).removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
            else
                treeitembody.removeClass("l-selected");
            if(p.allCheckDom)
                g.refreshAllCheckedDomStatus(false);
            if (isTriggerEvent != false)
            {
                g.trigger('cancelSelect', [{ data: treenodedata, target: treeitem[0] }]);
            }
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
        //根据data生成最终完整的tree html
        _getTreeHTMLByData: function (data, outlineLevel, isLast, isExpand)
        {
            var g = this, p = this.options;
            if (g.maxOutlineLevel < outlineLevel)
                g.maxOutlineLevel = outlineLevel;
            isLast = isLast || [];
            outlineLevel = outlineLevel || 1;
            var treehtmlarr = [];
            if (!isExpand) treehtmlarr.push('<ul class="l-children" style="display:none">');
            else treehtmlarr.push("<ul class='l-children'>");
            for (var i = 0; i < data.length; i++)
            {
                var o = data[i];
                var isFirst = i == 0;
                var isLastCurrent = i == data.length - 1;
                var delay = g._getDelay(o, outlineLevel);
                var isExpandCurrent = delay ? false : g._isExpand(o, outlineLevel);

                treehtmlarr.push('<li ');
                if (o.treedataindex != undefined)
                    treehtmlarr.push('treedataindex="' + o.treedataindex + '" ');
                if (isExpandCurrent)
                    treehtmlarr.push('isexpand=' + o.isexpand + ' ');
                treehtmlarr.push('outlinelevel=' + outlineLevel + ' ');
                //增加属性支持
                for (var j = 0; j < g.sysAttribute.length; j++)
                {
                    if ($(this).attr(g.sysAttribute[j]))
                        data[dataindex][g.sysAttribute[j]] = $(this).attr(g.sysAttribute[j]);
                }
                for (var j = 0; j < p.attribute.length; j++)
                {
                    if (o[p.attribute[j]])
                        treehtmlarr.push(p.attribute[j] + '="' + o[p.attribute[j]] + '" ');
                }

                //css class
                treehtmlarr.push('class="');
                isFirst && treehtmlarr.push('l-first ');
                isLastCurrent && treehtmlarr.push('l-last ');
                isFirst && isLastCurrent && treehtmlarr.push('l-onlychild ');
                treehtmlarr.push('"');
                treehtmlarr.push('>');
                treehtmlarr.push('<div class="l-body');
                if (p.selectable && p.selectable(o) == false)
                {
                    treehtmlarr.push(' l-unselectable');
                }
                treehtmlarr.push('">');
                for (var k = 0; k <= outlineLevel - 2; k++)
                {
                    if (isLast[k]) treehtmlarr.push('<div class="l-box"></div>');
                    else treehtmlarr.push('<div class="l-box l-line"></div>');
                }
                if (g.hasChildren(o))
                {
                    if (isExpandCurrent) treehtmlarr.push('<div class="l-box l-expandable-open"></div>');
                    else treehtmlarr.push('<div class="l-box l-expandable-close"></div>');
                    if (p.checkbox)
                    {
                        if (o.ischecked)
                            treehtmlarr.push('<div class="l-box l-checkbox l-checkbox-checked"></div>');
                        else if(g.isIncomplete(o))
                            treehtmlarr.push('<div class="l-box l-checkbox l-checkbox-incomplete"></div>');
                        else
                            treehtmlarr.push('<div class="l-box l-checkbox l-checkbox-unchecked"></div>');
                    }
                    if (p.parentIcon)
                    {
                        //node icon
                        treehtmlarr.push('<div class="l-box l-tree-icon ');
                        treehtmlarr.push(g._getParentNodeClassName(isExpandCurrent ? true : false) + " ");
                        if (p.iconFieldName && o[p.iconFieldName])
                            treehtmlarr.push('l-tree-icon-none');
                        treehtmlarr.push('">');
                        if (p.iconFieldName && o[p.iconFieldName])
                            treehtmlarr.push('<img src="' + o[p.iconFieldName] + '" />');
                        treehtmlarr.push('</div>');
                    }
                }
                else
                {
                    if (isLastCurrent) treehtmlarr.push('<div class="l-box l-note-last"></div>');
                    else treehtmlarr.push('<div class="l-box l-note"></div>');
                    if (p.checkbox)
                    {
                        if (o.ischecked)
                            treehtmlarr.push('<div class="l-box l-checkbox l-checkbox-checked"></div>');
                        else
                            treehtmlarr.push('<div class="l-box l-checkbox l-checkbox-unchecked"></div>');
                    }
                    if (p.childIcon)
                    {
                        //node icon
                        treehtmlarr.push('<div class="l-box l-tree-icon ');
                        treehtmlarr.push(g._getChildNodeClassName() + " ");
                        if (p.iconFieldName && o[p.iconFieldName])
                            treehtmlarr.push('l-tree-icon-none');
                        treehtmlarr.push('">');
                        if (p.iconFieldName && o[p.iconFieldName])
                            treehtmlarr.push('<img src="' + o[p.iconFieldName] + '" />');
                        treehtmlarr.push('</div>');
                    }
                }
                if (p.render)
                {
                    treehtmlarr.push('<span>' + p.render(o, o[p.textFieldName]) + '</span>');
                } else
                {
                    /*treehtmlarr.push('<span>' + o[p.textFieldName] + '</span>');*/
                    /*****************TODO开始*******************/
                    treehtmlarr.push('<span title="'+ o[p.textFieldName] +'">' + o[p.textFieldName] + '</span>');
                    /*****************TODO结束*******************/
                }
                treehtmlarr.push('</div>');
                if (g.hasChildren(o))
                {
                    var isLastNew = [];
                    for (var k = 0; k < isLast.length; k++)
                    {
                        isLastNew.push(isLast[k]);
                    }
                    isLastNew.push(isLastCurrent);
                    if (delay)
                    {
                        if(delay==true && p.renderAll){
                            treehtmlarr.push(g._getTreeHTMLByData(o.children, outlineLevel + 1, isLastNew, false).join(''));
                        }
                        else if (delay == true)
                        {
                            g.toggleNodeCallbacks.push({
                                data: o,
                                callback: function (dom, o)
                                {
                                    var content = g._getTreeHTMLByData(o.children, outlineLevel + 1, isLastNew, isExpandCurrent).join('');
                                    $(dom).append(content);
                                    $(">.l-children .l-body", dom).hover(function ()
                                    {
                                        $(this).addClass("l-over");
                                    }, function ()
                                    {
                                        $(this).removeClass("l-over");
                                    });
                                    g._removeToggleNodeCallback(o);
                                }
                            });
                        }
                        else if (delay.url)
                        {
                            (function (o, url, parms)
                            {
                                g.toggleNodeCallbacks.push({
                                    data: o,
                                    callback: function (dom, o)
                                    {
                                        g.loadData(dom, url, parms, {
                                            showLoading: function ()
                                            {
                                                $("div.l-expandable-close:first", dom).addClass("l-box-loading");
                                            },
                                            hideLoading: function ()
                                            {
                                                $("div.l-box-loading:first", dom).removeClass("l-box-loading");
                                            }
                                        });
                                        g._removeToggleNodeCallback(o);
                                    }
                                });
                            })(o, delay.url, delay.parms);
                        }
                    }
                    else
                    {
                        treehtmlarr.push(g._getTreeHTMLByData(o.children, outlineLevel + 1, isLastNew, isExpandCurrent).join(''));
                    }

                }
                treehtmlarr.push('</li>');
            }
            treehtmlarr.push("</ul>");
            return treehtmlarr;

        },
        loadData: function (node, url, param, e)
        {
            var g = this, p = this.options;
            e = $.extend({
                showLoading: function ()
                {
                    g.loading.show();
                },
                success: function () { },
                error: function () { },
                hideLoading: function ()
                {
                    g.loading.hide();
                }
            }, e || {});
            var ajaxtype = p.ajaxType;
            //解决树无法设置parms的问题
            param = $.extend(($.isFunction(p.parms) ? p.parms() : p.parms), param);
            if (p.ajaxContentType == "application/json" && typeof (param) != "string")
            {
                param = liger.toJSON(param);
            }
            var urlParms = $.isFunction(p.urlParms) ? p.urlParms.call(g) : p.urlParms;
            if (urlParms)
            {
                for (name in urlParms)
                {
                    url += url.indexOf('?') == -1 ? "?" : "&";
                    url += name + "=" + urlParms[name];
                }
            }
            var ajaxOp = {
                type: ajaxtype,
                url: url,
                data: param,
                dataType: 'json',
                beforeSend: function ()
                {
                    e.showLoading();
                },
                success: function (data)
                {
                    if (!data) return;
                    if (p.idField && p.parentIDField)
                    {
                        data = g.arrayToTree(data, p.idField, p.parentIDField);
                    }
                    e.hideLoading();
                    data = p.onBeforeShowData? p.onBeforeShowData(data) : data;
                    g.append(node, data);
                    g.trigger('success', [data]);
                    e.success(data);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown)
                {
                    try
                    {
                        e.hideLoading();
                        g.trigger('error', [XMLHttpRequest, textStatus, errorThrown]);
                        e.error(XMLHttpRequest, textStatus, errorThrown);
                    }
                    catch (e)
                    {

                    }
                }
            };
            if (p.ajaxContentType)
            {
                ajaxOp.contentType = p.ajaxContentType;
            }
            $.ajax(ajaxOp);
        },

    });
})(jQuery, window);
