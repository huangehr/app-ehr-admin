package com.yihu.ehr.file.upload;

import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * 文件上传
 *
 * @author 张进军
 * @date 2017/8/17 19:23
 */
@Controller
@RequestMapping("/fileUpload")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class FileUploadController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 上传文件
     */
    @RequestMapping("upload")
    @ResponseBody
    public Object upload(@RequestParam("file") MultipartFile file) {
        try {
            Envelop result = new Envelop();
            String filePath = uploadFile(file.getInputStream(), file.getOriginalFilename());
            if(!StringUtils.isEmpty(filePath)) {
                result.setSuccessFlg(true);
                result.setObj(filePath);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("请上传非空文件！");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("上传文件发生异常");
        }
    }

    /**
     * 上传文件，返回文件路径
     *
     * @param inputStream 文件流
     * @param fileName    文件名
     * @return 文件存储路径
     */
    private String uploadFile(InputStream inputStream, String fileName) throws Exception {
        int temp = 0;
        byte tempBuffer[] = new byte[1024];
        byte[] fileBuffer = new byte[0];
        while ((temp = inputStream.read(tempBuffer)) != -1) {
            fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
        }
        inputStream.close();

        String fileBase64Str = Base64.getEncoder().encodeToString(fileBuffer);
        FileResourceModel fileResourceModel = new FileResourceModel("", "org", "");

        String filePath = "";
        if(!StringUtils.isEmpty(fileBase64Str)) {
            Map<String, Object> params = new HashMap<>();
            params.put("file_str", fileBase64Str);
            params.put("file_name", fileName);
            params.put("json_data", toJson(fileResourceModel));
            filePath = HttpClientUtil.doPost(comUrl + "/filesReturnUrl", params, username, password);
        }
        return filePath;
    }

}
