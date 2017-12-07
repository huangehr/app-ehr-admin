<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    var clientId = '${clientId}';
    var signin = {
        $signinCon: $('#signinCon'),
        $tipsCon: $('.tips-con'),
        init:function () {
            var me = this;
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
                        "clientId": clientId
                    },
                    success: function (data) {
                        if(data.successFlg){
//                            var iframe = document.createElement('iframe');
                            <%--iframe.src = '${contextRoot}/index#signin';--%>
                            location.href = '${contextRoot}/index#signin';
//                            me.$signinCon.html(iframe);
                        }else{
                            me.$tipsCon.html(me.gethtml('访问失败'));
                            <%--location.href = '${contextRoot}/login';--%>
                        }
                    },
                    error: function (data) {
                        me.$tipsCon.html(me.gethtml('访问失败'));
                        <%--location.href = '${contextRoot}/login';--%>
                    }
                });
                return;
            } else {
                me.$tipsCon.html(me.gethtml('访问失败'));
            }
        },
        gethtml: function (msg) {
            return '<img src="${staticRoot}/images/error.png"><p>' + msg + '</p>';
        }
    }

    $(function() {
        signin.init();
    });

</script>