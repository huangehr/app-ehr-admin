package com.yihu.ehr.login.controller;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/logout")
public class LogoutController extends BaseUIController{

    @RequestMapping(value = "/reLogin")
    public String login(Model model,HttpServletRequest request) {
        request.getSession().removeAttribute(SessionAttributeKeys.CurrentUser);
        deleteRedisValue(request,SessionAttributeKeys.CurrentUser);
        model.addAttribute("contentPage","login/login");
        model.addAttribute("successFlg", true);
        return "generalView";
    }
}