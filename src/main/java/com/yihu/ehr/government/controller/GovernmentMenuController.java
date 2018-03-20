package com.yihu.ehr.government.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.government.GovernmentMenuModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ErrorCode;
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

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by wxw on 2017/11/2.
 */
@RequestMapping("/governmentMenu")
@Controller
public class GovernmentMenuController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String systemDictDialog(Model model) {
        model.addAttribute("contentPage","/government/menu/menu");
        return "pageView";
    }

    @RequestMapping("/getGovernmentMenuList")
    @ResponseBody
    public Object getGovernmentMenuList(String name, int page, int rows){
        String url = "/government/searchGovernmentMenu";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
//        stringBuffer.append("status=1;");
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name + " g1;code?" + name + " g1;");
        }
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("sorts", "-createTime");
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id){
        if (id == "") {
            model.addAttribute("id","-1");
        } else {
            model.addAttribute("id",id);
        }
        return  "/government/menu/menuInfoDialog";
    }

    @RequestMapping("/addOrUpdate")
    @ResponseBody
    public Object addOrUpdate(String mode, String jsonDate, String ids, HttpServletRequest request){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        String resultStr = "";
        try{
            GovernmentMenuModel governmentMenuModel = objectMapper.readValue(jsonDate, GovernmentMenuModel.class);
            UsersModel userDetailModel = getCurrentUserRedis(request);
            Map<String,Object> params = new HashMap<>();

            if("new".equals(mode)){
                String urlGet = "/government/checkName";
                params.clear();
                params.put("name",governmentMenuModel.getName());
                String envelopGetStr = HttpClientUtil.doGet(comUrl + urlGet, params, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    return envelopGetStr;
                }
                urlGet = "/government/checkCode";
                params.clear();
                params.put("code",governmentMenuModel.getCode());
                String envelopGetStr2 = HttpClientUtil.doGet(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
                if (!envelopGet2.isSuccessFlg()){
                    return envelopGetStr2;
                }

                Map<String,Object> args = new HashMap<>();
                governmentMenuModel.setCreateUser(userDetailModel.getId());
                args.put("jsonData",objectMapper.writeValueAsString(governmentMenuModel));
                args.put("ids", ids);
                String addUrl = "/government/save";
                String envelopStr = HttpClientUtil.doPost(comUrl + addUrl, args, username, password);
                return envelopStr;
            } else if("modify".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                params.clear();
                params.put("id", governmentMenuModel.getId());
                resultStr = HttpClientUtil.doGet(comUrl + "/government/detailById", params);
                envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    GovernmentMenuModel updateModel = getEnvelopModel(envelop.getObj(), GovernmentMenuModel.class);
                    updateModel.setName(governmentMenuModel.getName());
                    updateModel.setCode(governmentMenuModel.getCode());
                    updateModel.setUrl(governmentMenuModel.getUrl());
                    updateModel.setStatus(governmentMenuModel.getStatus());
                    updateModel.setUpdateUser(userDetailModel.getId());
                    args.put("jsonData",objectMapper.writeValueAsString(updateModel));
                    args.put("ids", ids);
                    String updateUrl = "/government/update";
                    String envelopStr = HttpClientUtil.doPost(comUrl + updateUrl, args, username, password);
                    return envelopStr;
                } else {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg(envelop.getErrorMsg());
                    return envelop;
                }
            }
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelop;
    }

    @RequestMapping("detailById")
    @ResponseBody
    public GovernmentMenuModel getTjQuotaById(Model model, Integer id ) {
        String url ="/government/detailById";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        GovernmentMenuModel detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),GovernmentMenuModel.class);
        } catch (Exception e) {
            LogService.getLogger(GovernmentMenuController.class).error(e.getMessage());
        }
        return detailModel;
    }

    @RequestMapping("hasExistsCode")
    @ResponseBody
    public boolean hasExistsCode(String code) {
        String url = "/government/checkCode";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("code", code);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr,Envelop.class);
            if (envelop.isSuccessFlg()) {
                return  true;
            }
        } catch (Exception e) {
            LogService.getLogger(GovernmentMenuController.class).error(e.getMessage());
        }
        return  false;
    }

    @RequestMapping("hasExistsName")
    @ResponseBody
    public boolean hasExistsName(String name) {
        String url = "/government/checkName";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("name", name);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr,Envelop.class);
            if (envelop.isSuccessFlg()) {
                return  true;
            }
        } catch (Exception e) {
            LogService.getLogger(GovernmentMenuController.class).error(e.getMessage());
        }
        return  false;
    }

    @RequestMapping("/getMonitorTypeList")
    @ResponseBody
    public Object getMonitorTypeList(String menuId){
        String url = "/resources/rsReportMonitorType/getRsReportMonitorTypeNoPage";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("menuId", menuId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(resultStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                envelop.setObj(envelopGet.getDetailModelList());
                envelop.setSuccessFlg(true);
                return envelop;
            }
            return resultStr;
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
