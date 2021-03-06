package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.resource.model.RsMetaMsgModel;

import com.yihu.ehr.util.excel.AExcelWriter;

import java.io.File;

import jxl.Workbook;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

public class RsMetaMsgModelWriter extends AExcelWriter {
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"资源标准编码", "数据元名称", "业务领域", "内部标识符", "类型", "关联字典", "是否允空", "说明", "错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    private String getErrorInfo(RsMetaMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("id")) ? "" : m.findErrorMsg("id") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("name")) ? "" : m.findErrorMsg("name") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("domain")) ? "" : m.findErrorMsg("domain") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("stdCode")) ? "" : m.findErrorMsg("stdCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("columnType")) ? "" : m.findErrorMsg("columnType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dictCode")) ? "" : m.findErrorMsg("dictCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("nullAble")) ? "" : m.findErrorMsg("nullAble") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("description")) ? "" : m.findErrorMsg("description") + "；";
        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (RsMetaMsgModel m : (List<RsMetaMsgModel>) ls) {
                addCell(ws, i, 0, m.getId(), m.findErrorMsg("id"));
                addCell(ws, i, 1, m.getName(), m.findErrorMsg("name"));
                addCell(ws, i, 2, m.getDomain(), m.findErrorMsg("domain"));
                addCell(ws, i, 3, m.getStdCode(), m.findErrorMsg("stdCode"));
                addCell(ws, i, 4, m.getColumnType(), m.findErrorMsg("columnType"));
                addCell(ws, i, 5, m.getDictCode(), m.findErrorMsg("dictCode"));
                addCell(ws, i, 6, m.getNullAble(), m.findErrorMsg("nullAble"));
                addCell(ws, i, 7, m.getDescription(), m.findErrorMsg("description"));
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