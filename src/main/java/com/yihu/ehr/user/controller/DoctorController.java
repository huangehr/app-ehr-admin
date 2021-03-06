package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.user.DoctorDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.service.GetInfoService;
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
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yeshijie on 2017/2/13.
 */
@Controller
@RequestMapping("/doctor")
public class DoctorController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private GetInfoService getInfoService;

    /**
     * 医生列表页
     *
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/user/doctor/doctor");
        return "pageView";
    }

    /**
     * 新增页面
     *
     * @param model
     * @return
     */
    @RequestMapping("addDoctorInfoDialog")
    public String addUser(Model model) {
        model.addAttribute("contentPage", "user/doctor/addDoctorInfoDialog");
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
        model.addAttribute("contentPage", "user/doctor/selectOrgDept");
        return "emptyView";
    }

    /**
     * 查找医生
     *
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchDoctor")
    @ResponseBody
    public Object searchDoctor(String searchNm, int page, int rows, HttpServletRequest request) {
        String url = "/doctors";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("name?" + searchNm + ";");
        }

        try {
            List<String> userOrgList = getUserOrgSaasListRedis(request);
            if (null != userOrgList && userOrgList.size() > 0 && AuthorityKey.NoUserOrgSaas.equalsIgnoreCase(userOrgList.get(0))) {
                UsersModel user = (UsersModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
                if (null == user) {
                    result.setSuccessFlg(true);
                    return result;
                }
                Map<String, Object> userParam = new HashMap<>();
                userParam.put("login_code", user.getLoginCode());
                String userInfo = HttpClientUtil.doGet(comUrl + "/users/" + user.getLoginCode(), userParam);
                Envelop envelop = (Envelop) this.objectMapper.readValue(userInfo, Envelop.class);
                String ex = this.objectMapper.writeValueAsString(envelop.getObj());
                UserDetailModel userDetailModel = this.objectMapper.readValue(ex, UserDetailModel.class);
                stringBuffer.append("idCardNo=" + userDetailModel.getIdCardNo() + ";");
            } else if (null != userOrgList && userOrgList.size() > 0) {
                String orgCode = String.join(",", userOrgList);
                params.put("orgCode", orgCode);
            }
            String filters = stringBuffer.toString();
            if (!StringUtils.isEmpty(filters)) {
                params.put("filters", filters);
            }
            params.put("sorts", "-insertTime");
            params.put("page", page);
            params.put("size", rows);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 验证code是否存在
     *
     * @param existenceType
     * @param existenceNm
     * @return
     */
    @RequestMapping("/existence")
    @ResponseBody
    public Object searchUser(String existenceType, String existenceNm) {
        String url = "/doctor/existence";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("existenceType", existenceType);
        params.put("existenceNm", existenceNm);

        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    /**
     * 新增修改
     *
     * @param doctorModelJsonData
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateDoctor")
    @ResponseBody
    public Object updateDoctor(String doctorModelJsonData, String jsonModel, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String url = "/doctor/";
        String resultStr = "";
        String imageId = "";
        Envelop result = new Envelop();
        ObjectMapper mapper = new ObjectMapper();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        //% 在URL中是特殊字符，需要特殊转义一下
        doctorModelJsonData = doctorModelJsonData.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
        String[] strings = URLDecoder.decode(doctorModelJsonData, "UTF-8").split(";");

        jsonModel = URLDecoder.decode(jsonModel, "UTF-8");
        DoctorDetailModel doctorDetailModel = toModel(strings[0], DoctorDetailModel.class);
        RestTemplates templates = new RestTemplates();

        request.setCharacterEncoding("UTF-8");
        InputStream inputStream = request.getInputStream();
        String imageName = request.getParameter("name");

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

            if (!StringUtils.isEmpty(doctorDetailModel.getId())) {
                Long doctorId = doctorDetailModel.getId();
                resultStr = templates.doGet(comUrl + "/doctors/admin/" + doctorId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    DoctorDetailModel updateDoctor = getEnvelopModel(envelop.getObj(), DoctorDetailModel.class);

                    updateDoctor.setName(doctorDetailModel.getName());
                    updateDoctor.setSex(doctorDetailModel.getSex());
                    updateDoctor.setSkill(doctorDetailModel.getSkill());
                    updateDoctor.setWorkPortal(doctorDetailModel.getWorkPortal());
                    updateDoctor.setEmail(doctorDetailModel.getEmail());
                    updateDoctor.setPhone(doctorDetailModel.getPhone());
                    updateDoctor.setSecondPhone(doctorDetailModel.getSecondPhone());
                    updateDoctor.setFamilyTel(doctorDetailModel.getFamilyTel());
                    updateDoctor.setOfficeTel(doctorDetailModel.getOfficeTel());
                    updateDoctor.setIntroduction(doctorDetailModel.getIntroduction());
                    updateDoctor.setJxzc(doctorDetailModel.getJxzc());
                    updateDoctor.setLczc(doctorDetailModel.getLczc());
                    updateDoctor.setXlzc(doctorDetailModel.getXlzc());
                    updateDoctor.setXzzc(doctorDetailModel.getXzzc());
                    updateDoctor.setIdCardNo(doctorDetailModel.getIdCardNo());
                    updateDoctor.setRoleType(doctorDetailModel.getRoleType());
                    updateDoctor.setJobType(doctorDetailModel.getJobType());
                    updateDoctor.setJobLevel(doctorDetailModel.getJobLevel());
                    updateDoctor.setJobScope(doctorDetailModel.getJobScope());
                    updateDoctor.setJobState(doctorDetailModel.getJobState());
                    updateDoctor.setRegisterFlag(doctorDetailModel.getRegisterFlag());
                    if (!StringUtils.isEmpty(restStream)) {
                        imageId = fileUpload(String.valueOf(doctorId), restStream, imageName);
                        updateDoctor.setPhoto(imageId);
                    }

                    params.add("doctor_json_data", toJson(updateDoctor));
                    params.add("model", jsonModel);
                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                params.add("doctor_json_data", toJson(doctorDetailModel));
                params.add("model", jsonModel);
                resultStr = templates.doPost(comUrl + url, params);
                result = toModel(resultStr, Envelop.class);
                if (result.isSuccessFlg()) {
                    DoctorDetailModel doctorModel = toModel(toJson(result.getObj()), DoctorDetailModel.class);
                    if (!StringUtils.isEmpty(restStream)) {
                        imageId = fileUpload(String.valueOf(doctorModel.getId()), restStream, imageName);
                    }
                    if (!StringUtils.isEmpty(imageId)) {
                        doctorModel.setPhoto(imageId);
                        params.remove("doctor_json_data");
                        params.add("doctor_json_data", toJson(doctorModel));
                        params.add("model", jsonModel);
                        resultStr = templates.doPut(comUrl + url, params);
                    }
                } else {
                    return failed(result.getErrorMsg());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.setSuccessFlg(false);
            result.setErrorMsg(e.getMessage());
            return result;
        }
        return resultStr;
    }

    /**
     * 删除医生
     *
     * @param doctorId
     * @return
     */
    @RequestMapping("deleteDoctor")
    @ResponseBody
    public Object deleteDoctor(Long doctorId) {
        String url = "/doctors/admin/" + doctorId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("doctorId", doctorId);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("删除失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 根据id获取医生
     *
     * @param model
     * @param doctorId
     * @param mode
     * @param session
     * @return
     * @throws IOException
     */
    @RequestMapping("getDoctor")
    public Object getDoctor(Model model, Long doctorId, String mode, HttpSession session) throws IOException {
        String url = "/doctors/admin/" + doctorId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("doctorId", doctorId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            Envelop ep = getEnvelop(resultStr);
            DoctorDetailModel detailModel = toModel(toJson(ep.getObj()), DoctorDetailModel.class);

            String imageOutStream = "";
            if (!StringUtils.isEmpty(detailModel.getPhoto())) {

                params.put("object_id", detailModel.getId());
                imageOutStream = HttpClientUtil.doGet(comUrl + "/files", params, username, password);
                envelop = toModel(imageOutStream, Envelop.class);

                if (envelop.getDetailModelList().size() > 0) {
                    session.removeAttribute("doctorImageStream");
                    session.setAttribute("doctorImageStream", imageOutStream == null ? "" : envelop.getDetailModelList().get(envelop.getDetailModelList().size() - 1));
                }
            }

            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "user/doctor/doctorInfoDialog");
            return "emptyView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("updDoctorStatus")
    @ResponseBody
    public Object updDoctorStatus(Long doctorId, String status) {
        String url = "/doctors/admin/" + doctorId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("status", status);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("更新失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    /**
     * 显示图片
     *
     * @param timestamp
     * @param session
     * @param response
     * @throws Exception
     */
    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp, HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("doctorImageStream");

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

    /**
     * 图片上传
     *
     * @param doctorId
     * @param inputStream
     * @param fileName
     * @return
     */
    public String fileUpload(String doctorId, String inputStream, String fileName) {

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String fileId = null;
        if (!StringUtils.isEmpty(inputStream)) {

            FileResourceModel fileResourceModel = new FileResourceModel(doctorId, "doctor", "");
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

    @RequestMapping(value = "/getOrgDeptsDate", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object getOrgDeptByOrgId(String orgId) {
        String url = "/org/getOrgDeptsDate";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> param = new HashMap<>();
        param.put("orgId", orgId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, param, username, password);
            List<Object> data = toModel(resultStr, Envelop.class).getDetailModelList();
            return toJson(data);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping(value = "/getOrgDeptInfoList", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object getOrgDeptInfoList(String idCardNo) {
        String url = "/org/userId/getOrgDeptInfoList";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> param = new HashMap<>();
        param.put("idCardNo", idCardNo);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, param, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
