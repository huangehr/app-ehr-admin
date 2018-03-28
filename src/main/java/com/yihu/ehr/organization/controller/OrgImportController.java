package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.dict.MDictionaryEntry;
import com.yihu.ehr.model.geography.MGeographyDict;
import com.yihu.ehr.model.org.MOrgHealthCategory;
import com.yihu.ehr.organization.model.OrgMsgModel;
import com.yihu.ehr.organization.service.OrgService;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.OrgMsgModelReader;
import com.yihu.ehr.util.excel.read.OrgMsgModelWriter;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
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
 * Created by zdm on 2017/10/19
 */
@Controller
@RequestMapping("/orgImport")
public class OrgImportController extends ExtendController<OrgService> {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    static final String parentFile = "org";

    @RequestMapping(value = "importOrg")
    @ResponseBody
    public void importOrgMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new OrgMsgModelReader();
            excelReader.read(file.getInputStream());
            List<OrgMsgModel> errorLs = excelReader.getErrorLs();
            List<OrgMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20 + "", "l_upd_progress");
            List<OrgMsgModel> saveLs = new ArrayList<OrgMsgModel>();
            //获取机构代码
            Set<String> orgCodes = findExistOrgCode(toJson(excelReader.getRepeat().get("orgCode")));
            //根据字典代码获取字典项列表--机构类型,如:行政\科研等
            Set<String> orgTypes = getDictEntryByDictId("7");
            //根据字典代码获取字典项列表--入驻方式：直连/第三方接入
            Set<String> settledWays = getDictEntryByDictId("8");
            //根据字典代码获取字典项列表--医院类型：综合性医院/眼科医院
            Set<String> hosTypeIds = getDictEntryByDictId("62");
            //根据字典代码获取字典项列表--医院归属：省属/市属。
            Set<String> ascriptionTypes = getDictEntryByDictId("63");
            //根据字典代码获取字典项列表--中西医标识：中医/西医
            Set<String> zxys = getDictEntryByDictId("70");
            //根据字典代码获取字典项列表--经济类型代码，如：国有全资\集体全资等
            Set<String> hosEconomics = getCodeDictEntryByDictId("102");
            //卫生机构分类代码信息
            Set<String> classifications = getHealthCategoryList();

            writerResponse(response, 35 + "", "l_upd_progress");
            OrgMsgModel model;
            for (int i = 0; i < correctLs.size(); i++) {
                model = correctLs.get(i);
                model = getAdressIdByName(model, model.getProvinceName(), model.getCityName(), model.getDistrict());
                if (model.isAdDivisionExist()) {
                    if (validate(model, orgCodes, orgTypes, settledWays, hosTypeIds, ascriptionTypes, zxys, hosEconomics, classifications) == 0) {
                        errorLs.add(model);
                    } else {
                        OrgMsgModel mod = getDictEntryKeyByName(model);
                        saveLs.add(mod);
                    }
                } else {
                    errorLs.add(model);
                }
            }
            for (int i = 0; i < errorLs.size(); i++) {
                model = errorLs.get(i);
                validate(model, orgCodes, orgTypes, settledWays, hosTypeIds, ascriptionTypes, zxys, hosEconomics, classifications);
            }
            writerResponse(response, 55 + "", "l_upd_progress");
            Map rs = new HashMap<>();
            if (!errorLs.isEmpty()) {
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
                ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                writerResponse(response, 75 + "", "l_upd_progress");
            }
            if (!saveLs.isEmpty()) {
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

    private Set<String> getCodeDictEntryByDictId(String dictId) throws IOException {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("dictId", dictId);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/systemDict/getDictEntryByDictId/" + dictId, conditionMap);
        Envelop envelopAddr = objectMapper.readValue(rs, Envelop.class);
        Set<String> st = new HashSet<String>();
        List<MDictionaryEntry> mDictionaryEntryList = (List<MDictionaryEntry>) getEnvelopList(envelopAddr.getDetailModelList(),
                new ArrayList<MDictionaryEntry>(), MDictionaryEntry.class);
        if (null != mDictionaryEntryList && mDictionaryEntryList.size() > 0) {
            for (MDictionaryEntry mDictionaryEntry : mDictionaryEntryList) {
                st.add(mDictionaryEntry.getCode());
            }
        }
        return st;
    }

    private Set<String> findExistOrgCode(String orgCode) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("orgCode", orgCode);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/orgCode/existence", conditionMap);
        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {
        });
    }

    private int validate(OrgMsgModel model, Set<String> orgCodes, Set<String> orgTypes, Set<String> settledWays,
                         Set<String> hosTypeIds, Set<String> ascriptionTypes,
                         Set<String> zxys, Set<String> hosEconomics, Set<String> classifications) {
        int rs = 1;
        if (orgCodes.contains(model.getOrgCode())) {
            model.addErrorMsg("orgCode", "该机构代码已存在，请核对！");
            rs = 0;
        }
        if (!orgTypes.contains(model.getOrgType())) {
            model.addErrorMsg("orgType", "该机构类型不存在，请参考系统字典的机构类型！");
            rs = 0;
        }
        if (!settledWays.contains(model.getSettledWay())) {
            model.addErrorMsg("settledWay", "该入驻方式不存在，请参考系统字典的连接方式！");
            rs = 0;
        }
        if (!hosTypeIds.contains(model.getHosTypeId())) {
            model.addErrorMsg("hosTypeId", "该医院类型不存在，请参考系统字典的医院类型！");
            rs = 0;
        }
        if (!ascriptionTypes.contains(model.getAscriptionType())) {
            model.addErrorMsg("ascriptionType", "该医院归属不存在，请参考系统字典的医院归属！");
            rs = 0;
        }
        if (!zxys.contains(model.getZxy())) {
            model.addErrorMsg("zxy", "该中西医标识不存在，请参考系统字典的中西医标识！");
            rs = 0;
        }

        if (!hosEconomics.contains(model.getHosEconomic())) {
            model.addErrorMsg("hosEconomic", "该经济类型代码不存在，请参考系统字典的经济类型代码！");
            rs = 0;
        }

        if (!classifications.contains(model.getClassification())) {
            model.addErrorMsg("classification", "该卫生机构分类不存在，请参考系统卫生机构分类！");
            rs = 0;
        }

        if (!classifications.contains(model.getBigClassification())) {
            model.addErrorMsg("bigClassification", "该卫生机构大分类不存在，请参考卫生机构大分类！");
            rs = 0;
        }

        return rs;
    }

    private List saveMeta(String orgs) throws Exception {
        Map map = new HashMap<>();
        map.put("orgs", orgs);
        EnvelopExt<OrgMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/organizations/batch", map), OrgMsgModel.class);
        if (envelop.isSuccessFlg()) {
            return envelop.getDetailModelList();
        }
        throw new Exception("保存失败！");
    }

    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result) {
        try {
            model.addAttribute("files", result);
            model.addAttribute("contentPage", "/organization/uploadOrgErrorDialog");
        } catch (Exception e) {
            e.printStackTrace();
        }
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

            new OrgMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("orgIsExistence")
    @ResponseBody
    public Object orgIsExistence(String filters) {
        String getOrgUrl = "/organizations/existence/" + filters;
        String resultStr = "";
        Envelop envelop = new Envelop();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, username, password);
            if (!Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("更新失败");
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String orgs, String eFile, String tFile, String datePath) {
        try {
            if (!StringUtils.isEmpty(orgs) && !StringUtils.isEmpty(orgs.replaceAll("\\[|\\]", ""))) {
                eFile = datePath + TemPath.separator + eFile;
                File file = new File(TemPath.getFullPath(eFile, parentFile));
                List<OrgMsgModel> all = (List<OrgMsgModel>) ObjectFileRW.read(file);
                List<OrgMsgModel> orgMsgModels = objectMapper.readValue(orgs, new TypeReference<List<OrgMsgModel>>() {
                });
                Map<String, Set> repeat = new HashMap<>();
                repeat.put("orgCode", new HashSet<String>());
                repeat.put("orgTypes", new HashSet<String>());
                repeat.put("settledWays", new HashSet<String>());
                repeat.put("hosTypeIds", new HashSet<String>());
                repeat.put("ascriptionTypes", new HashSet<String>());
                repeat.put("zxys", new HashSet<String>());

                for (OrgMsgModel model : orgMsgModels) {
                    model.validate(repeat);
                }
                //获取机构代码
                Set<String> orgCodes = findExistOrgCode(toJson(repeat.get("orgCode")));
                //根据字典代码获取字典项列表--机构类型,如:行政\科研等
                Set<String> orgTypes = getDictEntryByDictId("7");
                //根据字典代码获取字典项列表--入驻方式：直连/第三方接入
                Set<String> settledWays = getDictEntryByDictId("8");
                //根据字典代码获取字典项列表--医院类型：综合性医院/眼科医院
                Set<String> hosTypeIds = getDictEntryByDictId("62");
                //根据字典代码获取字典项列表--医院归属：省属/市属。
                Set<String> ascriptionTypes = getDictEntryByDictId("63");
                //根据字典代码获取字典项列表--中西医标识：中医/西医
                Set<String> zxys = getDictEntryByDictId("70");
                //根据字典代码获取字典项列表--经济类型代码，如：国有全资\集体全资等
                Set<String> hosEconomics = getCodeDictEntryByDictId("102");
                //卫生机构分类代码信息
                Set<String> classifications = getHealthCategoryList();
                OrgMsgModel model;
                List saveLs = new ArrayList<>();
                for (int i = 0; i < orgMsgModels.size(); i++) {
                    model = orgMsgModels.get(i);
                    model = getAdressIdByName(model, model.getProvinceName(), model.getCityName(), model.getDistrict());
                    if (model.isAdDivisionExist()) {
                        if (validate(model, orgCodes, orgTypes, settledWays, hosTypeIds, ascriptionTypes, zxys, hosEconomics, classifications) == 0 || model.errorMsg.size() > 0) {
                            all.set(all.indexOf(model), model);
                        } else {
                            OrgMsgModel mod = getDictEntryKeyByName(model);
                            saveLs.add(mod);
                            all.remove(model);
                        }
                    } else {
                        all.set(all.indexOf(model), model);
                    }
                }
                saveMeta(toJson(saveLs));
                ObjectFileRW.write(file, all);
                return success("");
            } else {
                return faild("无数据，保存失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    //根据字典代码获取字典项列表
    private Set<String> getDictEntryByDictId(String dictId) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("dictId", dictId);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/systemDict/getDictEntryByDictId/" + dictId, conditionMap);
        Envelop envelopAddr = objectMapper.readValue(rs, Envelop.class);
        Set<String> st = new HashSet<String>();
        List<MDictionaryEntry> mDictionaryEntryList = (List<MDictionaryEntry>) getEnvelopList(envelopAddr.getDetailModelList(),
                new ArrayList<MDictionaryEntry>(), MDictionaryEntry.class);
        if (null != mDictionaryEntryList && mDictionaryEntryList.size() > 0) {
            for (MDictionaryEntry mDictionaryEntry : mDictionaryEntryList) {
                st.add(mDictionaryEntry.getValue());
            }
        }
        return st;
    }

    //根据地址获取地址ID并获取最小区域
    private OrgMsgModel getAdressIdByName(OrgMsgModel model, String province, String city, String district) throws Exception {
        String urlAddr = ServiceApi.Geography.AddressDictByFields;
        Map<String, Object> args = new HashMap<>();
        int pid = 0;
        int AdDivision = 0;
        model.setAdDivisionExist(false);
        String[] values = {province, city, district};
        String[] fields = {"name"};
        for (int i = 0; i < 3; i++) {
            args.put("fields", fields[0]);
            args.put("values", values[i]);
            String envelopStrAddr = HttpClientUtil.doGet(comUrl + urlAddr, args, username, password);
            Envelop envelopAddr = objectMapper.readValue(envelopStrAddr, Envelop.class);
            if (envelopAddr.isSuccessFlg() && envelopAddr.getDetailModelList().size() > 0) {
                List<MGeographyDict> mlist = (List<MGeographyDict>) getEnvelopList(envelopAddr.getDetailModelList(),
                        new ArrayList<MGeographyDict>(), MGeographyDict.class);
                for (MGeographyDict geographyDict : mlist) {
                    if (pid <= geographyDict.getLevel()) {
                        pid = geographyDict.getLevel();
                        model.setAdDivisionExist(true);
                        model.setAdministrativeDivision(geographyDict.getId());
                    }
                }
            }
        }
        if (pid == 0) {
            model.addErrorMsg("isAdDivisionExist", "该机构机构地址格式不正确，请核对！");
        }
        return model;
    }

    //根据字典代码获取字典项Map
    private Map<String, String> getDictEntryMapByDictId(String dictId) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("dictId", dictId);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/systemDict/getDictEntryByDictId/" + dictId, conditionMap);
        Envelop envelopAddr = objectMapper.readValue(rs, Envelop.class);
        List<MDictionaryEntry> mDictionaryEntryList = (List<MDictionaryEntry>) getEnvelopList(envelopAddr.getDetailModelList(),
                new ArrayList<MDictionaryEntry>(), MDictionaryEntry.class);
        Map<String, String> map = new HashMap<>();
        if (null != mDictionaryEntryList && mDictionaryEntryList.size() > 0) {
            for (MDictionaryEntry mDictionaryEntry : mDictionaryEntryList) {
                map.put(mDictionaryEntry.getCode(), mDictionaryEntry.getValue());
            }
        }
        return map;
    }

    private OrgMsgModel getDictEntryKeyByName(OrgMsgModel model) {
        try {
            //根据字典代码获取字典项列表--机构类型,如:行政\科研等
            Map<String, String> orgTypes = getDictEntryMapByDictId("7");
            //根据字典代码获取字典项列表--入驻方式：直连/第三方接入
            Map<String, String> settledWays = getDictEntryMapByDictId("8");
            //根据字典代码获取字典项列表--医院类型：综合性医院/眼科医院
            Map<String, String> hosTypeIds = getDictEntryMapByDictId("62");
            //根据字典代码获取字典项列表--医院归属：省属/市属。
            Map<String, String> ascriptionTypes = getDictEntryMapByDictId("63");
            //根据字典代码获取字典项列表--中西医标识：中医/西医
            Map<String, String> zxys = getDictEntryMapByDictId("70");
            for (String key : orgTypes.keySet()) {
                if (model.getOrgType().equals(orgTypes.get(key).toString())) {
                    model.setOrgType(key);
                }
            }
            for (String key : settledWays.keySet()) {
                if (model.getSettledWay().equals(settledWays.get(key).toString())) {
                    model.setSettledWay(key);
                }
            }
            for (String key : hosTypeIds.keySet()) {
                if (model.getHosTypeId().equals(hosTypeIds.get(key).toString())) {
                    model.setHosTypeId(key);
                }
            }
            for (String key : ascriptionTypes.keySet()) {
                if (model.getAscriptionType().equals(ascriptionTypes.get(key).toString())) {
                    model.setAscriptionType(key);
                }
            }
            for (String key : zxys.keySet()) {
                if (model.getZxy().equals(zxys.get(key).toString())) {
                    model.setZxy(key);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

    /**
     * 获取所有的卫生机构类别
     *
     * @return
     * @throws Exception
     */
    public Set<String> getHealthCategoryList() throws Exception {
        String rs = HttpClientUtil.doGet(comUrl + ServiceApi.Org.HealthCategory.FindAll, username, password);
        Envelop envelopAddr = objectMapper.readValue(rs, Envelop.class);
        Set<String> st = new HashSet<String>();
        List<MOrgHealthCategory> mOrgHealthCategoryList = (List<MOrgHealthCategory>) getEnvelopList(envelopAddr.getDetailModelList(),
                new ArrayList<MOrgHealthCategory>(), MOrgHealthCategory.class);
        if (null != mOrgHealthCategoryList && mOrgHealthCategoryList.size() > 0) {
            for (MOrgHealthCategory mOrgHealthCategory : mOrgHealthCategoryList) {
                st.add(mOrgHealthCategory.getCode());
            }
        }
        return st;
    }
}
