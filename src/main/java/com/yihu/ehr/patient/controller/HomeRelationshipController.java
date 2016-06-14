package com.yihu.ehr.patient.controller;

import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.web.RestTemplates;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by AndyCai on 2016/4/20.
 */
@Controller
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
    public String homeRelationship(Model model,String id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "patient/homeRelationship");
        return "simpleView";

    }

    @RequestMapping("/home_relationship_list")
    @ResponseBody
    public Object getHomeRelationshipList(String id,int page,int rows)
    {
        try {
            String url = "/home_relationship";
            URLQueryBuilder queryBuilder = new URLQueryBuilder();
            queryBuilder.setPageNumber(page);
            queryBuilder.setPageSize(rows);
            queryBuilder.addFilter("householderIdCardNo","=",id,"");

            String result = restTemplates.doGet(comUrl + url+"?"+queryBuilder.toString(), page, rows);
            return result;
        }
        catch (Exception ex)
        {
            return failedSystem();
        }
    }

    @RequestMapping("/home_group_list")
    @ResponseBody
    public Object getHomeGroupList(String id,int page,int rows)
    {
        try {
            String url = "/home_group";
            URLQueryBuilder queryBuilder = new URLQueryBuilder();
            queryBuilder.setPageNumber(page);
            queryBuilder.setPageSize(rows);
            queryBuilder.addFilter("idCardNo","=",id,"");
            String result = restTemplates.doGet(comUrl + url+"?"+queryBuilder.toString(), page, rows);
            return result;
        }
        catch (Exception ex)
        {
            return failedSystem();
        }
    }
}
