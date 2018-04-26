<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
	<%--样式重置--%>
	.l-frozen .l-grid2 .l-grid-body {
		overflow-x: hidden !important;
	}
</style>
<input type="text" id="ipt_param_resourcesId" hidden="hidden" value="${resourcesId}"/>
<input type="text" id="ipt_param_resourcesCode" hidden="hidden" value="${resourcesCode}"/>
<%--<div id="">--%>
	<%--<div class="">--%>
		<%--<div  id="btn_param_new" style="" class="f-w120 l-button u-btn u-btn-primary u-btn-large " >--%>
			<%--<span>新增</span>--%>
		<%--</div>--%>
	<%--</div>--%>
	<%--<div>--%>
		<%--<div id="div_param_grid" class="f-m10" ></div>--%>
	<%--</div>--%>
<%--</div>--%>

<div id="div_wrapper" >
	<div class="m-retrieve-area f-pr m-form-inline" style="height: 40px">
		<div class="m-form-group f-mt10 ">
			<div class="m-form-control m-form-control-fr">
				<div id="btn_param_new" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span><spring:message code="btn.create"/></span>
				</div>
			</div>
		</div>
	</div>
	<div id="div_param_grid" ></div>
</div>


