package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.org.OrgDetailModel;
import com.yihu.ehr.agModel.org.OrgModel;
import com.yihu.ehr.agModel.org.RsOrgResourceModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.model.org.MRsOrgResource;
import com.yihu.ehr.patient.controller.PatientController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.service.GetInfoService;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;

/**
 * @author zlf
 * @version 1.0
 * @created 2015.08.10 17:57
 */
@Controller
@RequestMapping("/organization")
public class OrganizationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    
    @Autowired
    private GetInfoService getInfoService;

    @RequestMapping("/initial")
    public String orgInitial(Model model) {
        model.addAttribute("contentPage", "organization/organization");
        return "pageView";
    }

    @RequestMapping("organizationGrant")
    public String organizationGrant(Model model) {
        model.addAttribute("contentPage", "organization/organizationGrant");
        return "pageView";
    }
    @RequestMapping("uploadOrgErrorDialog")
    public String uploadOrgErrorDialog(Model model) {
        model.addAttribute("contentPage", "organization/uploadOrgErrorDialog");
        return "simpleView";
    }

    @RequestMapping("dialog/orgInfo")
    public String orgInfoTemplate(Model model, String orgCode, String mode, HttpSession session) {

        String getOrgUrl = "/organizations/" + orgCode;
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, username, password);
            Envelop envelop = getEnvelop(resultStr);
            OrgDetailModel orgDetailModel = toModel(toJson(envelop.getObj()), OrgDetailModel.class);
            Map<String, Object> params = new HashMap<>();
            String url = comUrl + "/files_path";
            params.put("object_id",orgCode);
            String envelopStr = HttpClientUtil.doGet(url,params, username, password);
            session.setAttribute("userImageStream", orgDetailModel.getImgLocalPath() == null ? "" : orgDetailModel.getImgLocalPath());
            Envelop imageLop =   getEnvelop(envelopStr);
            session.setAttribute("imageLop",toJson(imageLop));
        } catch (Exception e) {
             session.setAttribute("imageLop","{\"successFlg\":false,\"pageSize\":10,\"currPage\":0,\"totalPage\":0,\"totalCount\":0,\"detailModelList\":null,\"obj\":null,\"errorMsg\":\"系统错误,请联系管理员!\",\"errorCode\":0}");
             LogService.getLogger(OrganizationController.class).error(e.getMessage());
        }
        model.addAttribute("mode", mode);
        model.addAttribute("envelop", resultStr);
        model.addAttribute("contentPage", "organization/organizationInfoDialog");
        return "emptyView";
    }

    @RequestMapping("dialog/create")
    public String createInitial(Model model, String mode) {
        model.addAttribute("mode", mode);
        model.addAttribute("contentPage", "organization/orgCreateDialog");
        return "emptyView";
    }

    @RequestMapping("dialog/orgDataGrant")
    public String orgDataGrantDialog(Model model,String orgCode, String orgTypeName, String fullName) {
        model.addAttribute("orgCode", orgCode);
        model.addAttribute("orgTypeName", orgTypeName);
        model.addAttribute("fullName", fullName);
        model.addAttribute("contentPage", "organization/orgGrantInfoDialog");
        return "emptyView";
    }

    @RequestMapping(value = "searchOrgs", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object searchOrgs(String searchParm, String searchWay, String orgType, String province, String city, String district, int page, int rows,HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            //分页查询机构列表
            String url = "/organizations";
            String filters = "";
            Map<String, Object> params = new HashMap<>();
            if (!StringUtils.isEmpty(searchParm)) {
                filters += "orgCode?" + searchParm + " g1;fullName?" + searchParm + " g1;";
            }
            if (!StringUtils.isEmpty(searchWay)) {
                filters += "settledWay=" + searchWay + ";";
            }
            if (!StringUtils.isEmpty(orgType)) {
                filters += "orgType=" + orgType + ";";
            }
            //根据登录人的机构获取saas化机构
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "-createDate");
            params.put("size", rows);
            params.put("page", page);
            params.put("province", province);
            params.put("city", city);
            params.put("district", district);
            params.put("userOrgList", userOrgList);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 获取机构代码下拉框-带检索(根据输入机构代码/名称近似查询）
     * @param searchParm  控件传递参数的参数名
     */
    @RequestMapping("/orgCodes")
    @ResponseBody
    public Object searchOrgCodes(String filters, String searchParm,int page,int rows){
        Envelop envelop = new Envelop();
        filters = filters==null? "": filters;
        try{
            if (!org.apache.commons.lang.StringUtils.isEmpty(searchParm)){
                filters += "orgCode?"+searchParm+" g1;fullName?"+searchParm+" g1;";
            }
            String url = "/organizations";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStrFGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrFGet,Envelop.class);
            List<OrgModel> orgModels = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            if(envelopGet.isSuccessFlg()){
                orgModels = (List<OrgModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<OrgModel>(),OrgModel.class);
                for (OrgModel m:orgModels){
                    Map map = new HashMap<>();
                    map.put("id",m.getOrgCode());
                    map.put("name",m.getFullName());
                    list.add(map);
                }
                envelopGet.setDetailModelList(list);
                return envelopGet;
            }
            return envelop;
        }catch (Exception ex){
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return envelop;
        }
    }

    /**
     * 获取所有机构代码下拉框
     */
    @RequestMapping("/getAllorgCodes")
    @ResponseBody
    public Object getAllorgCodes(){
        Envelop envelop = new Envelop();
        try{
            String url = "/organizations";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters","");
            params.put("sorts","");
            params.put("page",1);
            params.put("size",1000);
            String envelopStrFGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrFGet,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                envelop.setObj(envelopGet.getDetailModelList());
                envelop.setSuccessFlg(true);
                return envelop;
            }
            return envelop;
        }catch (Exception ex){
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return envelop;
        }
    }

    @RequestMapping("deleteOrg")
    @ResponseBody
    public Object deleteOrg(String orgCode) {
        String getOrgUrl = "/organizations/" + orgCode;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    /**
     * @param orgCode
     * @return
     */
    @RequestMapping("activity")
    @ResponseBody
    public Object activity(String orgCode, String activityFlag) {

        String url = "/organizations/" + orgCode + "/" + activityFlag;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("更新失败");
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("updateOrg")
    @ResponseBody
    public Object updateOrg(String orgModel, String addressModel, String mode, HttpServletRequest request) throws UnsupportedEncodingException {
        //新增或修改 根据mode 选择
        String url = "/organizations";
        String envelopStr = "";
        Envelop envelop = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        RestTemplates templates = new RestTemplates();

        String orgJsonData = URLDecoder.decode(orgModel, "UTF-8");
        String orgData[] = orgJsonData.split(";");
        if (orgData.length > 1) {
            orgModel = orgData[0];
            addressModel = orgData[1];
            mode = orgData[2];
        }

        params.add("mOrganizationJsonData", orgModel);
        params.add("geography_model_json_data", addressModel);
        try {

            request.setCharacterEncoding("UTF-8");
            InputStream inputStream = request.getInputStream();
            String imageName = request.getParameter("name");

            int temp = 0;
            byte[] tempBuffer = new byte[1024];
            byte[] fileBuffer = new byte[0];
            while ((temp = inputStream.read(tempBuffer)) != -1) {
                fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
            }
            inputStream.close();

            String restStream = Base64.getEncoder().encodeToString(fileBuffer);
            String imageStream = URLEncoder.encode(restStream, "UTF-8");

            params.add("inputStream", imageStream);
            params.add("imageName", imageName);

            if ("new".equals(mode)) {
                envelopStr = templates.doPost(comUrl + url, params);
            } else {
                ObjectMapper objectMapper = new ObjectMapper();
                //读取参数，转化为模型
                OrgDetailModel org = objectMapper.readValue(orgModel, OrgDetailModel.class);
                //查询数据库得到对应的模型
                String getOrgUrl = "/organizations/" + org.getOrgCode();
                String envelopStrGet = templates.doGet(comUrl + getOrgUrl, params);
                envelop = objectMapper.readValue(envelopStrGet, Envelop.class);
                if (!envelop.isSuccessFlg()) {
                    return envelop;
                }
                OrgDetailModel orgForUpdate = getEnvelopModel(envelop.getObj(), OrgDetailModel.class);
                //将修改值存储到查询返回的对象中
                orgForUpdate.setFullName(org.getFullName());
                orgForUpdate.setShortName(org.getShortName());
                orgForUpdate.setSettledWay(org.getSettledWay());
                orgForUpdate.setAdmin(org.getAdmin());
                orgForUpdate.setTel(org.getTel());
                orgForUpdate.setOrgType(org.getOrgType());
                orgForUpdate.setTags(org.getTags());
                orgForUpdate.setImgLocalPath("");
                //用于存储机构最小划分区域的id -追加 start by zdm
                orgForUpdate.setAdministrativeDivision(org.getAdministrativeDivision());
                //用于存储机构最小划分区域的id -追加 end by zdm
                orgForUpdate.setCode(org.getCode());
                orgForUpdate.setTraffic(org.getTraffic());
                orgForUpdate.setPhoto(org.getPhoto());
                orgForUpdate.setHosTypeId(org.getHosTypeId());
                orgForUpdate.setPhone(org.getPhone());
                orgForUpdate.setHosPhoto(org.getHosPhoto());
                orgForUpdate.setAscriptionType(org.getAscriptionType());
                orgForUpdate.setIntroduction(org.getIntroduction());
                orgForUpdate.setLegalPerson(org.getLegalPerson());
                orgForUpdate.setLevelId(org.getLevelId());
                if(!StringUtils.isEmpty(org.getLogoUrl())){
                    orgForUpdate.setLogoUrl(org.getLogoUrl());
                }
                orgForUpdate.setSortNo(org.getSortNo());
                orgForUpdate.setParentHosId(org.getParentHosId());
                orgForUpdate.setIng(org.getIng());
                orgForUpdate.setLat(org.getLat());
                orgForUpdate.setZxy(org.getZxy());
                if ("Hospital".equalsIgnoreCase(org.getOrgType())) {
                    orgForUpdate.setBerth(org.getBerth());
                }



                String mOrgUpdateJson = objectMapper.writeValueAsString(orgForUpdate);
                params.add("mOrganizationJsonDatas", mOrgUpdateJson);
                envelopStr = templates.doPost(comUrl + "/organizations/update", params);
            }
            return envelopStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("getOrg")
    @ResponseBody
    public Object getOrg(String orgCode) {

        String getOrgUrl = "/organizations/" + orgCode;
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode", orgCode);

        Envelop envelop = new Envelop();
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("distributeKey")
    @ResponseBody
    public Object distributeKey(String orgCode) {

        String getOrgUrl = "/organizations/key";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("org_code", orgCode);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }


    @RequestMapping("validationOrg")
    @ResponseBody
    public Object validationOrg(String orgCode) {
        String getOrgUrl = "/organizations/existence/" + orgCode;
        String resultStr = "";
        Envelop envelop = new Envelop();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, username, password);
            if (!Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp,HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("userImageStream");
        String imageStream = URLDecoder.decode(fileStream, "UTF-8");

        try {
            outputStream = response.getOutputStream();
            byte[] bytes = Base64.getDecoder().decode(imageStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(PatientController.class).error(e.getMessage());
        } finally {
            if (outputStream != null)
                outputStream.close();
        }
    }

    @RequestMapping("/showImageLogo")
    @ResponseBody
    public void showImageLogo(String storagePath,HttpServletResponse response) throws Exception {
        if(org.apache.commons.lang3.StringUtils.isNotEmpty(storagePath)){
            OutputStream outputStream = null;
            try {
                Map<String,Object> params = new HashMap<>();
                storagePath = URLEncoder.encode(storagePath, "ISO8859-1");
                String fileName = System.currentTimeMillis() + storagePath.substring(storagePath.indexOf(".")-1);
                params.put("storagePath",storagePath);
                String imageOutStream = HttpClientUtil.doGet(comUrl + "/image_view",params,username, password);
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment;fileName="+fileName);
                outputStream = response.getOutputStream();
                byte[] bytes = Base64.getDecoder().decode(imageOutStream);
                outputStream.write(bytes);
                outputStream.flush();
            } catch (IOException e) {
                LogService.getLogger(OrganizationController.class).error(e.getMessage());
            } finally {
                if (outputStream != null)
                    outputStream.close();
            }
        }
    }


    @RequestMapping("/upload2")
    @ResponseBody
    public String upload2(HttpServletRequest request, HttpServletResponse response) throws IllegalStateException,
            IOException {
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession()
                .getServletContext());
        if (multipartResolver.isMultipart(request)) {
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            //取得request中的所有文件名
            Iterator<String> iter = multiRequest.getFileNames();
            while (iter.hasNext()) {
                //取得上传文件
                MultipartFile file = multiRequest.getFile(iter.next());
                file.getInputStream();
                if (file != null) {
                    String myFileName = file.getOriginalFilename();
                    System.out.println(myFileName);
                    String fildName = file.getName();
                    System.out.println(fildName);
                }
            }
        }

        return "";
    }


    /**
     * 资源文件上传
     * @param
     * @return
     */
    @RequestMapping("orgLogoFileUpload")
    @ResponseBody
    public Object orgLogoFileUpload(
            @RequestParam("logoFileUrl") MultipartFile file) throws IOException{
        Envelop result = new Envelop();
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename(); //获取文件名
        if (!file.isEmpty()) {
            return  uploadFile(inputStream,fileName);
        }
        return "fail";
    }

    public String uploadFile(InputStream inputStream,String fileName){
        try {
            //读取文件流，将文件输入流转成 byte
            int temp = 0;
            int bufferSize = 1024;
            byte tempBuffer[] = new byte[bufferSize];
            byte[] fileBuffer = new byte[0];
            while ((temp = inputStream.read(tempBuffer)) != -1) {
                fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
            }
            inputStream.close();
            String restStream = Base64.getEncoder().encodeToString(fileBuffer);
            String url = "";
            url = fileUpload(restStream,fileName);
            if (!StringUtils.isEmpty(url)){
                System.out.println("上传成功");
                return url;
            }else{
                System.out.println("上传失败");
            }

        } catch (Exception e) {
            return "fail";
        }
        return "fail";
    }

    /**
     * 图片上传
     * @param inputStream
     * @param fileName
     * @return
     */
    public String fileUpload(String inputStream,String fileName){

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String url = null;
        if (!StringUtils.isEmpty(inputStream)) {

            //mime  参数 doctor 需要改变  --  需要从其他地方配置
            FileResourceModel fileResourceModel = new FileResourceModel("","org","");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data",fileResourceModelJsonData);
            try {
                url = HttpClientUtil.doPost(comUrl + "/filesReturnUrl", params,username,password);
                return url;
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return url;
    }




  //资源授权
  //-------------------------------------------------------角色组---资源授权管理---开始----------------
  @RequestMapping("/resource/initial")
  public String resourceInitial(Model model, String backParams){
      model.addAttribute("backParams",backParams);
      model.addAttribute("contentPage", "organization/resource");
      return "pageView";
  }

    //获取角色组已授权资源ids集合
    @RequestMapping("/orgResourceIds")
    @ResponseBody
    public  Object getOrgResourceIds(String orgCode){
        Envelop envelop = new Envelop();
        List<String> list = new ArrayList<>();
        envelop.setSuccessFlg(false);
        envelop.setDetailModelList(list);
        URLQueryBuilder builder = new URLQueryBuilder();
        if (org.springframework.util.StringUtils.isEmpty(orgCode)) {
            return envelop;
        }
        builder.addFilter("organizationId", "=", orgCode, null);
        builder.setPageNumber(1)
                .setPageSize(999);
        String param = builder.toString();
        String url = "/resources/OrgGrants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()&&resultGet.getDetailModelList().size()!=0){
                List<RsOrgResourceModel> rsOrgModels = (List<RsOrgResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsOrgResourceModel>(),RsOrgResourceModel.class);
                for(RsOrgResourceModel m : rsOrgModels){
                    list.add(m.getResourceId());
                }
                envelop.setSuccessFlg(true);
            }
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(true);
        envelop.setDetailModelList(list);
        return envelop;
    }

    @RequestMapping("/org")
    @ResponseBody
    public Object getOrgById(String orgCode){
        Envelop envelop = new Envelop();
        try{
            String url = "/orgCode/"+orgCode;
            RestTemplates template = new RestTemplates();
            String envelopStr = template.doGet(comUrl+url);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //资源授权orgCode+resourceIds
    @RequestMapping("/resource/OrgGrants")
    @ResponseBody
    public Object resourceGrant(String orgCode,String resourceIds){
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/Org/"+orgCode+"/grant";
            Map<String,Object> params = new HashMap<>();
            params.put("orgCode", orgCode);
            params.put("resourceIds", resourceIds);
            String resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //批量、单个取消资源授权
    @RequestMapping("/resource/cancel")
    @ResponseBody
    public Object resourceGrantCancel(String orgCode,String resourceIds){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        if(org.springframework.util.StringUtils.isEmpty(orgCode)){
            envelop.setErrorMsg("机构code不能为空！");
            return envelop;
        }
        if(org.springframework.util.StringUtils.isEmpty(resourceIds)){
            envelop.setErrorMsg("资源id不能为空！");
            return envelop;
        }
        try {
            //先获取授权关系表的ids
            String url = "/resources/OrgGrants/no_paging";
            Map<String,Object> params = new HashMap<>();
            params.put("filters","organizationId="+orgCode+";resourceId="+resourceIds);
            String envelopStrGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            String ids = "";
            if(envelopGet.isSuccessFlg()&&envelopGet.getDetailModelList().size()!=0){
                List<MRsOrgResource> list = (List<MRsOrgResource>)getEnvelopList(envelopGet.getDetailModelList(),
                        new ArrayList<MRsOrgResource>(),MRsOrgResource.class);
                for(MRsOrgResource m:list){
                    ids += m.getId()+",";
                }
                ids = ids.substring(0,ids.length()-1);
            }
            //取消资源授权
            if(!org.springframework.util.StringUtils.isEmpty(ids)){
                String urlCancel = "/resources/OrgGrants";
                Map<String,Object> args = new HashMap<>();
                args.put("ids",ids);
                String result = HttpClientUtil.doDelete(comUrl+urlCancel,args,username,password);
                return result;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelop;
    }

    //修改、查看授权资源
    //-------------------------------------------------------角色组---资源授权管理---结束----------------

    //-------------------------------------------------------角色组----资源----数据元--管理开始--------------
    @RequestMapping("/resourceManage/initial")
    public String resourceManageInitial(Model model,String orgCode,String resourceId, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("orgRsId",getOrgResId(orgCode,resourceId));
        model.addAttribute("contentPage", "organization/resourceManage");
        return "pageView";
    }
    //获取角色组-资源关联关系id
    public String getOrgResId(String orgCode,String resourceId) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if (org.springframework.util.StringUtils.isEmpty(orgCode)|| org.springframework.util.StringUtils.isEmpty(resourceId)) {
            return "";
        }
        builder.addFilter("organizationId", "=",orgCode, null);
        builder.addFilter("resourceId", "=", resourceId, null);
        builder.setPageNumber(1)
                .setPageSize(1);
        String param = builder.toString();
        String url = "/resources/OrgGrants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()){
                List<RsOrgResourceModel> rsOrgModels = (List<RsOrgResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsOrgResourceModel>(),RsOrgResourceModel.class);
                RsOrgResourceModel resourceModel = rsOrgModels.get(0);
                return resourceModel.getId();
            }
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
        }
        return "";
    }


    @RequestMapping("/getOrgList")
    @ResponseBody
    public Object getOrgList(String searchParm) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params =  new HashMap<>();
            params.put("pid", 361100);
            if (!StringUtils.isEmpty(searchParm)) {
                params.put("fullName", searchParm);
            }
            String url = "/organizations/getOrgListByAddressPid";
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = objectMapper.readValue(resultStr, Envelop.class);
        }catch (Exception e){
            e.getMessage();
            envelop.setErrorMsg(e.getMessage());
            envelop.setSuccessFlg(false);
        }
        return envelop;
    }


    /**
     * 用户修改-选择机构：根据区域id或机构名称获取机构
     * @param areaId 区域id
     * @param fullName 机构名称-模糊搜索  区域id与机构名称不能同时为空
     * @return
     */
    @RequestMapping("getAllOrgByAdministrativeDivision")
    @ResponseBody
    public Object getAllOrgByAdministrativeDivision(Integer areaId,String fullName) {
        String getOrgUrl = "/basic/api/v1.0/org/getAllOrgByAdministrativeDivision";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("areaId",areaId);
        params.put("fullName",fullName);
        try {
            resultStr = HttpClientUtil.doDelete(adminInnerUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

}
