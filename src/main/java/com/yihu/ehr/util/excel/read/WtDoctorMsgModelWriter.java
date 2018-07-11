package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.user.controller.model.WtDoctorMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

/**
 * 卫统错误数据输出
 */
public class WtDoctorMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"机构id", "机构编码", "机构名称", "姓名", "身份证件种类", "身份证件号码", "出生日期", "性别代码", "民族代码", "参加工作日期", "办公室电话号码", "手机号码", "所在科室代码", "科室实际名称",
                "从事专业类别代码", "医师/卫生监督员执业证书编码", "医师执业类别代码", "医师执业范围代码", "是否多地点执业医师", "第2执业单位的机构类别", "第3执业单位的机构类别", "是否获得国家住院医师规范化培训合格证书",
                "住院医师规范化培训合格证书编码", "行政/业务管理职务代码", "专业技术资格(评)代码", "专业技术职务(聘)代码", "学历代码", "学位代码", "所学专业代码", "专业特长1", "专业特长2", "专业特长3", "年内人员流动情况",
                "调入/调出时间", "编制情况", "是否注册为全科医学专业", "全科医生取得培训合格证书情况", "是否由乡镇卫生院或社区卫生服务机构派驻村卫生室工作", "是否从事统计信息化业务工作", "统计信息化业务工作"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    public String getErrorInfo(WtDoctorMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgId")) ? "" : m.findErrorMsg("orgId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgFullName")) ? "" : m.findErrorMsg("orgFullName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("name")) ? "" : m.findErrorMsg("name") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sfzjzl")) ? "" : m.findErrorMsg("sfzjzl") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("idCardNo")) ? "" : m.findErrorMsg("idCardNo") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("csrq")) ? "" : m.findErrorMsg("csrq") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sex")) ? "" : m.findErrorMsg("sex") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("mzdm")) ? "" : m.findErrorMsg("mzdm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("cjgzrq")) ? "" : m.findErrorMsg("cjgzrq") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("officeTel")) ? "" : m.findErrorMsg("officeTel") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("phone")) ? "" : m.findErrorMsg("phone") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("szksdm")) ? "" : m.findErrorMsg("szksdm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dept_name")) ? "" : m.findErrorMsg("dept_name") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("role_type")) ? "" : m.findErrorMsg("role_type") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("yszyzsbm")) ? "" : m.findErrorMsg("yszyzsbm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("job_type")) ? "" : m.findErrorMsg("job_type") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("job_scope")) ? "" : m.findErrorMsg("job_scope") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sfdddzyys")) ? "" : m.findErrorMsg("sfdddzyys") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dezydwjglb")) ? "" : m.findErrorMsg("dezydwjglb") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dszydwjglb")) ? "" : m.findErrorMsg("dszydwjglb") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sfhdgjzs")) ? "" : m.findErrorMsg("sfhdgjzs") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zyyszsbm")) ? "" : m.findErrorMsg("zyyszsbm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xzzc")) ? "" : m.findErrorMsg("xzzc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("lczc")) ? "" : m.findErrorMsg("lczc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zyjszwdm")) ? "" : m.findErrorMsg("zyjszwdm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xldm")) ? "" : m.findErrorMsg("xldm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xwdm")) ? "" : m.findErrorMsg("xwdm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("szydm")) ? "" : m.findErrorMsg("szydm") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zktc1")) ? "" : m.findErrorMsg("zktc1") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zktc2")) ? "" : m.findErrorMsg("zktc2") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zktc3")) ? "" : m.findErrorMsg("zktc3") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("nnryldqk")) ? "" : m.findErrorMsg("nnryldqk") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("drdcsj")) ? "" : m.findErrorMsg("drdcsj") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("bzqk")) ? "" : m.findErrorMsg("bzqk") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sfzcqkyx")) ? "" : m.findErrorMsg("sfzcqkyx") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("qdhgzs")) ? "" : m.findErrorMsg("qdhgzs") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xzsqpzgz")) ? "" : m.findErrorMsg("xzsqpzgz") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sfcstjgz")) ? "" : m.findErrorMsg("sfcstjgz") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("tjxxhgz")) ? "" : m.findErrorMsg("tjxxhgz") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0, errorInfo.length() - 1);
    }

    @Override
    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (WtDoctorMsgModel m : (List<WtDoctorMsgModel>) ls) {
                addCell(ws, i, 0, m.getOrgId(), m.findErrorMsg("orgId"));
                addCell(ws, i, 1, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 2, m.getOrgFullName(), m.findErrorMsg("orgFullName"));
                addCell(ws, i, 3, m.getName(), m.findErrorMsg("name"));
                addCell(ws, i, 4, m.getSfzjzl(), m.findErrorMsg("sfzjzl"));
                addCell(ws, i, 5, m.getIdCardNo(), m.findErrorMsg("idCardNo"));
                addCell(ws, i, 6, m.getCsrq(), m.findErrorMsg("csrq"));
                addCell(ws, i, 7, m.getSex(), m.findErrorMsg("sex"));
                addCell(ws, i, 8, m.getMzdm(), m.findErrorMsg("mzdm"));
                addCell(ws, i, 9, m.getCjgzrq(), m.findErrorMsg("cjgzrq"));
                addCell(ws, i, 10, m.getOfficeTel(), m.findErrorMsg("officeTel"));
                addCell(ws, i, 11, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 12, m.getSzksdm(), m.findErrorMsg("szksdm"));
                addCell(ws, i, 13, m.getDept_name(), m.findErrorMsg("dept_name"));
                addCell(ws, i, 14, m.getRole_type(), m.findErrorMsg("role_type"));
                addCell(ws, i, 15, m.getYszyzsbm(), m.findErrorMsg("yszyzsbm"));
                addCell(ws, i, 16, m.getJob_type(), m.findErrorMsg("job_type"));
                addCell(ws, i, 17, m.getJob_scope(), m.findErrorMsg("job_scope"));
                addCell(ws, i, 18, m.getSfdddzyys(), m.findErrorMsg("sfdddzyys"));
                addCell(ws, i, 19, m.getDezydwjglb(), m.findErrorMsg("dezydwjglb"));
                addCell(ws, i, 20, m.getDszydwjglb(), m.findErrorMsg("dszydwjglb"));
                addCell(ws, i, 21, m.getSfhdgjzs(), m.findErrorMsg("sfhdgjzs"));
                addCell(ws, i, 22, m.getZyyszsbm(), m.findErrorMsg("zyyszsbm"));
                addCell(ws, i, 23, m.getXzzc(), m.findErrorMsg("xzzc"));
                addCell(ws, i, 24, m.getLczc(), m.findErrorMsg("lczc"));
                addCell(ws, i, 25, m.getZyjszwdm(), m.findErrorMsg("zyjszwdm"));
                addCell(ws, i, 26, m.getXldm(), m.findErrorMsg("xldm"));
                addCell(ws, i, 27, m.getXwdm(), m.findErrorMsg("xwdm"));
                addCell(ws, i, 28, m.getSzydm(), m.findErrorMsg("szydm"));
                addCell(ws, i, 29, m.getZktc1(), m.findErrorMsg("zktc1"));
                addCell(ws, i, 30, m.getZktc2(), m.findErrorMsg("zktc2"));
                addCell(ws, i, 31, m.getZktc3(), m.findErrorMsg("zktc3"));
                addCell(ws, i, 32, m.getNnryldqk(), m.findErrorMsg("nnryldqk"));
                addCell(ws, i, 33, m.getDrdcsj(), m.findErrorMsg("drdcsj"));
                addCell(ws, i, 34, m.getBzqk(), m.findErrorMsg("bzqk"));
                addCell(ws, i, 35, m.getSfzcqkyx(), m.findErrorMsg("sfzcqkyx"));
                addCell(ws, i, 36, m.getQdhgzs(), m.findErrorMsg("qdhgzs"));
                addCell(ws, i, 37, m.getXzsqpzgz(), m.findErrorMsg("xzsqpzgz"));
                addCell(ws, i, 38, m.getSfcstjgz(), m.findErrorMsg("sfcstjgz"));
                addCell(ws, i, 39, m.getTjxxhgz(), m.findErrorMsg("tjxxhgz"));
                addCell(ws, i, 23, getErrorInfo(m), "");
                i++;
            }
            wwb.write();
            wwb.close();
        } catch (IOException e) {
            e.printStackTrace();
            if (wwb != null) {
                wwb.close();
            }
            throw e;
        }
    }
}