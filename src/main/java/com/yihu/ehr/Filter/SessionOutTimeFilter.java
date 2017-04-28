package com.yihu.ehr.Filter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.ContextAttributes;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.ObjectMapperUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/3/26
 */
@Component("loginFilter")
public class SessionOutTimeFilter extends OncePerRequestFilter {

    @Value("${app.oauth2authorize}")
    private String authorize;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;

    @Autowired
    public ObjectMapper objectMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, FilterChain filterChain) throws ServletException, IOException {
        String path = httpServletRequest.getRequestURI();
        if (path.indexOf("/login") != -1
                || path.indexOf("/out") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/static-dev") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/develop") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/rest") != -1
                || path.indexOf("swagger") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/v2/api-docs") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/browser") != -1
                || path.indexOf(httpServletRequest.getContextPath() + "/mobile") != -1) {
            filterChain.doFilter(httpServletRequest, httpServletResponse);
            return;
        }

        String accessToken  = httpServletRequest.getParameter(ContextAttributes.ACCESS_TOKEN);
        String clientId  = httpServletRequest.getParameter(ContextAttributes.CLIENT_ID);
        String loginName = httpServletRequest.getParameter(ContextAttributes.LOGIN_NAME);;
        if (accessToken == null || clientId == null) {
            if (httpServletRequest.getSession(false) == null
                    || httpServletRequest.getSession().getAttribute(SessionAttributeKeys.CurrentUser) == null) {

                // AJAX REQUEST PROCESS
                if ("XMLHttpRequest".equalsIgnoreCase(httpServletRequest.getHeader("X-Requested-With"))) {
                    httpServletResponse.setHeader("sessionStatus", "timeOut");
                    httpServletResponse.getWriter().print("{}");
                    return;
                }
                httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/out");
                return;
            }
        }else {
            //验证token
            String validTokenUrl = "/oauth/validToken?clientId=" + clientId + "&accessToken=" + accessToken;
            Map<String, Object> params = new HashMap<>();
            try {
                String resultStr = HttpClientUtil.doPost(authorize + validTokenUrl, params, this.username, this.password);
                Map map = objectMapper.readValue(resultStr, Map.class);
                if ((boolean)map.get("successFlg")){
                    //验证通过。赋值session中的用户信息
                    resultStr = HttpClientUtil.doGet(comUrl + "/users/"+loginName, params, this.username, this.password);
                    Envelop envelop = (Envelop)this.objectMapper.readValue(resultStr, Envelop.class);
                    String ex = this.objectMapper.writeValueAsString(envelop.getObj());
                    UserDetailModel userDetailModel = this.objectMapper.readValue(ex, UserDetailModel.class);
                    httpServletRequest.getSession().setAttribute(SessionAttributeKeys.CurrentUser, userDetailModel);

                    //获取用户角色信息
                    List<AppFeatureModel> features = getUserFeatures(userDetailModel.getId());
                    Collection<GrantedAuthority> gas = new ArrayList<>();
                    if(features!=null){
                        for(AppFeatureModel feature: features){
                            if(!StringUtils.isEmpty(feature.getUrl()))
                                gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                        }
                    }
                    //生成认证token
                    Authentication token = new UsernamePasswordAuthenticationToken(this.username, this.password, gas);
                    //将信息存放到SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(token);
                }else {
                    //TODO 返回到错误页面
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        filterChain.doFilter(httpServletRequest, httpServletResponse);
    }

    private List<AppFeatureModel> getUserFeatures(String userId) throws Exception {
        Map params = new HashMap<>();
        params.put("user_id", userId);
        String resultStr = HttpClientUtil.doGet(comUrl + "/roles/user/features", params, this.username, this.password);
        EnvelopExt<AppFeatureModel> envelopExt =
                (EnvelopExt<AppFeatureModel>) ObjectMapperUtil.toModel(resultStr, new TypeReference<EnvelopExt<AppFeatureModel>>() {
                });
        if(envelopExt.isSuccessFlg())
            return envelopExt.getDetailModelList();
        throw new Exception(envelopExt.getErrorMsg());
    }

}
