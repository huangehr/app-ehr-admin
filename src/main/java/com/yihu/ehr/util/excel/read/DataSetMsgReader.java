package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class DataSetMsgReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();

            boolean correct;
            int j = 0, rows;
            Map<String, Set> childRepeat;

            DataSetMsg p;
            MetaDataMsg child;
            getRepeat().put("code", new HashSet<>());
            getRepeat().put("referenceCode", new HashSet<>());

            for (Sheet sheet : sheets) {
                correct = true;
                if ((rows = sheet.getRows()) == 0) continue;
                p = new DataSetMsg();
                p.setName(getCellCont(sheet, 0, 1));
                p.setCode(getCellCont(sheet, 1, 1));
                p.setReferenceCode(getCellCont(sheet, 2, 1));
                p.setSummary(getCellCont(sheet, 3, 1));
                p.setExcelSeq(j);
                if (p.validate(repeat) == 0)
                    correct = false;
                childRepeat = new HashMap<>();
                childRepeat.put("innerCode", new HashSet<>());
                childRepeat.put("dictCode", new HashSet<>());
                childRepeat.put("columnName", new HashSet<>());
                for (int i = 5; i < rows; i++) {
                    child = new MetaDataMsg();
                    child.setDataSetCode(p.getCode());
                    child.setInnerCode(getCellCont(sheet, i, 1));
                    child.setCode(getCellCont(sheet, i, 2));
                    child.setName(getCellCont(sheet, i, 3));
                    child.setDefinition(getCellCont(sheet, i, 4));
                    child.setType(getCellCont(sheet, i, 5));
                    child.setFormat(getCellCont(sheet, i, 6));
                    child.setDictCode(getCellCont(sheet, i, 7));
                    child.setColumnName(getCellCont(sheet, i, 8));
                    child.setColumnType(getCellCont(sheet, i, 9));
                    child.setColumnLength(getCellCont(sheet, i, 10));
                    child.setPrimaryKey(getCellCont(sheet, i, 11));
                    child.setNullable(getCellCont(sheet, i, 12));
                    child.setExcelSeq(i);
                    if (child.validate(childRepeat) == 0)
                        correct = false;
                    p.addChild(child);
                }
                getRepeat().put("dictCode"+j, childRepeat.get("dictCode"));
                if (!correct)
                    errorLs.add(p);
                else
                    correctLs.add(p);
                j++;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (rwb != null) rwb.close();
        }
    }
}
