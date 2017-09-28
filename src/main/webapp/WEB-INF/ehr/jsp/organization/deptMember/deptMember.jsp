<%--
  Created by IntelliJ IDEA.
  User: janseny
  Date: 2017/7/30
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
    .m-form-control{display: inline-block;vertical-align: middle;}
    .mouse-pop-win{width: 140px;position: fixed;left:0;top: 0;z-index: 10;background: #fff;border: 1px solid #ccc;}
    .pop-item{line-height: 35px;text-align: center;}

    .pop-item a{display: block;color: #555a5f;}
    .pop-item a:hover{background: #00a0e9;color: #fff;}
    .pop-win{width: 460px;/*height: 200px;*/position: fixed;left:50%;top: 50%;-webkit-transform: translate(-50%,-50%);-moz-transform: translate(-50%,-50%);-ms-transform: translate(-50%,-50%);-o-transform: translate(-50%,-50%);transform: translate(-50%,-50%);z-index: 999;background: #fff;border: 1px solid #ccc;padding-bottom: 74px;}
    .pop-form{padding: 17px 0 0 0;}
    .pop-form label{display: block;position: relative;float: left;width: 130px;height: 30px;line-height: 30px;text-align: right;min-height: 1px;padding-right: 10px;padding-left: 10px;font-weight: normal;}
    .pop-form input{height: 28px;line-height: 28px;padding: 0 10px;vertical-align: middle;background-color: #fff;width: 238px;margin: 0;outline: none;color: #555555;margin-top: 1px;}
    .btns{width: 100%;position: absolute;text-align: center;bottom: 0;left: 0;padding: 20px;}
    .btn{display: inline-block;width: 98px;height: 35px;line-height: 23px;text-align: center;color: #fff;font-size: 13px;font-weight: 600;margin: 0 10px;}
    .btn:hover,.btn:focus{color: #fff;}
    .sure-btn{background: #2D9BD2;}
    .cancel-btn{background: #B9C8D2;}
    .pop-tit{height: 40px;line-height: 40px;font-size: 15px;font-weight: 600;padding-left: 10px;color: #fff;background: #2D9BD2;}
    .pop-f-hide{display: none}
    .pop-form .l-checkbox-wrapper{margin-top: 7px;}
</style>

<div class="f-dn" data-head-title="true">部门成员添加</div>
<div id="div_wrapper">
    <div id="conditionArea" class="f-ml10" >
        <div class="body-head f-h40" align="left">
            <a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/organization/initial');"  class="f-fwb">返回上一层 </a>
            <span class="f-ml20 f-fwb">部门与成员管理</span>
            <span class="f-ml20">机构全称：</span><input value="${orgName}" class="f-fwb f-mt10" readonly id="h_org_name"/>
            <span class="f-ml20">机构代码：</span><input value="${orgCode}" class="f-mt10" readonly id="h_org_code"/>
            <input type="hidden" id="h_org_id" value="${orgId}"/>
            <input type="hidden" id="h_org_type" value="${orgType}"/>
        </div>
    </div>
    <!-- ####### 查询条件部分 ####### -->
    <div id="div_content" class="f-ww contentH">
        <div id="div_left" class="f-w240 f-bd f-of-hd" style="position: relative;">
            <div style="position: absolute;left: 10px;top: 6px;">备注：右击可进行部门信息的维护</div>
            <!--资源浏览树-->
            <div id="div_tree" class="f-w230 f-pt30">
                <div id="div_resource_browse_tree"></div>
            </div>
        </div>
        <!--资源浏览详情-->
        <div id="div_right" class="div-resource-browse ">
            <div class="right-retrieve">
                <span id="categoryName" style="font-size: 16px;font-weight:900;display: none"></span>
                <input type="hidden" id="categoryId" />
                <input type="hidden" id="categoryOrgId" />
                <%--<div class="m-form-control">
                    <!--下拉框-->
                    <input type="text" id="inp_status" class="f-h28 f-w160" placeholder="请选择状态" data-type="select"
                           data-attr-scan="status">
                </div>--%>
                <div class="m-form-control">
                    <!--输入框-->
                    <input type="text" id="inp_searchNm" placeholder="请输入成员名称" class="f-ml10 f-h28 f-w240"
                           data-attr-scan="searchNm"/>
                </div>
                <div class="m-form-control  f-mr10">
                    <sec:authorize url="/deptMember/infoInitial">
                        <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-ml10">
                            <span>搜索</span>
                        </div>
                    </sec:authorize>
                </div>
                <div class="m-form-control  f-mr10">
                    <sec:authorize url="/deptMember/infoInitial">
                        <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-ml10">
                            <span>新增成员</span>
                        </div>
                    </sec:authorize>
                </div>
            </div>
            <div class="div-result-msg">
                <div id="div_resource_info_grid"></div>
            </div>
        </div>
    </div>
</div>

