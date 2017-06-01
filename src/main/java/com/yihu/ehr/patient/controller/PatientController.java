package com.yihu.ehr.patient.controller;

import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.patient.PatientDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.web.RestTemplates;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang.ArrayUtils;
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
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zqb on 2015/8/14.
 */
@Controller
@RequestMapping("/patient")
public class PatientController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    public PatientController() {
    }

    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/patient/patient");
        return "pageView";
    }

    @RequestMapping("patientDialogType")
    public Object patientDialogType(String idCardNo, String patientDialogType, Model model,HttpSession session) throws IOException {
        String url = "";
        String resultStr = "";
        Envelop result = new Envelop();
        RestTemplates templates = new RestTemplates();
        Map<String,Object> params = new HashMap<>();
        try {
            if (patientDialogType.equals("addPatient")) {
                PatientDetailModel patientDetailModel = new PatientDetailModel();
                result.setObj(patientDetailModel);
                model.addAttribute("patientModel", toJson(result));
                model.addAttribute("patientDialogType", patientDialogType);
                model.addAttribute("contentPage", "patient/patientInfoDialog");
//                return "generalView";
                return "simpleView";
            } else {
                url = "/populations/";
                //todo 该controller的download方法放后台处理
                resultStr = templates.doGet(comUrl + url + idCardNo);
                Envelop envelop = getEnvelop(resultStr);

                PatientDetailModel patientDetailModel = toModel(toJson(envelop.getObj()),PatientDetailModel.class);

                String imageOutStream = "";
                if (!StringUtils.isEmpty(patientDetailModel.getIdCardNo())) {

                    params.put("object_id",patientDetailModel.getIdCardNo());
                    imageOutStream = HttpClientUtil.doGet(comUrl + "/files",params,username, password);
                    result = toModel(imageOutStream,Envelop.class);

                    if (result.getDetailModelList().size()>0){
                        session.setAttribute("patientImageStream",result.getDetailModelList().get(result.getDetailModelList().size()-1));
                    }
                }

                model.addAttribute("patientDialogType", patientDialogType);
                if (envelop.isSuccessFlg()) {
                    model.addAttribute("patientModel", resultStr);
                    if (patientDialogType.equals("updatePatient")) {
                        model.addAttribute("contentPage", "patient/patientInfoDialog");
                        //return "generalView";
                        return "simpleView";
                    } else if (patientDialogType.equals("patientInfoMessage")) {
                        model.addAttribute("contentPage", "patient/patientBasicInfoDialog");
                        return "simpleView";
                    }
                } else {
                    return envelop.getErrorMsg();
                }
                return "";
            }

        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("searchPatient")
    @ResponseBody
    public Object searchPatient(String searchNm, String province, String city, String district, int page, int rows) {
        String url = "/populations";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm.trim());
        params.put("page", page);
        params.put("rows", rows);
        params.put("home_province", province);
        params.put("home_city", city);
        params.put("home_district", district);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("deletePatient")
    @ResponseBody
    /* 删除病人信息 requestBody格式:
    * "idCardNo":""  //身份证号
    */
    public Object deletePatient(String idCardNo) {
        String url = "/populations/" + idCardNo;
        String resultStr = "";
        Envelop result = new Envelop();
        try {
            RestTemplates restTemplates = new RestTemplates();
            resultStr = restTemplates.doDelete(comUrl + url);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 检查身份证是否已经存在
     */
    @RequestMapping("checkIdCardNo")
    @ResponseBody
    public Object checkIdCardNo(String searchNm) {
        String url = "/populations/is_exist/" + searchNm;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id_card_no", searchNm);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping(value = "updatePatient")
    @ResponseBody
    //注册或更新病人信息Header("Content-type: text/html; charset=UTF-8")
    public Object updatePatient(String patientJsonData, String patientDialogType,HttpServletRequest request, HttpServletResponse response) {

        try {

            String url = "/populations";
            String resultStr = "";
            String imageId = "";
            Envelop result = new Envelop();
            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            String[] strings = URLDecoder.decode(patientJsonData, "UTF-8").split(";");
            PatientDetailModel patientDetailModel = toModel(strings[0], PatientDetailModel.class);
            RestTemplates templates = new RestTemplates();

            request.setCharacterEncoding("UTF-8");
            InputStream inputStream = request.getInputStream();
            String imageName = request.getParameter("name");

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
            String imageStream = URLEncoder.encode(restStream, "UTF-8");

//            params.add("inputStream", imageStream);
//            params.add("imageName", imageName);
            if (strings[1].equals("updatePatient")) {
                String idCardNo = patientDetailModel.getIdCardNo();
                resultStr = templates.doGet(comUrl + url + '/' + idCardNo);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    PatientDetailModel updatePatient = getEnvelopModel(envelop.getObj(), PatientDetailModel.class);
                    //todo:姓名、身份证号能否修改
                    updatePatient.setName(patientDetailModel.getName());
                    updatePatient.setIdCardNo(patientDetailModel.getIdCardNo());
                    updatePatient.setGender(patientDetailModel.getGender());
                    updatePatient.setNation(patientDetailModel.getNation());
                    updatePatient.setNativePlace(patientDetailModel.getNativePlace());
                    updatePatient.setMartialStatus(patientDetailModel.getMartialStatus());
                    updatePatient.setBirthday(patientDetailModel.getBirthday());
                    if(!StringUtils.isEmpty(patientDetailModel.getBirthday())){
                        updatePatient.setBirthday(patientDetailModel.getBirthday()+" 00:00:00");
                    }
                    updatePatient.setBirthPlaceInfo(patientDetailModel.getBirthPlaceInfo());
                    updatePatient.setHomeAddressInfo(patientDetailModel.getHomeAddressInfo());
                    updatePatient.setWorkAddressInfo(patientDetailModel.getWorkAddressInfo());
                    updatePatient.setResidenceType(patientDetailModel.getResidenceType());
                    updatePatient.setLocalPath("");

                    imageId = fileUpload(updatePatient.getIdCardNo(),restStream,imageName);
                    if (!StringUtils.isEmpty(imageId))
                        updatePatient.setPicPath(imageId);

                    //联系电话
                    Map<String, String> telphoneNo = null;
                    String tag = "联系电话";
                    telphoneNo = toModel(updatePatient.getTelephoneNo(), Map.class);
                    if (telphoneNo != null) {
                        if (telphoneNo.containsKey(tag)) {
                            telphoneNo.remove(tag);
                        }
                    } else {
                        telphoneNo = new HashMap<String, String>();
                    }
                    telphoneNo.put(tag, patientDetailModel.getTelephoneNo());
                    updatePatient.setTelephoneNo(toJson(telphoneNo));
                    updatePatient.setEmail(patientDetailModel.getEmail());

                    params.add("patient_model_json_data", toJson(updatePatient));
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else if (strings[1].equals("addPatient")) {
                //联系电话
                Map<String, String> telphoneNo = new HashMap<String, String>();
                String tag = "联系电话";
                telphoneNo.put(tag, patientDetailModel.getTelephoneNo());
                patientDetailModel.setTelephoneNo(toJson(telphoneNo));
                if(!StringUtils.isEmpty(patientDetailModel.getBirthday())){
                    patientDetailModel.setBirthday(patientDetailModel.getBirthday()+" 00:00:00");
                }
                imageId = fileUpload(patientDetailModel.getIdCardNo(),restStream,imageName);
                if (!StringUtils.isEmpty(imageId)) {
                    patientDetailModel.setPicPath(imageId);
                }

                params.add("patientModelJsonData", toJson(patientDetailModel));
            }
            try {

                if (strings[1].equals("updatePatient")) {

                    resultStr = templates.doPost(comUrl + "/population", params);

                } else if (strings[1].equals("addPatient")) {

                    resultStr = templates.doPost(comUrl + url, params);

                }
                result.setSuccessFlg(getEnvelop(resultStr).isSuccessFlg());
                return result;
            } catch (Exception e) {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SystemError.toString());
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }


    public String fileUpload(String patientId,String inputStream,String fileName){

        RestTemplates templates = new RestTemplates();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();

        String fileId = null;
        if (!StringUtils.isEmpty(inputStream)) {

            FileResourceModel fileResourceModel = new FileResourceModel(patientId,"patient","");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.add("file_str",inputStream);
            params.add("file_name",fileName);
            params.add("json_data",fileResourceModelJsonData);

            fileId = templates.doPost(comUrl + "/files",params);

        }

        return fileId;

    }

    @RequestMapping("resetPass")
    @ResponseBody
    public Object resetPass(String idCardNo) {
        String url = "/populations/password/";
        String resultStr = "";
        Envelop result = new Envelop();
        try {
            RestTemplates templates = new RestTemplates();
            resultStr = templates.doPut(comUrl + url + idCardNo, null);
            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 注：因直接访问文件路径，无法显示文件信息
     * 将文件路径解析成字节流，通过字节流的方式读取文件
     *
     * @param session
     * @param response
     * @param localImgPath 文件路径
     * @throws Exception
     */
    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp,HttpSession session, HttpServletResponse response, String localImgPath) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        FileInputStream fis = null;
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("patientImageStream");
//        String imageStream = URLDecoder.decode(fileStream,"UTF-8");

        try {
            outputStream = response.getOutputStream();
//            File file = new File(localImgPath);
//            if (!file.exists()) {
//                LogService.getLogger(PatientController.class).error("人口头像不存在：" + localImgPath);
//                return;
//            }
//            fis = new FileInputStream(localImgPath);
//            int count = 0;
//            byte[] buffer = new byte[1024 * 1024];
//            while ((count = fis.read(buffer)) != -1)
//                outputStream.write(buffer, 0, count);
//            outputStream.flush();

            byte[] bytes = Base64.getDecoder().decode(fileStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(PatientController.class).error(e.getMessage());
        } finally {
            if (outputStream != null)
                outputStream.close();
            if (fis != null)
                fis.close();
        }
    }

}
