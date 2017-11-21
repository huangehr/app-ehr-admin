package com.yihu.ehr.emergency.model;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

public class AmbulanceMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        //"{'车牌号码', '初始经度','初始纬度', '归属片区', '所属医院编码', '所属医院名称', '随车手机号码', '百度鹰眼设备号'}"
        String[] header = {"车牌号码", "初始经度", "初始纬度", "归属片区", "所属医院编码", "所属医院名称", "随车手机号码", "百度鹰眼设备号", "错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    public String getErrorInfo(AmbulanceMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("id")) ? "" : m.findErrorMsg("id") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("initLongitude")) ? "" : m.findErrorMsg("initLongitude") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("initLatitude")) ? "" : m.findErrorMsg("initLatitude") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("district")) ? "" : m.findErrorMsg("district") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgName")) ? "" : m.findErrorMsg("orgName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("phone")) ? "" : m.findErrorMsg("phone") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("entityName")) ? "" : m.findErrorMsg("entityName") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (AmbulanceMsgModel m : (List<AmbulanceMsgModel>) ls) {
                addCell(ws, i, 0, m.getId(), m.findErrorMsg("id"));
                addCell(ws, i, 1, String.valueOf(m.getInitLongitude()), m.findErrorMsg("initLongitude"));
                addCell(ws, i, 2, String.valueOf(m.getInitLatitude()), m.findErrorMsg("initLatitude"));
                addCell(ws, i, 3, m.getDistrict(), m.findErrorMsg("district"));
                addCell(ws, i, 4, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 5, m.getOrgName(), m.findErrorMsg("orgName"));
                addCell(ws, i, 6, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 7, m.getEntityName(), m.findErrorMsg("entityName"));
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