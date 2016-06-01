package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.org.OrgDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.resource.service.GrantService;
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
public class GrantController extends ExtendController<GrantService>{

    public GrantController() {
        this.init(
                "/resource/grant/grid",        //列表页面url
                "/resource/grant/dialog"      //编辑页面url
        );
    }


    @RequestMapping("/gotoAppGrant")
    public Object gotoGrant(Model model, String resourceId){

        try {
            model.addAttribute("resourceId", resourceId);
            model.addAttribute("contentPage", "/resource/grant/grant");
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/getOrgList")
    @ResponseBody
    public Object getOrgList(String orgType) {

        try {
            String url = "/organizations/combo";
            PageParms pageParms = new PageParms(999, 1)
                    .addEqualNotNull("orgType", orgType);
            String resultStr = service.search(url, pageParms);
            return formatOrgComboData(resultStr).getDetailModelList();
        } catch (Exception e) {
            return systemError();
        }
    }

    public EnvelopExt formatOrgComboData(String resultStr){
        EnvelopExt<OrgDetailModel> rs = getEnvelopExt(resultStr, OrgDetailModel.class);
        List ls = new ArrayList<>();
        if(rs.getDetailModelList()!=null && rs.getDetailModelList().size()>0){
            Map<String, String> tem;
            for(OrgDetailModel org : rs.getDetailModelList()){
                tem = new HashMap<>();
                tem.put("id", "org_" + org.getOrgCode());
                tem.put("name", org.getFullName());
                ls.add(tem);
            }
        }
        rs.setDetailModelList(ls);
        return rs;
    }

    @RequestMapping("/getApps")
    @ResponseBody
    public Object getAppList(String org, String name) {

        try {
            PageParms pageParms = new PageParms(500, 1)
                    .addEqual("status", "Approved")
                    .addEqual("org", org)
                    .addLikeNotNull("name", name);
            return service.search("/apps", pageParms);
        } catch (Exception ex) {
            ex.printStackTrace();
            return systemError();
        }
    }

    private String getGrantTree(String resourceId) throws Exception {
        String url = "/resources/grant/app/tree";
        PageParms pageParms = new PageParms()
                .addExt("resourceId", resourceId);
        return service.search(url, pageParms);
    }

    @RequestMapping("/tree")
    @ResponseBody
    public Object tree(String resourceId) {

        try {
            return getGrantTree(resourceId);
        } catch (Exception ex) {
            ex.printStackTrace();
            return systemError();
        }
    }


    @RequestMapping("/saveGrantApp")
    @ResponseBody
    public Object saveGrantApp(String resourceId, String deleteIds, String addIds) {

        try {
            String url = service.comUrl + "/resources/"+ resourceId +"/grant";
            Map map = new HashMap<>();
            map.put("addIds", addIds);
            map.put("deleteIds", deleteIds);
            String resultStr = service.doPost(url, map);
            return resultStr;
        } catch (Exception e) {
            return faild("授权失败");
        }
    }

    @RequestMapping("/lock")
    @ResponseBody
    public Object lock(String ids, int valid) {

        try {
            String url = service.comUrl + "/resources/metadatas/valid";
            Map map = new HashMap<>();
            map.put("ids", ids);
            map.put("valid", valid);
            String resultStr = service.doPut(url, map);
            if("true".equals(resultStr))
                return success("");
            else
                return faild("操作失败");
        } catch (Exception e) {
            return faild("操作失败");
        }
    }

    @RequestMapping("/saveMeta")
    @ResponseBody
    public Object saveMeta(String id, String dimension) {

        try {
            if(StringUtils.isEmpty(id))
                faild("参数错误！");
            String url = service.comUrl + "/resources/metadata/grants/"+ id;
            Map map = new HashMap<>();
            map.put("dimension", dimension);
            String resultStr = service.doPost(url, map);
            return resultStr;
        } catch (Exception e) {
            return faild("授权失败");
        }
    }
}
