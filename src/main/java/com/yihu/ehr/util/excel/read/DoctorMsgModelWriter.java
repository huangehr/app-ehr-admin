package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

public class DoctorMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"医生账号", "姓名", "身份证号", "性别", "机构代码", "机构全称", "科室名称", "医生专长", "邮箱", "联系电话", "类别", "执业类别", "从事专业类别代码", "执业范围", "执业状态", "是否注册", "是否制证", "技术职称", "学历", "行政职称", "办公电话（固）", "医生门户首页", "简介", "错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    public String getErrorInfo(DoctorMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("code")) ? "" : m.findErrorMsg("code") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("name")) ? "" : m.findErrorMsg("name") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("idCardNo")) ? "" : m.findErrorMsg("idCardNo") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("sex")) ? "" : m.findErrorMsg("sex") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgFullName")) ? "" : m.findErrorMsg("orgFullName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgDeptName")) ? "" : m.findErrorMsg("orgDeptName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("skill")) ? "" : m.findErrorMsg("skill") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("email")) ? "" : m.findErrorMsg("email") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("phone")) ? "" : m.findErrorMsg("phone") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("roleType")) ? "" : m.findErrorMsg("roleType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jobType")) ? "" : m.findErrorMsg("jobType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jobLevel")) ? "" : m.findErrorMsg("jobLevel") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jobScope")) ? "" : m.findErrorMsg("jobScope") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("registerFlag")) ? "" : m.findErrorMsg("registerFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jxzc")) ? "" : m.findErrorMsg("jxzc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("lczc")) ? "" : m.findErrorMsg("lczc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xlzc")) ? "" : m.findErrorMsg("xlzc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("xzzc")) ? "" : m.findErrorMsg("xzzc") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("officeTel")) ? "" : m.findErrorMsg("officeTel") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("workPortal")) ? "" : m.findErrorMsg("workPortal") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("introduction")) ? "" : m.findErrorMsg("introduction") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0, errorInfo.length() - 1);
    }
    @Override
    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (DoctorMsgModel m : (List<DoctorMsgModel>) ls) {
                addCell(ws, i, 0, m.getCode(), m.findErrorMsg("code"));
                addCell(ws, i, 1, m.getName(), m.findErrorMsg("name"));
                addCell(ws, i, 2, m.getIdCardNo(), m.findErrorMsg("idCardNo"));
                addCell(ws, i, 3, m.getSex(), m.findErrorMsg("sex"));
                addCell(ws, i, 4, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 5, m.getOrgFullName(), m.findErrorMsg("orgFullName"));
                addCell(ws, i, 6, m.getOrgDeptName(), m.findErrorMsg("orgDeptName"));
                addCell(ws, i, 7, m.getSkill(), m.findErrorMsg("skill"));
                addCell(ws, i, 8, m.getEmail(), m.findErrorMsg("email"));
                addCell(ws, i, 9, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 10, m.getRoleType(), m.findErrorMsg("roleType"));
                addCell(ws, i, 11, m.getJobType(), m.findErrorMsg("jobType"));
                addCell(ws, i, 12, m.getJobLevel(), m.findErrorMsg("jobLevel"));
                addCell(ws, i, 13, m.getJobScope(), m.findErrorMsg("jobScope"));
                addCell(ws, i, 14, m.getJobState(), m.findErrorMsg("jobState"));
                addCell(ws, i, 15, m.getRegisterFlag(), m.findErrorMsg("registerFlag"));
                addCell(ws, i, 16, m.getJxzc(), m.findErrorMsg("jxzc"));
                addCell(ws, i, 17, m.getLczc(), m.findErrorMsg("lczc"));
                addCell(ws, i, 18, m.getXlzc(), m.findErrorMsg("xlzc"));
                addCell(ws, i, 19, m.getXzzc(), m.findErrorMsg("xzzc"));
                addCell(ws, i, 20, m.getOfficeTel(), m.findErrorMsg("officeTel"));
                addCell(ws, i, 21, m.getWorkPortal(), m.findErrorMsg("workPortal"));
                addCell(ws, i, 22, m.getIntroduction(), m.findErrorMsg("introduction"));
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