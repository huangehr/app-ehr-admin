package com.yihu.ehr.patient.controller;

import com.yihu.ehr.agModel.esb.HosAcqTaskModel;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by yww on 2016/6/21.
 */
@Controller
@RequestMapping("/authentication")
public class AuthenticationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    //主页面初始化
    @RequestMapping("/initial")
    public String authenticationInitial(Model model,String backParams){
        model.addAttribute("contentPage","patient/authentication/authentication");
        model.addAttribute("backParams",backParams);
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String authenticationInfoInitial(Model model,String id,String dataModel) throws Exception{
        model.addAttribute("contentPage","patient/authentication/authenticationInfo");
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("info",objectMapper.writeValueAsString(getObjectById()));
        return "pageView";
    }


    public Object getObjectById(){
        Envelop envelop = new Envelop();
        HosAcqTaskModel model = new HosAcqTaskModel();
        model.setId("1111111111");//id
        model.setCreateTime("2016-06-06 12:12:12");//时间
        model.setStartTime("15805926666");//电话
        model.setOrgCode("张三（");//名字
        model.setSystemCode("350823196003221019");//身份证号
        model.setStatus("待审核");
        model.setMessage("");//图片路径
        envelop.setObj(model);
        return envelop;
    }










    //详情页面初始化
    //分页查询
    //认证状态修改











}
