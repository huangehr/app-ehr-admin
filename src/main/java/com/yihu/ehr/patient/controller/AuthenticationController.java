package com.yihu.ehr.patient.controller;

import com.yihu.ehr.agModel.patient.AuthenticationModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateTimeUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by yww on 2016/6/21.
 */
@Controller
@RequestMapping("/authentication")
public class AuthenticationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    //主页面初始化
    @RequestMapping("/initial")
    public String authenticationInitial(Model model,String backParams){
        model.addAttribute("contentPage","patient/authentication/authentication");
        model.addAttribute("backParams",StringUtils.isEmpty(backParams)?"{}":backParams);
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String authenticationInfoInitial(Model model,String id,String dataModel){
        model.addAttribute("contentPage","patient/authentication/authenticationInfo");
        model.addAttribute("id",id);
        model.addAttribute("dataModel",dataModel);
        Envelop envelop = new Envelop();
        String en = "";
        try{
            en = objectMapper.writeValueAsString(envelop);
            String url ="/patient/Authentication/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            model.addAttribute("envelop",envelopStr);
            Map<String,Object> params = new HashMap<>();
            params.put("object_id",id);
//            params.put("mime","patient");
            String envelopStrImgPath = HttpClientUtil.doGet(comUrl+"/files_path",params,username,password);
            model.addAttribute("imgPath",envelopStrImgPath);
        }catch (Exception ex){
            LogService.getLogger(AuthenticationController.class).error(ex.getMessage());
            model.addAttribute("envelop",en);
            model.addAttribute("imgPath",en);
        }
        return "pageView";
    }

    //分页查询
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String startTime,String endTime,String status,String name,int page,int rows){
        Envelop envelop = new Envelop();
        String filters = "";
        try{
            if(!StringUtils.isEmpty(startTime)){
                filters += "applyDate>"+changeToUtc(startTime)+";";
            }
            if(!StringUtils.isEmpty(endTime)){
                filters += "applyDate<"+changeToUtc(endTime)+";";
            }
            if(!StringUtils.isEmpty(name)){
                filters += "name?"+name+";";
            }
            if(!StringUtils.isEmpty(status)){
                filters += "status?"+status+";";
            }
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","+applyDate");
            params.put("page",page);
            params.put("size",rows);
            String url = "/patient/authentications";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
    //认证状态修改
    @RequestMapping("/updateStatus")
    @ResponseBody
    public Object updateStatus(String id,String status,HttpServletRequest request){
        Envelop envelop = new Envelop();
        try{
            UsersModel userDetailModel = getCurrentUserRedis(request);
            String urlGet = "/patient/Authentication/"+id;
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,username,password);
            envelop = getEnvelop(envelopStrGet);
            if(envelop.isSuccessFlg()){
                AuthenticationModel modelUpdate = getEnvelopModel(envelop.getObj(), AuthenticationModel.class);
                modelUpdate.setAuditor(userDetailModel.getId());
                modelUpdate.setAuditDate(DateTimeUtil.utcDateTimeFormat(new Date()));
                modelUpdate.setApplyDate(changeToUtc(modelUpdate.getApplyDate()));
                modelUpdate.setStatus(status);
                String url = "/patient/authentications";
                Map<String,Object> params = new HashMap<>();
                params.put("model",objectMapper.writeValueAsString(modelUpdate));
                return HttpClientUtil.doPut(comUrl + url, params,username,password);
            }
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    @RequestMapping("/showImage")
    @ResponseBody
    public void showImage(String timestamp,String imgPath,HttpServletResponse response) throws Exception {
        OutputStream outputStream = null;
        try {
            Map<String,Object> params = new HashMap<>();
            params.put("storagePath",imgPath);
            String imageOutStream = HttpClientUtil.doGet(comUrl + "/image_view",params,username, password);
            response.setContentType("text/html; charset=UTF-8");
            response.setContentType("image/jpeg");
            outputStream = response.getOutputStream();
            byte[] bytes = Base64.getDecoder().decode(imageOutStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(PatientController.class).error(e.getMessage());
        } finally {
            if (outputStream != null) {
                outputStream.close();
            }
        }
    }


    //yyyy-MM-dd HH:mm:ss 转换为yyyy-MM-dd'T'HH:mm:ss'Z 格式
    public String changeToUtc(String datetime) throws Exception{
        Date date = DateTimeUtil.simpleDateTimeParse(datetime);
        return DateTimeUtil.utcDateTimeFormat(date);
    }
}
