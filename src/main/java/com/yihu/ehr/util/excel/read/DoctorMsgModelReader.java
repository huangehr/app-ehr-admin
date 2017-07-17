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
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgFullName", new HashSet<>());
            getRepeat().put("orgDeptName", new HashSet<>());

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
                    if(null!=getCellCont(sheet, i, 4)) {
                        String orgCode = getCellCont(sheet, i, 4).trim();
                        p.setOrgCode(orgCode);
                    }else{
                        p.setOrgCode(getCellCont(sheet, i, 4));
                    }

                    if(null!=getCellCont(sheet, i, 5)) {
                        String orgFullName = getCellCont(sheet, i, 5).trim();
                        p.setOrgFullName(orgFullName);
                    }else{
                        p.setOrgFullName(getCellCont(sheet, i, 5));
                    }

                    if(null!=getCellCont(sheet, i, 6)){
                        //去除中文逗号
                        String orgDept=getCellCont(sheet, i, 6).replace("，",",").trim();
                        p.setOrgDeptName(orgDept);
                    }else{
                        p.setOrgDeptName(getCellCont(sheet, i, 6));
                    }

                    p.setSkill(getCellCont(sheet, i, 7));

                    p.setEmail(getCellCont(sheet, i, 8));
                    p.setPhone(getCellCont(sheet, i, 9));
                    p.setOfficeTel(getCellCont(sheet, i, 10));
                    p.setJxzc(getCellCont(sheet, i, 11));
                    p.setLczc(getCellCont(sheet, i, 12));
                    p.setXlzc(getCellCont(sheet, i, 13));
                    p.setXzzc(getCellCont(sheet, i, 14));
                    p.setIntroduction(getCellCont(sheet, i, 15));
                    p.setWorkPortal(getCellCont(sheet, i, 16));
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
