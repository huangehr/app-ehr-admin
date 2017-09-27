package com.yihu.ehr.login.controller;

import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
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

    @RequestMapping(value = "")
    public String init(Model model, HttpServletRequest request) throws Exception {
        Object clientId = request.getSession().getAttribute("clientId");
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);

        Map<String, Object> params = new HashMap<>();
        if (clientId != null) {
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

        model.addAttribute("menuData", menuData);
        model.addAttribute("contentPage", "login/empty");
        model.addAttribute("successFlg", true);
        return "frameView";
    }
}