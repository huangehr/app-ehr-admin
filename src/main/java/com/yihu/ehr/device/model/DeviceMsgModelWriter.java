package com.yihu.ehr.device.model;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

public class DeviceMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"设备名称","归属机构代码","设备代号", "采购数量", "产地", "厂家", "设备型号","采购时间","新旧情况","设备价格","使用年限","状态","是否配置GPS","错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    public String getErrorInfo(DeviceMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("deviceName")) ? "" : m.findErrorMsg("deviceName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("deviceType")) ? "" : m.findErrorMsg("deviceType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("purchaseNum")) ? "" : m.findErrorMsg("purchaseNum") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("originPlace")) ? "" : m.findErrorMsg("originPlace") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("manufacturerName")) ? "" : m.findErrorMsg("manufacturerName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("deviceModel")) ? "" : m.findErrorMsg("deviceModel") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("purchaseTime")) ? "" : m.findErrorMsg("purchaseTime") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("isNew")) ? "" : m.findErrorMsg("isNew") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("devicePrice")) ? "" : m.findErrorMsg("devicePrice") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("yearLimit")) ? "" : m.findErrorMsg("yearLimit") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("status")) ? "" : m.findErrorMsg("status") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("isGps")) ? "" : m.findErrorMsg("isGps") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (DeviceMsgModel m : (List<DeviceMsgModel>) ls) {
                addCell(ws, i, 0, m.getDeviceName(), m.findErrorMsg("deivceName"));
                addCell(ws, i, 1, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 2, m.getDeviceType(), m.findErrorMsg("deviceType"));
                addCell(ws, i, 3, m.getPurchaseNum(), m.findErrorMsg("purchaseNum"));
                addCell(ws, i, 4, m.getOriginPlace(), m.findErrorMsg("originPlace"));
                addCell(ws, i, 5, m.getManufacturerName(), m.findErrorMsg("manufacturerName"));
                addCell(ws, i, 6, m.getDeviceModel(), m.findErrorMsg("deviceModel"));
                addCell(ws, i, 7, m.getPurchaseTime(), m.findErrorMsg("purchaseTime"));
                addCell(ws, i, 8, m.getIsNew(), m.findErrorMsg("isNew"));
                addCell(ws, i, 9, String.valueOf(m.getDevicePrice()), m.findErrorMsg("devicePrice"));
                addCell(ws, i, 10, String.valueOf(m.getYearLimit()), m.findErrorMsg("yearLimit"));
                addCell(ws, i, 11, m.getStatus(), m.findErrorMsg("status"));
                addCell(ws, i, 12, m.getIsGps(), m.findErrorMsg("isGps"));
                addCell(ws, i, 13, getErrorInfo(m), "");
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