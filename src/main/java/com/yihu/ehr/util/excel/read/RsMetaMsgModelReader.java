package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.resource.model.RsMetaMsgModel;

import java.util.HashSet;

import jxl.Sheet;
import jxl.Workbook;

public class RsMetaMsgModelReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            RsMetaMsgModel p;
            getRepeat().put("id", new HashSet<>());
            getRepeat().put("dictCode", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new RsMetaMsgModel();
                    p.setId(getCellCont(sheet, i, 0));
                    p.setName(getCellCont(sheet, i, 1));
                    p.setDomain(getCellCont(sheet, i, 2));
                    p.setStdCode(getCellCont(sheet, i, 3));
                    p.setColumnType(getCellCont(sheet, i, 4));
                    p.setDictCode(getCellCont(sheet, i, 5));
                    p.setNullAble(getCellCont(sheet, i, 6));
                    p.setDescription(getCellCont(sheet, i, 7));

                    p.setExcelSeq(j);
                    int rs = p.validate(repeat);
                    if (rs == 0)
                        errorLs.add(p);
                    else if (rs == 1)
                        correctLs.add(p);
                }
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (rwb != null) rwb.close();
        }
    }
}
