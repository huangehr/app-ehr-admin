<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">维度授权</div>

<!-- ####### 页面部分 ####### -->
<div>

	<div id="div_wrapper">

		<div id="conditionArea" class="f-mb10 f-mr10" align="right">
			<div class="body-head f-h30" align="left">
				<a id="btn_back" class="f-fwb">返回上一层 </a>
				<input id="adapter_plan_id" value='${adapterPlanId}' hidden="none" />
				<span class="f-ml20">资源名称：</span><input class="f-fwb f-mt10" readonly id="resource_name"/>
				<span class="f-ml20">资源代码：</span><input class="f-fwb f-mt10" readonly id="resource_code"/>
				<span class="f-ml20">资源主题：</span><input class="f-mt10" readonly id="resource_sub"/>
			</div>
		</div>

		<div id="grid_content" style="width: 100%">
			<!--   列表   -->
			<div id="div_right">
				<div id="entryRetrieve" class="m-retrieve-area f-pr m-form-inline condition retrieve-border" data-role-form>
					<div id="resource_title" style="font-size: 20px; height: 40px; text-align: center; padding-top: 14px; font-weight: bold"></div>
					<div id="entry_retrieve_inner" class="m-retrieve-inner m-form-group f-mt10">
					</div>
				</div>
				<div id="rightGrid"></div>
			</div>
		</div>
	</div>

</div>


