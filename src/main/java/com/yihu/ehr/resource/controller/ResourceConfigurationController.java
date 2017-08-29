package com.yihu.ehr.resource.controller;

import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 资源配置服务控制器
 * Created by wq on 2016/5/23.
 */
@Controller
@RequestMapping("/resourceConfiguration")
public class ResourceConfigurationController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String resourceConfigurationInitial(Model model,String dataModel) {
        model.addAttribute("contentPage", "/resource/resourceconfiguration/resourceConfiguration");
        model.addAttribute("dataModel",dataModel);
        return "pageView";
    }

    @RequestMapping("searchResourceConfiguration")
    @ResponseBody
    public Object searchResourceConfiguration(String searchNm, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        String metaDataUrl = "/resources/metadata";
        String resultStr = "";
        params.put("filters", "");
        String filters ="valid=1";
        if (!StringUtils.isEmpty(searchNm)){
            filters += ";name?" + searchNm + " g1;id?" + searchNm + " g1";
        }
        params.put("filters",filters);
        params.put("page", page);
        params.put("size", rows);
        params.put("fields", "");
        params.put("sorts", "");
        try {
            resultStr = HttpClientUtil.doGet(comUrl + metaDataUrl, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;

    }

    @RequestMapping("searchSelResourceConfiguration")
    @ResponseBody
    public Object searchSelResourceConfiguration(String searchNm, String resourcesId, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        String ResourceMetadataUrl = "/resources/rs_metadata";
        String selResourceMetadataListUrl = "/resources/" + resourcesId + "/metadata_list";
        String resultStr = "";
        try {
            if (searchNm.equals("selAll")) {
                resultStr = HttpClientUtil.doGet(comUrl + selResourceMetadataListUrl, params, username, password);
            } else {
                params.put("filters", "");
                if (!StringUtils.isEmpty(searchNm)) {
                    params.put("filters", "name?" + searchNm + " g1;id?" + searchNm + " g1");
                }
                params.put("resources_id", "");
                if (!StringUtils.isEmpty(resourcesId)) {
                    params.put("resources_id", resourcesId);
                }
                params.put("page", page);
                params.put("size", rows);
                params.put("fields", "");
                params.put("sorts", "");
                resultStr = HttpClientUtil.doGet(comUrl + ResourceMetadataUrl, params, username, password);
            }
        } catch (Exception e) {

        }
        return resultStr;

    }

    @RequestMapping("/saveResourceConfiguration")
    @ResponseBody
    public String saveResourceConfiguration(String addRowDatas, String delRowDatas) {
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String metaDataUrl = "/resources/rs_metadata/batch";
        try {
            if (!StringUtils.isEmpty(delRowDatas)) {
                //执行删除操作
                params.put("ids", delRowDatas);
                resultStr = HttpClientUtil.doDelete(comUrl + metaDataUrl, params, username, password);
            }
            if (!StringUtils.isEmpty(addRowDatas)) {
                //执行新增操作
                params.put("metadatas", addRowDatas);
                resultStr = HttpClientUtil.doPost(comUrl + metaDataUrl, params, username, password);
            }
        } catch (Exception e) {

        }
        return resultStr;
    }
}