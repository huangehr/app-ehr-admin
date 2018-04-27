package com.yihu.ehr.question.controller;

import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by Administrator on 2018/4/19 0019.
 */
@RequestMapping("/question")
@Controller
public class question extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String questionInitial(Model model) {

        model.addAttribute("contentPage","/question/question_list");
        return "pageView";
    }

    @RequestMapping("template")
    public String questionTemplate(Model model) {

        model.addAttribute("contentPage","/questiontemplate/template_list");
        return "pageView";
    }

}
