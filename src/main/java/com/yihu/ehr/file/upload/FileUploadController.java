package com.yihu.ehr.file.upload;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.FileUploadUtil;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

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

            Map<String, Object> uploadFileParams = FileUploadUtil.getParams(file.getInputStream(), file.getOriginalFilename());
            String filePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

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

}
