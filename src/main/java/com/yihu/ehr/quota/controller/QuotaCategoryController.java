package com.yihu.ehr.quota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.QuotaCategoryModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.tj.MQuotaCategory;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wxw on 2017/8/31.
 */
@Controller
@RequestMapping("/quota")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class QuotaCategoryController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/health/healthBusiness");
        return "pageView";
    }

    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id){
        if (id == "") {
            model.addAttribute("id","-1");
        } else {
            model.addAttribute("id",id);
        }
        return  "/report/health/healthBusinessInfoDialog";
    }

    @RequestMapping("/getQuotaCategoryList")
    @ResponseBody
    public Object getQuotaCategoryList(String name, String searchParm,Integer id, int page, int rows){
        String url = "/quotaCategory/pageList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name + " g1;code?" + name + " g1;");
        }
        if (!StringUtils.isEmpty(searchParm)) {
            stringBuffer.append("name?" + searchParm + ";");
        }
        if (!StringUtils.isEmpty(id)) {
            stringBuffer.append("id<>" + id + ";");
        }
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(QuotaCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("deleteQuotaCategory")
    @ResponseBody
    public Object deleteQuotaCategory(Integer id) {
        String url = "/quotaCategory/delete";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("id", id);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            if ("true".equals(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("detailById")
    @ResponseBody
    public MQuotaCategory getTjQuotaById(Model model, Integer id ) {
        String url ="/quotaCategory/detailById";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        MQuotaCategory detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),MQuotaCategory.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailModel;
    }

    @RequestMapping("/addOrUpdateQuotaCategory")
    @ResponseBody
    public Object addOrUpdateQuotaCategory(String mode, String jsonDate){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            QuotaCategoryModel quotaCategoryModel = objectMapper.readValue(jsonDate, QuotaCategoryModel.class);

            Map<String,Object> params = new HashMap<>();

            if("new".equals(mode)){
                String urlGet = "/quotaCategory/checkName";
                params.clear();
                params.put("name",quotaCategoryModel.getName());
                String envelopGetStr = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    return envelopGetStr;
                }
                urlGet = "/quotaCategory/checkCode";
                params.clear();
                params.put("code",quotaCategoryModel.getCode());
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
                if (!envelopGet2.isSuccessFlg()){
                    return envelopGetStr2;
                }

                Map<String,Object> args = new HashMap<>();
                args.put("jsonData",objectMapper.writeValueAsString(quotaCategoryModel));
                String addUrl = "/quotaCategory/add";
                String envelopStr = HttpClientUtil.doPost(comUrl + addUrl, args, username, password);
                return envelopStr;
            } else if("modify".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("jsonData",objectMapper.writeValueAsString(quotaCategoryModel));
                String updateUrl = "/quotaCategory/update";
                String envelopStr = HttpClientUtil.doPost(comUrl + updateUrl, args, username, password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(QuotaCategoryController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("hasExistsName")
    @ResponseBody
    public boolean hasExistsName(String name) {
        String url = "/quotaCategory/checkName";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("name", name);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr,Envelop.class);
            if (envelop.isSuccessFlg()) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }

    @RequestMapping("hasExistsCode")
    @ResponseBody
    public boolean hasExistsCode(String code) {
        String url = "/quotaCategory/checkCode";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("code", code);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr,Envelop.class);
            if (envelop.isSuccessFlg()) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }

    @RequestMapping("/getAllQuotaCategoryList")
    @ResponseBody
    public Object getAllQuotaCategoryList(){
        String url = "/quotaCategory/getQuotaCategoryChild";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(QuotaCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/getQuotaCategoryListTree")
    @ResponseBody
    public Object getQuotaCategoryListTree(){
        String url = "/quotaCategory/list";
        List<QuotaCategoryModel> list = new ArrayList<>();
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            Envelop envelopGet = objectMapper.readValue(resultStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<QuotaCategoryModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),QuotaCategoryModel.class);
            }
            return list;
        } catch (Exception ex) {
            LogService.getLogger(QuotaCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return list;
        }
    }
}
