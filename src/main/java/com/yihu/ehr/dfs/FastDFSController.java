package com.yihu.ehr.dfs;

import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 文件服务 Controller
 *
 * @author 张进军
 * @date 2017/12/13 10:51
 */
@Controller
@RequestMapping("/fastDfs")
public class FastDFSController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "/dfs/fast-dfs/list");
        return "pageView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String sn, String name, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuilder filter = new StringBuilder();

        if (!StringUtils.isEmpty(sn)) {
            filter.append("sn=" + sn);
        }
        if (!StringUtils.isEmpty(name)) {
            filter.append(";name?" + name);
        }

        try {
            params.put("filter", filter.toString());
            params.put("page", page);
            params.put("size", rows);

            return HttpClientUtil.doGet(comUrl + "/fastDfs/page", params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/getPublicUrl")
    @ResponseBody
    public Object getPublicUrl(String path) {
        try {
            return HttpClientUtil.doGet(comUrl + "/fastDfs/getPublicUrl", username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/getServersStatus")
    @ResponseBody
    public Object getServersStatus(String path) {
        try {
            return HttpClientUtil.doGet(comUrl + "/fastDfs/status", username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

}
