<%@ page import="java.util.Date" %>
<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/25
  Time: 10:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/Scripts/setJs.js?tim=<%=new Date()%>"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    $(function () {

        function onUploadSuccess(g, result) {
            if (result == 'suc')
                $.Notice.success("导入成功");
            else {
                result = eval('(' + result + ')')
                var url = "${contextRoot}/std/dataset/downLoadErrInfo?f=" + result.eFile[1] + "&datePath=" + result.eFile[0];
                $.ligerDialog.open({
                    height: 80,
                    content: "请下载&nbsp;<a target='diframe' href='" + url + "'>导入失败信息</a><iframe id='diframe' name='diframe'> </iframe>",
                });
            }
        }

        function onDlgClose() {
            var versionCode = $("#cdaVersion").ligerGetComboBoxManager().getValue();
            set.list.getSetList(versionCode, 1);
        }

        $('#upd').uploadFile({
            url: "${contextRoot}/std/dataset/import?version=000000000000",
            onUploadSuccess: onUploadSuccess,
            onDlgClose: onDlgClose,
            onBeforeUpload: function () {
                if(!set.list.versionStage) {
                    $.Notice.error("已发布版本不可导入数据!");
                    return false;
                }
            }
        });

        set.list.init();
    })
</script>