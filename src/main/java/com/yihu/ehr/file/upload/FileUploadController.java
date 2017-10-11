package com.yihu.ehr.file.upload;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.FileUploadUtil;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
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
     * 上传文件，返回文件存储路径
     */
    @RequestMapping("upload")
    @ResponseBody
    public Object upload(String name, HttpServletRequest request) {
        try {
            Envelop result = new Envelop();

            Map<String, Object> uploadFileParams = FileUploadUtil.getParams(request.getInputStream(), name);
            String storagePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

            result.setSuccessFlg(true);
            result.setObj(storagePath);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("上传文件发生异常");
        }
    }

}
