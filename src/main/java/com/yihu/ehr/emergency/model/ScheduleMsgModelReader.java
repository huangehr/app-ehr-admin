package com.yihu.ehr.emergency.model;

import com.yihu.ehr.util.datetime.DateUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;
import org.apache.poi.util.StringUtil;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.HashSet;

public class ScheduleMsgModelReader extends AExcelReader {
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            ScheduleMsgModel p;
            getRepeat().put("carId", new HashSet<>());
            getRepeat().put("dutyNum", new HashSet<>());
            getRepeat().put("dutyPhone", new HashSet<>());
            getRepeat().put("start", new HashSet<>());
            getRepeat().put("end", new HashSet<>());
            getRepeat().put("main", new HashSet<>());
            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new ScheduleMsgModel();
                    p.setDutyName(getCellCont(sheet, i, 0));
                    p.setGender(getCellCont(sheet, i, 1));
                    p.setDutyNum(getCellCont(sheet, i, 2));
                    p.setDutyRole(getCellCont(sheet, i, 3));
                    p.setDutyPhone(getCellCont(sheet, i, 4));
                    p.setCarId(getCellCont(sheet, i, 5));
                    p.setStart(getCellCont(sheet, i, 6));
                    p.setEnd(getCellCont(sheet, i, 7));
                    p.setMain(getCellCont(sheet, i, 8));
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
