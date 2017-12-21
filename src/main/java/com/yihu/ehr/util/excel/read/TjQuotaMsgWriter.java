package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.apache.commons.lang.StringUtils;

import java.io.IOException;
import java.util.List;

public class TjQuotaMsgWriter extends AExcelWriter {

    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"名称", "标识", "参考", "备注"};
        int i = 0;
        for (String h : header) {
            addCell(ws, i, 0, h);
            i++;
        }

        String[] cheader = {"序号", "内部标识", "数据元编码", "数据元名称", "数据元定义", "数据类型", "表示格式", "术语范围值", "列名", "列类型"	, "列长度", "主键"	, "可为空"};
        i = 0;
        for (String h : cheader) {
            addCell(ws, 4, i, h);
            i++;
        }
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws;
            int i = 0;
            int j;
            for (DataSetMsg m : (List<DataSetMsg>) ls) {
                ws = wwb.createSheet(StringUtils.isEmpty(m.getName()) ? "sheet" + i : m.getName(), i);
                addHeader(ws);
//                addCell(ws, 0, 1, m.getName(), m.findErrorMsg("name"));
//                addCell(ws, 1, 1, m.getCode(), m.findErrorMsg("code"));
//                addCell(ws, 2, 1, m.getReferenceCode(), m.findErrorMsg("referenceCode"));
//                addCell(ws, 3, 1, m.getSummary(), m.findErrorMsg("summary"));
                j = 5;
                for (MetaDataMsg e : m.getChildren()) {
//                    addCell(ws, j, 0, (j-4) +"");
//                    addCell(ws, j, 1, e.getInnerCode(), e.findErrorMsg("innerCode"));
//                    addCell(ws, j, 2, e.getCode(), e.findErrorMsg("code"));
//                    addCell(ws, j, 3, e.getName(), e.findErrorMsg("name"));
//                    addCell(ws, j, 4, e.getDefinition(), e.findErrorMsg("definition"));
//                    addCell(ws, j, 5, e.getType(), e.findErrorMsg("type"));
//                    addCell(ws, j, 6, e.getFormat(), e.findErrorMsg("format"));
//                    addCell(ws, j, 7, e.getDictCode(), e.findErrorMsg("dictCode"));
//                    addCell(ws, j, 8, e.getColumnName(), e.findErrorMsg("columnName"));
//                    addCell(ws, j, 9, e.getColumnType(), e.findErrorMsg("columnType"));
//                    addCell(ws, j, 10, e.getColumnLength(), e.findErrorMsg("columnLength"));
//                    addCell(ws, j, 11, e.getPrimaryKey(), e.findErrorMsg("primaryKey"));
//                    addCell(ws, j, 12, e.getNullable(), e.findErrorMsg("nullable"));
                    j++;
                }
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
