package com.yihu.ehr.emergency.model;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

public class ScheduleMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"姓名", "性别", "工号", "角色", "手机号", "车牌号", "开始时间", "结束时间", "主班/副班"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    public String getErrorInfo(ScheduleMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dutyName")) ? "" : m.findErrorMsg("dutyName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("gender")) ? "" : m.findErrorMsg("gender") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dutyNum")) ? "" : m.findErrorMsg("dutyNum") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dutyRole")) ? "" : m.findErrorMsg("dutyRole") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dutyPhone")) ? "" : m.findErrorMsg("dutyPhone") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("carId")) ? "" : m.findErrorMsg("carId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("start")) ? "" : m.findErrorMsg("start") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("end")) ? "" : m.findErrorMsg("end") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("main")) ? "" : m.findErrorMsg("main") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (ScheduleMsgModel m : (List<ScheduleMsgModel>) ls) {
                addCell(ws, i, 0, m.getDutyName(), m.findErrorMsg("dutyName"));
                addCell(ws, i, 1, m.getGender(), m.findErrorMsg("gender"));
                addCell(ws, i, 2, m.getDutyNum(), m.findErrorMsg("dutyNum"));
                addCell(ws, i, 3, m.getDutyRole(), m.findErrorMsg("dutyRole"));
                addCell(ws, i, 4, m.getDutyPhone(), m.findErrorMsg("dutyPhone"));
                addCell(ws, i, 5, m.getCarId(), m.findErrorMsg("carId"));
                addCell(ws, i, 6, m.getStart().toString(), m.findErrorMsg("start"));
                addCell(ws, i, 7, m.getEnd().toString(), m.findErrorMsg("end"));
                addCell(ws, i, 8, m.getMain(), m.findErrorMsg("main"));
                addCell(ws, i, 9, getErrorInfo(m), "");
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