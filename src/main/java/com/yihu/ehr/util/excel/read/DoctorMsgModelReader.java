package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.resource.model.RsMetaMsgModel;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashSet;

public class DoctorMsgModelReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            DoctorMsgModel p;
            getRepeat().put("code", new HashSet<>());
            getRepeat().put("phone", new HashSet<>());
            getRepeat().put("email", new HashSet<>());
            getRepeat().put("idCardNo", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new DoctorMsgModel();
                    p.setCode(getCellCont(sheet, i, 0));
                    p.setName(getCellCont(sheet, i, 1));
                    p.setIdCardNo(getCellCont(sheet, i, 2));
                    if(getCellCont(sheet, i, 3).equals("男")){
                        p.setSex("1");
                    }else{
                        p.setSex("2");
                    }

                    p.setSkill(getCellCont(sheet, i, 4));

                    p.setEmail(getCellCont(sheet, i, 5));
                    p.setPhone(getCellCont(sheet, i, 6));
                    p.setOfficeTel(getCellCont(sheet, i, 7));
                    p.setJxzc(getCellCont(sheet, i, 8));
                    p.setLczc(getCellCont(sheet, i, 9));
                    p.setXlzc(getCellCont(sheet, i, 10));
                    p.setXzzc(getCellCont(sheet, i, 11));
                    p.setIntroduction(getCellCont(sheet, i, 12));
                    p.setWorkPortal(getCellCont(sheet, i, 13));
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
