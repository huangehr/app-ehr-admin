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
import com.yihu.ehr.util.service.RedisService;
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
    @Autowired
    public RedisService redisService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.indexOf("/login") != -1
                || path.indexOf("/out") != -1
                || path.indexOf(request.getContextPath() + "/static-dev") != -1
                || path.indexOf(request.getContextPath() + "/develop") != -1
                || path.indexOf(request.getContextPath() + "/rest") != -1
                || path.indexOf("swagger") != -1
                || path.indexOf(request.getContextPath() + "/v2/api-docs") != -1
                || path.indexOf(request.getContextPath() + "/browser") != -1
                || path.indexOf(request.getContextPath() + "/mobile") != -1) {
            filterChain.doFilter(request, response);
            return;
        }

        String accessToken = request.getParameter(ContextAttributes.ACCESS_TOKEN);
        String clientId = request.getParameter(ContextAttributes.CLIENT_ID);
        String loginName = request.getParameter(ContextAttributes.LOGIN_NAME);

        boolean valid = false;
        if(request.getSession().getAttribute(SessionAttributeKeys.CurrentUser) == null){
            String currentUser = redisService.getRedisValue(request,SessionAttributeKeys.CurrentUser);
            if(StringUtils.isEmpty(currentUser)){
                valid = true;
            }
        }
        // 待处理 超时问题 session tomcat 默认20s超时 生产session设置半小时
        if (accessToken == null || clientId == null) {
            //session 同步到 redis
            if (request.getSession(false) == null || valid) {
                // AJAX REQUEST PROCESS
                if ("XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))) {
                    response.setHeader("sessionStatus", "timeOut");
                    response.getWriter().print("{}");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/out");
                return;
            }
        } else {
            //验证token
            String validTokenUrl = "/oauth/validToken?clientId=" + clientId + "&accessToken=" + accessToken;
            Map<String, Object> params = new HashMap<>();
            try {
                String resultStr = HttpClientUtil.doPost(authorize + validTokenUrl, params, this.username, this.password);
                Map map = objectMapper.readValue(resultStr, Map.class);
                if ((boolean) map.get("successFlg")) {
                    //验证通过。赋值session中的用户信息
                    resultStr = HttpClientUtil.doGet(comUrl + "/users/" + loginName, params, this.username, this.password);
                    Envelop envelop = (Envelop) this.objectMapper.readValue(resultStr, Envelop.class);
                    String ex = this.objectMapper.writeValueAsString(envelop.getObj());
                    UserDetailModel userDetailModel = this.objectMapper.readValue(ex, UserDetailModel.class);

                    request.getSession().setAttribute(SessionAttributeKeys.CurrentUser, userDetailModel);
                    //session 同步到 redis
                    redisService.setRedisObjectValue(request,SessionAttributeKeys.CurrentUser, userDetailModel);

                    //获取用户角色信息
                    List<AppFeatureModel> features = getUserFeatures(userDetailModel.getId());
                    Collection<GrantedAuthority> gas = new ArrayList<>();
                    if (features != null) {
                        for (AppFeatureModel feature : features) {
                            if (!StringUtils.isEmpty(feature.getUrl()))
                                gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                        }
                    }
                    //生成认证token
                    Authentication token = new UsernamePasswordAuthenticationToken(this.username, this.password, gas);
                    //将信息存放到SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(token);
                } else {
                    //TODO 返回到错误页面
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        filterChain.doFilter(request, response);
    }

    private List<AppFeatureModel> getUserFeatures(String userId) throws Exception {
        Map params = new HashMap<>();
        params.put("user_id", userId);
        String resultStr = HttpClientUtil.doGet(comUrl + "/roles/user/features", params, this.username, this.password);
        EnvelopExt<AppFeatureModel> envelopExt =
                (EnvelopExt<AppFeatureModel>) ObjectMapperUtil.toModel(resultStr, new TypeReference<EnvelopExt<AppFeatureModel>>() {
                });
        if (envelopExt.isSuccessFlg())
            return envelopExt.getDetailModelList();
        throw new Exception(envelopExt.getErrorMsg());
    }

}
