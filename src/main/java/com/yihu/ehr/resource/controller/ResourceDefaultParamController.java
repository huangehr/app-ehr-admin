package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.resource.ResourceDefaultParamModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by yww on 2016/7/20.
 */
@Controller
@RequestMapping("/resource/rsDefaultParam")
public class ResourceDefaultParamController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String rsDefaultParamInitial(Model model,String resourcesId,String resourcesCode){
        model.addAttribute("contentPage","/resource/rsdefaultparam/defaultParam");
        model.addAttribute("resourcesId",resourcesId);
        model.addAttribute("resourcesCode",resourcesCode);
        return "simpleView";
    }

    @RequestMapping("/infoInitial")
    public String rsDefaultParamInfoInitial(Model model,String id,String resourcesId,String resourcesCode,String mode,String rowIndex){
        model.addAttribute("contentPage","/resource/rsdefaultparam/defaultParamDialog");
        model.addAttribute("mode",mode);
        model.addAttribute("resourcesId",resourcesId);
        model.addAttribute("resourcesCode",resourcesCode);
        model.addAttribute("rowIndex",rowIndex);
        Envelop envelop = new Envelop();
        String en = "";
        try {
            en = objectMapper.writeValueAsString(envelop);
            if(StringUtils.equals(mode,"new")){
                model.addAttribute("info", en);
                return "simpleView";
            }
            String url = "/resources/param/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            model.addAttribute("info", envelopStr);
        } catch (Exception ex) {
            LogService.getLogger(ResourceDefaultParamModel.class).error(ex.getMessage());
            model.addAttribute("info", en);
        }
        return "simpleView";
    }

    //新增、修改
    @RequestMapping("/update")
    @ResponseBody
    public Object addOrUpdate(String dataJson,String mode){
        if(StringUtils.isEmpty(mode)){
            return failed("操作类别不能为空！");
        }
        if(StringUtils.isEmpty(dataJson)){
            return failed("空数据！");
        }
        try{
            ResourceDefaultParamModel model = objectMapper.readValue(dataJson,ResourceDefaultParamModel.class);
            if(StringUtils.isEmpty(model.getResourcesId())){
                return failed("资源id不能为空！");
            }
            if(StringUtils.isEmpty(model.getResourcesCode())){
                return failed("资源编码不能为空！");
            }
            if(StringUtils.isEmpty(model.getParamKey())){
                return failed("默认参数名不能为空！");
            }
            if(StringUtils.isEmpty(model.getParamValue())){
                return failed("默认参数值不能为空！");
            }
            String url = ServiceApi.Resources.Param;
            Map<String,Object> params = new HashMap<>();
            params.put("json_data",dataJson);
            if(StringUtils.equalsIgnoreCase(mode,"new")){
                String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStr;
            }
            String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
    //删除
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String id){
        try{
            if(id == null){
                return failed("id不能为空！");
            }
            String url = ServiceApi.Resources.Param+"/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
    //查看不分页
    @RequestMapping("/searchList")
    @ResponseBody
    public Object searchList(String resourcesId){
        try{
            if(StringUtils.isEmpty(resourcesId)){
                return failed("资源id不能为空！");
            }
            String filters = "resourcesId="+resourcesId;
            String url = ServiceApi.Resources.ParamsNoPage;
            Map<String,Object> params = new HashMap<>();
            params.put("filters",filters);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //参数值唯一性验证
    @RequestMapping("/isKeyValueExistence")
    @ResponseBody
    public Object isExistenceRsParamKeyValue(String resourcesId,String paramKey,String paramValue){
        try{
            String url = ServiceApi.Resources.ParamKeyValueExistence;
            Map<String,Object> params = new HashMap<>();
            params.put("resources_id",resourcesId);
            params.put("param_key",paramKey);
            params.put("param_value",paramValue);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
}
