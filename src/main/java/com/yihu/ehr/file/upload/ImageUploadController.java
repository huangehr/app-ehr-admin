package com.yihu.ehr.file.upload;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import net.minidev.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.*;

/**
 * Created by yww on 2016/5/13.
 */
@Controller
@RequestMapping("/file")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ImageUploadController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/upload/image")
    @ResponseBody
    public Object uploadImage(HttpServletRequest request,String mime,String objectId,String purpose){
        Envelop envelop = new Envelop();
        try {
        CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
        if (multipartResolver.isMultipart(request)) {
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
            Iterator<String> iter = multiRequest.getFileNames();
            while (iter.hasNext()) {
                MultipartFile file = multiRequest.getFile(iter.next());
                String fileBase64 =  new String(Base64.getEncoder().encode(file.getBytes()));
                Map<String, Object> params = new HashMap<>();
                JSONObject jsonData = new JSONObject();
                jsonData.put("mime",mime);
                jsonData.put("objectId",objectId);
                jsonData.put("purpose",purpose);
                params.put("file_str", fileBase64);
                params.put("file_name", file.getOriginalFilename());
                params.put("json_data", jsonData.toJSONString());
                HttpClientUtil.doPost(comUrl + "/files", params, username, password);
            }
            envelop.setSuccessFlg(true);
            return  envelop;
        }else{
            throw new RuntimeException("未检测到图片！");
        }

        }catch (IOException o){
            throw new RuntimeException("图片转换BASE64错误");
        }catch (Exception e){
            throw new RuntimeException(e.getMessage());
        }
    }

    @RequestMapping("/download/image")
    @ResponseBody
    public Object downloadImage(HttpServletRequest request,String objectId,String mime){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            String url = comUrl + "/files";
            params.put("object_id",objectId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            return envelopStr;
        }catch (Exception e){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("图片获取失败！");
            return envelop;
        }
    }

    @RequestMapping("/view/image")
    @ResponseBody
    public Object viewImage(HttpServletRequest request, String storagePath){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            storagePath = URLEncoder.encode(storagePath, "ISO8859-1");
            String url = comUrl + "/image_view";
            params.put("storagePath",storagePath);
            String envelopStr = HttpClientUtil.doGet(url,params, username, password);
            envelop.setSuccessFlg(true);
            envelop.setObj("data:image/jpeg;base64,"+envelopStr);
            return envelop;
        }catch (Exception e){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("图片获取失败！");
            return envelop;
        }
    }

    @RequestMapping("/delete/image")
    @ResponseBody
    public Object deleteImage(HttpServletRequest request, String storagePath){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            storagePath = URLEncoder.encode(storagePath, "ISO8859-1");
            String url = comUrl + "/image_delete";
            params.put("storagePath",storagePath);
            String envelopStr = HttpClientUtil.doDelete(url,params, username, password);
            envelop.setSuccessFlg(true);
            return envelop;
        }catch (Exception e){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("图片获取失败！");
            return envelop;
        }
    }



    @RequestMapping("/upload/EditorImage")
    public String uploadEditorImage(HttpServletRequest request, HttpServletResponse response,String mime,String objectId,String purpose){
        Map<String,Object> param = new HashMap<String,Object>();
        Map<String,Object> rmap = new HashMap<String,Object>();
        try {
            CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
            if (multipartResolver.isMultipart(request)) {
                MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
                Iterator<String> iter = multiRequest.getFileNames();
                while (iter.hasNext()) {
                    MultipartFile file = multiRequest.getFile(iter.next());
                    String fileBase64 =  new String(Base64.getEncoder().encode(file.getBytes()));
                    Map<String, Object> params = new HashMap<>();
                    JSONObject jsonData = new JSONObject();
                    jsonData.put("mime","editor");
                    jsonData.put("objectId",new Date().getTime());
                    jsonData.put("purpose",purpose);
                    params.put("file_str", fileBase64);
                    params.put("file_name", new Date().getTime()+file.getName());
                    params.put("json_data", jsonData.toJSONString());
                    String url = HttpClientUtil.doPost(comUrl + "/filesReturnHttpUrl", params, username, password);

                    param.put("url",url);
                    param.put("state","上传成功");
                    param.put("size",file.getSize());
                    param.put("original",file.getOriginalFilename());
                    param.put("title",file.getName());
                    param.put("type",file.getContentType());

                    rmap.put("error", 0);
                    rmap.put("url", url);
                }
                response.setContentType("text/html"); // 设置字符编码为UTF-8, 这样支持汉字显示
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();


                out.print(JSONObject.toJSONString(rmap));
            }else{
                throw new RuntimeException("未检测到图片！");
            }

        }catch (IOException o){
            throw new RuntimeException("图片转换BASE64错误");
        }catch (Exception e){
            throw new RuntimeException(e.getMessage());
        }
        return  null;
    }
}
