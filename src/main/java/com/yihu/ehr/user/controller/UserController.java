package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.user.PlatformAppRolesTreeModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.geography.controller.AddressController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
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
    @Autowired
    private UserRolesController userRolesController;

    @RequestMapping("initial")
    public String userInitial(Model model) {
        model.addAttribute("contentPage", "user/user");
        return "pageView";
    }

    @RequestMapping("userType")
    public String userTypeInitial(Model model) {
        model.addAttribute("contentPage", "user/roles/userType");
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
        return "emptyView";
    }

    /**
     * 选择机构部门
     *
     * @param model
     * @return
     */
    @RequestMapping("selectOrgDept")
    public String selectOrgDept(String idCardNo, String type,String origin, Model model) {
        model.addAttribute("idCardNo", idCardNo);
        model.addAttribute("type", type);
        model.addAttribute("origin", origin);
        model.addAttribute("contentPage", "user/roles/selectOrgDept");
        return "emptyView";
    }


    @RequestMapping("searchUsers")
    @ResponseBody
    public Object searchUsers(String searchNm, String searchOrg, String searchType, int page, int rows, HttpServletRequest request) {

        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();

            StringBuffer stringBuffer = new StringBuffer();
            if (!StringUtils.isEmpty(searchNm)) {
                stringBuffer.append("realName" + PageParms.LIKE + searchNm + ";");
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
            List<String> userOrgList = getUserOrgSaasListRedis(request);
            if (null != userOrgList && userOrgList.size() > 0 && "-NoneOrg".equalsIgnoreCase(userOrgList.get(0))) {
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
            LogService.getLogger(UserController.class).error(e.getMessage());
            return failed(ERR_SYSTEM_DES);
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
                return failed("删除失败");
            }
            return result;
        } catch (Exception e) {
            LogService.getLogger(UserController.class).error(e.getMessage());
            return failed(ERR_SYSTEM_DES);
        }

    }

    @RequestMapping("activityUser")
    @ResponseBody
    public Object activityUser(String userId, boolean activated) {
        String url = "/users/admin/" + userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("activity", activated);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                return failed("更新失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    @RequestMapping(value = "updateUser", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateUser(String userModelJsonData, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String url = "/user/";
        String resultStr = "";
        Envelop envelop = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        ObjectMapper mapper = new ObjectMapper();
        RestTemplates templates = new RestTemplates();

        String userJsonDataModel = URLDecoder.decode(userModelJsonData, "UTF-8");
        UserDetailModel userDetailModel = mapper.readValue(userJsonDataModel, UserDetailModel.class);

        // 个人头象图片信息上传
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

        // 用户信息新增开始
        try {
            if (!StringUtils.isEmpty(userDetailModel.getId())) {
                //修改
                String getUser = templates.doGet(comUrl + "/users/admin/" + userDetailModel.getId());
                envelop = mapper.readValue(getUser, Envelop.class);
                String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                UserDetailModel userModel = mapper.readValue(userJsonModel, UserDetailModel.class);
                userModel.setRealName(userDetailModel.getRealName());
                userModel.setIdCardNo(userDetailModel.getIdCardNo());
                userModel.setGender(userDetailModel.getGender());
                userModel.setMartialStatus(userDetailModel.getMartialStatus());
                userModel.setEmail(userDetailModel.getEmail());
                userModel.setTelephone(userDetailModel.getTelephone());
                userModel.setUserType(userDetailModel.getUserType());
                userModel.setOrganization(userDetailModel.getOrganization());
                userModel.setMajor("");
                if (null != userDetailModel.getBirthday() && !"".equals(userDetailModel.getBirthday())) {
                    userModel.setBirthday(userDetailModel.getBirthday());
                } else {
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
                if ("Doctor".equals(userDetailModel.getUserType())) {
                    userModel.setMajor(userDetailModel.getMajor());
                }
                String imageId = fileUpload(userModel.getId(), restStream, imageName);
                if (!StringUtils.isEmpty(imageId)) {
                    userModel.setImgRemotePath(imageId);
                }
                userModel.setSecondPhone(userDetailModel.getSecondPhone());
                userModel.setQq(userDetailModel.getQq());
                userModel.setMicard(userDetailModel.getMicard());
                userModel.setSsid(userDetailModel.getSsid());

                userJsonDataModel = toJson(userModel);
                params.add("user_json_data", userJsonDataModel);

                resultStr = templates.doPut(comUrl + url, params);
            } else {

                params.add("user_json_data", userJsonDataModel);
                resultStr = templates.doPost(comUrl + url, params);
                envelop = toModel(resultStr, Envelop.class);
                UserDetailModel addUserModel = toModel(toJson(envelop.getObj()), UserDetailModel.class);
                String imageId = fileUpload(addUserModel.getId(), restStream, imageName);

                if (!StringUtils.isEmpty(imageId)) {
                    addUserModel.setImgRemotePath(imageId);
                    String userData = templates.doGet(comUrl + "/users/admin/" + addUserModel.getId());
                    envelop = mapper.readValue(userData, Envelop.class);
                    String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                    UserDetailModel userModel = mapper.readValue(userJsonModel, UserDetailModel.class);
                    userModel.setImgRemotePath(imageId);

                    params.remove("user_json_data");
                    params.add("user_json_data", toJson(userModel));
//                    params.add("user_json_data",toJson(addUserModel));
                    resultStr = templates.doPut(comUrl + url, params);

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return resultStr;

    }

    @RequestMapping(value = "updateUserAndInitRoles")
    @ResponseBody
    public Object updateUserAndInitRoles(String userModelJsonData, String orgModel, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1、参数初始化
        String url = "/user/";
        String resultStr = "";
        String userId = "";
        Envelop envelop = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        ObjectMapper mapper = new ObjectMapper();
        RestTemplates templates = new RestTemplates();

        // 2、界面数据获取
        String userJsonDataModel = URLDecoder.decode(userModelJsonData, "UTF-8");
        UserDetailModel userDetailModel = mapper.readValue(userJsonDataModel, UserDetailModel.class);
        String userType = userDetailModel.getUserType().toString();

        // 3、个人头象图片信息上传
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

        // 4、更新用户信息
        try {
            // 4-1、当用户信息存在的情况，调用修改方法
            if (!StringUtils.isEmpty(userDetailModel.getId())) {
                // 获取现有的用户数据
                userId = userDetailModel.getId().toString();
                String getUser = templates.doGet(comUrl + "/users/admin/" + userDetailModel.getId());
                envelop = mapper.readValue(getUser, Envelop.class);
                String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                UserDetailModel userModel = mapper.readValue(userJsonModel, UserDetailModel.class);
                // 将界面上的维护信息维护到现有的数据中
                userModel.setRealName(userDetailModel.getRealName());
                userModel.setIdCardNo(userDetailModel.getIdCardNo());
                userModel.setGender(userDetailModel.getGender());
                userModel.setEmail(userDetailModel.getEmail());
                userModel.setTelephone(userDetailModel.getTelephone());
                userModel.setUserType(userType);
                userModel.setImgLocalPath("");
                // 基于传入的角色列表进行授权的维护，更新role_user,user_app表
                userModel.setRole(userDetailModel.getRole());
                String imageId = fileUpload(userModel.getId(), restStream, imageName);
                if (!StringUtils.isEmpty(imageId)) {
                    userModel.setImgRemotePath(imageId);
                }
                userJsonDataModel = toJson(userModel);
                params.add("user_json_data", userJsonDataModel);

                resultStr = templates.doPut(comUrl + url, params);
            } else {
                //4-2、当用户信息不存在的情况，调用新增的方法
                params.add("user_json_data", userJsonDataModel);
                resultStr = templates.doPost(comUrl + url, params);
                envelop = toModel(resultStr, Envelop.class);
                UserDetailModel addUserModel = toModel(toJson(envelop.getObj()), UserDetailModel.class);
                String imageId = fileUpload(addUserModel.getId(), restStream, imageName);
                userId = addUserModel.getId().toString();

                if (!StringUtils.isEmpty(imageId)) {
                    addUserModel.setImgRemotePath(imageId);
                    String userData = templates.doGet(comUrl + "/users/admin/" + addUserModel.getId());
                    envelop = mapper.readValue(userData, Envelop.class);
                    String userJsonModel = mapper.writeValueAsString(envelop.getObj());
                    UserDetailModel userModel = mapper.readValue(userJsonModel, UserDetailModel.class);
                    userModel.setImgRemotePath(imageId);
                    params.remove("user_json_data");
                    params.add("user_json_data", toJson(userModel));

                    resultStr = templates.doPut(comUrl + url, params);
                }
            }
            //4-3、进行用户机构关联关系维护
            envelop = userRolesController.initUserOrgRelation(userId, orgModel);
            if (!envelop.isSuccessFlg()) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("初始化授权失败，请联系管理员进行手动授权操作！");
                return envelop.toString();
            }

        //获取用户及角色（部分有字典转换）
            MultiValueMap<String, String> pars = new LinkedMultiValueMap<>();
            pars.add("userName", userDetailModel.getLoginCode());
            resultStr = templates.doGet(adminInnerUrl + "/basic/api/v1.0/users/GetUserByLoginCode/" + userDetailModel.getLoginCode());
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return resultStr;
    }

    public String fileUpload(String userId, String inputStream, String fileName) {

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String fileId = null;
        if (!StringUtils.isEmpty(inputStream)) {

            FileResourceModel fileResourceModel = new FileResourceModel(userId, "user", "");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data", fileResourceModelJsonData);
            try {
                fileId = HttpClientUtil.doPost(comUrl + "/files", params, username, password);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return fileId;

    }

    @RequestMapping("resetPass")
    @ResponseBody
    public Object resetPass(String userId, @ModelAttribute(SessionAttributeKeys.CurrentUser) UsersModel userDetailModel) {
        String url = "/users/password/" + userId;
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
                return failed("更新失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("getUser")
    public Object getUser(Model model, String userId, String mode, HttpSession session, HttpServletRequest request) throws IOException {
        String url = "/users/admin/" + userId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            UserDetailModel userDetailModel = toModel(toJson(ep.getObj()), UserDetailModel.class);

            String imageOutStream = "";
            if (userDetailModel != null && !StringUtils.isEmpty(userDetailModel.getImgRemotePath())) {
                params.put("object_id", userDetailModel.getId());
                imageOutStream = HttpClientUtil.doGet(comUrl + "/files", params, username, password);
                envelop = toModel(imageOutStream, Envelop.class);
                if (envelop.getDetailModelList().size() > 0) {
                    session.removeAttribute("userImageStream");
                    session.setAttribute("userImageStream", imageOutStream == null ? "" : envelop.getDetailModelList().get(envelop.getDetailModelList().size() - 1));
                }
            }
            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "user/userInfoDialog");
            return "emptyView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("unbundling")
    @ResponseBody
    public Object unbundling(String userId, String type) {
        String getUserUrl = "/users/binding/" + userId;//解绑 todo 网关中需添加此方法
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
                return failed("更新失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("distributeKey")
    @ResponseBody
    public Object distributeKey(String loginCode, HttpServletRequest request) throws IOException {
        String getUserUrl = "/user/key";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        UsersModel user = getCurrentUserRedis(request);
        params.put("userId", user.getId());
        try {
            resultStr = HttpClientUtil.doPut(comUrl + getUserUrl, params, username, password);
            if (!StringUtils.isEmpty(resultStr)) {
                envelop.setObj(resultStr);
                envelop.setSuccessFlg(true);
            } else {
                return failed("更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
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
        params.put("existenceType", existenceType);
        params.put("existenceNm", existenceNm);

        try {
            resultStr = HttpClientUtil.doGet(comUrl + getUserUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp, HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("userImageStream");
        try {
            outputStream = response.getOutputStream();
            byte[] bytes = Base64.getDecoder().decode(fileStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(UserController.class).error(e.getMessage());
        } finally {
            if (outputStream != null) {
                outputStream.close();
            }
        }
    }

    @RequestMapping("/changePassWord")
    @ResponseBody
    public Object changePassWord(String userId, String passWord) {
        String getUserUrl = "/users/changePassWord";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("password", passWord);

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
    public Object appFeatureInitial(Model model, String userId) {
        model.addAttribute("contentPage", "user/userFeature");
        model.addAttribute("userId", userId);
        //获取用户所属角色
        Envelop envelop = new Envelop();
        String en = "";
        try {
            en = objectMapper.writeValueAsString(envelop);
            String url = "/roles/role_user/userRolesIds";
            Map<String, Object> params = new HashMap<>();
            params.put("user_id", userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            model.addAttribute("envelop", envelopStr);
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
            model.addAttribute("envelop", en);
        }
        return "simpleView";
    }


    /**
     * 选择机构部门
     *
     * @param model
     * @return
     */
    @RequestMapping("appRoleGroup")
    public String appRoleGroup(String roles, String type, Model model) {
        model.addAttribute("roles", roles);
        model.addAttribute("type", type);
        model.addAttribute("contentPage", "app/approle/appRoleGroup");
        return "emptyView";
    }

    //获取应用-用户角色组关系列表,用于查看权限
    @RequestMapping("/appRoles")
    @ResponseBody
    public Object getAppRoles(String userId) {
        //角色组类型字典：应用角色（type="0"）/用户角色（type="1"）
        //应用分类字典：平台应用（sourceType="1"）/接入应用（sourcetype="0")
        String type = "1";
        String sourceType = "1";
        try {
            String url = "/roles/app_user_roles";
            Map<String, Object> params = new HashMap<>();
            params.put("type", type);
            params.put("source_type", sourceType);
            params.put("user_id", userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ERR_SYSTEM_DES);
        }
    }

    //获取用户某个应用下的权限

    /**
     * @param roleIds 用户所属角色组ids
     * @return
     */
    @RequestMapping("/userAppFeatures")
    @ResponseBody
    public Object getUserAppFeatures(String roleIds) {
        if (StringUtils.isEmpty(roleIds)) {
            return failed("角色组ids不能为空！");
        }
        try {
            String url = "/users/user_features";
            Map<String, Object> params = new HashMap<>();
            params.put("roles_ids", roleIds);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
            envelop.getDetailModelList();
            if (envelop.isSuccessFlg() && envelop.getDetailModelList().size() > 0) {
                return getEnvelopList(envelop.getDetailModelList(), new ArrayList<>(), AppFeatureModel.class);
            }
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ERR_SYSTEM_DES);
        }
    }

    //获取所用平台应用下的角色组用于下拉框
    @RequestMapping("/appRolesList")
    @ResponseBody
    public Object getAppRolesList() {
        String roleType = "1";//用户角色类型字典值
        String appSourceType = "1";//应用类型字典值
        try {
            String url = "/roles/platformAppRolesTree";
            Map<String, Object> params = new HashMap<>();
            params.put("type", roleType);
            params.put("source_type", appSourceType);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
            envelop.getDetailModelList();
            if (envelop.isSuccessFlg() && envelop.getDetailModelList().size() > 0) {
                return getEnvelopList(envelop.getDetailModelList(), new ArrayList<>(), PlatformAppRolesTreeModel.class);
            }
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/getPatientInUserByIdCardNo")
    @ResponseBody
    public Object getUserByIdCardNo(String idCardNo) {
        String getUserUrl = "/getPatientInUserByIdCardNo";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id_card_no", idCardNo);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getUserUrl, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr, Envelop.class);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    //查看是否有权限
    @RequestMapping("/isRoleUser")
    @ResponseBody
    public boolean isRoleUser(String userId) {
        String url = "/roles/role_user/userRolesIds";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("user_id", userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
            if (envelop.isSuccessFlg() && null != envelop.getObj() && !"".equals(envelop.getObj())) {
                return true;
            }
        } catch (Exception ex) {
            LogService.getLogger(UserController.class).error(ex.getMessage());
        }
        return false;
    }

    /**
     * 通过系统设置字典获取准确的位置信息
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getDistrictByUserId")
    @ResponseBody
    public Envelop getDistrictByUserId() throws Exception {
        Integer systemSettingId = getSystemSettingId();
        if (null == systemSettingId) {
            return failed("获取系统设置信息失败");
        }
        String currentCityUrl = "/dictionaries/entries";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("filters", "dictId=" + systemSettingId + ";code=CITY");
        params.put("page", 1);
        params.put("size", 1);
        HttpResponse httpResponse = HttpUtils.doGet(comUrl + currentCityUrl, params, null);
        if (httpResponse.isSuccessFlg()) {
            Envelop envelop = objectMapper.readValue(httpResponse.getContent(), Envelop.class);
            if (envelop.isSuccessFlg() && envelop.getDetailModelList().size() > 0) {
                List<Map<String, Object>> systemDictEntryModelList = envelop.getDetailModelList();
                String cityId = systemDictEntryModelList.get(0).get("value").toString();
                String url = "/geography_entries/pid/" + cityId;
                Envelop result = new Envelop();
                HttpResponse httpResponse1 = HttpUtils.doGet(comUrl + url, null);
                if (httpResponse1.isSuccessFlg()) {
                    Envelop envelop2 = objectMapper.readValue(httpResponse1.getContent(), Envelop.class);
                    if (envelop2.isSuccessFlg()) {
                        result.setSuccessFlg(true);
                        result.setObj(envelop2.getDetailModelList());
                        return result;
                    } else {
                        return failed(envelop.getErrorMsg());
                    }
                } else {
                    failed(httpResponse1.getErrorMsg());
                }
            } else {
                return failed(envelop.getErrorMsg());
            }
        }
        return failed(httpResponse.getErrorMsg());
    }


    @RequestMapping(value = "/getOrgByUserId")
    @ResponseBody
    public Envelop getOrgByUserId() throws Exception {
        Integer systemSettingId = getSystemSettingId();
        if (null == systemSettingId) {
            return failed("获取系统设置信息失败");
        }
        String currentCityUrl = "/dictionaries/entries";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("filters", "dictId=" + systemSettingId + ";code=CITY");
        params.put("page", 1);
        params.put("size", 1);
        HttpResponse httpResponse = HttpUtils.doGet(comUrl + currentCityUrl, params, null);
        if (httpResponse.isSuccessFlg()) {
            Envelop envelop = objectMapper.readValue(httpResponse.getContent(), Envelop.class);
            if (envelop.isSuccessFlg() && envelop.getDetailModelList().size() > 0) {
                List<Map<String, Object>> systemDictEntryModelList = envelop.getDetailModelList();
                String cityId = systemDictEntryModelList.get(0).get("value").toString();
                params.clear();
                params.put("pid", cityId);
                String orgUrl = "/organizations/getOrgListByAddressPid";
                HttpResponse httpResponse1 = HttpUtils.doGet(comUrl + orgUrl, params);
                if (httpResponse1.isSuccessFlg()) {
                    Envelop envelop2 = objectMapper.readValue(httpResponse1.getContent(), Envelop.class);
                    envelop2.setObj(envelop2.getDetailModelList());
                    return envelop2;
                } else {
                    return failed(httpResponse1.getErrorMsg());
                }
            } else {
                return failed(envelop.getErrorMsg());
            }
        }
        return failed(httpResponse.getErrorMsg());
    }

    @RequestMapping("searchDictEntry")
    @ResponseBody
    public String searchDictEntryList(Long dictId, Integer page, Integer rows) {
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!org.springframework.util.StringUtils.isEmpty(dictId)) {
            stringBuffer.append("dictId=" + dictId);
        }
        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!org.springframework.util.StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);

        try {
            String url = "/dictionaries/entries";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            result = objectMapper.readValue(resultStr, Envelop.class);
            SystemDictEntryModel systemDictEntryModel = new SystemDictEntryModel();
            if (null != result.getDetailModelList() && result.getDetailModelList().size() > 0) {
                systemDictEntryModel = getEnvelopModel(result.getDetailModelList().get(0), SystemDictEntryModel.class);
            }
            return systemDictEntryModel.getCode();
        } catch (Exception ex) {
            LogService.getLogger(SystemDictEntryModel.class).error(ex.getMessage());
            return "查询字典项失败！";
        }
    }

    /**
     * 获取城市
     *
     * @param pid
     * @return
     */
    public String getAdressDictChildByParent(Integer pid) {
        String url = "/geography_entries/pid/";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("pid", pid);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url + pid, params, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            String str = "";
            if (null != envelop && envelop.getDetailModelList().size() > 0) {
                for (Object object : envelop.getDetailModelList()) {
                    str = str + ((LinkedHashMap) object).get("id").toString() + ",";
                }
                str = str.substring(0, str.length() - 1) + "";
            }
            return str;
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    public Envelop searchOrgs(String administrativeDivision) {
        Envelop envelop = new Envelop();
        try {
            //分页查询机构列表
            String url = "/organizations/combo";
            String filters = "";
            Map<String, Object> params = new HashMap<>();

            if (!org.springframework.util.StringUtils.isEmpty(administrativeDivision)) {
                filters += "administrativeDivision=" + administrativeDivision + ";";
            }
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "-createDate");
            params.put("size", 999);
            params.put("page", 1);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = objectMapper.readValue(resultStr, Envelop.class);
            envelop.setCurrPage(0);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 用户-关联机构（某个区域下的机构）
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/AddressDictByPid")
    @ResponseBody
    public Envelop AddressDictByPid(Integer cityPid) throws Exception {
        String url = "/geography_entries/pid/" + cityPid;
        HttpResponse httpResponse = HttpUtils.doGet(comUrl + url, null);
        if (httpResponse.isSuccessFlg()) {
            Envelop envelop = objectMapper.readValue(httpResponse.getContent(), Envelop.class);
            return envelop;
        } else {
            return failed(httpResponse.getErrorMsg());
        }
    }

}
