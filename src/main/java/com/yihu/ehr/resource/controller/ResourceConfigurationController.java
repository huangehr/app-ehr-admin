package com.yihu.ehr.resource.controller;

import com.yihu.ehr.api.ServiceApi;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
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
    public String resourceConfigurationInitial(Model model) {
        model.addAttribute("contentPage", "/resource/resourceconfiguration/resourceConfiguration");
        return "pageView";
    }

    @RequestMapping("searchResourceconfiguration")
    @ResponseBody
    public Object searchResourceconfiguration(String searchNm, int page, int rows){
        Map<String, Object> params = new HashMap<>();
        String metaDataUrl = ServiceApi.Resources.Metadatas;
        String resultStr = "";

        params.put("filters","");
        if (!StringUtils.isEmpty(searchNm))
            params.put("filters","name?" + searchNm + " g1;stdCode?" + searchNm +" g1");

        params.put("page", page);
        params.put("size", rows);
        params.put("fields","");
        params.put("sorts","");

        try{

            resultStr = HttpClientUtil.doGet(comUrl + metaDataUrl,params,username,password);

        }catch (Exception e){

        }
        return resultStr;

    }

    @RequestMapping("searchSelResourceconfiguration")
    @ResponseBody
    public Object searchSelResourceconfiguration(String searchNm,String resourcesId, int page, int rows){
        Map<String, Object> params = new HashMap<>();
        String ResourceMetadataUrl = ServiceApi.Resources.ResourceMetadatas;

        String resultStr = "";

        params.put("filters","");
        if (!StringUtils.isEmpty(searchNm))
            params.put("filters","name?" + searchNm + " g1;stdCode?" + searchNm +" g1");

        params.put("resources_id","");
        if (!StringUtils.isEmpty(resourcesId))
            params.put("resources_id",resourcesId);

        params.put("page", page);
        params.put("size", rows);
        params.put("fields","");
        params.put("sorts","");

        try{

            resultStr = HttpClientUtil.doGet(comUrl + ResourceMetadataUrl,params,username,password);

        }catch (Exception e){

        }
        return resultStr;

    }

    @RequestMapping("/saveResourceconfiguration")
    @ResponseBody
    public String saveResourceconfiguration(String addRowDatas, String delRowDatas) {

        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String delMetaDataUrl = ServiceApi.Resources.ResourceMetadatas;
        String addMetaDataUrl = ServiceApi.Resources.ResourceMetadatasBatch;

        try {
            if (!StringUtils.isEmpty(delRowDatas)) {
                //执行删除操作
//                params.put("delRowDatas", delRowDatas);
//                resultStr = HttpClientUtil.doDelete(comUrl + delMetaDataUrl, params, username, password);
            }

            if (!StringUtils.isEmpty(addRowDatas)) {
                //执行新增操作
                params.put("metadatas", addRowDatas);
                resultStr = HttpClientUtil.doPost(comUrl + addMetaDataUrl, params, username, password);
            }
        } catch (Exception e) {

        }

        return resultStr;
    }
}