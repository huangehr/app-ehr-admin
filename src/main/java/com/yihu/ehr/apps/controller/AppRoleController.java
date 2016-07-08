package com.yihu.ehr.apps.controller;

import com.google.gson.Gson;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
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

    @RequestMapping("/appRoleDialog")
    public String appRoleDialog(Model model,String appRoleGroupId,String type){

        Envelop envelop = new Envelop();
        model.addAttribute("appRoleGroupModel",toJson(envelop));
        if (!StringUtils.isEmpty(appRoleGroupId)){
            Map<String, Object> params = new HashMap<>();
            String resultStr = "";
            String url = "/appRoleGroup";
            params.put("appRoleGroupId",appRoleGroupId);
            try {
                resultStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
                model.addAttribute("appRoleGroupModel",resultStr);
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        model.addAttribute("contentPage", "/app/approle/appRoleDialog");
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
        UsersModel usersModel = new UsersModel();
        usersModel.setEmail("8555@qq.com");
        usersModel.setLoginCode("wq");
        usersModel.setId("124");
        usersModel.setRealName("王琼");
        usersModel.setTelephone("110");

        UsersModel usersModel1 = new UsersModel();
        usersModel1.setEmail("112@qq.com");
        usersModel1.setLoginCode("1wq");
        usersModel1.setId("1124");
        usersModel1.setRealName("1王琼");
        usersModel1.setTelephone("1110");

        UsersModel usersModel2 = new UsersModel();
        usersModel2.setEmail("22@qq.com");
        usersModel2.setLoginCode("2wq");
        usersModel2.setId("2124");
        usersModel2.setRealName("2王琼");
        usersModel2.setTelephone("2110");

        List<UsersModel> usersModelList = new ArrayList<>();
        usersModelList.add(usersModel);
        usersModelList.add(usersModel1);
        usersModelList.add(usersModel2);
        envelop.setDetailModelList(usersModelList);
        resultStr = toJson(envelop);
        // TODO: 2016/7/7 测试数据结束

        return resultStr;
    }

    @RequestMapping("/saveAppRoleGroup")
    @ResponseBody
    public String saveAppRoleGroup(String appRoleGroupModel){
        Map<String, Object> params = new HashMap<>();
        String url = "/saveAppRoleGroup";
        String resultStr = "";

        params.put("appRoleGroupModel", appRoleGroupModel);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;

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


}