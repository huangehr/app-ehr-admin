package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashSet;

/**
 * Created by Administrator on 2017/7/14.
 */
public class OrgDeptMsgModelReader extends AExcelReader {
    @Override
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            OrgDeptMsgModel p;
            getRepeat().put("code", new HashSet<>());
            getRepeat().put("orgCode", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new OrgDeptMsgModel();
                    p.setCode(getCellCont(sheet, i, 0));
                    p.setName(getCellCont(sheet, i, 1));
                    p.setParentDeptId(getCellCont(sheet, i, 2));
                    p.setParentDeptName(getCellCont(sheet, i ,3));
                    p.setPhone(getCellCont(sheet, i, 4));
                    p.setGloryId(getCellCont(sheet, i, 5));
                    p.setOrgCode(getCellCont(sheet, i, 6));
                    p.setOrgName(getCellCont(sheet, i, 7));
                    p.setIntroduction(getCellCont(sheet, i, 8));
                    p.setPlace(getCellCont(sheet, i, 9));
                    p.setPyCode(getCellCont(sheet, i, 10));
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
