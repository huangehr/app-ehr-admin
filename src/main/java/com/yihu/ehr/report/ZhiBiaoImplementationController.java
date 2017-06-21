package com.yihu.ehr.report;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 * Created by llh on 2017/6/8.
 */
@Controller
@RequestMapping("/zhibiaoimplementation")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ZhiBiaoImplementationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 指标实施首页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiaoconfig/zhiBiaoConfigIndex");
        return "pageView";
    }

    /**
     * 操作日志首页
     * @param model
     * @return
     */
    @RequestMapping("operationLog")
    public String operationLog(Model model) {
        model.addAttribute("contentPage", "/report/zhibiaoconfig/zhiBiaoConfigIndex");
        return "pageView";
    }



}
