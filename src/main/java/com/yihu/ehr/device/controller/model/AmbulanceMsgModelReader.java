package com.yihu.ehr.emergency.model;

import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;
import org.springframework.util.StringUtils;

import java.util.HashSet;

public class AmbulanceMsgModelReader extends AExcelReader {
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            AmbulanceMsgModel p;
            getRepeat().put("id", new HashSet<>());
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgName", new HashSet<>());
            getRepeat().put("phone", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new AmbulanceMsgModel();
                    p.setId(getCellCont(sheet, i, 0));
                    if(!StringUtils.isEmpty(getCellCont(sheet, i, 1))){
                        p.setInitLongitude(Double.valueOf(getCellCont(sheet, i, 1)));
                    }
                    if(!StringUtils.isEmpty(getCellCont(sheet, i, 2))){
                        p.setInitLatitude(Double.valueOf(getCellCont(sheet, i, 2)));
                    }

                    p.setDistrict(getCellCont(sheet, i, 3));

                    p.setOrgCode(getCellCont(sheet, i, 4));
                    p.setOrgName(getCellCont(sheet, i, 5));
                    p.setPhone(getCellCont(sheet, i, 6));
                    p.setStatus("0");
                    p.setEntityName(getCellCont(sheet, i, 7));
                    p.setExcelSeq(j);

                    int rs = p.validate(repeat);
                    if (rs == 0)
                        errorLs.add(p);
                    else if (rs == 1)
                        correctLs.add(p);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("模板不正确，请下载新的模板，并按照示例正确填写后上传！");
        } finally {
            if (rwb != null) rwb.close();
        }
    }
}
