package com.yihu.ehr.util.excel.read;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import java.io.IOException;
import java.util.List;

public class DoctorMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"医生编号", "姓名", "身份证号码", "性别", "医生专长", "邮箱", "联系电话", "办公电话(固)", "教学职称", "临床职称", "学历", "行政职称", "简介", "医生门户首页"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

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
                addCell(ws, i, 4, m.getSkill(), m.findErrorMsg("skill"));
                addCell(ws, i, 5, m.getEmail(), m.findErrorMsg("email"));
                addCell(ws, i, 6, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 7, m.getOfficeTel(), m.findErrorMsg("officeTel"));
                addCell(ws, i, 8, m.getJxzc(), m.findErrorMsg("jxzc"));
                addCell(ws, i, 9, m.getLczc(), m.findErrorMsg("lczc"));
                addCell(ws, i, 10, m.getXlzc(), m.findErrorMsg("xlzc"));
                addCell(ws, i, 11, m.getXzzc(), m.findErrorMsg("xzzc"));
                addCell(ws, i, 12, m.getIntroduction(), m.findErrorMsg("introduction"));
                addCell(ws, i, 13, m.getWorkPortal(), m.findErrorMsg("workPortal"));
                i++;
            }
            wwb.write();
            wwb.close();
        } catch (IOException e) {
            e.printStackTrace();
            if (wwb != null) wwb.close();
            throw e;
        }
    }
}