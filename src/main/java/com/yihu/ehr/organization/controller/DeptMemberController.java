package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.org.OrgDeptMemberModel;
import com.yihu.ehr.agModel.org.OrgDeptModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.model.org.MOrgDept;
import com.yihu.ehr.resource.controller.ResourceInterfaceController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * Created by janseny on 2017/3/30.
 */

@Controller
@RequestMapping("/deptMember")
public class DeptMemberController   extends ExtendController<OrgAdapterPlanService> {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initialDeptMember")
    public String deptMemberInitial(Model model,String mode, String orgCode, String orgId, String orgName,String orgType){
        model.addAttribute("orgCode",orgCode);
        model.addAttribute("orgId",orgId);
        model.addAttribute("orgName",orgName);
        model.addAttribute("mode",mode);
        model.addAttribute("orgType",orgType);
        model.addAttribute("contentPage", "/organization/deptMember/deptMember");
        return "pageView";
    }

    //部门树目录数据-获取所有分类的不分页方法
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(String orgId){
        List<OrgDeptModel> list = new ArrayList<>();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/orgDept/list";
            Map<String,Object> params = new HashMap<>();
            params.put("orgId",orgId);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<OrgDeptModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),OrgDeptModel.class);
            }
        }catch (Exception ex){
            LogService.getLogger(DeptMemberController.class).error(ex.getMessage());
        }
        return list;
    }

    /**
     * 查找机构成员
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchOrgDeptMembers")
    @ResponseBody
    public Object searchOrgDeptMembers(String searchNm,String status,String categoryId, int page, int rows) {
        String url = "/orgDeptMember/list";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("userName?" + searchNm + ";" );
        }
        if (!StringUtils.isEmpty(categoryId)) {
            stringBuffer.append("deptId=" + categoryId + ";" );
        }else{
            stringBuffer.append("deptId=-0;" );
        }
        if (!StringUtils.isEmpty(status)) {
            if(status.equals("有效")){
                stringBuffer.append("status=0;");
            }
            if(status.equals("无效")){
                stringBuffer.append("status=1;" );
            }
        }else {
            stringBuffer.append("status=0;" );
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
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String id,String mode,String categoryId,String categoryOrgId){
        model.addAttribute("mode",mode);
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("categoryOrgId",categoryOrgId);
        model.addAttribute("contentPage","/organization/deptMember/deptMemberInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        String categoryName = "";
        try{
            model.addAttribute("categoryName",categoryName);
            if (!StringUtils.isEmpty(id)) {
                 String url = "/orgDeptMember/admin/"+id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    //更新
    @RequestMapping("/updateOrgDeptMember")
    @ResponseBody
    public Object updateOrgDeptMember(String dataJson,String deptId,String mode){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        String url = "/orgDeptMember";
        try{
            OrgDeptMemberModel model = objectMapper.readValue(dataJson, OrgDeptMemberModel.class);
            model.setDeptId(Integer.valueOf(deptId));
            if(StringUtils.isEmpty(model.getUserId())){
                envelop.setErrorMsg("姓名不能为空！");
                return envelop;
            }
//            if (model.getDeptId() == null){
//                envelop.setErrorMsg("部门不能为空！");
//                return envelop;
//            }
            Map<String,Object> params = new HashMap<>();
            String urlGet = "/orgDept/checkUser";
            params.clear();
            params.put("orgId",model.getOrgId());
            params.put("userId",model.getUserId());
            String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
            Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
            if (!envelopGet2.isSuccessFlg()){
                return envelopGetStr2;
            }

            if("new".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("memberRelationJsonData",objectMapper.writeValueAsString(model));
                String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                urlGet = "/orgDeptMember/admin/" + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原成员息获取失败！");
                }
                OrgDeptMemberModel  updateModel = getEnvelopModel(envelopGet.getObj(),OrgDeptMemberModel.class);
                updateModel.setUserId(model.getUserId());
                updateModel.setUserName(model.getUserName());
                updateModel.setDutyName(model.getDutyName());
                updateModel.setParentUserId(model.getParentUserId());
                updateModel.setParentUserName(model.getParentUserName());
                updateModel.setRemark(model.getRemark());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);

                params.clear();
                params.put("memberRelationJsonData",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(DeptMemberController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * @param id
     * @param status
     * @return
     */
    @RequestMapping("activity")
    @ResponseBody
    public Object activity(String id, String status) {

        String url = "/orgDeptMember/updateStatus";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("memberRelationId",Integer.valueOf(id));
        params.put("status",Integer.valueOf(status));
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return envelop;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            return envelop;
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
        String url = "/orgDeptMember/delete";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("memberRelationId", memberRelationId);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("/getUserList")
    @ResponseBody
    public Object getUserList( String searchParm, int page, int rows) {
        try {
            String url = "/users";
            PageParms pageParms = new PageParms(rows, page)
                    .addLikeNotNull("realName", searchParm);
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "realName");
        } catch (Exception e) {
            return systemError();
        }
    }



    //添加子部门和更新部门名称
    @RequestMapping("/updateOrgDept")
    @ResponseBody
    public Object updateOrgDept(String id,String mode,String code,String name){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            if (StringUtils.isEmpty(id)){
                envelop.setErrorMsg("数据有误！");
                return envelop;
            }
            if (StringUtils.isEmpty(name)){
                envelop.setErrorMsg("名称不能为空！");
                return envelop;
            }

            Map<String,Object> params = new HashMap<>();

            if("new".equals(mode)){
                String urlGet = "/orgDept/detail";
                params.clear();
                params.put("deptId",id);//上级部门id
                String envelopGetStr = HttpClientUtil.doPost(comUrl + urlGet, params, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("上级部门信息获取失败！");
                    return envelop;
                }
                OrgDeptModel  parentpModel = getEnvelopModel(envelopGet.getObj(),OrgDeptModel.class);
                urlGet = "/orgDept/checkDeptName";
                params.clear();
                params.put("orgId",parentpModel.getOrgId());
                params.put("name",name);
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
                if (!envelopGet2.isSuccessFlg()){
                    return envelopGetStr2;
                }

                OrgDeptModel sunorgDeptModel = new OrgDeptModel();
                sunorgDeptModel.setCode(code);
                sunorgDeptModel.setName(name);
                sunorgDeptModel.setParentDeptId(Integer.valueOf(id));
                sunorgDeptModel.setOrgId(parentpModel.getOrgId());
                Map<String,Object> args = new HashMap<>();
                args.put("orgDeptsJsonData",objectMapper.writeValueAsString(sunorgDeptModel));
                String addUrl = "/orgDept";
                String envelopStr = HttpClientUtil.doPost(comUrl+addUrl,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                params.clear();
                params.put("deptId",Integer.valueOf(id) );
                params.put("name",name);
                String updateUrl = "/orgDept/resetName";
                String envelopStr = HttpClientUtil.doPost(comUrl + updateUrl, params, username, password);
                return envelopStr;
            }else if("addRoot".equals(mode)){
                OrgDeptModel rootDeptModel = new OrgDeptModel();
                rootDeptModel.setCode(code);
                rootDeptModel.setName(name);
                rootDeptModel.setOrgId(id);
                Map<String,Object> args = new HashMap<>();
                args.put("orgDeptsJsonData",objectMapper.writeValueAsString(rootDeptModel));
                String addUrl = "/orgDept";
                String envelopStr = HttpClientUtil.doPost(comUrl+addUrl,args,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(DeptMemberController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }


    /**
     * 删除部门
     * @param orgDeptId
     * @return
     */
    @RequestMapping("delOrgDept")
    @ResponseBody
    public Object delOrgDept(int orgDeptId) {
        String url = "/orgDept/delete";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("deptId", orgDeptId);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


    /**
     * 上下移动部门
     * @param preDeptId
     * @param  afterDeptId
     * @return
     */
    @RequestMapping("changeSortOrgDept")
    @ResponseBody
    public Object changeSortOrgDept(int preDeptId,int afterDeptId) {
        String url = "/orgDept/changeSort";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("preDeptId", preDeptId);
        params.put("afterDeptId", afterDeptId);

        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SystemError.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("/getOrgList")
    @ResponseBody
    public Object getOrgList( String searchParm,int page, int rows) {
        try {
            String url = "/organizations";
            PageParms pageParms = new PageParms(rows, page)
                    .addLikeNotNull("fullName", searchParm);
            String resultStr = service.doGet(comUrl + url, pageParms);
            Envelop envelop = formatComboData(resultStr, "id", "fullName");
            return envelop;
        } catch (Exception e) {
            return systemError();
        }
    }

    @RequestMapping("/getOrgMemberList")
    @ResponseBody
    public Object getOrgMemberList( String searchParm,String orgId,int page, int rows) {
        try {
            String url = "/orgDeptMember/list";
            PageParms pageParms = new PageParms(rows, page)
                    .addEqual("orgId", orgId)
                    .addLikeNotNull("userName", searchParm);
            String resultStr = service.doPost(comUrl + url, pageParms);
            Envelop envelop = formatComboData(resultStr, "id", "userName");
            return envelop;
        } catch (Exception e) {
            return systemError();
        }
    }

    @RequestMapping("/getDeptList")
    @ResponseBody
    public Object getDeptList(String searchParm, int page, int rows) {
        try {
            String url = "/orgDept/getAllOrgDepts";
            PageParms pageParms = new PageParms(rows, page)
                    .addLikeNotNull("name", searchParm);
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "name");
        } catch (Exception e) {
            return systemError();
        }
    }

    @RequestMapping("/addOrUpdateOrgDept")
    @ResponseBody
    public Object addOrUpdateOrgDept(String id, String mode, String orgDeptJsonDate){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            if (StringUtils.isEmpty(id)){
                envelop.setErrorMsg("数据有误！");
                return envelop;
            }
            OrgDeptModel orgDeptModel = objectMapper.readValue(orgDeptJsonDate, OrgDeptModel.class);

            Map<String,Object> params = new HashMap<>();

            if("new".equals(mode)){
                String urlGet = "/orgDept/detail";
                params.clear();
                params.put("deptId",id);//上级部门id
                String envelopGetStr = HttpClientUtil.doPost(comUrl + urlGet, params, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("上级部门信息获取失败！");
                    return envelop;
                }
                OrgDeptModel  parentpModel = getEnvelopModel(envelopGet.getObj(),OrgDeptModel.class);
                urlGet = "/orgDept/checkDeptName";
                params.clear();
                params.put("orgId",parentpModel.getOrgId());
                params.put("name",orgDeptModel.getName());
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2,Envelop.class);
                if (!envelopGet2.isSuccessFlg()){
                    return envelopGetStr2;
                }

                OrgDeptModel sunorgDeptModel = new OrgDeptModel();
                sunorgDeptModel.setCode(orgDeptModel.getCode());
                sunorgDeptModel.setName(orgDeptModel.getDeptDetail().getName());
                sunorgDeptModel.setParentDeptId(Integer.valueOf(id));
                sunorgDeptModel.setOrgId(parentpModel.getOrgId());
                orgDeptModel.getDeptDetail().setOrgId(parentpModel.getOrgId());
                orgDeptModel.getDeptDetail().setCode(UUID.randomUUID().toString().replace("-", ""));
                sunorgDeptModel.setDeptDetail(orgDeptModel.getDeptDetail());

                Map<String,Object> args = new HashMap<>();
                args.put("orgDeptsJsonData",objectMapper.writeValueAsString(sunorgDeptModel));
                String addUrl = "/orgDept";
                String envelopStr = HttpClientUtil.doPost(comUrl+addUrl,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                OrgDeptModel updateDeptModel = new OrgDeptModel();
                BeanUtils.copyProperties(orgDeptModel, updateDeptModel);
//                updateDeptModel.setCode(orgDeptModel.getCode());
                updateDeptModel.setName(orgDeptModel.getDeptDetail().getName());
//                updateDeptModel.setDeptDetail(orgDeptModel.getDeptDetail());

                Map<String,Object> args = new HashMap<>();
                args.put("orgDeptJsonData",objectMapper.writeValueAsString(updateDeptModel));
                String updateUrl = "/orgDept";
                String envelopStr = HttpClientUtil.doPut(comUrl + updateUrl, args, username, password);
                return envelopStr;
            }else if("addRoot".equals(mode)){
                OrgDeptModel rootDeptModel = new OrgDeptModel();
                rootDeptModel.setCode(orgDeptModel.getCode());
                rootDeptModel.setName(orgDeptModel.getDeptDetail().getName());
                rootDeptModel.setOrgId(orgDeptModel.getDeptDetail().getOrgId());
                orgDeptModel.getDeptDetail().setCode(UUID.randomUUID().toString().replace("-", ""));
                rootDeptModel.setDeptDetail(orgDeptModel.getDeptDetail());

                Map<String,Object> args = new HashMap<>();
                args.put("orgDeptsJsonData",objectMapper.writeValueAsString(rootDeptModel));
                String addUrl = "/orgDept";
                String envelopStr = HttpClientUtil.doPost(comUrl+addUrl,args,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(DeptMemberController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("/getOrgDeptByCode")
    @ResponseBody
    public MOrgDept getOrgDeptByCode(Model model, Integer deptId ) {
        String url ="/orgDept/detailById";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("deptId", deptId);
        MOrgDept orgDeptModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            orgDeptModel = toModel(toJson(ep.getObj()),MOrgDept.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orgDeptModel;
    }
}
