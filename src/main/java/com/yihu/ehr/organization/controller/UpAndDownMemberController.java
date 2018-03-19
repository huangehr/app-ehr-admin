package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.org.OrgDeptMemberModel;
import com.yihu.ehr.agModel.org.OrgDeptModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.model.org.MOrgMemberRelation;
import com.yihu.ehr.resource.controller.ResourceInterfaceController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
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
 * Created by janseny
 */

@Controller
@RequestMapping("/upAndDownMember")
public class UpAndDownMemberController extends ExtendController<OrgAdapterPlanService> {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initialUpAndDownMember")
    public String deptMemberInitial(Model model,String mode, String orgCode, String orgId, String orgName){
        model.addAttribute("orgCode",orgCode);
        model.addAttribute("orgId",orgId);
        model.addAttribute("orgName",orgName);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage", "/organization/upAndDownMember/upAndDownMember");
        return "emptyView";
    }

    //成员上下级树目录数据
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(int orgId,String searchNm){
        List<MOrgMemberRelation> list = new ArrayList<>();
        try{
            String envelopStr = "";
            String url = "/orgDeptMember/getAllOrgDeptMemberDistinct";
            Map<String,Object> params = new HashMap<>();
            params.put("orgId",orgId);
            params.put("searchNm",searchNm==null?"":searchNm);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<MOrgMemberRelation>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),MOrgMemberRelation.class);
            }
        }catch (Exception ex){
            LogService.getLogger(UpAndDownMemberController.class).error(ex.getMessage());
        }
        return list;
    }

    /**
     * 查找下级成员
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchUpAndDownMembers")
    @ResponseBody
    public Object searchUpAndDownMembers(String searchNm,String userId,String orgId, int page, int rows) {
        String url = "/orgDeptMember/list";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("userName?" + searchNm + ";" );
        }
        stringBuffer.append("status=0;" );
        if (!StringUtils.isEmpty(userId)) {
            stringBuffer.append("parentUserId=" + userId + ";" );
        }
        if (!StringUtils.isEmpty(orgId)) {
            stringBuffer.append("orgId=" + orgId + ";" );
        }else{
            stringBuffer.append("orgId=-0;" );
        }
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }


    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String mode,String categoryId,String categoryOrgId,String categoryName){
        model.addAttribute("mode",mode);
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("categoryOrgId",categoryOrgId);
        model.addAttribute("categoryName",categoryName);
        model.addAttribute("contentPage","/organization/upAndDownMember/upAndDownMemberInfoDialog");
        return "emptyView";
    }

    //更新
    @RequestMapping("/updateOrgDeptMember")
    @ResponseBody
    public Object updateOrgDeptMember(String dataJson,String pUserId,String parentUserName){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            OrgDeptMemberModel model = objectMapper.readValue(dataJson, OrgDeptMemberModel.class);
            if(StringUtils.isEmpty(model.getUserId())){
                envelop.setErrorMsg("用户不能为空！");
                return envelop;
            }
            model.setParentUserId(pUserId);
            model.setParentUserName(parentUserName);
            Map<String, Object> params = new HashMap<>();
            String url = "/updateOrgDeptMemberParent";
            String updateModelJson = objectMapper.writeValueAsString(model);
            params.put("memberRelationJsonData",updateModelJson);
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return envelopStr;

        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }



    /**
     * 删除成员
     * @param memberRelationId
     * @return
     */
    @RequestMapping("deleteOrgDeptMember")
    @ResponseBody
    public Object deleteOrgDeptMember(int memberRelationId) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try {
            Map<String, Object> params = new HashMap<>();
            String url = "/orgDeptMember/updateStatus";
            params.clear();
            params.put("memberRelationId",memberRelationId);
            params.put("status",1);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if(envelopStr.equals("true")){
                envelop.setSuccessFlg(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return envelop;
    }



}
