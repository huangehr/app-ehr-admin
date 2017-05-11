<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

  (function ($, win) {
    $(function () {

      /* ************************** 全局变量定义 **************************** */
      var Util = $.Util;
      var retrieve = null;
      var master = null;
      var adapterGrid = null;
      var adapterDataSet = null;
      var adapterType = 21;
      var searchOrg;
      var tabelGrid=null;
      /* *************************** 函数定义 ******************************* */
      function pageInit() {
        retrieve.init();
      }

      /* *************************** 模块初始化 ***************************** */
      retrieve = {
        $element: $('.m-retrieve-area'),
        $startDate:$("#inp_start_date"),
        $endDate:$("#inp_end_date"),
        $addDetail: $('#btn_detail'),
        init: function () {
          var self = this;
          self.$startDate.ligerDateEditor({format: "yyyy-MM-dd"});
          self.$endDate.ligerDateEditor({format: "yyyy-MM-dd"});
          self.$element.show();
        }
      };
      
      tabelGrid = $("#table_analysis").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/report/analysisListData',
            columns: [
									{ display: '时间', name: 'Date', frozen:true,height:"40px"},
	                { display: '对象', name: 'Hospital', frozen:true,height:"40px"},
	                { display: '完整性', columns:
	                [
											{ display: '', name: 'bizhi',height:"40px"},
	                    { display: '整体数量', name: 'OverallQuantity',height:"40px"},
	                    { display: '数据集', name: 'DataSet',height:"40px"},
	                    { display: '数据元', name: 'DataElement',height:"40px"}
		                ]
	                },
	                { display: '准确性', columns:
	                [
	                    { display: '准确性', name: 'Accuracy',height:"40px"}
		                ]
	                },
	                { display: '及时性', columns:
	                [
											{ display: '全部及时性', name: 'AllTimeliness',height:"40px"},
	                    { display: '住院病人及时性', name: 'InpatientTimeliness',height:"40px"},
	                    { display: '门诊病人及时性', name: 'OutpatientTimeliness',height:"40px"}
	                ]
	                }
	                ],
            delayLoad:true,
            selectRowButtonOnly: true,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            onBeforeShowData: function (data) {
            debugger
            	console.log(data);
              if(data.detailModelList.length==0){
                entryMater.reloadGrid('');
              }
            },
            onAfterShowData: function () {
              this.select(0);
              setTimeout(function () {
			            $('#table_analysis .l-grid-body1 .l-grid-body-table tbody').rowspan('Date', tabelGrid);
			            $('#table_analysis .l-grid-body1 .l-grid-body-table tbody').rowspan('Hospital', tabelGrid);
	            }, 0)
            },
            onSelectRow: function(row){
              entryMater.grid.options.newPage = 1;
              entryMater.reloadGrid();
            }
          }));
//			tabelGrid = $("#table_analysis").ligerGrid({
//                columns: [
//									{ display: '时间', name: 'Date', frozen:true,height:"40px"},
//	                { display: '对象', name: 'Hospital', frozen:true,height:"40px"},
//	                { display: '完整性', columns:
//	                [
//											{ display: '', name: 'bizhi',height:"40px"},
//	                    { display: '整体数量', name: 'OverallQuantity',height:"40px"}, 
//	                    { display: '数据集', name: 'DataSet',height:"40px"},
//	                    { display: '数据元', name: 'DataElement',height:"40px"}
//		                ]
//	                },
//	                { display: '准确性', columns:
//	                [
//	                    { display: '准确性', name: 'Accuracy',height:"40px"}
//		                ]
//	                },
//	                { display: '及时性', columns:
//	                [
//											{ display: '全部及时性', name: 'AllTimeliness',height:"40px"},
//	                    { display: '住院病人及时性', name: 'InpatientTimeliness',height:"40px"}, 
//	                    { display: '门诊病人及时性', name: 'OutpatientTimeliness',height:"40px"}
//	                ]
//	                }
//	                ], 
//									pageSize: 30, 
//									checkbox: true,
//	                allowHideColumn: false,
//	                data: CustomersData,
//	                width: '100%', 
//									height: '50px', 
//									isScroll:false,
//									alternatingRow:false,
//									mouseoverRowCssClass:"",
//									rownumbers: true,
//									checkbox:false,
//									headerRowHeight:"40px",
//									onAfterShowData: function (s) {
//			        			setTimeout(function () {
//						            $('#table_analysis .l-grid-body1 .l-grid-body-table tbody').rowspan('Date', tabelGrid);
//						            $('#table_analysis .l-grid-body1 .l-grid-body-table tbody').rowspan('Hospital', tabelGrid);
//			                }, 0)
//			            }
//            });
      /* *************************** 页面功能 **************************** */
      pageInit();
    });
    
  })(jQuery, window);
	jQuery.fn.rowspan = function (colname, tableObj) {
		var colIdx;
		for (var i = 0, n = tableObj.columns.length; i < n; i++) {
		    if (tableObj.columns[i]["columnname"] == colname) {
		        colIdx = i < 0 ? 0 : i ;
		        break;
		    }
		}
		return this.each(function () {
	    var that;
	    $('tr', this).each(function (row) {
	        $('td:eq(' + colIdx + ')', this).filter(':visible').each(function (col) {
	            if (that != null && $(this).html() == $(that).html()) {
	                rowspan = $(that).attr("rowspan");
	                if (rowspan == undefined) {
	                    $(that).attr("rowspan", 1);
	                    rowspan = $(that).attr("rowspan");
	                }
	                rowspan = Number(rowspan) + 1;
	                $(that).attr("rowspan", rowspan);
	                    $(this).hide();
	                } else {
	                    that = this;
	                }
	            });
	        });
	    });
	}
</script>