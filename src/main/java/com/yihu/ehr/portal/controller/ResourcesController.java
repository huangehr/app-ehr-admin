package com.yihu.ehr.portal.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.portal.PortalResourcesModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.user.controller.UserController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by yeshijie on 2017/2/13.
 */
@Controller
@RequestMapping("/portalResources")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ResourcesController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    File tempPathFile;

    /**
     * 列表页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/portal/resources/portalResources");
        return "pageView";
    }

    /**
     * 新增页面
     * @param model
     * @return
     */
    @RequestMapping("addResourcesInfoDialog")
    public String addResources(Model model) {
        model.addAttribute("contentPage", "portal/resources/addPortalResourcesDialog");
        return "generalView";
    }

    /**
     * 查找资源
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchPortalResources")
    @ResponseBody
    public Object searchDoctor(String searchNm, int page, int rows) {
        String url = "/portalResources";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("name=" + searchNm );
        }
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
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 新增修改
     * @param portalResourcesModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updatePortalResources", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updatePortalResources(String portalResourcesModelJsonData, HttpServletRequest request) throws IOException{

        String url = "/portalResources/";
        String resultStr = "";
        String imageId = "";
        System.out.println();
        ObjectMapper mapper = new ObjectMapper();
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(portalResourcesModelJsonData, "UTF-8").split(";");
        PortalResourcesModel detailModel = toModel(strings[0], PortalResourcesModel.class);
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

            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long portalResourcesId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/portalResources/admin/" + portalResourcesId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    PortalResourcesModel updateResources = getEnvelopModel(envelop.getObj(), PortalResourcesModel.class);

                    updateResources.setName(detailModel.getName());
                    updateResources.setVersion(detailModel.getVersion());
                    updateResources.setAndroidQrCodeUrl(detailModel.getAndroidQrCodeUrl());
                    updateResources.setIosQrCodeUrl(detailModel.getIosQrCodeUrl());
                    updateResources.setDescription(detailModel.getDescription());
                    updateResources.setUrl(detailModel.getUrl());
                    updateResources.setPakageType(detailModel.getPakageType());

                    imageId = fileUpload(String.valueOf(portalResourcesId),restStream,imageName);
                    if (!StringUtils.isEmpty(imageId))
                        updateResources.setPicUrl(imageId);

                    params.add("portalResources_json_data", toJson(updateResources));

                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setUploadUser(userDetailModel.getId());
                params.add("portalResources_json_data", toJson(detailModel));
                resultStr = templates.doPost(comUrl + url, params);
                result = toModel(resultStr,Envelop.class);
                PortalResourcesModel portalResourcesModel = toModel(toJson(result.getObj()),PortalResourcesModel.class);
                imageId = fileUpload(String.valueOf(portalResourcesModel.getId()),restStream,imageName);
                if (!StringUtils.isEmpty(imageId))
                    detailModel.setPicUrl(imageId);

                String resourcesModelData = templates.doGet(comUrl + "/portalResources/admin/"+portalResourcesModel.getId());
                result = mapper.readValue(resourcesModelData,Envelop.class);
                String resourcesModelDataJsonModel = mapper.writeValueAsString(result.getObj());
                PortalResourcesModel portalResourcesModelNew = mapper.readValue(resourcesModelDataJsonModel,PortalResourcesModel.class);
                portalResourcesModelNew.setPicUrl(imageId);

                params.remove("portalResources_json_data");
                params.add("portalResources_json_data", toJson(portalResourcesModelNew));
                resultStr = templates.doPut(comUrl + url, params);

            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }

    /**
     * 删除资源
     * @param portalResourcesId
     * @return
     */
    @RequestMapping("deletePortalResources")
    @ResponseBody
    public Object deletePortalResources(Long portalResourcesId) {
        String url = "/portalResources/admin/" + portalResourcesId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("portalResourcesId", portalResourcesId);
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

    /**
     * 根据id获取资源
     * @param model
     * @param portalResourcesId
     * @param mode
     * @return
     */
    @RequestMapping("getPortalResources")
    public Object getPortalResources(Model model, Long portalResourcesId, String mode, HttpSession session) {
        String url = "/portalResources/admin/"+portalResourcesId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("portalResourcesId", portalResourcesId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            Envelop ep = getEnvelop(resultStr);
            PortalResourcesModel detailModel = toModel(toJson(ep.getObj()),PortalResourcesModel.class);

            String imageOutStream = "";
            if (!StringUtils.isEmpty(detailModel.getPicUrl())) {

                params.put("object_id",detailModel.getId());
                imageOutStream = HttpClientUtil.doGet(comUrl + "/files",params,username, password);
                envelop = toModel(imageOutStream,Envelop.class);

                if (envelop.getDetailModelList().size()>0){
                    session.removeAttribute("portalResourcesImageStream");
                    session.setAttribute("portalResourcesImageStream",imageOutStream == null ? "" :envelop.getDetailModelList().get(envelop.getDetailModelList().size()-1));
                }
            }

            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "portal/resources/portalResourcesInfoDialog");
            return "simpleView";
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }


    /**
     * 图片上传
     * @param portalResourcesId
     * @param inputStream
     * @param fileName
     * @return
     */
    public String fileUpload(String portalResourcesId,String inputStream,String fileName){

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String fileId = null;
        if (!StringUtils.isEmpty(inputStream)) {

            //mime  参数 doctor 需要改变  --  需要从其他地方配置
            FileResourceModel fileResourceModel = new FileResourceModel(portalResourcesId,"doctor","");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data",fileResourceModelJsonData);
            try {
                fileId = HttpClientUtil.doPost(comUrl + "/files", params,username,password);
                return fileId;
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return fileId;
    }

    /**
     * 显示图片
     * @param timestamp
     * @param session
     * @param response
     * @throws Exception
     */
    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(String timestamp,HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("portalResourcesImageStream");

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
     * 资源文件上传
     * @param
     * @return
     */
    @RequestMapping("portalResourcesFileUpload")
    @ResponseBody
    public Object portalResourcesFileUpload(
            @RequestParam("apkFile") MultipartFile file) throws IOException{
        Envelop result = new Envelop();
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename(); //获取文件名
        if (!file.isEmpty()) {
            return  uploadFile(inputStream,fileName);
        }
        return "fail";
    }

    /**
     * 资源文件上传
     * @param
     * @return
     */
    @RequestMapping("portalResourcesFileUploadAndriod")
    @ResponseBody
    public Object portalResourcesFileUploadAndriod(
            @RequestParam("androidFile") MultipartFile file) throws IOException{
        Envelop result = new Envelop();
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename(); //获取文件名
        if (!file.isEmpty()) {
            return  uploadFile(inputStream,fileName);
        }
        return "fail";
    }

    /**
     * 资源文件上传
     * @param
     * @return
     */
    @RequestMapping("portalResourcesFileUploadIos")
    @ResponseBody
    public Object portalResourcesFileUploadIos(
            @RequestParam("iosFile") MultipartFile file) throws IOException{
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
            String imageId = "";
            imageId = fileUpload("",restStream,fileName);
            if (!StringUtils.isEmpty(imageId)){
                System.out.println("上传成功");
                return imageId;
            }else{
                System.out.println("上传失败");
            }

        } catch (Exception e) {
            return "fail";
        }
        return "fail";
    }

}
