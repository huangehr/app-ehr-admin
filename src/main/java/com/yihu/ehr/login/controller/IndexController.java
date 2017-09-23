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

    @RequestMapping(value = "")
    public String init(Model model, HttpServletRequest request) throws Exception {
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        Map<String, Object> params = new HashMap<>();
        params.put("appId", "zkGuSIm2Fg"); // 基础信息管理 应用
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