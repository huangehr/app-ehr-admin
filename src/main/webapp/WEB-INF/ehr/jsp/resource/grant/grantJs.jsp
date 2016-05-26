<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        var data = [];

        data.push({ id: 1, pid: 0, text: '1' });
        data.push({ id: 2, pid: 1, text: '1.1' });
        data.push({ id: 4, pid: 2, text: '1.1.2' });
        data.push({ id: 5, pid: 2, text: '1.1.2' });

        data.push({ id: 10, pid: 8, text: 'wefwfwfe' });
        data.push({ id: 11, pid: 8, text: 'wgegwgwg' });
        data.push({ id: 12, pid: 8, text: 'gwegwg' });

        data.push({ id: 6, pid: 2, text: '1.1.3', ischecked: true });
        data.push({ id: 7, pid: 2, text: '1.1.4' });
        data.push({ id: 8, pid: 7, text: '1.1.5' });
        data.push({ id: 9, pid: 7, text: '1.1.6' });

        function searchFun(){

        }

        var initFilter = function () {
            var vo = [
                {type: 'text', id: 'ipt_app_search', searchFun: searchFun, width: 228},
            ];
            initFormFields(vo);
        };

        var initOrgTree = function () {
            var orgTreeDom = $('#org_tree');
            orgTreeDom.ligerTree({
                idFieldName :'id',
                parentIDFieldName :'pid',
                data: data,
                checkbox: false,
                parentIcon: '',
                childIcon: '',
                slide: false
            });
            orgTreeDom.find('span').addClass('l-tree-text-height');
            $("#org_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
        };

        var initAppAllChecked =  function(){
            var allChecked = $('#allChecked');
            allChecked.mouseover(function () {
                $(this).parent().addClass('l-over');
            })
            allChecked.mouseout(function () {
                $(this).parent().removeClass('l-over');
            });
            allChecked.click(function () {
                $(this).toggleClass('l-checkbox-checked');
                $(this).toggleClass('l-checkbox-unchecked');
            });
        };

        var initAppTree = function () {
            var data = [];
            data.push({ id: 1, pid: 0, text: '1' });
            data.push({ id: 2, pid: 0, text: '1.1' });
            data.push({ id: 4, pid: 0, text: '1.1.2' });
            data.push({ id: 5, pid: 0, text: '1.1.2' });

            var appTreeDom = $('#app_tree');
            appTreeDom.ligerTree({
                idFieldName :'id',
                parentIDFieldName :'pid',
                data: data,
                checkbox: true,
                parentIcon: '',
                childIcon: ''
            });
            appTreeDom.find('span').addClass('l-tree-text-height');
            $("#app_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
        };

        var initCheckedTree = function () {
            var data = [];
            var checkedTreeDom = $('#checked_tree');
            checkedTreeDom.ligerTree({
                idFieldName :'id',
                parentIDFieldName :'pid',
                data: data,
                checkbox: true,
                parentIcon: '',
                childIcon: '',
                slide: false,
                onCheck: function (res,checked) {
                    if(!checked){
                        res.target.remove(res.data);
                    }
                }
            });
            checkedTreeDom.find('span').addClass('l-tree-text-height');
            $("#checked_tree_wrap").mCustomScrollbar({theme: "minimal-dark", axis: "yx"});
        }
        var initForm = function () {
            initFilter();
            initAppAllChecked();
            initOrgTree();
            initAppTree();
            initCheckedTree();
        }();

    })(jQuery, window);
</script>