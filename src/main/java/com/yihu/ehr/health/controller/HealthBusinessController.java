package com.yihu.ehr.health.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.health.HealthBusinessModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.health.MHealthBusiness;
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
 * Created by Administrator on 2017/6/23.
 */
@Controller
@RequestMapping("/health")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HealthBusinessController extends BaseUIController {
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

    @RequestMapping("/getHealthBusinessList")
    @ResponseBody
    public Object getHealthBusinessList(String name, String searchParm,Integer id, int page, int rows){
        String url = "/healthBusiness/pageList";
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
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("deleteHealthBusiness")
    @ResponseBody
    public Object deleteHealthBusiness(Integer id) {
        String url = "/healthBusiness/delete";
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
    public MHealthBusiness getTjQuotaById(Model model, Integer id ) {
        String url ="/healthBusiness/detailById";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        MHealthBusiness detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),MHealthBusiness.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailModel;
    }

    @RequestMapping("/addOrUpdateHealthBusiness")
    @ResponseBody
    public Object addOrUpdateHealthBusiness(String mode, String jsonDate){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            HealthBusinessModel healthBusinessModel = objectMapper.readValue(jsonDate, HealthBusinessModel.class);

            Map<String,Object> params = new HashMap<>();

            if("new".equals(mode)){
                String urlGet = "/healthBusiness/checkName";
                params.clear();
                params.put("name",healthBusinessModel.getName());
                String envelopGetStr = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    return envelopGetStr;
                }
                urlGet = "/healthBusiness/checkCode";
                params.clear();
                params.put("code",healthBusinessModel.getCode());
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
                if (!envelopGet2.isSuccessFlg()){
                    return envelopGetStr2;
                }

                Map<String,Object> args = new HashMap<>();
                args.put("jsonData",objectMapper.writeValueAsString(healthBusinessModel));
                String addUrl = "/healthBusiness/add";
                String envelopStr = HttpClientUtil.doPost(comUrl + addUrl, args, username, password);
                return envelopStr;
            } else if("modify".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("jsonData",objectMapper.writeValueAsString(healthBusinessModel));
                String updateUrl = "/healthBusiness/update";
                String envelopStr = HttpClientUtil.doPost(comUrl + updateUrl, args, username, password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("hasExistsName")
    @ResponseBody
    public boolean hasExistsName(String name) {
        String url = "/healthBusiness/checkName";
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
        String url = "/healthBusiness/checkCode";
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

    @RequestMapping("/getAllHealthBusinessList")
    @ResponseBody
    public Object getAllHealthBusinessList(){
        String url = "/healthBusiness/getHealthBusinessChild";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/getHealthBusinessListTree")
    @ResponseBody
    public Object getHealthBusinessListTree(){
        String url = "/healthBusiness/list";
        List<HealthBusinessModel> list = new ArrayList<>();
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            Envelop envelopGet = objectMapper.readValue(resultStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<HealthBusinessModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),HealthBusinessModel.class);
            }
            return list;
        } catch (Exception ex) {
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return list;
        }
    }
}
