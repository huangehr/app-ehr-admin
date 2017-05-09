package com.yihu.ehr.report;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * Created by llh on 2017/5/9.
 */
@Controller
@RequestMapping("/report")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ReportController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 趋势分析页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/report/trendAnalysis");
        return "pageView";
    }

    /**
     * 分析列表页面
     * @param model
     * @return
     */
    @RequestMapping("analysisList")
    public String addResources(Model model) {
        model.addAttribute("contentPage", "report/analysisList");
        return "pageView";
    }



}
