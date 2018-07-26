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
            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) {
                    continue;
                }
                for (int i = 1; i < rows; i++, j++) {
                    orgMsgModel = new OrgMsgModel();
                    orgMsgModel.setId(null == getCellCont(sheet, i, 0) ? "" : getCellCont(sheet, i, 0).trim());
                    orgMsgModel.setFullName(null == getCellCont(sheet, i, 1) ? "" : getCellCont(sheet, i, 1).trim());
                    orgMsgModel.setBasicUnitFlag(null == getCellCont(sheet, i, 2).trim() ? "" : getCellCont(sheet, i, 2).trim());
                    orgMsgModel.setParentHosId(null == getCellCont(sheet, i, 3).trim() ? "" : getCellCont(sheet, i, 3).trim());
                    orgMsgModel.setActivityFlag(null == getCellCont(sheet, i, 4) ? "" : getCellCont(sheet, i, 4).trim());
                    orgMsgModel.setOrgChanges(null == getCellCont(sheet, i, 5).trim() ? "" : getCellCont(sheet, i, 5).trim());
                    orgMsgModel.setOrgCode(null == getCellCont(sheet, i, 6) ? "" : getCellCont(sheet, i, 6).trim());
                    orgMsgModel.setHosManageType(null == getCellCont(sheet, i, 7) ? "" : getCellCont(sheet, i, 7).trim());
                    orgMsgModel.setHosEconomic(null == getCellCont(sheet, i, 8) ? "" : getCellCont(sheet, i, 8).trim());
                    orgMsgModel.setHosTypeId(null == getCellCont(sheet, i, 9) ? "" : getCellCont(sheet, i, 9).trim());
                    orgMsgModel.setHosTypeName(null == getCellCont(sheet, i, 10).trim() ? "" : getCellCont(sheet, i, 10).trim());
                    orgMsgModel.setAdministrativeDivision(null == getCellCont(sheet, i, 11) ? "" : getCellCont(sheet, i, 11).trim());
                    orgMsgModel.setStreetId(null == getCellCont(sheet, i, 12).trim() ? "" : getCellCont(sheet, i, 12).trim());
                    orgMsgModel.setLevelId(null == getCellCont(sheet, i, 13).trim() ? "" : getCellCont(sheet, i, 13).trim());
                    orgMsgModel.setHosHierarchy(null == getCellCont(sheet, i, 14).trim() ? "" : getCellCont(sheet, i, 14).trim());
                    orgMsgModel.setHostUnit(null == getCellCont(sheet, i, 15).trim() ? "" : getCellCont(sheet, i, 15).trim());
                    orgMsgModel.setAscriptionType(null == getCellCont(sheet, i, 16) ? "" : getCellCont(sheet, i, 16).trim());
                    orgMsgModel.setDischargePatientFlag(null == getCellCont(sheet, i, 17) ? "" : getCellCont(sheet, i, 17).trim());
                    orgMsgModel.setReportingClinicFlag(null == getCellCont(sheet, i, 18).trim() ? "" : getCellCont(sheet, i, 18).trim());
                    orgMsgModel.setReportingVillageClinicFlag(null == getCellCont(sheet, i, 19) ? "" : getCellCont(sheet, i, 19).trim());
                    orgMsgModel.setReportingOrg(null == getCellCont(sheet, i, 20) ? "" : getCellCont(sheet, i, 20).trim());
                    orgMsgModel.setFoundingTime(null == getCellCont(sheet, i, 21) ? "" : getCellCont(sheet, i, 21).trim());
                    orgMsgModel.setRegisteredCapital(null == getCellCont(sheet, i, 22) ? "" : getCellCont(sheet, i, 22).trim());
                    orgMsgModel.setLegalPerson(null == getCellCont(sheet, i, 23) ? "" : getCellCont(sheet, i, 23).trim());
                    orgMsgModel.setHosEconomic(null == getCellCont(sheet, i, 24) ? "" : getCellCont(sheet, i, 24).trim());
                    orgMsgModel.setBranchOrgFlag(null == getCellCont(sheet, i, 25) ? "" : getCellCont(sheet, i, 25).trim());
                    orgMsgModel.setLocation(null == getCellCont(sheet, i, 26) ? "" : getCellCont(sheet, i, 26).trim());
                    orgMsgModel.setPostalcode(null == getCellCont(sheet, i, 27) ? "" : getCellCont(sheet, i, 27).trim());
                    orgMsgModel.setTel(null == getCellCont(sheet, i, 28) ? "" : getCellCont(sheet, i, 28).trim());
                    orgMsgModel.setEmail(null == getCellCont(sheet, i, 29) ? "" : getCellCont(sheet, i, 29).trim());
                    orgMsgModel.setDomainName(null == getCellCont(sheet, i, 30) ? "" : getCellCont(sheet, i, 30).trim());
                    orgMsgModel.setRegistrationNumber(null == getCellCont(sheet, i, 31) ? "" : getCellCont(sheet, i, 31).trim());
                    orgMsgModel.setRegistrationRatificationAgency(null == getCellCont(sheet, i, 32) ? "" : getCellCont(sheet, i, 32).trim());
                    orgMsgModel.setCertificateDate(null == getCellCont(sheet, i, 33) ? "" : getCellCont(sheet, i, 33).trim());
                    orgMsgModel.setOperator(null == getCellCont(sheet, i, 34) ? "" : getCellCont(sheet, i, 34).trim());
                    orgMsgModel.setEntryStaff(null == getCellCont(sheet, i, 35) ? "" : getCellCont(sheet, i, 35).trim());
                    orgMsgModel.setCreateTime(null == getCellCont(sheet, i, 36) ? "" : getCellCont(sheet, i, 36).trim());
                    orgMsgModel.setUpdateTime(null == getCellCont(sheet, i, 37) ? "" : getCellCont(sheet, i, 37).trim());
                    orgMsgModel.setTermValidityStart(null == getCellCont(sheet, i, 38) ? "" : getCellCont(sheet, i, 38).trim());
                    orgMsgModel.setTermValidityEnd(null == getCellCont(sheet, i, 39) ? "" : getCellCont(sheet, i, 39).trim());
                    orgMsgModel.setJkzlOrgId(null == getCellCont(sheet, i, 40) ? "" : getCellCont(sheet, i, 40).trim());
                    orgMsgModel.setExcelSeq(j);
                    int rs = orgMsgModel.validate(repeat);
                    if (rs == 0) {
                        errorLs.add(orgMsgModel);
                    } else if (rs == 1) {
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
