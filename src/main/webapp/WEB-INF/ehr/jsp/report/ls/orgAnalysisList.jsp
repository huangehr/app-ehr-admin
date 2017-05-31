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

  <div style="height: 2000px;overflow:auto">

     <h1 style="margin-bottom: 50px;: 50px;"> 单个机构统计数据 </h1>

    <table width="80%" border="1" align="center" style="text-align:center">

      <c:forEach var="model" items="${qcDailyStorageModelList}" >
        <tr style="margin-bottom: 40px;height: 40px; color: blue;"><td colspan="7"><h3>${model.eventDate}</h3></td></tr>
        <tr  style="height: 40px;">
          <td>数据集</td>
          <td>累计入库记录数</td>
          <td>当天入库记录数</td>
          <td>累计可识别</td>
          <td>累计不可识别</td>
          <td>当天可识别</td>
          <td>当天不可识别</td>
        </tr>
        <c:forEach var="modelDetail" items="${model.qcDailyStorageDetailModelList}" >
          <tr style="height: 30px;">
            <td>${modelDetail.dataType}</td>
            <td>${modelDetail.totalStorageNum}</td>
            <td>${modelDetail.todayStorageNum}</td>
            <td>${modelDetail.totalIdentifyNum}</td>
            <td>${modelDetail.totalNoIdentifyNum}</td>
            <td>${modelDetail.todayIdentifyNum}</td>
            <td>${modelDetail.todayNoIdentifyNum}</td>
          </tr>
        </c:forEach>
      </c:forEach>

    </table>


  </div>

</div>