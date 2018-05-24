package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.org.OrgModel;
import com.yihu.ehr.agModel.user.DoctorDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.organization.controller.DeptMemberController;
import com.yihu.ehr.organization.controller.OrganizationController;
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

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new DoctorMsgModelReader();
            excelReader.read(file.getInputStream());
            List<DoctorMsgModel> errorLs = excelReader.getErrorLs();
            List<DoctorMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20 + "", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取医生表里面的手机号码
            Set<String> phones = findExistPhoneInDoctor(toJson(excelReader.getRepeat().get("phone")));
            //获取医生表里面的身份证号码
            Set<String> idCardNos = findExistIdCardNoInDoctor(toJson(excelReader.getRepeat().get("idCardNo")));
            //获取账户表里面的手机号码
            Set<String> userPhones = findExistPhoneInUser(toJson(excelReader.getRepeat().get("phone")));
            //获取医生表里面的邮箱
            Set<String> emails = findExistEmailInDoctor(toJson(excelReader.getRepeat().get("email")));
            //获取账户表里面的邮箱
            Set<String> userEmails = findExistEmailInUser(toJson(excelReader.getRepeat().get("email")));
            //获取医生表里面的身份证号码
            Set<String> userIdCardNos = findExistIdCardNoInUser(toJson(excelReader.getRepeat().get("idCardNo")));
            //判断机构是否存在

            //判断机构部门是否存在

            writerResponse(response, 35 + "", "l_upd_progress");
            DoctorMsgModel model;
            for (int i = 0; i < correctLs.size(); i++) {
                model = correctLs.get(i);
                //, Set<String> emails, Set<String> userEmails
                if (validate(model, phones, userPhones, emails, userEmails, idCardNos, userIdCardNos) == 0) {
                    errorLs.add(model);
                } else {
                    saveLs.add(model);
                }
            }
            for (int i = 0; i < errorLs.size(); i++) {
                model = errorLs.get(i);
                validate(model, phones, userPhones, emails, userEmails, idCardNos, userIdCardNos);
            }
            writerResponse(response, 55 + "", "l_upd_progress");
            Map rs = new HashMap<>();
            if (errorLs.size() > 0) {
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
                ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                writerResponse(response, 75 + "", "l_upd_progress");
            }
            if (saveLs.size() > 0) {
                saveMeta(toJson(saveLs));
            }
            if (rs.size() > 0) {
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            } else {
                writerResponse(response, 100 + "", "l_upd_progress");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (e.getMessage().equals("模板不正确，请下载新的模板，并按照示例正确填写后上传！")) {
                writerResponse(response, "-2", "l_upd_progress");
            } else {
                writerResponse(response, "-1", "l_upd_progress");
            }
        }
    }

    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result) {
        model.addAttribute("files", result);
        model.addAttribute("contentPage", "/user/doctor/impGrid");
        return "pageView";
    }

    @RequestMapping("/importLs")
    @ResponseBody
    public Object importLs(int page, int rows, String filenName, String datePath) {
        try {
            File file = new File(TemPath.getFullPath(datePath + TemPath.separator + filenName, parentFile));
            List ls = (List) ObjectFileRW.read(file);

            int start = (page - 1) * rows;
            int total = ls.size();
            int end = start + rows;
            end = end > total ? total : end;

            List g = new ArrayList<>();
            for (int i = start; i < end; i++) {
                g.add(ls.get(i));
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

    @Override
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
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("phones", phones);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/doctor/phone/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }

    //根据身份证号码在doctor表获取数据
    private Set<String> findExistIdCardNoInDoctor(String idCardNos) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("idCardNos", idCardNos);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/doctor/idCardNo/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }

    //根据身份证号码在user表获取数据
    private Set<String> findExistIdCardNoInUser(String idCardNos) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("idCardNos", idCardNos);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/user/idCardNo/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }


    //根据电话号码在user表获取数据
    private Set<String> findExistPhoneInUser(String phones) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("phones", phones);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/user/phone/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }


    private int validate(DoctorMsgModel model, Set<String> phones, Set<String> userPhones, Set<String> emails, Set<String> userEmails, Set<String> idCardNos, Set<String> userIdCardNos) {
        int rs = 1;
        boolean existFlag = searchUsers(model.getIdCardNo(), model.getPhone());
        String orgId = searchOrgByCodes(model.getOrgCode(), model.getOrgFullName());
        //医生表
        if (phones.contains(model.getPhone())) {
            model.addErrorMsg("phone", "该电话号码在医生表已存在，请核对！");
            rs = 0;
        }
        //医生表
        if (idCardNos.contains(model.getIdCardNo())) {
            model.addErrorMsg("idCardNo", "该身份证号码在医生表已存在，请核对！");
            rs = 0;
        }
        if (!(model.getIdCardNo().length() == 15 || model.getIdCardNo().length() == 18)) {
            model.addErrorMsg("idCardNo", "该身份证号码格式不正确，请核对！");
            rs = 0;
        }
        //账户表
        if (userPhones.contains(model.getPhone())) {
            //账户表中存在此电话号码，但不是此人的账户，则判断为该电话号码重复。
            if (!existFlag) {
                model.addErrorMsg("phone", "该电话号码已被注册，请核对！");
                rs = 0;
            }
        }
        //账户表
        if (userIdCardNos.contains(model.getIdCardNo())) {
            //账户表中存在此电话号码，但不是此人的账户，则判断为该电话号码重复。
            if (!existFlag) {
                model.addErrorMsg("idCardNo", "该身份证号码对应的账户已存在，请核对！");
                rs = 0;
            }
        }
        //医生表
        if (emails.contains(model.getEmail())) {
            model.addErrorMsg("email", "该邮箱在医生表已存在，请核对！");
            rs = 0;
        }
        //账户表
        if (userEmails.contains(model.getEmail())) {
            model.addErrorMsg("email", "该邮箱对应的账户已存在，请核对！");
            rs = 0;
        }
        //机构不存在，报错
        if (StringUtils.isEmpty(orgId)) {
            model.addErrorMsg("orgCode", "该机构代码或机构名称不正确，请核对！");
            model.addErrorMsg("orgFullName", "该机构代码或机构名称不正确，请核对！");
            rs = 0;
        } else {
            //部门是否存在
            try {
                Map<String, Object> params = new HashMap<>();
                String urlGet = "/orgDept/checkDeptName";
                params.clear();
                params.put("orgId", orgId);
                params.put("name", model.getOrgDeptName());
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2, Envelop.class);
                if (envelopGet2.isSuccessFlg()) {
                    model.addErrorMsg("orgDeptName", "该机构部门不存在，请核对！");
                    rs = 0;
                }
            } catch (Exception ex) {
                LogService.getLogger(DoctorImportController.class).error(ex.getMessage());
            }
        }

        return rs;
    }

    private List saveMeta(String doctors) throws Exception {
        Map map = new HashMap<>();
        map.put("doctors", doctors);
        EnvelopExt<DoctorMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/doctor/batch", map), DoctorMsgModel.class);
        if (envelop.isSuccessFlg()) {
            return envelop.getDetailModelList();
        }
        throw new Exception("保存失败！");
    }

    @Override
    public EnvelopExt getEnvelopExt(String json, Class entity) {
        try {
            return objectMapper.readValue(json, service.initExtTypeReference(entity));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath, HttpServletResponse response) throws IOException {
        OutputStream toClient = response.getOutputStream();
        try {
            f = datePath + TemPath.separator + f;
            File file = new File(TemPath.getFullPath(f, parentFile));
            response.reset();
            response.setContentType("octets/stream");
            response.addHeader("Content-Disposition", "attachment; filename="
                    + new String((f.substring(0, f.length() - 4) + ".xls").getBytes("gb2312"), "ISO8859-1"));
            new DoctorMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
            if (toClient != null) {
                toClient.close();
            }
        }
    }

    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String doctors, String eFile, String tFile, String datePath) {
        if (!StringUtils.isEmpty(doctors) && !StringUtils.isEmpty(doctors.replaceAll("\\[|\\]", ""))) {
            try {
                eFile = datePath + TemPath.separator + eFile;
                File file = new File(TemPath.getFullPath(eFile, parentFile));
                List<DoctorMsgModel> all = (List<DoctorMsgModel>) ObjectFileRW.read(file);
                List<DoctorMsgModel> doctorMsgModels = objectMapper.readValue(doctors, new TypeReference<List<DoctorMsgModel>>() {
                });
                Map<String, Set> repeat = new HashMap<>();
                repeat.put("phone", new HashSet<String>());
                repeat.put("code", new HashSet<String>());
                repeat.put("email", new HashSet<String>());
                repeat.put("idCardNo", new HashSet<String>());
                for (DoctorMsgModel model : doctorMsgModels) {
                    model.validate(repeat);
                }
                //获取医生表里面的手机号码
                Set<String> phones = findExistPhoneInDoctor(toJson(repeat.get("phone")));
                //获取账户表里面的手机号码
                Set<String> userPhones = findExistPhoneInUser(toJson(repeat.get("phone")));
                //获取医生表里面的身份证号码
                Set<String> idCardNos = findExistIdCardNoInDoctor(toJson(repeat.get("idCardNo")));
                //获取医生表里面的邮箱
                Set<String> emails = findExistEmailInDoctor(toJson(repeat.get("email")));
                //获取账户表里面的邮箱
                Set<String> userEmails = findExistEmailInUser(toJson(repeat.get("email")));
                //获取医生表里面的身份证号码
                Set<String> userIdCardNos = findExistIdCardNoInUser(toJson(repeat.get("idCardNo")));
                DoctorMsgModel model;
                List saveLs = new ArrayList<>();
                for (int i = 0; i < doctorMsgModels.size(); i++) {
                    model = doctorMsgModels.get(i);
                    if (validate(model, phones, userPhones, emails, userEmails, idCardNos, userIdCardNos) == 0 || model.errorMsg.size() > 0) {
                        all.set(all.indexOf(model), model);
                    } else {
                        saveLs.add(model);
                        all.remove(model);
                    }
                }
                if (saveLs.size() > 0) {
                    saveMeta(toJson(saveLs));
                    ObjectFileRW.write(file, all);
                    return success("");
                } else {
                    ObjectFileRW.write(file, all);
                    return failed("尚有数据未验证通过！");
                }
            } catch (Exception e) {
                e.printStackTrace();
                return systemError();
            }
        } else {
            return failed("没有数据，保存失败！");
        }
    }

    @RequestMapping("/doctorIsExistence")
    @ResponseBody
    public Object doctorIsExistence(String filters) {
        try {
            Map map = new HashMap<>();
            map.put("filters", filters);
            String resultStr = "";
            resultStr = HttpClientUtil.doGet(comUrl + "/doctor/onePhone/existence", map, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/userIsExistence")
    @ResponseBody
    public Object userIsExistence(String filters) {
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

    @RequestMapping("/deptIsExistence")
    @ResponseBody
    public Object deptIsExistence(String filters) {
        try {
            String[] org = filters.split(";");
            Map map = new HashMap<>();
            String orgId = searchOrgByCodes(org[0], org[1]);
            //机构不存在，报错
            Envelop envelop = new Envelop();
            if (StringUtils.isEmpty(orgId)) {
                envelop.setSuccessFlg(false);
                envelop.setObj(false);
            } else {
                //部门是否存在
                Map<String, Object> params = new HashMap<>();
                String urlGet = "/orgDept/checkDeptName";
                params.clear();
                params.put("orgId", orgId);
                params.put("name", org[2]);
                String envelopGetStr2 = HttpClientUtil.doPut(comUrl + urlGet, params, username, password);
                Envelop envelopGet2 = objectMapper.readValue(envelopGetStr2, Envelop.class);
                if (envelopGet2.isSuccessFlg()) {
                    envelop.setSuccessFlg(true);
                }
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    /**
     * 获取机构代码下拉框-带检索(根据输入机构代码/名称近似查询）
     *
     * @param filters 控件传递参数的参数名
     */
    @RequestMapping("/orgCodeIsExistence")
    @ResponseBody
    public Object searchOrgCodes(String filters) {
        Envelop envelop = new Envelop();
        try {
            String url = "/organizations";
            Map<String, Object> params = new HashMap<>();
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "");
            params.put("page", 1);
            params.put("size", 15);
            String envelopStrFGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStrFGet, Envelop.class);
            List<OrgModel> orgModels = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            if (envelopGet.isSuccessFlg() && envelopGet.getDetailModelList().size() > 0) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(true);
                envelop.setObj(true);
                envelop.setErrorMsg("该机构代码或机构名称不正确！");
            }
            return envelop;
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return envelop;
        }
    }


    //根据邮箱在doctor表获取数据
    private Set<String> findExistEmailInDoctor(String emails) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("emails", emails);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/doctor/email/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }

    //根据邮箱在user表获取数据
    private Set<String> findExistEmailInUser(String emails) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("emails", emails);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/user/email/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }

    public boolean searchUsers(String idCardNo, String phone) {

        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(idCardNo)) {
            stringBuffer.append("idCardNo=" + idCardNo + ";");
        }
        if (!StringUtils.isEmpty(phone)) {
            stringBuffer.append("telephone=" + phone + ";");
        }
        params.put("filters", "");
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", 1);
        params.put("size", 999);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = mapper.readValue(resultStr, Envelop.class);

            if ((null != envelop.getDetailModelList() && envelop.getDetailModelList().size() > 0) || null != envelop.getObj()) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取机构
     *
     * @param orgCode 控件传递参数的参数名
     */
    @RequestMapping("/orgCodes")
    @ResponseBody
    public String searchOrgByCodes(String orgCode, String fullName) {
        Envelop envelop = new Envelop();
        String filters = "";
        StringBuffer stringBuffer = new StringBuffer();
        try {
            if (!org.apache.commons.lang.StringUtils.isEmpty(orgCode)) {
                stringBuffer.append("orgCode=" + orgCode + ";");
            }
            if (!org.apache.commons.lang.StringUtils.isEmpty(fullName)) {
                stringBuffer.append("fullName=" + fullName + ";");
            }
            filters = stringBuffer.toString();
            String url = "/organizations";
            Map<String, Object> params = new HashMap<>();
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "");
            params.put("page", 1);
            params.put("size", 999);
            String envelopStrFGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStrFGet, Envelop.class);
            List<OrgModel> orgModels = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            String orgId = "";
            if (envelopGet.isSuccessFlg()) {
                orgModels = (List<OrgModel>) getEnvelopList(envelopGet.getDetailModelList(), new ArrayList<OrgModel>(), OrgModel.class);
                for (OrgModel m : orgModels) {
                    orgId = String.valueOf(m.getId());
                }
            }
            return orgId;
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return "";
        }
    }

    /** 获取系统字典 校验
     * @param dictId
     * @return
     */
    public Object searchDictEntryListForDDL(Long dictId) {
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(dictId)) {
            stringBuffer.append("dictId=" + dictId);
        }
        params.put("filters",stringBuffer.toString());
        params.put("page", 1);
        params.put("size", 500);
        try {
            String url = "/dictionaries/entries";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
        }
        return resultStr;
    }

}
