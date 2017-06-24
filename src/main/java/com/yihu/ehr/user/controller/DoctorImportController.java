package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.user.DoctorDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.user.controller.service.DoctorService;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.DoctorMsgModelReader;
import com.yihu.ehr.util.excel.read.DoctorMsgModelWriter;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by yeshijie on 2017/2/13.
 */
@Controller
@RequestMapping("/doctorImport")
public class DoctorImportController extends ExtendController<DoctorService> {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    static final String parentFile = "doctor";

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
           writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new DoctorMsgModelReader();
            excelReader.read(file.getInputStream());
            List<DoctorMsgModel> errorLs = excelReader.getErrorLs();
            List<DoctorMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取医生表里面的手机号码
            Set<String> phones = findExistPhoneInDoctor(toJson(excelReader.getRepeat().get("phone")));
            //获取账户表里面的手机号码
            Set<String> userPhones = findExistPhoneInUser(toJson(excelReader.getRepeat().get("phone")));
            //获取医生表里面的邮箱
            Set<String> emails = findExistEmailInDoctor(toJson(excelReader.getRepeat().get("email")));
            //获取账户表里面的邮箱
            Set<String> userEmails = findExistEmailInUser(toJson(excelReader.getRepeat().get("email")));


            writerResponse(response, 35+"", "l_upd_progress");
            DoctorMsgModel model;
            for(int i=0; i<correctLs.size(); i++){
                model = correctLs.get(i);
                //, Set<String> emails, Set<String> userEmails
                if(validate(model, phones,userPhones,emails,userEmails)==0)
                    errorLs.add(model);
                else
                    saveLs.add(model);
            }
            for(int i=0; i<errorLs.size(); i++){
                model = errorLs.get(i);
                validate(model, phones, userPhones,emails,userEmails);
            }
            writerResponse(response, 55+"", "l_upd_progress");
            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
                ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)),errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                writerResponse(response, 75 + "", "l_upd_progress");
            }
            if(saveLs.size()>0)
                saveMeta(toJson(saveLs));

            if(rs.size()>0)
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            else
                writerResponse(response, 100 + "", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result){
        try {
//            model.addAttribute("domainData", service.searchSysDictEntries(31));
//            model.addAttribute("columnTypeData", service.searchSysDictEntries(30));
//            model.addAttribute("ynData", service.searchSysDictEntries(18));
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("files", result);
        model.addAttribute("contentPage", "/user/doctor/impGrid");
        return "pageView";
    }

    @RequestMapping("/importLs")
    @ResponseBody
    public Object importLs(int page, int rows, String filenName, String datePath){
        try{
            File file = new File( TemPath.getFullPath(datePath + TemPath.separator + filenName, parentFile) );
            List ls = (List) ObjectFileRW.read(file);

            int start = (page-1) * rows;
            int total = ls.size();
            int end = start + rows;
            end = end > total ? total : end;

            List g = new ArrayList<>();
            for(int i=start; i<end; i++){
                g.add( ls.get(i) );
            }

            Envelop envelop = new Envelop();
            envelop.setDetailModelList(g);
            envelop.setTotalCount(total);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    protected void writerResponse(HttpServletResponse response, String body, String client_method) throws IOException {
        StringBuffer sb = new StringBuffer();
        sb.append("<script type=\"text/javascript\">//<![CDATA[\n");
        sb.append("     parent.").append(client_method).append("(").append(body).append(");\n");
        sb.append("//]]></script>");

        response.setContentType("text/html;charset=UTF-8");
        response.addHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
        response.setHeader("Cache-Control", "pre-check=0,post-check=0");
        response.setDateHeader("Expires", 0);
        response.getWriter().write(sb.toString());
        response.flushBuffer();
    }
    //根据电话号码在doctor表获取数据
    private Set<String> findExistPhoneInDoctor(String phones) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("phones", phones);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/doctor/phone/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }
    //根据电话号码在user表获取数据
    private Set<String> findExistPhoneInUser(String phones) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("phones", phones);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/user/phone/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }


    private int validate(DoctorMsgModel model, Set<String> phones, Set<String> userPhones, Set<String> emails, Set<String> userEmails){
        int rs = 1;
        //医生表
        if(phones.contains(model.getPhone())){
            model.addErrorMsg("phone", "该电话号码在医生表已存在，请核对！");
            rs = 0;
        }
        //账户表
        if(userPhones.contains(model.getPhone())){
            model.addErrorMsg("phone", "该电话号码对应的账户已存在，请核对！");
            rs = 0;
        }
        //医生表
        if(emails.contains(model.getEmail())){
            model.addErrorMsg("email", "该邮箱在医生表已存在，请核对！");
            rs = 0;
        }
        //账户表
        if(userEmails.contains(model.getEmail())){
            model.addErrorMsg("email", "该邮箱对应的账户已存在，请核对！");
            rs = 0;
        }
        //账户表
        if(model.getIntroduction().length()>256){
            model.addErrorMsg("introduction", "该简介过长，请核对！");
            rs = 0;
        }

        return rs;
    }

    private List saveMeta(String doctors) throws Exception {
        Map map = new HashMap<>();
        map.put("doctors", doctors);
        EnvelopExt<DoctorMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/doctor/batch", map), DoctorMsgModel.class);
        if(envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }

    public EnvelopExt getEnvelopExt(String json, Class entity){
        try {
            return objectMapper.readValue(json, service.initExtTypeReference(entity));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath,  HttpServletResponse response) throws IOException {

        OutputStream toClient = response.getOutputStream();
        try{
            f = datePath + TemPath.separator + f;
            File file = new File( TemPath.getFullPath(f, parentFile) );
            response.reset();
            response.setContentType("octets/stream");
            response.addHeader("Content-Disposition", "attachment; filename="
                    + new String((f.substring(0, f.length()-4)+".xls").getBytes("gb2312"), "ISO8859-1"));

//            toClient = new BufferedOutputStream(response.getOutputStream());
            new DoctorMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
//            if(toClient!=null) toClient.close();
        }
    }

    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String doctors, String eFile, String tFile, String datePath){

        try{
            eFile = datePath + TemPath.separator + eFile;
            File file = new File(TemPath.getFullPath(eFile, parentFile));
            List<DoctorMsgModel> all = (List<DoctorMsgModel>) ObjectFileRW.read(file);
            List<DoctorMsgModel> doctorMsgModels = objectMapper.readValue(doctors, new TypeReference<List<DoctorMsgModel>>() {});


            Map<String, Set> repeat = new HashMap<>();
            repeat.put("phone", new HashSet<String>());
            repeat.put("code", new HashSet<String>());
            repeat.put("email", new HashSet<String>());
            for(DoctorMsgModel model : doctorMsgModels){
                model.validate(repeat);
            }
            //获取医生表里面的手机号码
            Set<String> phones = findExistPhoneInDoctor(toJson(repeat.get("phone")));
            //获取账户表里面的手机号码
            Set<String> userPhones = findExistPhoneInUser(toJson(repeat.get("phone")));
            //获取医生表里面的邮箱
            Set<String> emails = findExistEmailInDoctor(toJson(repeat.get("email")));
            //获取账户表里面的邮箱
            Set<String> userEmails = findExistEmailInUser(toJson(repeat.get("email")));
//            Set<String> existIds = findExistId(toJson(repeat.get("id")));
//            String domains = getSysDictEntries(31);
//            String columnTypes = getSysDictEntries(30);
//            String nullAbles = "[0,1]";

            DoctorMsgModel model;
            List saveLs = new ArrayList<>();
            for(int i=0; i<doctorMsgModels.size(); i++){
                model = doctorMsgModels.get(i);
                if(validate(model, phones, userPhones,emails,userEmails)==0|| model.errorMsg.size()>0) {
                    all.set(all.indexOf(model), model);
                }else{
                    saveLs.add(model);
                    all.remove(model);
                }

            }
            saveMeta(toJson(saveLs));
            ObjectFileRW.write(file, all);

            return success("");
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
    @RequestMapping("/doctorIsExistence")
    @ResponseBody
    public Object doctorIsExistence(String filters){
        try {
            Map map = new HashMap<>();
            map.put("filters", filters);
            String resultStr = "";
            resultStr = HttpClientUtil.doGet(comUrl + "/doctor/onePhone/existence", map, username, password);
            return resultStr;
//            doctorIsExistenceUrl = "/doctor/onePhone/existence"; //存在
//            userIsExistenceUrl = "/user/onePhone/existence"; //存在
//            return service.doctorIsExistence(map);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
    @RequestMapping("/userIsExistence")
    @ResponseBody
    public Object userIsExistence(String filters){
        try {
            Map map = new HashMap<>();
            map.put("filters", filters);
            String resultStr = "";
            resultStr = HttpClientUtil.doGet(comUrl + "/user/onePhone/existence", map, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    //根据邮箱在doctor表获取数据
    private Set<String> findExistEmailInDoctor(String emails) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("emails", emails);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/doctor/email/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }
    //根据邮箱在user表获取数据
    private Set<String> findExistEmailInUser(String emails) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("emails", emails);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/user/email/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }


}
