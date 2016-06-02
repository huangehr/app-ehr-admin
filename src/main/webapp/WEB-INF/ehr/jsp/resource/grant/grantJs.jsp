<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        var treeData = parent.getTreeData();

        var resourceId = '${resourceId}';
        var urls = {grant: "${contextRoot}/resource/grant/saveGrantApp"}
        function searchFun(){
            var p = $('#ipt_app_search').val();
            appTree.s_search(p);
        }

        var initFilter = function () {
            var vo = [
                {type: 'text', id: 'ipt_app_search', searchFun: searchFun, width: 228},
            ];
            initFormFields(vo);
        };

        var initBtn = function () {

            function treeToArr(treeData, arr){
                if(!treeData || !$.isArray(treeData)|| treeData.length==0)
                    return;
                $.each(treeData, function (i, v) {
                    arr.push(v);
                    treeToArr(v.children, arr);
                })
            }
            function getDataId(data){
                var ids = [];
                if(data && $.isArray(data)){
                    $.each(data, function (i, v) {
                        if(parseInt($(checkedTree.getNodeDom(v)).attr('outlinelevel'))==3){
                            ids.push(v.id);
                        }
                    })
                }
                return ids;
            }

            var oldIds = [];
            treeToArr(treeData, oldIds);
            oldIds = getDataId(oldIds);

            function getDeleteIds(curDataIdStr){
                var ids = [];
                $.each(oldIds, function (i, v) {
                    if(curDataIdStr.indexOf(v)==-1){
                        ids.push(v);
                    }
                })
                return ids;
            }
            function getAddIds(data){
                var ids = [];
                var oldIdStr = oldIds.join(",");
                $.each(data, function (i, v) {
                    if(oldIdStr.indexOf(v)==-1){
                        ids.push(v);
                    }
                })
                return ids;
            }
            
            $('#btn_grant').click(function () {
                var waittingDialog = $.ligerDialog.waitting('正在授权中,请稍候...');
                var dataId = getDataId(checkedTree.getCheckedData());
                var dataModel = $.DataModel.init();
                dataModel.createRemote(urls.grant, {
                    data: {
                        resourceId: resourceId,
                        deleteIds: getDeleteIds(dataId.join(",")).join(","),
                        addIds: getAddIds(dataId).join(",")},
                    success: function (data) {
                        waittingDialog.close();
                        if(data.successFlg){
                            parent.closeDialog("授权成功！");
                        }else
                            $.Notice.error("授权失败！");
                    },
                    error: function () {
                        $.Notice.error("请求出错！");
                        waittingDialog.close();
                    }
                });
            });

            $('#btn_cancel').click(function () {
                parent.closeDialog();
            })
        }

        var selectedOrg, orgTree, orgTreeDom = $('#org_tree');
        var initOrgTree = function () {
            fetchData('${contextRoot}/dict/searchDictEntryList?dictId=7&page=1&rows=50',
                    function (data) {
                        data = data.detailModelList;
                        $.each(data, function (i, v) {
                            v.children = [];
                            v.id = v.code;
                            v.name = v.value;
                            v.level = 1;
                        });
                        orgTree = initTree(orgTreeDom,
                                {
                                    btnClickToToggleOnly: false,
                                    needCancel: false,
                                    data: data,
                                    selectable: function (e) { return e.level != 1;},
                                    delay: function (e) { return {url: '${contextRoot}/resource/grant/getOrgList?orgType=' + e.data.code};},
                                    onSelect: function (e) { selectedOrg = e.data; initAppTree(e.data.id.substring(4));}
                                });
                        $("#org_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
            });
        };

        var allChecked = $('#allChecked');
        var initAppAllChecked =  function(){
            allChecked.mouseover(function () {
                $(this).parent().addClass('l-over');
            })
            allChecked.mouseout(function () {
                $(this).parent().removeClass('l-over');
            });
            allChecked.click(function (e, model) {
                var clz = $(this).attr('class');
                if(clz.indexOf('l-checkbox-checked') != -1 || model=='cancelSelect'){
                    $(this).removeClass('l-checkbox-checked l-checkbox-incomplete').addClass('l-checkbox-unchecked');
                    appTree.selectNode(function (e) {
                        appTree.cancelSelect(e);
                        return false;
                    });
                    if(model != 'cancelSelect'){
                        if($(appTreeDom).find('.l-box.l-checkbox:hidden').length==0)
                            cancelSelete(selectedOrg, 2);
                        else{
                            var doms = $(appTreeDom).find('li:visible');
                            var treedata = appTree.getData();
                            $.each(doms, function (i, v) {
                                cancelSelete(appTree._getDataNodeByTreeDataIndex(treedata, $(v).attr('treedataindex')), 3);
                            })
                        }
                    }
                }else{
                    $(this).removeClass('l-checkbox-incomplete l-checkbox-unchecked').addClass('l-checkbox-checked');
                    appTree.selectNode(function (e) {
                        var node = $(appTree.getNodeDom (e));
                        return !node.is(':hidden');
                    })
                    refreshCheckedTree(true, appTree.getCheckedData(), 3, true);
                }
            });
        };

        var appTree,appTreeDom = $('#app_tree');
        var initAppTree = function (code) {
            var url = "${contextRoot}/resource/grant/getApps?org="+code;
            if(appTree){
                $(allChecked).removeClass('l-checkbox-checked l-checkbox-incomplete').addClass('l-checkbox-unchecked');
                appTree.clear();
                appTree.loadData(undefined, url, {});
            }
            else{
                appTree = initTree(appTreeDom, {checkbox: true, url: url,
                    selectable: function () {return false;},
                    onUnSelect: function (e) {
                        var checkbox;
                        if((checkbox=$(e.dom).prev()).hasClass('l-checkbox')){
                            checkbox.trigger("click");
                        }
                    },
                    onAfterSSearch: function (e) {
                        refreshAllCheckedDomStatus(true);
                    },
                    onSuccess: function (data) {
                        var data = data.detailModelList;
                        var chkLen = 0;
                        $.each(data, function (i, v) {
                            if(findDomById(checkedTreeDom, v.id, 3).length>0){
                                chkLen++;
                                v.ischecked = true;
                            }
                        })
                        this.setData(data);
                        refreshAllCheckedDomStatus(true);
                    },
                    onCheck: function (e, checked) {
                        refreshAllCheckedDomStatus(checked);
                        refreshCheckedTree(checked, [e.data], 3, false);
                    }
                });
                $("#app_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
            }
        };

        var checkedTree, checkedTreeDom = $('#checked_tree');
        var initCheckedTree = function () {

            checkedTree =initTree(checkedTreeDom, {
                data: treeData,
                checkbox: true,
                btnClickToToggleOnly: false,
                selectable: function (e) {return false;},
                onCheck: function (res, checked) {
                    if(!checked){
                        var dom = $(res.target);
                        var outlinelevel = dom.attr('outlinelevel');
                        if(outlinelevel==1 && selectedOrg){
                            var id = orgTree.getParentTreeItem(selectedOrg, 1).id;
                            if(res.data.id==id)
                                allChecked.trigger('click', 'cancelSelect');
                        }
                        else if(outlinelevel==2){
                            if(selectedOrg && res.data.id==selectedOrg.id)
                                allChecked.trigger('click', 'cancelSelect');
                        }
                        else {
                            if(selectedOrg && selectedOrg.id==checkedTree.getParentTreeItem(res.target, 2).id){
                                appTree.cancelSelect(findDomById(appTreeDom, res.data.id, 1));
                                refreshAllCheckedDomStatus(checked);
                            }
                        }
                        cancelSelete(res.data, outlinelevel);
                    }
                },
                onCancelselect: function (res) {
                    checkedTree.removeData(res.data);
                }
            });

            checkedTreeDom.find('.l-box.l-checkbox').addClass('l-checkbox-checked').removeClass('l-checkbox-unchecked');
            $("#checked_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
        }



        function refreshAllCheckedDomStatus(checked){
            var allChecked = $('#allChecked');
            if(checked && appTree.isAllChecked())
                allChecked.addClass('l-checkbox-checked').removeClass('l-checkbox-unchecked l-checkbox-incomplete');
            else if(appTree.isEmpty() || appTree.isNoChecked())
                allChecked.addClass('l-checkbox-unchecked').removeClass('l-checkbox-incomplete l-checkbox-checked');
            else
                allChecked.addClass('l-checkbox-incomplete').removeClass('l-checkbox-unchecked l-checkbox-checked');
        }

        function refreshCheckedTree(checked, newData, outlinelevel, allChecked) {
            var tmp;
            if(checked && selectedOrg){
                if(!allChecked && findDomById(checkedTreeDom, newData[0].id, outlinelevel).length>0)
                    return;
                if((tmp = findDomById(checkedTreeDom, selectedOrg.id, 2)).length==0){
                    var parentData = orgTree.getDataByID(orgTree.getParentTreeItem(selectedOrg, 1).id);
                    if((tmp = findDomById(checkedTreeDom, parentData.id, 1)).length==0)
                        newData = copyData([parentData, selectedOrg, newData]) ;
                    else
                        newData = copyData([selectedOrg, newData]) ;
                }
                else{
                    function isCopy(id){
                        return !checkedTree.isExist(tmp[0], id, 3);
                    }
                    newData = copyData([newData], isCopy);
                }
                checkedTree.append(tmp[0], newData);
            }
            else if(!checked) {
                cancelSelete(newData[0], outlinelevel);
            }
        }

        function cancelSelete(newData, outlinelevel){
            var node = findDomById(checkedTreeDom, newData.id, outlinelevel);
            var parentDom = $(checkedTree.getParentTreeItem(node));
            var parentData ;
            if(parentDom.length==0 || ((parentData = getDataByDom(checkedTree, parentDom)).children &&　parentData.children.length > 1)){
                checkedTree.cancelSelect(node);
            }
            else{
                cancelSelete(parentData, parseInt(outlinelevel) - 1);
            }
        }

        function getDataByDom(checkedTree, dom){
            var dataId = dom.attr?dom.attr('treedataindex'): dom;
            return checkedTree._getDataNodeByTreeDataIndex(checkedTree.getData(),dataId);
        }


        function copyData(data, isCopy){
            var newData, tmp =[];
            for(var i=data.length-1; i>=0; i--){
                if($.isArray((tmp = data[i]))){
                    if(i!=data.length-1)
                        throw new error("param error！");
                    newData = [];
                    $.each(tmp, function (i, v) {
                        if(!isCopy || isCopy(v.id)) {
                            newData.push({id: v.id, name: v.name, ischecked: true});
                        }
                    })
                } else {
                    if(newData)
                        newData = [{id: tmp.id, name: tmp.name, children: newData, ischecked: true}];
                    else
                        newData = [{id: tmp.id, name: tmp.name, ischecked: true}];
                }
            }
            return newData;
        }

        function findDomById(parent, id, outlinelevel){
            return parent.find('li[id="'+ id +'"][outlinelevel='+ outlinelevel +']:first');
        }

        var initForm = function () {
            initFilter();
            initAppAllChecked();
            initOrgTree();
            initAppTree();
            initCheckedTree();
            initBtn();
//            checkedTree.isAllChecked();
        }();

    })(jQuery, window);
</script>