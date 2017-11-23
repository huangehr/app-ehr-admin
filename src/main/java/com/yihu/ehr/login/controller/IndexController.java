package com.yihu.ehr.login.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.omg.CORBA.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.lang.Object;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/index")
public class IndexController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Value("${app.baseClientId}")
    private String baseClientId;
    @Autowired
    public ObjectMapper objectMapper;

    @RequestMapping(value = "")
    public String init(Model model, HttpServletRequest request) throws Exception {
        String clientId = (String)request.getSession().getAttribute("clientId");
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        if( ! StringUtils.isNotEmpty(clientId)){
             clientId =  getRedisValue(request,"clientId");
        }
        if(userDetailModel == null){
            userDetailModel = objectMapper.readValue(getRedisValue(request, SessionAttributeKeys.CurrentUser), UserDetailModel.class);
        }
        Map<String, Object> params = new HashMap<>();
        if (StringUtils.isNotEmpty(clientId)) {
            // 从总支撑门户过来，会附带 appId 参数
            params.put("appId", clientId.toString());
        } else {
            // 从总支撑后台管理系统登录界面进来，则显示【基础信息管理】应用菜单
            params.put("appId", baseClientId);
        }
        params.put("userId", userDetailModel.getId());
        String envelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.AppFeature.FindAppMenus, params, username, password);
        Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
        String menuData = toJson(envelop.getDetailModelList());

        String host = (String)request.getSession().getAttribute("host");
        String lastLoginTime = (String)request.getSession().getAttribute("last_login_time");
        if( ! StringUtils.isNotEmpty(host)){
            host = getRedisValue(request ,"host");
        }
        if( ! StringUtils.isNotEmpty(lastLoginTime)){
            lastLoginTime = getRedisValue(request ,"last_login_time");
        }

        model.addAttribute("last_login_time",lastLoginTime);
        model.addAttribute("host",host);
        model.addAttribute("menuData", menuData);
        model.addAttribute("contentPage", "login/empty");
        model.addAttribute("successFlg", true);
        return "frameView";
    }
}