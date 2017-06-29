<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var signin = {
        init:function () {
            //判断是否自动登录
            var hash = window.location.hash;
            if(hash.indexOf("#access_token")>=0)
            {
                //获取accrss_token
                var tokenString =hash.substring(1,hash.indexOf("&"));
                var token = tokenString.substr(hash.indexOf("="));
                //自动登录
                $.ajax({
                    url: "${contextRoot}/login/autoLogin",
                    type: 'POST',
                    dataType: 'json',
                    data:{
                        "token":token,
                        "isQcReport":2
                    },
                    success: function (data) {
                        if(data.successFlg){
                            location.href = '${contextRoot}/resourceBrowse/browseBefore#signin';
                        }else{
                            location.href = '${contextRoot}/login';
                        }
                    },
                    error: function (data) {
                        location.href = '${contextRoot}/login';
                    }
                });
                return;
            }
        }
    }

    $(function() {
        signin.init();
    });

</script>