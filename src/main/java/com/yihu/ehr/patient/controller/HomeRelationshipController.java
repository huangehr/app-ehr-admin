package com.yihu.ehr.patient.controller;

import com.yihu.ehr.util.RestTemplates;
import com.yihu.ehr.util.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by AndyCai on 2016/4/20.
 */
@RestController
@RequestMapping("/home_relation")
public class HomeRelationshipController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private RestTemplates restTemplates;


    @RequestMapping("/home_relationship")
    @ResponseBody
    public String homeRelationship(Model model) {
        model.addAttribute("contentPage", "/patient/homeRelationship");
        return "simpleView";
    }

    @RequestMapping("/home_relationship_list")
    @ResponseBody
    public Object getHomeRelationshipList(String id,int page,int pageSize)
    {
        try {
            String url = "/home_relationship";
            String result = restTemplates.doGet(comUrl + url, id, page, pageSize);
            return result;
        }
        catch (Exception ex)
        {
            return failedSystem();
        }
    }

    @RequestMapping("/home_group_list")
    public Object getHomeGroupList(String id,int page,int pageSize)
    {
        try {
            String url = "/home_group";
            String result = restTemplates.doGet(comUrl + url, id, page, pageSize);
            return result;
        }
        catch (Exception ex)
        {
            return failedSystem();
        }
    }
}
