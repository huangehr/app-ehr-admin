package com.yihu.ehr.apps.controller;

import com.google.gson.Gson;
import com.yihu.ehr.agModel.app.AppModel;
import com.yihu.ehr.agModel.user.RolesModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.web.DefaultErrorAttributes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wq on 2016/7/7.
 */

@Controller
@RequestMapping("/appRole")
public class AppRoleController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/app/approle/appRole");
        return "pageView";
    }


    /**
     * 应用角色组
     * 新增、
     * 修改、
     * 权限配置、
     * 应用接入、
     * 弹框、
     * @param model
     * @param jsonStr
     * @param type
     * @return
     */
    @RequestMapping("/appRoleDialog")
    public String appRoleDialog(Model model,String jsonStr,String type){

        Envelop envelop = new Envelop();
        model.addAttribute("appRoleGroupModel",toJson(envelop));
        if (!StringUtils.isEmpty(jsonStr)&&type.equals("edit")){
            Map<String, Object> params = new HashMap<>();
            String resultStr = "";
            String url = "/appRoleGroup";
            params.put("appRoleGroupId",toModel(jsonStr,RolesModel.class).getId());
            try {
                resultStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
                model.addAttribute("appRoleGroupModel",resultStr);
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        String contentPage = "";
        switch (type){
            case "featrueConfig":
                contentPage = "/app/approle/featrueConfigDialog";
                model.addAttribute("jsonStr", jsonStr);
                break;
            case "appInsert":
                contentPage = "/app/approle/appInsert";
                break;
            default:
                contentPage = "/app/approle/appRoleDialog";
                break;
        }
        model.addAttribute("contentPage", contentPage);
        return "pageView";
    }

    @RequestMapping("/searchAppRole")
    @ResponseBody
    public String searchAppRole(String searchNm, String gridType,String appRoleId, int page, int rows) {

        Map<String, Object> params = new HashMap<>();
        String url = gridType.equals("appRole") ? "/appRole" : "/appRoleGroup";
        String resultStr = "";

        String filters = StringUtils.isEmpty(searchNm)?"appRoleId="+appRoleId:"appRoleId="+appRoleId+" g0"+"test="+searchNm+" g1";
        params.put("filters", filters);
        params.put("page", page);
        params.put("size", rows);
        try {
//            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        //todo 暂无数据，以下为测试部分
        Envelop envelop = new Envelop();
        RolesModel rolesModel = new RolesModel();
        rolesModel.setName("8555@qq.com");
        rolesModel.setCode("wq");
        rolesModel.setId(124l);
        rolesModel.setDescription("王琼");

        RolesModel rolesModel1 = new RolesModel();
        rolesModel1.setName("8555@qq.com");
        rolesModel1.setCode("wq");
        rolesModel1.setId(124l);
        rolesModel1.setDescription("王琼");

        RolesModel rolesModel2 = new RolesModel();
        rolesModel2.setName("8555@qq.com");
        rolesModel2.setCode("wq");
        rolesModel2.setId(124l);
        rolesModel2.setDescription("王琼");

        List<RolesModel> rolesModelList = new ArrayList<>();
        rolesModelList.add(rolesModel);
        rolesModelList.add(rolesModel1);
        rolesModelList.add(rolesModel2);
        envelop.setDetailModelList(rolesModelList);
        resultStr = toJson(envelop);
        // TODO: 2016/7/7 测试数据结束

        return resultStr;
    }

    @RequestMapping("/saveAppRoleGroup")
    @ResponseBody
    public String saveAppRoleGroup(String appRoleGroupModel,String saveType){
        Map<String, Object> params = new HashMap<>();
        String url = saveType.equals("add")?"/addAppRoleGroup":"/updateAppRoleGroup";
        String resultStr = "";

        params.put("appRoleGroupModel", appRoleGroupModel);
        try {
//            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

//        return resultStr;
        // TODO: 2016/7/8 以下为测试数据
        Envelop envelop = new Envelop();
        envelop.setErrorMsg("error");
        envelop.setSuccessFlg(true);
        return toJson(envelop);

    }

    @RequestMapping("/deleteAppRoleGroup")
    @ResponseBody
    public String deleteAppRoleGroup(String appGroupId){
        Map<String, Object> params = new HashMap<>();
        String url = "/appRoleGroup";
        String resultStr = "";

        params.put("appGroupId", appGroupId);
        try {
//            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        // TODO: 2016/7/7 暂无数据  以下为测试数据
        Envelop envelop = new Envelop();
        envelop.setErrorMsg("删除失败");
        envelop.setSuccessFlg(true);
        resultStr = toJson(envelop);
        return resultStr;
    }

    @RequestMapping("/updateFeatureConfig")
    @ResponseBody
    public String updateFeatureConfig(int AppFeatureId,boolean updateType){
        Map<String, Object> params = new HashMap<>();
        String url = updateType?"/addFeatureConfig":"/updateFeatureConfig";
        String resultStr = "";

        params.put("AppFeatureId", AppFeatureId);
        try {
//            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
//        return resultStr;
        // TODO: 2016/7/8 以下为测试数据
        Envelop envelop = new Envelop();
        envelop.setErrorMsg("error");
        envelop.setSuccessFlg(true);
        return toJson(envelop);
    }

    @RequestMapping("/updateAppInsert")
    @ResponseBody
    public String updateAppInsert(String appInsertId,boolean updateType){
        Map<String, Object> params = new HashMap<>();
        String url = updateType?"/addFeatureConfig":"/updateFeatureConfig";
        String resultStr = "";
        params.put("appInsertId", appInsertId);
        try {
//            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultStr;
    }

    @RequestMapping("/searchAppInsert")
    @ResponseBody
    public String searchAppInsert(String searchNm,int page, int rows){
//        Map<String, Object> params = new HashMap<>();
//        String url = updateType?"/addFeatureConfig":"/updateFeatureConfig";
        String resultStr = "";
//        params.put("appInsertId", appInsertId);
//        try {
////            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        return resultStr;
    }

}