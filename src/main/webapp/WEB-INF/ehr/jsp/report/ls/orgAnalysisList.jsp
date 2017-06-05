<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<style>
   #contentPage{
     overflow: hidden;
     height: 100%;
   }
  #div_statistics_form{
    overflow: auto;
    position: absolute;
    width: 100%;
    height: 100%;
  }
</style>

<div id="div_statistics_form"  style="overflow:auto" >

  <div style="overflow:auto;margin-bottom: 100px;">
       <!-- ####### 查询条件部分 ####### -->
       <div class="m-retrieve-area f-dn f-pr m-form-inline condition" data-role-form>
         <div class="m-form-group f-mt10">
           <div class="m-form-control f-mr10">
             <!--下拉框-->
             <input id="inp_deptId" class="required useTitle f-h28 f-w150 validate-special-char" data-type="select" placeholder="请选择机构"/>
           </div>
           <div class="m-form-control">
             <input type="text" id="inp_start_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的开始时间"/>
           </div>
           <div class="m-form-control" style="width: 32px;">
             <label>--</label>
           </div>
           <div class="m-form-control">
             <input type="text" id="inp_end_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的结束时间"/>
           </div>
           <div class="m-form-control f-ml10">
             <!--按钮:查询-->
             <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
               <span><spring:message code="btn.search"/></span>
             </div>
           </div>
         </div>
       </div>

    <table width="80%" border="1" align="center" style="text-align:center" id="table_data">

      <%--<c:forEach var="model" items="${qcDailyStorageModelList}" >--%>
        <%--<tr style="margin-bottom: 40px;height: 40px; color: blue;"><td colspan="7"><h3>${model.eventDate}</h3></td></tr>--%>
        <%--<tr  style="height: 40px;">--%>
          <%--<td>数据集</td>--%>
          <%--<td>累计入库记录数</td>--%>
          <%--<td>当天入库记录数</td>--%>
          <%--<td>累计可识别</td>--%>
          <%--<td>累计不可识别</td>--%>
          <%--<td>当天可识别</td>--%>
          <%--<td>当天不可识别</td>--%>
        <%--</tr>--%>
        <%--<c:forEach var="modelDetail" items="${model.qcDailyStorageDetailModelList}" >--%>
          <%--<tr style="height: 30px;">--%>
            <%--<td>${modelDetail.dataType}</td>--%>
            <%--<td>${modelDetail.totalStorageNum}</td>--%>
            <%--<td>${modelDetail.todayStorageNum}</td>--%>
            <%--<td>${modelDetail.totalIdentifyNum}</td>--%>
            <%--<td>${modelDetail.totalNoIdentifyNum}</td>--%>
            <%--<td>${modelDetail.todayIdentifyNum}</td>--%>
            <%--<td>${modelDetail.todayNoIdentifyNum}</td>--%>
          <%--</tr>--%>
        <%--</c:forEach>--%>
      <%--</c:forEach>--%>

    </table>


  </div>

</div>