<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
  (function ($, win) {
    $(function () {

      /* ************************** 全局变量定义 **************************** */
      var Util = $.Util;
      var retrieve = null;
      var master = null;
      var conditionArea = null;
      var organizationCode = '${adapterOrg}';
      var entryRetrieve = null;
      var entryMater = null;
      var cfgModel = 0;
      var changeFlag=false;
      var dialogOpener = null;
      var isFirstPage = true;
      var selectRow = null, isSaveSelectStatus = false;
      var selectEntityRow = null, isSaveEntitySelectStatus = false;
      var cfg = [
        {
          left:{title:'数据集', cls:'', search:'/orgdataset/searchOrgDataSets', goAdd:'/orgdataset/template/orgDataInfo', del:'/orgdataset/deleteOrgDataSet'},
          right:{title:'数据元', cls:'', search:'/orgdataset/searchOrgMetaDatas', goAdd:'/orgdataset/template/orgMetaDataInfo', del:'/orgdataset/deleteOrgMetaData',delLs:'/orgdataset/deleteOrgMetaDataList'}
        },
        {
          left:{title:'字典', cls:'', search:'/orgdict/searchOrgDicts', goAdd:'/orgdict/template/orgDictInfo', del:'/orgdict/deleteOrgDict'},
          right:{title:'字典项', cls:'', search:'/orgdict/searchOrgDictItems', goAdd:'/orgdict/template/orgDictItemsInfo', del:'/orgdict/deleteOrgDictItem',delLs:'/orgdict/deleteOrgDictItemList'}
        }
      ];
      /* *************************** 函数定义 ******************************* */
      function pageInit() {
        resizeContent();
        retrieve.init();
        conditionArea.init();
        entryRetrieve.init();
        master.init();
        master.reloadGrid();
        entryMater.init();
      }

//      function reloadGrid (url, parms) {
//        this.grid.setOptions({url:url,parms:parms});
//        this.grid.loadData(true);
////        this.grid.set({
////          url: url,
////          parms: parms
////        });
////        this.grid.reload();
//      }

      function resizeContent(){
        var contentW = $('#grid_content').width();
        var leftW = $('#div_left').width();
        $('#div_right').width(contentW-leftW-20);
      }
      /* *************************** title模块初始化 ***************************** */
      conditionArea = {
        $element: $('#conditionArea'),
        $adapter_org :$('#adapter_org'),
        $btn_switch_dataSet :$('#switch_dataSet'),
        $btn_switch_dict :$('#switch_dict'),
        init : function () {
          this.initAdapterOrg();
          this.bindEvents();
          this.$element.show();
        },
        initAdapterOrg: function () {
          var dataModel = $.DataModel.init();
          dataModel.fetchRemote("${contextRoot}/adapterorg/getAdapterOrg",{
            data:{code:organizationCode},
            success: function(data) {
              var model = data.obj;
              $("#adapterorg_name").val(model.name);
				$('#adapterorg_type').val(model.typeValue);
				$('#adapterorg_org').val(model.orgValue);
              $('#adapterorg_parent').val(model.parentValue);
            }});
        },
        bindEvents : function () {
          this.$btn_switch_dataSet.click(function () {
            if(cfgModel==0)
              return;
            cfgModel = 0;
            retrieve.setTitle();
            entryRetrieve.setTitle();
            changeFlag=true;
			  conditionArea.$btn_switch_dataSet.addClass('btn-primary');
			  conditionArea.$btn_switch_dict.removeClass('btn-primary');
            master.reloadGrid(1);
          });

          this.$btn_switch_dict.click(function () {
            if(cfgModel==1)
              return;
            cfgModel = 1;
            retrieve.setTitle();
            entryRetrieve.setTitle();
            changeFlag=true;
			  conditionArea.$btn_switch_dataSet.removeClass('btn-primary');
			  conditionArea.$btn_switch_dict.addClass('btn-primary');
            master.reloadGrid(1);
          })
        }
      };

      /* *************************** left模块初始化 ***************************** */
      retrieve = {
        $element: $('#retrieve'),
        $searchNm: $('#searchNm'),
        $addBtn: $('#btn_create'),
        $title :$('#left_title'),
        init: function () {
          this.$searchNm.ligerTextBox({width: 240, isSearch: true, search: function () {
            master.reloadGrid(1);
          }});
          this.$element.show();
        },
        setTitle: function () {
            this.$title.html(cfg[cfgModel].left.title);
        }
      };

      master = {
        infoDialog: null,
        grid: null,
        init: function () {
          if(this.grid)
            return;
          this.grid = $("#div_left_grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/orgdataset/searchOrgDataSets',
            columns: [
              { display: 'id', name: 'id', hide:true },
              { display: 'sequence', name: 'sequence', hide:true },
              { display: '编码', name: 'code',width: '33%', isAllowHide: false ,align:'left '},
              { display: '名称',name: 'name', width: '33%',isAllowHide: false  ,align:'left'},
              { display: '操作', name: 'operator', width: '34%', render: function (row) {
                var html = '<div class="grid_edit" name="edit_click" style="" title="编辑" onclick="javascript:'+Util.format("$.publish('{0}',['{1}','{2}'])","grid:left:open", row.id,'modify')+'"></div> ' +
                            '<div class="grid_delete" name="delete_click" style="" title ="删除" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","grid:left:delete", row.id)+'"></div>'
                return html;
              }}
            ],
            delayLoad:true,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            onBeforeShowData: function (data) {
              if(data.totalCount==0){
                entryMater.reloadGrid(1, '');
              }
            },
            onAfterShowData: function () {
              if(selectRow!=null && isSaveSelectStatus){
                isSaveSelectStatus= false;
                this.select(selectRow);
              }
              else
                this.select(0);
            },
            onSelectRow: function(row){
              selectRow = row;
              entryMater.reloadGrid(1);
            }
          }));
          this.bindEvents();
          // 自适应宽度
          this.grid.adjustToWidth();
        },
        reloadGrid: function (curPage) {

          var searchNm = $("#searchNm").val();
          var values = {
            codeOrName: searchNm,
            organizationCode: organizationCode
          };
          if (changeFlag){
            var url = '${contextRoot}' + cfg[cfgModel].left.search;
            this.grid.setOptions({url:url,parms: $.extend({},values), newPage: 1});
          }else{
            if(curPage){
              this.grid.options.newPage = curPage;
            }
            this.grid.setOptions({parms: $.extend({},values)});
            //重新查询
            this.grid.loadData(true);
          }
//          changeFlag=false;
        },
        bindEvents: function () {
          $.subscribe('grid:left:open',function(event,id,mode){
            var title = mode == 'modify'?'修改' : '新增';
            if(mode=='modify'){
              isSaveSelectStatus = true;
            }
            title += cfg[cfgModel].left.title;
            dialogOpener = cfgModel==0?0:2;
            master.infoDialog = $.ligerDialog.open({
              height:450,
              width: 460,
              title : title,
              url: '${contextRoot}' + cfg[cfgModel].left.goAdd,
              urlParms: {
                id: id,
                mode : mode
              },
              isHidden: false,
              opener: true,
              load: true
            });
          });

          $.subscribe('grid:left:delete',function(event,id) {
            $.Notice.confirm('确认删除所选数据？', function (r) {
              if(r){
                var dataModel = $.DataModel.init();
                dataModel.updateRemote('${contextRoot}'+ cfg[cfgModel].left.del,{
                  data:{id:id},
                  success:function(data){
                    if(data.successFlg){
                      $.Notice.success( '操作成功！');
                      isFirstPage = false;
                      master.reloadGrid(Util.checkCurPage.call(master.grid, 1));
                    }else{
                      $.Notice.success( '操作失败！');
                    }

                  }
                });
              }
            })
          });
        }
      };

      /* *************************** right模块初始化 ***************************** */
      entryRetrieve = {
        $element: $('#entryRetrieve'),
        $searchNm: $('#searchNmEntry'),
        $title: $('#right_title'),
        init: function () {
          this.$searchNm.ligerTextBox({width: 240, isSearch: true, search: function () {
            entryMater.reloadGrid(1);
          }});
          this.$element.show();
        },
        setTitle: function () {
          this.$title.html(cfg[cfgModel].right.title);
        }
      };

      entryMater = {
        entryInfoDialog: null,
        grid: null,
        init: function (dictId) {
          if(this.grid)
            return;
          this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/orgdataset/searchOrgMetaDatas',
            columns: [
              { display: 'id', name: 'id', hide:true },
              { display: 'dictId', name: 'dictId', hide:true },
              { display: '编码', name: 'code',width: '33%', isAllowHide: false ,align:'left' },
              { display: '名称',name: 'name', width: '33%',isAllowHide: false  ,align:'left'},
              { display: '操作', name: 'operator', width: '34%', render: function (row) {
				  var html = '<div class="grid_edit" title="编辑" name="edit_click" style="margin-left:85px;cursor:pointer;" title="修改" onclick="javascript:'+Util.format("$.publish('{0}',['{1}','{2}','{3}'])","grid:right:open", row.id,'modify')+'"></div> '
						  +'<div class="grid_delete" title="删除" name="delete_click" style="margin-left:20px;cursor:pointer;" title ="删除" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","grid:right:delete", row.id)+'"></div>';

//                var html = '<a href="#" onclick="javascript:'+Util.format("$.publish('{0}',['{1}','{2}','{3}'])","grid:right:open", row.id,'modify')+'">修改</a>' +
//                        ' / <a href="#" onclick="javascript:'+Util.format("$.publish('{0}',['{1}'])","grid:right:delete", row.id)+'">删除</a>';
                return html;
              }}
            ],
            delayLoad:true,
            selectRowButtonOnly: false,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            checkbox:true,
            pageSize:15,
            onDblClickRow : function (row){
              //$.publish('grid:right:open',[row.id, 'modify']);
            },
            onAfterShowData: function () {
              if(selectEntityRow!=null && isSaveEntitySelectStatus){
                isSaveEntitySelectStatus= false;
                this.select(selectEntityRow);
              }
            },
            onSelectRow: function(row){
              selectEntityRow = row;
            }
          }));
          this.bindEvents();
          // 自适应宽度
          this.grid.adjustToWidth();
        },
        reloadGrid: function (curPage, seq) {
          var searchNmEntry = $("#searchNmEntry").val();
          if(seq!=''){
            var row = master.grid.getSelectedRow();
            if(row)
              seq = row.sequence;
          }
          var values = {
            organizationCode :organizationCode,
            codeOrName: searchNmEntry,
            orgDataSetSeq:seq,
            orgDictSeq:seq
          };
          if (changeFlag){
            var url = '${contextRoot}'+cfg[cfgModel].right.search;
            this.grid.setOptions({url:url,parms: $.extend({},values), newPage:1});
          }else{
            if(curPage)
              this.grid.options.newPage = curPage;
            this.grid.setOptions({parms: $.extend({},values)});
            //重新查询
            this.grid.loadData(true);
          }
          changeFlag=false;
        },
        bindEvents: function () {
          //窗体改变大小事件
          $(window).bind('resize', function() {
            resizeContent();
          });
          //
          $.subscribe('grid:right:open',function(event,id,mode){
            var row = master.grid.getSelectedRow();
            if(!row){
              if(cfgModel==0)
                $.Notice.warn('请先添加数据集数据');
              else
                $.Notice.warn('请先添加字典数据');
              return;
            }
            var title = mode == 'modify'?'修改' :'新增';
            if(mode=='modify')
              isSaveEntitySelectStatus = true;
            title += cfg[cfgModel].right.title;
            dialogOpener = cfgModel==0?1:3;
            entryMater.entryInfoDialog = $.ligerDialog.open({
              height:460,
              width: 460,
              title : title,
              url: '${contextRoot}'+cfg[cfgModel].right.goAdd,
              urlParms: {
                id:id,
                mode:mode
              },
              isHidden: false,
              opener: true,
              load: true
            });
          });

          $.subscribe('grid:right:delete',function(event,ids) {
            if(!ids){
              var rows = entryMater.grid.getSelectedRows();
              if(rows.length==0){
                $.Notice.warn( '请选择要删除的数据行！');
                return;
              }
              ids ="";
              for(var i=0;i<rows.length;i++){
                ids += rows[i].id+",";
              }
            }
            else
              ids = ids;

            $.Notice.confirm('确认删除所选数据？', function (r) {
              if(r){
                var dataModel = $.DataModel.init();
                dataModel.updateRemote('${contextRoot}'+cfg[cfgModel].right.delLs,{
                  data:{ids:ids},
                  success:function(data){
                    $.Notice.success( '操作成功！');
                    entryMater.reloadGrid(Util.checkCurPage.call(entryMater.grid, ids.split(',').length));
                  }
                });
              }
            })
          });
        },
        closeDl : function () {
          this.entryInfoDialog.close();
        }
      };
      /* ******************Dialog页面回调接口****************************** */
      win.reloadMasterGrid = function () {
        isFirstPage = false;
        if(dialogOpener==0||dialogOpener==2)
          master.reloadGrid();
        else
          entryMater.reloadGrid();
      };
      win.getOrgCode = function () {
        return organizationCode;
      };
      win.getSeq = function () {
        var row = master.grid.getSelectedRow();
        if(row)
          return row.sequence;
        return '';
      };
      win.getDialogOpener = function () {
        return dialogOpener;
      };
      win.closeDialog = function ( msg) {
        if(dialogOpener==0||dialogOpener==2)
          master.infoDialog.close();
        else
          entryMater.closeDl();
        if(msg)
          $.Notice.success(msg);
      };
      /* *************************** 页面功能 **************************** */
      pageInit();
    });
  })(jQuery, window);
</script>
