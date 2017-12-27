package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.user.PlatformAppRolesTreeModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.geography.controller.AddressController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.*;

/**
 * @author zlf
 * @version 1.0
 * @created 2015.08.10 17:57
 */
@Controller
@RequestMapping("/user")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class UserController extends BaseUIController {
    public static final String GroupField = "groupName";
    public static final String RemoteFileField = "remoteFileName";
    public static final String FileIdField = "fid";
    public static final String FileUrlField = "fileUrl";

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private AddressController addressController;

    @RequestMapping("initial")
    public String userInitial(Model model) {
        model.addAttribute("contentPage", "user/user");
        return "pageView";
    }

    @RequestMapping("initialChangePassword")
    public String inChangePassword(Model model) {
        model.addAttribute("contentPage", "user/changePassword");
        return "generalView";
    }

    @RequestMapping("addUserInfoDialog")
    public String addUser(Model model) {
        model.addAttribute("contentPage", "user/addUserInfoDialog");
        return "generalView";
    }

    @RequestMapping("searchUsers")
    @ResponseBody
    public Object searchUsers(String searchNm,String searchOrg, String searchType, int page, int rows, HttpServletRequest request) {

        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();

            StringBuffer stringBuffer = new StringBuffer();
            if (!StringUtils.isEmpty(searchNm)) {
                stringBuffer.append("realName"+ PageParms.LIKE + searchNm + ";");
            }
            if (!StringUtils.isEmpty(searchOrg)) {
                stringBuffer.append("organization=" + searchOrg + ";");
            }
            if (!StringUtils.isEmpty(searchType)) {
                stringBuffer.append("userType=" + searchType + ";");
            }

            params.put("filters", "");
            String filters = stringBuffer.toString();
            if (!StringUtils.isEmpty(filters)) {
                params.put("filters", filters);
            }
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            boolean isAccessAll = getIsAccessAllRedis(request);
            if (!isAccessAll && null == userOrgList) {
                envelop.setSuccessFlg(true);
                return envelop;
            } else if (null != userOrgList && userOrgList.size() > 0) {
                String orgCode = String.join(",", userOrgList);
                params.put("orgCode", orgCode);
            }
            params.put("page", page);
            params.put("size", rows);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }

    }

    @RequestMapping("deleteUser")
    @ResponseBody
    public Object deleteUser(String userId) {
        String url = "/users/admin/" + userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("userId", userId);
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

    @RequestMapping("activityUser")
    @ResponseBody
    public Object activityUser(String userId, boolean activated) {
        String url = "/users/admin/"+userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("activity", activated);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }

    @RequestMapping(value = "updateUser", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateUser(String userModelJsonData,HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = "/user/";
        String resultStr = "";
        Envelop envelop = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        ObjectMapper mapper = new ObjectMapper();
        RestTemplates templates = new RestTemplates();

        String userJsonDataModel = URLDecoder.decode(userModelJsonData,"UTF-8");
        UserDetailModel userDetailModel = mapper.readValue(userJsonDataModel, UserDetailModel.class);

        request.setCharacterEncoding("UTF-8");
        InputStream inputStream = request.getInputStream();
        String imageName = request.getParameter("name");

        int temp = 0;
        byte[] tempBuffer = new byte[1024];
        byte[] fileBuffer = new byte[0];
        while ((temp = inputStream.read(tempBuffer)) != -1) {
            fileBuffer = ArrayUtils.addAll(fileBuffer,ArrayUtils.subarray(tempBuffer,0,temp));
        }
        inputStream.close();

        String restStream = Base64.getEncoder().encodeToString(fileBuffer);

        try {
            if (!StringUtils.isEmpty(userDetailModel.getId())) {
                //修改
                String getUser = templates.doGet(comUrl + "/users/admin/"+userDetailModel.getId());
                envelop = mapper.readValue(getUser,Envelop.class);
                String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                UserDetailModel userModel = mapper.readValue(userJsonModel,UserDetailModel.class);
                userModel.setRealName(userDetailModel.getRealName());
                userModel.setIdCardNo(userDetailModel.getIdCardNo());
                userModel.setGender(userDetailModel.getGender());
                userModel.setMartialStatus(userDetailModel.getMartialStatus());
                userModel.setEmail(userDetailModel.getEmail());
                userModel.setTelephone(userDetailModel.getTelephone());
                userModel.setUserType(userDetailModel.getUserType());
                userModel.setOrganization(userDetailModel.getOrganization());
                userModel.setMajor("");
                if(null!=userDetailModel.getBirthday()&&!"".equals(userDetailModel.getBirthday())){
                    userModel.setBirthday(userDetailModel.getBirthday());
                }else{
                    userModel.setBirthday(null);
                }

                userModel.setRealnameFlag(userDetailModel.getRealnameFlag());
                userModel.setImgLocalPath("");
                userModel.setRole(userDetailModel.getRole());
                userModel.setProvinceId(userDetailModel.getProvinceId());
                userModel.setProvinceName(userDetailModel.getProvinceName());
                userModel.setCityId(userDetailModel.getCityId());
                userModel.setCityName(userDetailModel.getCityName());
                userModel.setAreaId(userDetailModel.getAreaId());
                userModel.setAreaName(userDetailModel.getAreaName());
                userModel.setStreet(userDetailModel.getStreet());
                if(userDetailModel.getUserType().equals("Doctor")){
                    userModel.setMajor(userDetailModel.getMajor());
                }
                String imageId = fileUpload(userModel.getId(),restStream,imageName);
                if (!StringUtils.isEmpty(imageId)){
                    userModel.setImgRemotePath(imageId);
                }
                userModel.setSecondPhone(userDetailModel.getSecondPhone());
                userModel.setQq(userDetailModel.getQq());
                userModel.setMicard(userDetailModel.getMicard());
                userModel.setSsid(userDetailModel.getSsid());

                userJsonDataModel = toJson(userModel);
                params.add("user_json_data", userJsonDataModel);

                resultStr = templates.doPut(comUrl + url, params);
            }else{

                params.add("user_json_data", userJsonDataModel);

                resultStr = templates.doPost(comUrl + url, params);

                envelop = toModel(resultStr,Envelop.class);
                UserDetailModel addUserModel = toModel(toJson(envelop.getObj()),UserDetailModel.class);

                String imageId = fileUpload(addUserModel.getId(),restStream,imageName);

                if (!StringUtils.isEmpty(imageId)){
                    addUserModel.setImgRemotePath(imageId);

                    String userData = templates.doGet(comUrl + "/users/admin/"+addUserModel.getId());
                    envelop = mapper.readValue(userData,Envelop.class);
                    String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                    UserDetailModel userModel = mapper.readValue(userJsonModel,UserDetailModel.class);
                    userModel.setImgRemotePath(imageId);

                    params.remove("user_json_data");
                    params.add("user_json_data",toJson(userModel));
//                    params.add("user_json_data",toJson(addUserModel));
                    resultStr = templates.doPut(comUrl + url, params);

                }

            }
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return resultStr;

    }

    public String fileUpload(String userId,String inputStream,String fileName){

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String fileId = null;
        if (!StringUtils.isEmpty(inputStream)) {

            FileResourceModel fileResourceModel = new FileResourceModel(userId,"user","");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data",fileResourceModelJsonData);
            try {
                fileId = HttpClientUtil.doPost(comUrl + "/files", params,username,password);
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        return fileId;

    }

    @RequestMapping("resetPass")
    @ResponseBody
    public Object resetPass(String userId,@ModelAttribute(SessionAttributeKeys.CurrentUser) UserDetailModel userDetailModel) {
        String url = "/users/password/"+userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
                result.setObj(userDetailModel.getId()); //重置到当前用户时需重登
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("getUser")
    public Object getUser(Model model, String userId, String mode, HttpSession session,HttpServletRequest request) throws IOException {
        String url = "/users/admin/"+userId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            UserDetailModel userDetailModel = toModel(toJson(ep.getObj()),UserDetailModel.class);

            String imageOutStream = "";
            if (userDetailModel!=null && !StringUtils.isEmpty(userDetailModel.getImgRemotePath())) {
                params.put("object_id",userDetailModel.getId());
                imageOutStream = HttpClientUtil.doGet(comUrl + "/files",params,username, password);
                envelop = toModel(imageOutStream,Envelop.class);
                if (envelop.getDetailModelList().size()>0){
                    session.removeAttribute("userImageStream");
                    session.setAttribute("userImageStream",imageOutStream == null ? "" :envelop.getDetailModelList().get(envelop.getDetailModelList().size()-1));
                }
            }
            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "user/userInfoDialog");
            return "simpleView";
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("unbundling")
    @ResponseBody
    public Object unbundling(String userId, String type) {
        String getUserUrl = "/users/binding/"+userId;//解绑 todo 网关中需添加此方法
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("type", type);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + getUserUrl, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("distributeKey")
    @ResponseBody
    public Object distributeKey(String loginCode) {
        String getUserUrl = "/users/key/"+loginCode;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("loginCode", loginCode);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + getUserUrl, params, username, password);
            if (!StringUtils.isEmpty(resultStr)) {
                envelop.setObj(resultStr);
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }

        return envelop;
    }

    @RequestMapping("/existence")
    @ResponseBody
    public Object searchUser(String existenceType, String existenceNm) {
        String getUserUrl = "/users/existence";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("existenceType",existenceType);
        params.put("existenceNm",existenceNm);

        try {
            resultStr = HttpClientUtil.doGet(comUrl + getUserUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }

    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp,HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("userImageStream");

//        String imageStream = URLDecoder.decode(fileStream,"UTF-8");

        try {
            outputStream = response.getOutputStream();
            byte[] bytes = Base64.getDecoder().decode(fileStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(UserController.class).error(e.getMessage());
        } finally {
            if (outputStream != null)
                outputStream.close();
        }
    }

    @RequestMapping("/changePassWord")
    @ResponseBody
    public Object changePassWord(String userId,String passWord){
        String getUserUrl = "/users/changePassWord";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("user_id",userId);
        params.put("password",passWord);

        try {
            resultStr = HttpClientUtil.doPut(comUrl + getUserUrl, params, username, password);
            envelop.setObj(resultStr);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("密码修改失败");
        }

        return envelop;
    }

    //查看权限页面初始化
    @RequestMapping("/appFeatureInitial")
    public Object appFeatureInitial(Model model,String userId){
        model.addAttribute("contentPage","user/userFeature");
        model.addAttribute("userId",userId);
        //获取用户所属角色
        Envelop envelop = new Envelop();
        String en = "";
        try {
            en = objectMapper.writeValueAsString(envelop);
            String url = "/roles/role_user/userRolesIds";
            Map<String,Object> params = new HashMap<>();
            params.put("user_id",userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            model.addAttribute("envelop", envelopStr);
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
            model.addAttribute("envelop", en);
        }
        return "simpleView";
    }

    //获取应用-用户角色组关系列表,用于查看权限
    @RequestMapping("/appRoles")
    @ResponseBody
    public Object getAppRoles(String userId){
        //角色组类型字典：应用角色（type="0"）/用户角色（type="1"）
        //应用分类字典：平台应用（sourceType="1"）/接入应用（sourcetype="0")
        String type = "1";
        String sourceType = "1";
        try {
            String url = "/roles/app_user_roles";
            Map<String,Object> params = new HashMap<>();
            params.put("type",type);
            params.put("source_type",sourceType);
            params.put("user_id",userId);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //获取用户某个应用下的权限
    /**
     *
     * @param roleIds 用户所属角色组ids
     * @return
     */
    @RequestMapping("/userAppFeatures")
    @ResponseBody
    public Object getUserAppFeatures(String roleIds){
        if(StringUtils.isEmpty(roleIds)){
            return failed("角色组ids不能为空！");
        }
        try {
            String url = "/users/user_features";
            Map<String,Object> params = new HashMap<>();
            params.put("roles_ids",roleIds);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            envelop.getDetailModelList();
            if(envelop.isSuccessFlg()&&envelop.getDetailModelList().size()>0){
                return getEnvelopList(envelop.getDetailModelList(),new ArrayList<>(), AppFeatureModel.class);
            }
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //获取所用平台应用下的角色组用于下拉框
    @RequestMapping("/appRolesList")
    @ResponseBody
    public Object getAppRolesList(){
        String roleType = "1";//用户角色类型字典值
        String appSourceType = "1";//应用类型字典值
        try {
            String url = "/roles/platformAppRolesTree";
            Map<String,Object> params = new HashMap<>();
            params.put("type",roleType);
            params.put("source_type",appSourceType);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            envelop.getDetailModelList();
            if(envelop.isSuccessFlg()&&envelop.getDetailModelList().size()>0){
                return getEnvelopList(envelop.getDetailModelList(),new ArrayList<>(), PlatformAppRolesTreeModel.class);
            }
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/getPatientInUserByIdCardNo")
    @ResponseBody
    public Object getUserByIdCardNo(String idCardNo) {
        String getUserUrl = "/getPatientInUserByIdCardNo";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id_card_no",idCardNo);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getUserUrl, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr,Envelop.class);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }

    //查看是否有权限
    @RequestMapping("/isRoleUser")
    @ResponseBody
    public boolean isRoleUser(String userId){
        String url = "/roles/role_user/userRolesIds";
        try {
            Map<String,Object> params = new HashMap<>();
            params.put("user_id",userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            if (envelop.isSuccessFlg() && null != envelop.getObj() && !"".equals(envelop.getObj())) {
                return  true;
            }
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
        }
        return false;
    }

    @RequestMapping(value = "/getDistrictByUserId")
    @ResponseBody
    public Object getDistrictByUserId() {
       /* HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpSession session = request.getSession();
        UserDetailModel user = (UserDetailModel)session.getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/getDistrictByUserId";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId",user.getId());
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }*/
        String url = "/geography_entries/pid/350200";
        String resultStr = "";
        Envelop result = new Envelop();
        try{
            resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            if (envelop.isSuccessFlg()) {
                result.setObj(envelop.getDetailModelList());
                result.setSuccessFlg(true);
                return result;
            }else{
                result.setSuccessFlg(false);
                return result;
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping(value = "/getOrgByUserId")
    @ResponseBody
    public Object getOrgByUserId() {
        /*HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpSession session = request.getSession();
        UserDetailModel user = (UserDetailModel)session.getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/getOrgByUserId";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId",user.getId());
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }*/
        Envelop envelop = new Envelop();
        envelop = (Envelop)addressController.getOrgs("福建省", "厦门市");
        return envelop;
    }
}
