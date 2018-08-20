package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.agModel.org.OrgModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.organization.controller.OrganizationController;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.user.controller.model.WtDoctorMsgModel;
import com.yihu.ehr.user.controller.service.DoctorService;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.DoctorMsgModelReader;
import com.yihu.ehr.util.excel.read.DoctorMsgModelWriter;
import com.yihu.ehr.util.excel.read.WtDoctorMsgModelReader;
import com.yihu.ehr.util.excel.read.WtDoctorMsgModelWriter;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * Created by zdm on 2017/2/13.
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
    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new WtDoctorMsgModelReader();
            excelReader.read(file.getInputStream());
            List<WtDoctorMsgModel> errorLs = excelReader.getErrorLs();
            List<WtDoctorMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20 + "", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取医生表里面所有的手机号码
            Set<String> phones = findExistPhoneInDoctor(toJson(excelReader.getRepeat().get("phone")));
            //获取医生表里面所有的身份证号码
            Set<String> idCardNos = findExistIdCardNoInDoctor(toJson(excelReader.getRepeat().get("idCardNo")));
            //获取用户表里面的所有手机号码
            Set<String> userPhones = findExistPhoneInUser(toJson(excelReader.getRepeat().get("phone")));
            //获取用户表里面的所有身份证号码
            Set<String> userIdCardNos = findExistIdCardNoInUser(toJson(excelReader.getRepeat().get("idCardNo")));
            //获取组织机构代码-机构全称
            Map<String,String> orgCode_FullName = getOrgCodeAndFullName("orgCode");
            //获取组织机构代码-机构id
            Map<String,String> orgCode_id = getOrgCodeAndFullName("id");
            //获取科室代码-值
            Map<String,String> deptCode_value= getDictEntryCodeAndValueByDictId("215");

            writerResponse(response, 35 + "", "l_upd_progress");
            WtDoctorMsgModel model;
            for (int i = 0; i < correctLs.size(); i++) {
                model = correctLs.get(i);
                if (validate(model, phones, userPhones, idCardNos, userIdCardNos,orgCode_FullName) == 0) {
                    errorLs.add(model);
                } else {
                    model.setOrgId(orgCode_id.get(model.getOrgCode()));
                    model.setDept_name(deptCode_value.get(model.getSzksdm()));
                    saveLs.add(model);
                }
            }
            for (int i = 0; i < errorLs.size(); i++) {
                model = errorLs.get(i);
                validate(model, phones, userPhones, idCardNos, userIdCardNos,orgCode_FullName);
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
        if(!StringUtils.isEmpty(phones.replaceAll("[\\[\\]]", ""))){
            MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
            conditionMap.add("phones", phones);
            RestTemplates template = new RestTemplates();
            String rs = template.doPost(service.comUrl + "/doctor/phone/existence", conditionMap);
            return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
            });
        }
       return  new HashSet<>();
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
        if(!StringUtils.isEmpty(phones.replaceAll("[\\[\\]]", ""))){
            MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
            conditionMap.add("phones", phones);
            RestTemplates template = new RestTemplates();
            String rs = template.doPost(service.comUrl + "/user/phone/existence", conditionMap);
            return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
            });
        }
       return new HashSet<>();
    }


    private int validate(WtDoctorMsgModel model, Set<String> phones, Set<String> userPhones, Set<String> idCardNos, Set<String> userIdCardNos,Map<String,String> orgCode_FullName) {
        int rs = 1;
        //医生表-电话号码
        if (phones.contains(model.getPhone())) {
            model.addErrorMsg("phone", "该电话号码在医生表已存在，请核对！");
            rs = 0;
        }
        //医生表-身份证号码
        if (idCardNos.contains(model.getIdCardNo())) {
            model.addErrorMsg("idCardNo", "该身份证号码在医生表已存在，请核对！");
            rs = 0;
        }
        //用户表-电话号码
        if (userPhones.contains(model.getPhone())) {
            model.addErrorMsg("phone", "该电话号码在医生表已存在，请核对！");
            rs = 0;
        }
        //用户表-身份证号
        if (userIdCardNos.contains(model.getIdCardNo())) {
            model.addErrorMsg("idCardNo", "该身份证号码在医生表已存在，请核对！");
            rs = 0;
        }

        if (!(model.getIdCardNo().length() == 15 || model.getIdCardNo().length() == 18)) {
            model.addErrorMsg("idCardNo", "该身份证号码格式不正确，请核对！");
            rs = 0;
        }

        //机构不存在，报错

        if (null==orgCode_FullName.get(model.getOrgCode())||!orgCode_FullName.get(model.getOrgCode()).equals(model.getOrgFullName())) {
            model.addErrorMsg("orgCode", "该机构代码或机构名称不正确，请核对！");
            model.addErrorMsg("orgFullName", "该机构代码或机构名称不正确，请核对！");
            rs = 0;
        }
        return rs;
    }

    private List saveMeta(String doctors) throws Exception {
        Map map = new HashMap<>();
        map.put("doctors", doctors);
        EnvelopExt<WtDoctorMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/doctor/batch", map), WtDoctorMsgModel.class);
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
            new WtDoctorMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
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
                List<WtDoctorMsgModel> all = (List<WtDoctorMsgModel>) ObjectFileRW.read(file);
                List<WtDoctorMsgModel> doctorMsgModels = objectMapper.readValue(doctors, new TypeReference<List<WtDoctorMsgModel>>() {
                });
                Map<String, Set> repeat = new HashMap<>();
                repeat.put("phone", new HashSet<String>());
                repeat.put("idCardNo", new HashSet<String>());
                for (WtDoctorMsgModel model : doctorMsgModels) {
                    model.validate(repeat);
                }
                //获取医生表里面的手机号码
                Set<String> phones = findExistPhoneInDoctor(toJson(repeat.get("phone")));
                //获取账户表里面的手机号码
                Set<String> userPhones = findExistPhoneInUser(toJson(repeat.get("phone")));
                //获取医生表里面的身份证号码
                Set<String> idCardNos = findExistIdCardNoInDoctor(toJson(repeat.get("idCardNo")));
                //获取医生表里面的身份证号码
                Set<String> userIdCardNos = findExistIdCardNoInUser(toJson(repeat.get("idCardNo")));
                //获取组织机构代码-机构全称
                Map<String,String> orgCode_FullName = getOrgCodeAndFullName("orgCode");
                WtDoctorMsgModel model;
                List saveLs = new ArrayList<>();
                for (int i = 0; i < doctorMsgModels.size(); i++) {
                    model = doctorMsgModels.get(i);
                    if (validate(model, phones, userPhones, idCardNos, userIdCardNos,orgCode_FullName) == 0 || model.errorMsg.size() > 0) {
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
     * 获取组织机构代码、机构全称
     */
    @RequestMapping("/orgCodes")
    @ResponseBody
    public Map<String,String> getOrgCodeAndFullName(String field) {
        String url = "/basic/api/v1.0/org/getOrgCodeAndFullName";
        Envelop envelop;
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("field",field);
            HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
            envelop = toModel(response.getContent(), Envelop.class);
            return objectMapper.readValue(toJson(envelop.getObj()), new TypeReference<Map<String,String>>() {});
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return null;
        }
    }

    /**
     * 获取系统字典 校验
     *
     * @param dictId
     * @param value
     * @return
     */
    public String searchDictEntryListForDDL(Long dictId, String value) {
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(value)) {
            if (!StringUtils.isEmpty(dictId)) {
                stringBuffer.append("dictId=" + dictId + ";");
            }
            stringBuffer.append("value=" + value + ";");
            params.put("filters", stringBuffer.toString());
            params.put("page", 1);
            params.put("size", 500);
            try {
                String url = "/dictionaries/entries";
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                Envelop envelop = objectMapper.readValue(resultStr, Envelop.class);
                List<SystemDictEntryModel> modelList = (List<SystemDictEntryModel>) getEnvelopList(envelop.getDetailModelList(), new ArrayList<SystemDictEntryModel>(), SystemDictEntryModel.class);
                for (SystemDictEntryModel m : modelList) {
                    resultStr = m.getCode();
                }
            } catch (Exception ex) {
                LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            }
        }
        return resultStr;
    }

    /**
     * 根据字典id获取字典项编码和值
     */
    public Map<String,String> getDictEntryCodeAndValueByDictId(String dictId) {
        String url = "/basic/api/v1.0/dictionaries/getDictEntryCodeAndValueByDictId";
        Envelop envelop;
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("dictId",dictId);
            HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
            envelop = toModel(response.getContent(), Envelop.class);
            return objectMapper.readValue(toJson(envelop.getObj()), new TypeReference<Map<String,String>>() {});
        } catch (Exception ex) {
            LogService.getLogger(OrganizationController.class).error(ex.getMessage());
            return null;
        }
    }


}
