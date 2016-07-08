package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
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
 * Created by yww on 2016/7/6.
 */
@RequestMapping("/userRoles")
@Controller
public class UserRolesController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String rolesInitial(Model model){
        model.addAttribute("contentPage","user/roles/roles");
        return "pageView";
    }

    @RequestMapping("/rolesInfoInitial")
    public String rolesInfoInitial(Model model,String id,String mode){
        model.addAttribute("contentPage","user/roles/rolesInfoDialog");
        model.addAttribute("mode",mode);
        Envelop envelop = new Envelop();
        String en = "";
        try{
            en = objectMapper.writeValueAsString(envelop);
            String url ="/roles/role/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            model.addAttribute("envelop",envelopStr);
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            model.addAttribute("envelop",en);
        }
        return "simpleView";
    }

    @RequestMapping("/rolesUsersInitial")
    public String rolesUsersInitial(Model model,String id){
        model.addAttribute("contentPage","user/roles/rolesUsers");
        return "simpleView";
    }

    @RequestMapping("/rolesLimitsInitial")
    public String rolesLimitsInitial(Model model,String id){
        model.addAttribute("contentPage","user/roles/rolesUsersInitial");
        return "simpleView";
    }
    //角色组增改
    @RequestMapping("/update")
    @ResponseBody
    public Object rolesUpdate(String dataJson,String mode){
        return null;
    }

    //角色组删除
    @RequestMapping("/delete")
    @ResponseBody
    public Object rolesDelete(String id){
        return null;
    }
    //角色组列表查询
    @RequestMapping("/search")
    @ResponseBody
    public Object searchRoles(String rolesName,String type,String stdAppId,int page,int rows){
        if(StringUtils.isEmpty(type)){type = "1";}
        StringBuffer buffer = new StringBuffer();
        buffer.append("type"+type+";");
        if(!StringUtils.isEmpty(rolesName)){
            buffer.append("name?"+rolesName);
        }
        String filters = buffer.toString();
        Envelop envelop = new Envelop();
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("size",rows);
            params.put("page",page);
            String url = "/roles/roles";
            String enveloStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return enveloStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }
    //角色组人员配置（增删人员）
    @RequestMapping("/userUpdate")
    @ResponseBody
    public Object roleUserUpdate(){
        return null;
    }
    //角色组权限配置（增删）
    @RequestMapping("/featureUpdate")
    @ResponseBody
    public Object roleFeatureUpdate(){
        return null;
    }
}
