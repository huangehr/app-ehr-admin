package com.yihu.ehr.util.excel.read;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.organization.controller.OrganizationController;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Sheet;
import jxl.Workbook;
import org.springframework.util.StringUtils;
import java.text.SimpleDateFormat;
import java.util.*;

public class DoctorMsgModelReader extends AExcelReader {
    private String username;
    private String password;
    private String comUrl;
    private ObjectMapper objectMapper;
    // 人员类别 系统字典
    public static final long roleTypeDictId = 120;
    // 执业类别
    public static final long jobTypeDictId = 104;
    // 执业级别
    public static final long jobLevelDictId = 105;
    // 执业范围
    public static final long jobScopeDictId = 103;
    // 执业状态
    public static final long jobStateDictId = 106;
    // 技术职称
    public static final long lczcDictId = 118;
    @Override
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            DoctorMsgModel p;
            getRepeat().put("code", new HashSet<>());
            getRepeat().put("phone", new HashSet<>());
            getRepeat().put("email", new HashSet<>());
            getRepeat().put("idCardNo", new HashSet<>());
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgFullName", new HashSet<>());
            getRepeat().put("orgDeptName", new HashSet<>());
            getRepeat().put("roleType", new HashSet<>());
            getRepeat().put("jobType", new HashSet<>());
            getRepeat().put("jobLevel", new HashSet<>());
            getRepeat().put("jobScope", new HashSet<>());
            getRepeat().put("jobState", new HashSet<>());
            getRepeat().put("lczc", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) {
                    continue;
                }
                for (int i = 1; i < rows; i++, j++) {
                    p = new DoctorMsgModel();
                    boolean vatFlag = true;
                    p.setCode(getCellCont(sheet, i, 0));
                    p.setName(getCellCont(sheet, i, 1));
                    p.setIdCardNo(getCellCont(sheet, i, 2));
                    if (getCellCont(sheet, i, 3).equals("男")) {
                        p.setSex("1");
                    } else {
                        p.setSex("2");
                    }
                    if (null != getCellCont(sheet, i, 4)) {
                        String orgCode = getCellCont(sheet, i, 4).trim();
                        p.setOrgCode(orgCode);
                    } else {
                        p.setOrgCode(getCellCont(sheet, i, 4));
                    }

                    if (null != getCellCont(sheet, i, 5)) {
                        String orgFullName = getCellCont(sheet, i, 5).trim();
                        p.setOrgFullName(orgFullName);
                    } else {
                        p.setOrgFullName(getCellCont(sheet, i, 5));
                    }

                    if (null != getCellCont(sheet, i, 6)) {
                        //去除中文逗号
                        String orgDept = getCellCont(sheet, i, 6).replace("，", ",").trim();
                        p.setOrgDeptName(orgDept);
                    } else {
                        p.setOrgDeptName(getCellCont(sheet, i, 6));
                    }
                    p.setSkill(getCellCont(sheet, i, 7));
                    p.setEmail(getCellCont(sheet, i, 8));
                    p.setPhone(getCellCont(sheet, i, 9));
                    String roleType = getCellCont(sheet, i, 10) == null ? "" : getCellCont(sheet, i, 10).trim();
                    if ("医生".equals(roleType)) {
                        roleType = "医师";
                    } else if ("护士".equals(roleType)) {
                        roleType = "注册护士";
                    }

                    if (!"".equals(searchDictEntryListForDDL(roleTypeDictId, roleType))) {
                        p.setRoleType(searchDictEntryListForDDL(roleTypeDictId, roleType));
                    } else {
                        vatFlag = false;
                        p.validate("roleType",vatFlag);
                    }

                    if (!"".equals(searchDictEntryListForDDL(jobTypeDictId, getCellCont(sheet, i, 11).trim()))) {
                        p.setJobType(searchDictEntryListForDDL(jobTypeDictId, getCellCont(sheet, i, 11).trim()));
                    } else {
                        vatFlag = false;
                        p.validate("jobType",vatFlag);
                    }

                    if (!"".equals(searchDictEntryListForDDL(jobLevelDictId, getCellCont(sheet, i, 12).trim()))) {
                        p.setJobLevel(searchDictEntryListForDDL(jobLevelDictId, getCellCont(sheet, i, 12).trim()));
                    } else {
                        vatFlag = false;
                        p.validate("jobLevel",vatFlag);
                    }
                    if (!"".equals(searchDictEntryListForDDL(jobScopeDictId, getCellCont(sheet, i, 13).trim()))) {
                        p.setJobScope(searchDictEntryListForDDL(jobScopeDictId, getCellCont(sheet, i, 13).trim()));
                    } else {
                        vatFlag = false;
                        p.validate("jobScope",vatFlag);
                    }
                    if (!"".equals(searchDictEntryListForDDL(jobStateDictId, getCellCont(sheet, i, 14).trim()))) {
                        p.setJobState(searchDictEntryListForDDL(jobStateDictId, getCellCont(sheet, i, 14).trim()));
                    } else {
                        vatFlag = false;
                        p.validate("jobState",vatFlag);
                    }
                    //0为是，1为否
                    String registerFlag = getCellCont(sheet, i, 15) == null ? "" : getCellCont(sheet, i, 15).trim();
                    if ("是".equals(registerFlag)) {
                        p.setRegisterFlag("0");
                    } else {
                        p.setRegisterFlag("1");
                    }
                    //1已制证   2未制证  3未知
                    String jxzc = getCellCont(sheet, i, 16) == null ? "" : getCellCont(sheet, i, 16).trim();
                    if ("是".equals(jxzc)) {
                        p.setJxzc("1");
                    } else {
                        p.setJxzc("2");
                    }
                    if (!"".equals(searchDictEntryListForDDL(lczcDictId, getCellCont(sheet, i, 17).trim()))) {
                        p.setLczc(searchDictEntryListForDDL(lczcDictId, getCellCont(sheet, i, 17).trim()));
                    } else {
                        vatFlag = false;
                        p.validate("lczc",vatFlag);
                    }
                    p.setXlzc(getCellCont(sheet, i, 18) == null ? "" : getCellCont(sheet, i, 18).trim());
                    p.setXzzc(getCellCont(sheet, i, 19) == null ? "" : getCellCont(sheet, i, 19).trim());
                    p.setOfficeTel(getCellCont(sheet, i, 20));
                    p.setWorkPortal(getCellCont(sheet, i, 21));
                    p.setIntroduction(getCellCont(sheet, i, 22) == null ? "" : getCellCont(sheet, i, 22).trim());
                    p.setExcelSeq(j);
                    int rs = p.validate(repeat);
                    if (rs == 1 && vatFlag == true) {
                        correctLs.add(p);
                    }else{
                        errorLs.add(p);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("模板不正确，请下载新的模板，并按照示例正确填写后上传！");
        } finally {
            if (rwb != null) {
                rwb.close();
            }
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
     * 将envelop中的DetailList串转化为模板对象集合
     * Envelop envelop = objectMapper.readValue(resultStr,Envelop.class)
     * modelList = envelop.getDetailModelList()
     *
     * @param modelList
     * @param targets
     * @param targetCls
     * @param <T>
     * @return
     */
    public <T> Collection<T> getEnvelopList(List modelList, Collection<T> targets, Class<T> targetCls) {
        try {
            objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
            for (Object aModelList : modelList) {
                String objJsonData = objectMapper.writeValueAsString(aModelList);
                T model = objectMapper.readValue(objJsonData, targetCls);
                targets.add(model);
            }
            return targets;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
    public DoctorMsgModelReader() {
    }

    public DoctorMsgModelReader(String username, String password, String comUrl, ObjectMapper objectMapper) {
        this.username = username;
        this.password = password;
        this.comUrl = comUrl;
        this.objectMapper = objectMapper;
    }
}
