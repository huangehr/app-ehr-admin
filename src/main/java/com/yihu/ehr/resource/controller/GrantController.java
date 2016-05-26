package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.util.Envelop;
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
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller
@RequestMapping("/resource/grant")
public class GrantController extends ExtendController<OrgAdapterPlanService>{

    public GrantController() {
        this.init(
                "/resource/grant/grid",        //列表页面url
                "/resource/grant/dialog"      //编辑页面url
        );
    }

    @RequestMapping("/list_test")
    @ResponseBody
    public Object search(String fields, String filters, String sorts, int page, int rows, String extParms){

        try{
            Envelop envelop = new Envelop();
            List ls = new ArrayList<>();
            Map map = new HashMap<>();
            map.put("type", "1");
            ls.add(map);
            envelop.setDetailModelList(ls);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }


    @RequestMapping("/gotoAppGrant")
    public Object gotoGrant(Model model, String id){

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id",id);

            model.addAttribute("contentPage", "/resource/grant/grant");
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

}
