package com.yihu.ehr.resource.controller;

import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by wq on 2016/5/23.
 */

@Controller
@RequestMapping("/resourceConfiguration")
public class ResourceConfigurationController extends BaseUIController{

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String resourceConfigurationInitial(Model model){
        model.addAttribute("contentPage","/resource/resourceconfiguration/resourceConfiguration");
        return "pageView";
    }
}
