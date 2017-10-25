package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.patient.model.RsMedicalCardModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

public class RsMedicalCardModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"卡类型", "卡号", "发卡机构", "发卡时间", "有效起始时间", "有效截止时间", "说明", "状态", "错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    private String getErrorInfo(RsMedicalCardModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("cardType")) ? "" : m.findErrorMsg("cardType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("cardNo")) ? "" : m.findErrorMsg("cardNo") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("releaseOrg")) ? "" : m.findErrorMsg("releaseOrg") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("releaseDate")) ? "" : m.findErrorMsg("releaseDate") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("validityDateBegin")) ? "" : m.findErrorMsg("validityDateBegin") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("validityDateEnd")) ? "" : m.findErrorMsg("validityDateEnd") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("description")) ? "" : m.findErrorMsg("description") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("status")) ? "" : m.findErrorMsg("status") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (RsMedicalCardModel m : (List<RsMedicalCardModel>) ls) {
                addCell(ws, i, 0, m.getCardType(), m.findErrorMsg("cardType"));
                addCell(ws, i, 1, m.getCardNo(), m.findErrorMsg("cardNo"));
                addCell(ws, i, 2, m.getReleaseOrg(), m.findErrorMsg("releaseOrg"));
                addCell(ws, i, 3, m.getReleaseDate(), m.findErrorMsg("releaseDate"));
                addCell(ws, i, 4, m.getValidityDateBegin(), m.findErrorMsg("validityDateBegin"));
                addCell(ws, i, 5, m.getValidityDateEnd(), m.findErrorMsg("validityDateEnd"));
                addCell(ws, i, 6, m.getDescription(), m.findErrorMsg("description"));
                addCell(ws, i, 7, m.getStatus(), m.findErrorMsg("status"));
                addCell(ws, i, 8, getErrorInfo(m), "");
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
