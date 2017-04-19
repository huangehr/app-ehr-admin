package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.patient.model.RsMedicalCardModel;
import com.yihu.ehr.resource.model.RsMetaMsgModel;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashSet;

public class RsMedicalCardModelReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            RsMedicalCardModel p;
            getRepeat().put("cardNo", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new RsMedicalCardModel();
                    p.setCardType(getCellCont(sheet, i, 0));
                    p.setCardNo(getCellCont(sheet, i, 1));
                    p.setReleaseOrg(getCellCont(sheet, i, 2));
                    p.setReleaseDate(getCellCont(sheet, i, 3));
                    p.setValidityDateBegin(getCellCont(sheet, i, 4));
                    p.setValidityDateEnd(getCellCont(sheet, i, 5));
                    p.setDescription(getCellCont(sheet, i, 6));
                    p.setStatus(getCellCont(sheet, i, 7));

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
