package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.org.OrgDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.resource.service.OrgGrantService;
import com.yihu.ehr.util.rest.Envelop;
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
@RequestMapping("/orgResource/grant")
public class OrgGrantController extends ExtendController<OrgGrantService>{

    public OrgGrantController() {
        this.init(
                "/resource/grant/grid",        //列表页面url
                "/resource/grant/rolesDialog"      //编辑页面url
        );
    }

    @Override
    public String beforeSearch(String searchUrl, Map<String, Object> params) {
        return searchUrl.replace("{Org_res_id}", (String) params.get("orgResId"));
    }

    @RequestMapping("/gotoOrgGrant")
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

    @RequestMapping("/getOrg")
    @ResponseBody
    public Object getOrgList(String org, String name) {

        try {
            PageParms pageParms = new PageParms(500, 1)
                    .addEqual("status", "orgroved")
                    .addEqual("org", org)
                    .addLikeNotNull("name", name);
            return service.search("/org", pageParms);
        } catch (Exception ex) {
            ex.printStackTrace();
            return systemError();
        }
    }

    private String getGrantTree(String resourceId) throws Exception {
        String url = "/resources/grant/org/tree";
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


    @RequestMapping("/saveGrantOrg")
    @ResponseBody
    public Object saveGrantApp(String resourceId, String deleteIds, String orgIds) {

        try {
            String url = service.comUrl + "/resources/"+ resourceId +"/grant";
            Map map = new HashMap<>();
            map.put("orgIds", orgIds);
            map.put("deleteIds", deleteIds);
            String resultStr = service.doPost(url, map);
            return resultStr;
        } catch (Exception e) {
            return faild("授权失败");
        }
    }

    @RequestMapping("/lock")
    @ResponseBody
    public Object lock(String data, int valid) {

        try {
            String url = service.comUrl + "/resources/metadatas/valid";
            Map map = new HashMap<>();
            map.put("data", data);
            map.put("valid", valid);
            String resultStr = service.doLargePost(url, map);
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
    public Object saveMeta(String model) {

        try {
            String url = service.comUrl + "/resources/orgMetadatas/grants";
            Map map = new HashMap<>();
            map.put("model", model);
            String resultStr = service.doPost(url, map);
            return resultStr;
        } catch (Exception e) {
            return faild("授权失败");
        }
    }

    @RequestMapping("/gotoMetaGrant")
    public Object gotoMetaGrant(Model model, String mode, String id, String rolesResId, String resMetaId, String organizationId){
        try {
            Envelop envelop;
            Map<String, Object> params = new HashMap<>();

            if (!StringUtils.isEmpty(id)){
                params.put("id",id);
                envelop = getEnvelop(service.getModel(params));
            }else {
                params.put("org_res_id",rolesResId);
                params.put("res_meta_id", resMetaId);
                params.put("organization_id", organizationId);
                envelop = getEnvelop(service.search("/resources/org_resource/metadata/grant", params));
            }

            Object plan;
            if(envelop.getObj()==null)
                plan = service.newModel();
            else
                plan = envelop.getObj();

            model.addAttribute("model",toJson(plan));
            model.addAttribute("contentPage", getModeUrl(mode));
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
    //角色组维度授权
    @RequestMapping("/orgLock")
    @ResponseBody
    public Object orgLock(String data, int valid) {

        try {
            String url = service.comUrl + "/resources/orgMetadatas/valid";
            Map map = new HashMap<>();
            map.put("data", data);
            map.put("valid", valid);
            String resultStr = service.doLargePost(url, map);
            if("true".equals(resultStr))
                return success("");
            else
                return faild("操作失败");
        } catch (Exception e) {
            return faild("操作失败");
        }
    }
    //角色组维度授权
    @RequestMapping("/orgSaveMeta")
    @ResponseBody
    public Object orgSaveMeta(String model) {

        try {
            String url = service.comUrl + "/resources/orgMetadatas/grants";
            Map map = new HashMap<>();
            map.put("model", model);
            String resultStr = service.doPost(url, map);
            return resultStr;
        } catch (Exception e) {
            return faild("授权失败");
        }
    }

}
