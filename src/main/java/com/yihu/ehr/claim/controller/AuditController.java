package com.yihu.ehr.claim.controller;

import com.yihu.ehr.controller.BaseUIController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by wq on 2016/6/21.
 */

@Controller
@RequestMapping("/audit")
public class AuditController extends BaseUIController{

    @RequestMapping("/initial")
    public String initial(Model model){
        model.addAttribute("contentPage","claim/audit");
        return "pageView";
    }
}
