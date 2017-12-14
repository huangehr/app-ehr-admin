package com.yihu.ehr.dfs;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
    @Value("${fast-dfs.public-server}")
    private String fastDfsPublicServer;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "dfs/list");
        return "pageView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String sn, String name, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        List<Map<String, Object>> filterList = new ArrayList<>();

        if (!StringUtils.isEmpty(sn)) {
            Map<String, Object> snMap = new HashMap<>();
            snMap.put("andOr", "and");
            snMap.put("condition", "=");
            snMap.put("field", "sn");
            snMap.put("value", sn);
            filterList.add(snMap);
        }
        if (!StringUtils.isEmpty(name)) {
            Map<String, Object> nameMap = new HashMap<>();
            nameMap.put("andOr", "and");
            nameMap.put("condition", "?");
            nameMap.put("field", "name");
            nameMap.put("value", name);
            filterList.add(nameMap);
        }

        try {
            params.put("filter", objectMapper.writeValueAsString(filterList));
            params.put("page", page);
            params.put("size", rows);

            return HttpClientUtil.doGet(comUrl + "/fastDfs/page", params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(FastDFSController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/download")
    @ResponseBody
    public Object download(String path) {
        Envelop envelop = new Envelop();
        try {
            path = path.replace(":", "/");
            envelop.setObj(fastDfsPublicServer + "/" + path);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(FastDFSController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
