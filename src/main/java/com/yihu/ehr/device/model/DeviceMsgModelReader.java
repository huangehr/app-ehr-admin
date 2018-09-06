package com.yihu.ehr.device.model;

import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;
import org.springframework.util.StringUtils;

import java.util.HashSet;

public class DeviceMsgModelReader extends AExcelReader {
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            DeviceMsgModel p;
            getRepeat().put("orgCode", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new DeviceMsgModel();
                    p.setDeviceName(getCellCont(sheet, i, 0));
                    p.setOrgCode(getCellCont(sheet, i, 1));
                    p.setDeviceType(getCellCont(sheet, i, 2));
                    p.setPurchaseNum(getCellCont(sheet, i, 3));
                    p.setOriginPlace(getCellCont(sheet, i, 4));
                    p.setManufacturerName(getCellCont(sheet, i, 5));
                    p.setDeviceModel(getCellCont(sheet, i, 6));
                    p.setPurchaseTime(getCellCont(sheet, i, 7));
                    p.setIsNew(getCellCont(sheet, i, 8));
                    if(!StringUtils.isEmpty(getCellCont(sheet, i, 9))) {
                        p.setDevicePrice(Double.valueOf(getCellCont(sheet, i, 9)));
                    }
                    if(!StringUtils.isEmpty(getCellCont(sheet, i, 10))) {
                        p.setYearLimit(Integer.valueOf(getCellCont(sheet, i, 10)));
                    }
                    p.setStatus(getCellCont(sheet, i, 11));
                    p.setIsGps(getCellCont(sheet, i, 12));
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
