package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.organization.controller.model.OrgMsgModel;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashSet;

/**
 * Created by zdm on 2017/10/19
 */
public class OrgMsgModelReader extends AExcelReader {
    @Override
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            OrgMsgModel p;
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgType", new HashSet<>());// 机构类型,如:行政\科研等
            getRepeat().put("settledWay", new HashSet<>());// 入驻方式：直连/第三方接入
            getRepeat().put("hosTypeId", new HashSet<>());// 医院类型：综合性医院/眼科医院
            getRepeat().put("ascriptionType", new HashSet<>());// 医院归属：省属/市属。
            getRepeat().put("zxy", new HashSet<>());// 中西医标识：中医/西医

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new OrgMsgModel();
                    p.setOrgCode(getCellCont(sheet, i, 0));
                    p.setFullName(getCellCont(sheet, i, 1));
                    p.setHosTypeId(getCellCont(sheet, i, 2).trim());
                    p.setAscriptionType(getCellCont(sheet, i ,3).trim());
                    p.setShortName(getCellCont(sheet, i ,4));
                    p.setOrgType(getCellCont(sheet, i, 5).trim());
                    p.setLevelId(getCellCont(sheet, i, 6));
                    p.setLegalPerson(getCellCont(sheet, i, 7));
                    p.setAdmin(getCellCont(sheet, i, 8));
                    p.setPhone(getCellCont(sheet, i, 9));
                    p.setZxy(getCellCont(sheet, i, 10).trim());
                    p.setBerth(getCellCont(sheet,i,11));
                    p.setProvinceName(getCellCont(sheet, i, 12).trim());
                    p.setCityName(getCellCont(sheet, i, 13).trim());
                    p.setDistrict(getCellCont(sheet, i, 14).trim());
                    p.setTown(getCellCont(sheet, i, 15).trim());
                    p.setStreet(getCellCont(sheet, i, 16));
                    p.setTraffic(getCellCont(sheet, i ,17));
                    p.setSettledWay(getCellCont(sheet, i ,18).trim());
                    p.setIng(getCellCont(sheet, i, 19));
                    p.setLat(getCellCont(sheet, i, 20));
                    p.setTags(getCellCont(sheet, i, 21));
                    p.setIntroduction(getCellCont(sheet, i, 22));

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
