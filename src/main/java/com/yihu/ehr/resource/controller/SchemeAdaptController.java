package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.resource.MRsAdapterSchema;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by linz on 2016/5/23.
 */

@Controller
@RequestMapping("/schemeAdapt")
public class SchemeAdaptController extends BaseUIController {


    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private ObjectMapper objectMapper;

    public static final String SCHEME_PLATFORM="1";//平台类型
    public static final String SCHEME_TP="2";//第三方


    @RequestMapping("/initial")
    public String resourceSchemeInitial(Model model){
        model.addAttribute("contentPage","/resource/adaptview/schemeAdapt");
        return "pageView";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object searchAdaptSchemes(String searchNm, String type, int page, int rows){
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("code?").append(searchNm).append(" g1;").append("name?").append(searchNm).append(" g1;");
        }
        if (!StringUtils.isEmpty(type)) {
            stringBuffer.append("type=").append(type).append(";");
        }
        params.put("filters", "");
        params.put("page", page);
        params.put("size", rows);
        String filters = stringBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        String url = ServiceApi.Adaptions.Schemes;
        String result="";
        try {
            result = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return result;
        } catch (Exception e){
            e.printStackTrace();
            return failed("内部服务请求失败");
        }
    }
    /**
     * 资源适配：新增、修改窗口
     * @param model
     * @param mode
     * @return
     */
    @RequestMapping("gotoModify")
    public Object adapterSchemeTemplate(Model model, String id,String mode) {
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id",id);
        try {
            if(mode.equals("view") || mode.equals("modify")) {
                String url = "/adaptions/schemas/"+id;
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                model.addAttribute("rs", "success");
            }
            model.addAttribute("info", StringUtils.isEmpty(resultStr)?toJson(result):resultStr);
            model.addAttribute("mode",mode);
            model.addAttribute("contentPage","/resource/adaptview/schemeAdaptDialog");
            return "emptyView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed("内部服务请求失败");
        }
    }

    /**
     * 资源适配：新增、修改窗口
     * @param model
     * @param dataJson
     * @return
     */
    @RequestMapping("save")
    @ResponseBody
    public Object updateSchemeAdpat(Model model,String dataJson) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        try{
        MRsAdapterSchema mRsAdapterSchema = objectMapper.readValue(dataJson,MRsAdapterSchema.class);
        if (StringUtils.isEmpty(mRsAdapterSchema.getType())) {
            result.setSuccessFlg(false);
            result.setErrorMsg("方案类别不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(mRsAdapterSchema.getName())) {
            result.setSuccessFlg(false);
            result.setErrorMsg("方案名称不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(mRsAdapterSchema.getCode())) {
            result.setSuccessFlg(false);
            result.setErrorMsg("方案编码不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(mRsAdapterSchema.getAdapterVersion())&&this.SCHEME_PLATFORM.equals(mRsAdapterSchema.getType())) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        if(StringUtils.isEmpty(mRsAdapterSchema.getAdapterVersion())&&this.SCHEME_TP.equals(mRsAdapterSchema.getType())){
            result.setSuccessFlg(false);
            result.setErrorMsg("标准名称不能为空！");
            return result;
        }
        params.put("adapterSchema",toJson(mRsAdapterSchema));
        String url = ServiceApi.Adaptions.Schemes;
        if(StringUtils.isNotBlank(mRsAdapterSchema.getId())){
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
        }else{
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
        }
        return resultStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed("内部服务请求失败");
        }
    }

    @RequestMapping("delete")
    @ResponseBody
    public Object deleteScheme(String schemeId) {
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<String, Object>();
        String url = "/adaptions/schemas/"+schemeId;
        try{
           String resultStr =  HttpClientUtil.doDelete(comUrl+url,params,username,password);
           return resultStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed("内部服务请求失败");
        }
    }
}
