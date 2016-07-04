package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.resource.model.DictionaryEntryMsg;
import com.yihu.ehr.resource.model.DictionaryMsg;
import com.yihu.ehr.resource.model.RsDictionaryEntryMsg;
import com.yihu.ehr.resource.model.RsDictionaryMsg;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.apache.commons.lang.StringUtils;

import java.io.IOException;
import java.util.List;

public class DictionaryMsgWriter extends AExcelWriter {

    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"代码", "名称", "说明"};
        if (header != null) {
            int i = 0;
            for (String h : header) {
                addCell(ws, i, 0, h);
                i++;
            }
        }
    }

    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws;
            int i = 0;
            for (DictionaryMsg m : (List<DictionaryMsg>) ls) {
                ws = wwb.createSheet(StringUtils.isEmpty(m.getName())? "sheet" +i : m.getName() , i);
                addHeader(ws);
                addCell(ws, 0, 1, m.getCode(), m.findErrorMsg("code"));
                addCell(ws, 1, 1, m.getName(), m.findErrorMsg("name"));
                int j = 0;
                for (DictionaryEntryMsg e : m.getChildren()) {
                    addCell(ws, j, 3, e.getCode(), e.findErrorMsg("code"));
                    addCell(ws, j, 4, e.getName(), e.findErrorMsg("name"));
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
