package com.yihu.ehr.esb.controller;

import com.yihu.ehr.agModel.standard.dict.DictEntryModel;
import com.yihu.ehr.agModel.standard.dict.DictModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.esb.MHosEsbMiniRelease;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import javafx.util.Pair;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.CellFormat;
import jxl.write.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by linz on 2016/5/17.
 */
@RequestMapping("/esb/hosRelease")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HosEsbMiniReleaseController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String dictInitial(Model model) {
        model.addAttribute("contentPage","/esb/release/hosEsbMiniRelease");
        return "pageView";
    }

    @RequestMapping("/releaseInfo")
    public String releaseInfo(Model model, String releaseId,String mode) {
        Map<String, Object> params = new HashMap<>();
        MHosEsbMiniRelease mHosEsbMiniRelease = new MHosEsbMiniRelease();
        Envelop result = new Envelop();
        String resultStr = "";
        //mode定义：new modify view三种模式，新增，修改，查看
        if(mode.equals("view") || mode.equals("modify")){

        }
        model.addAttribute("info",toJson(mHosEsbMiniRelease));
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/esb/release/hosEsbMiniReleaseInfoDialog");
        return "simpleView";
    }
    /**
     * 新增或更新程序包代码
     *
     * @return
     */
    @RequestMapping("saveReleaseInfo")
    @ResponseBody
    public Object saveReleaseInfo(String systemCode, String file, String versionName, String versionCode, String releaseId,HttpServletRequest request) {
        Envelop result = new Envelop();
        String resultStr = "";

        if (StringUtils.isEmpty(systemCode)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("程序包代码不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(file)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("文件路径不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(versionName)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本名称不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(versionCode)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本编号不能为空！");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        MHosEsbMiniRelease mHosEsbMiniRelease = new MHosEsbMiniRelease();
        mHosEsbMiniRelease.setId(releaseId);
        mHosEsbMiniRelease.setSystemCode(systemCode);
        mHosEsbMiniRelease.setFile(file);
        mHosEsbMiniRelease.setVersionCode(Integer.parseInt(versionCode));
        mHosEsbMiniRelease.setVersionName(versionName);
        mHosEsbMiniRelease.setReleaseTime(new Date());
        try{
            String url = "/esb/createHosEsbMiniRelease";
            resultStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return resultStr;
        }catch(Exception ex){
            LogService.getLogger(HosEsbMiniReleaseController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("deleteReleaseInfo")
    @ResponseBody
    public Object deleteReleaseInfo(String releaseInfoId) {
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<String, Object>();
        String url = "/esb/deleteHosEsbMiniRelease/"+releaseInfoId;
        try{
            HttpClientUtil.doDelete(comUrl+url,params,username,password);
            result.setSuccessFlg(true);
            return result;
        }catch(Exception ex){
            LogService.getLogger(HosEsbMiniReleaseController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


    /**
     * 根据条件查询相应的软件包
     *
     * @return
     */
    @RequestMapping("getReleaseInfoList")
    @ResponseBody
    public Object getReleaseInfoList(String systemCode,Integer page, Integer rows) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(systemCode)) {
            stringBuffer.append("systemCode?%" + systemCode + "%");
        }
        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        params.put("fields", "");
        params.put("sorts", "");
        try{
            String url = "/esb/searchHosEsbMiniReleases";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        }catch(Exception ex){
            LogService.getLogger(HosEsbMiniReleaseController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }
}
