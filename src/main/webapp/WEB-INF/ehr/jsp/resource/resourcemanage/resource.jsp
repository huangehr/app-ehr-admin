<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/23
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div class="f-dn" data-head-title="true">资源注册</div>
<div id="div_wrapper">
	<!-- ####### 查询条件部分 ####### -->
	<div id="div_content" class="f-ww contentH">
		<div id="div_left" class="f-w240 f-bd f-of-hd">
			<div class="f-mt10 f-mb10 f-ml10 f-w240">
				<input type="text" id="inp_search" class="f-ml10 f-h28"/>
			</div>
			<!--资源浏览树-->
			<div id="div_tree" class="f-w230">
				<div id="div_resource_browse_tree" class="f-hh"></div>
			</div>
		</div>
		<!--资源浏览详情-->
		<div id="div_right" class="div-resource-browse">
			<div class="right-retrieve">
				<div class="f-db f-pt10 f-pb10 f-ml10">
					<!--输入框-->
					<input type="text" id="inp_searchNm" placeholder="请输入资源代码或名称" class="f-ml10 f-h28 f-w240" data-attr-scan="searchNm"/>
				</div>
				<div class="f-db f-fr f-pt10 f-mr10">
					<div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
						<span>新增资源</span>
					</div>
				</div>
			</div>
			<div class="div-result-msg">
				<div id="div_resource_info_grid"></div>
			</div>
		</div>
	</div>
</div>