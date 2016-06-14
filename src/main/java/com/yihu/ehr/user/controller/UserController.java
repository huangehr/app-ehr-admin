package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.patient.controller.PatientController;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.web.RestTemplates;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.httpclient.*;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.httpclient.util.URIUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Base64;
import java.util.Map;
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
    public Object searchUsers(String searchNm, String searchType, int page, int rows) {

        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("realName?" + searchNm + " g1;organization?" + searchNm + " g1;");
        }
        if (!StringUtils.isEmpty(searchType)) {
            stringBuffer.append("userType=" + searchType);
        }

        params.put("filters", "");
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }

        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
                userModel.setImgLocalPath("");
                if(userDetailModel.getUserType().equals("Doctor")){
                    userModel.setMajor(userDetailModel.getMajor());
                }

                String imageId = fileUpload(userModel.getId(),restStream,imageName);
//                String imageId = null;
//                if (!StringUtils.isEmpty(restStream)) {
//
//                    FileResourceModel fileResourceModel = new FileResourceModel(userModel.getId(),"user","");
//                    String fileResourceModelJsonData = objectMapper.writeValueAsString(fileResourceModel);
//
//                    MultiValueMap<String, String> params1 = new LinkedMultiValueMap<>();
//                    params1.add("file_str",restStream);
//                    params1.add("file_name",imageName);
//                    params1.add("json_data",fileResourceModelJsonData);
//
//                    imageId = templates.doPost(comUrl + "/files",params1);
//
//                }

                if (!StringUtils.isEmpty(imageId)){
                    userModel.setImgRemotePath(imageId);
                }

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
    public Object getUser(Model model, String userId, String mode, HttpSession session) throws IOException {
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
            if (!StringUtils.isEmpty(userDetailModel.getImgRemotePath())) {

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
            LogService.getLogger(PatientController.class).error(e.getMessage());
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


    public static String doPost(String url, Map<String, String> params, String charset, boolean pretty) {
        StringBuffer response = new StringBuffer();
        HttpClient client = new HttpClient();
        PostMethod method = new PostMethod(url);
        //设置Http Post数据
        if (params != null) {
            HttpMethodParams p = new HttpMethodParams();
            NameValuePair[] data = {new NameValuePair("file_str",params.get("fileName")),new NameValuePair("fileResourceModelJsonData",params.get("file_str")),new NameValuePair("file_str",params.get("file_str"))};
            // 将表单的值放入postMethod中
            method.setRequestBody(data);
        }
        try {
            client.executeMethod(method);
            if (method.getStatusCode() == HttpStatus.SC_OK) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream(), charset));
                String line;
                while ((line = reader.readLine()) != null) {
                    if (pretty)
                        response.append(line).append(System.getProperty("line.separator"));
                    else
                        response.append(line);
                }
                reader.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            method.releaseConnection();
        }
        return response.toString();
    }

}
