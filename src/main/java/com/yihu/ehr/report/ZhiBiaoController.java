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
@RequestMapping("/zhibiao")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ZhiBiaoController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 指标管理首页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model, String quotaTypeNo, String name) {
        model.addAttribute("quotaTypeNo", quotaTypeNo);
        model.addAttribute("name", name);
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoIndex");
        return "pageView";
    }

    /**
     * 指标详情页
     * @param model
     * @return
     */
    @RequestMapping("zhiBiaoDetail")
    public String zhiBiaoDetail(Model model,String quotaCode) {
        model.addAttribute("quotaCode", quotaCode);
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoDetail");
        return "emptyView";
    }


    /**
     * 指标图表配置
     * @param model
     * @return
     */
    @RequestMapping("zhiBiaoChartConfigure")
    public String zhiBiaoChartConfigure(Model model,String quotaCode, String quotaName) {
        model.addAttribute("quotaCode", quotaCode);
        model.addAttribute("quotaName", quotaName);
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoChartConfigure");
        return "emptyView";
    }

    /**
     * 新增/编辑指标页
     * @param model
     * @return
     */
    @RequestMapping("zhiBiaoInfoDialog")
    public String zhiBiaoInfoDialog(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoInfoDialog");
        return "simpleView";
    }


}
