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
@RequestMapping("/zhibiaoconfig")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ZhiBiaoConfigController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 指标配置管理首页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiaoconfig/zhiBiaoConfigIndex");
        return "pageView";
    }

    /**
     * 新增/编辑数据源页
     * @param model
     * @return
     */
    @RequestMapping("dataSourceDialog")
    public String dataSourceDialog(Model model,String id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "/report/zhibiaoconfig/dataSourceDialog");
        return "simpleView";
    }

    /**
     * 新增/编辑数据存储页
     * @param model
     * @return
     */
    @RequestMapping("dataStorageDialog")
    public String dataStorageDialog(Model model,String id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "/report/zhibiaoconfig/dataStorageDialog");
        return "simpleView";
    }

    /**
     * 新增/编辑主维度页
     * @param model
     * @return
     */
    @RequestMapping("weiDuDialog")
    public String addWeiDuDialog(Model model,String id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "/report/zhibiaoconfig/weiDuDialog");
        return "simpleView";
    }

    /**
     * 新增/编辑细维度页
     * @param model
     * @return
     */
    @RequestMapping("xiWeiDuDialog")
    public String xiWeiDuDialog(Model model,String id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "/report/zhibiaoconfig/xiWeiDuDialog");
        return "simpleView";
    }



}
