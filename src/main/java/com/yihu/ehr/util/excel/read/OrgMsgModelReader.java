package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.organization.model.OrgMsgModel;
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
            OrgMsgModel orgMsgModel;
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgType", new HashSet<>());// 机构类型,如:行政\科研等
            getRepeat().put("settledWay", new HashSet<>());// 入驻方式：直连/第三方接入
            getRepeat().put("hosTypeId", new HashSet<>());// 医院类型：综合性医院/眼科医院
            getRepeat().put("ascriptionType", new HashSet<>());// 医院归属：省属/市属。
            getRepeat().put("zxy", new HashSet<>());// 中西医标识：中医/西医

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0){
                    continue;
                }
                for (int i = 1; i < rows; i++, j++) {
                    orgMsgModel = new OrgMsgModel();
                    orgMsgModel.setOrgCode(getCellCont(sheet, i, 0));
                    orgMsgModel.setFullName(getCellCont(sheet, i, 1));
                    orgMsgModel.setHosTypeId(getCellCont(sheet, i, 2).trim());
                    orgMsgModel.setAscriptionType(getCellCont(sheet, i ,3).trim());
                    orgMsgModel.setShortName(getCellCont(sheet, i ,4));
                    orgMsgModel.setOrgType(getCellCont(sheet, i, 5).trim());
                    orgMsgModel.setLevelId(getCellCont(sheet, i, 6));
                    orgMsgModel.setLegalPerson(getCellCont(sheet, i, 7));
                    orgMsgModel.setAdmin(getCellCont(sheet, i, 8));
                    orgMsgModel.setPhone(getCellCont(sheet, i, 9));
                    orgMsgModel.setZxy(getCellCont(sheet, i, 10).trim());
                    orgMsgModel.setBerth(getCellCont(sheet,i,11));
                    orgMsgModel.setProvinceName(getCellCont(sheet, i, 12).trim());
                    orgMsgModel.setCityName(getCellCont(sheet, i, 13).trim());
                    orgMsgModel.setDistrict(getCellCont(sheet, i, 14).trim());
                    orgMsgModel.setTown(getCellCont(sheet, i, 15).trim());
                    orgMsgModel.setStreet(getCellCont(sheet, i, 16));
                    orgMsgModel.setTraffic(getCellCont(sheet, i ,17));
                    orgMsgModel.setSettledWay(getCellCont(sheet, i ,18).trim());
                    orgMsgModel.setIng(getCellCont(sheet, i, 19));
                    orgMsgModel.setLat(getCellCont(sheet, i, 20));
                    orgMsgModel.setTags(getCellCont(sheet, i, 21));
                    orgMsgModel.setIntroduction(getCellCont(sheet, i, 22));

                    orgMsgModel.setHosHierarchy(getCellCont(sheet, i, 23));
                    orgMsgModel.setHosEconomic(getCellCont(sheet, i, 24));
                    orgMsgModel.setClassification(getCellCont(sheet, i, 25));
                    orgMsgModel.setBigClassification(getCellCont(sheet, i, 26));
                    orgMsgModel.setNature(getCellCont(sheet, i, 27));
                    orgMsgModel.setBranchType(getCellCont(sheet, i, 28));
                    orgMsgModel.setDisplayStatus(getCellCont(sheet, i, 29));
                    orgMsgModel.setJkzlOrgId(getCellCont(sheet, i, 30));

                    orgMsgModel.setExcelSeq(j);

                    int rs = orgMsgModel.validate(repeat);
                    if (rs == 0){
                        errorLs.add(orgMsgModel);
                    } else if (rs == 1){
                        correctLs.add(orgMsgModel);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("模板不正确，请下载新的模板，并按照示例正确填写后上传！");
        } finally {
            if (rwb != null) {
                rwb.close();
            }
        }
    }
}
