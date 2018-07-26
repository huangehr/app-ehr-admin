package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.organization.model.OrgMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

/**
 * Created by zdm on 2017/10/19
 */
public class OrgMsgModelWriter extends AExcelWriter {

    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"机构ID", "机构名称", "是否基层单位", "上级机构ID", "是否启用", "机构变动情况", "组织机构代码", "机构分类管理代码", "经济类型代码", "卫生机构类别代码", "卫生机构类别代码名称", "行政区划代码", "街道/乡镇代码",
                "医院等级（级）", "医院等级（等）", "设置/主办单位(村卫生室不填)", "政府办机构隶属关系", "是否填报出院病人表", "是否代报诊所", "是否代报村卫生室", "诊所、村卫生室所属代报机构",
                "单位开业/成立时间", "注册资金(万元)", "法定代表人(负责人)", "是否分支机构", "地址", "邮政编码", "电话号码", "电子邮箱", "单位网站域名", "批准文号/注册号",
                "登记批准机构", "办证日期", "经办人", "录入人", "新增机构创建时间", "作废时间", "最后修改时间", "有效期起", "有效期止", "健康之路同步机构ID"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    private String getErrorInfo(OrgMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("id")) ? "" : m.findErrorMsg("id") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("fullName")) ? "" : m.findErrorMsg("fullName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("basicUnitFlag")) ? "" : m.findErrorMsg("basicUnitFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("parentHosId")) ? "" : m.findErrorMsg("parentHosId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("activityFlag")) ? "" : m.findErrorMsg("activityFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgChanges")) ? "" : m.findErrorMsg("orgChanges") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosManageType")) ? "" : m.findErrorMsg("hosManageType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosEconomic")) ? "" : m.findErrorMsg("hosEconomic") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosTypeId")) ? "" : m.findErrorMsg("hosTypeId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosTypeName")) ? "" : m.findErrorMsg("hosTypeName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("administrativeDivision")) ? "" : m.findErrorMsg("administrativeDivision") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("streetId")) ? "" : m.findErrorMsg("streetId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("levelId")) ? "" : m.findErrorMsg("levelId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosHierarchy")) ? "" : m.findErrorMsg("hosHierarchy") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hostUnit")) ? "" : m.findErrorMsg("hostUnit") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("ascriptionType")) ? "" : m.findErrorMsg("ascriptionType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("dischargePatientFlag")) ? "" : m.findErrorMsg("dischargePatientFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("reportingClinicFlag")) ? "" : m.findErrorMsg("reportingClinicFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("reportingVillageClinicFlag")) ? "" : m.findErrorMsg("reportingVillageClinicFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("reportingOrg")) ? "" : m.findErrorMsg("reportingOrg") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("foundingTime")) ? "" : m.findErrorMsg("foundingTime") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("registeredCapital")) ? "" : m.findErrorMsg("registeredCapital") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("legalPerson")) ? "" : m.findErrorMsg("legalPerson") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("branchOrgFlag")) ? "" : m.findErrorMsg("branchOrgFlag") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("location")) ? "" : m.findErrorMsg("location") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("postalcode")) ? "" : m.findErrorMsg("postalcode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("tel")) ? "" : m.findErrorMsg("tel") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("email")) ? "" : m.findErrorMsg("email") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("domainName")) ? "" : m.findErrorMsg("domainName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("registrationNumber")) ? "" : m.findErrorMsg("registrationNumber") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("registrationRatificationAgency")) ? "" : m.findErrorMsg("registrationRatificationAgency") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("certificateDate")) ? "" : m.findErrorMsg("certificateDate") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("operator")) ? "" : m.findErrorMsg("operator") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("entryStaff")) ? "" : m.findErrorMsg("entryStaff") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("createTime")) ? "" : m.findErrorMsg("createTime") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("cancelTime")) ? "" : m.findErrorMsg("cancelTime") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("updateTime")) ? "" : m.findErrorMsg("updateTime") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("termValidityStart")) ? "" : m.findErrorMsg("termValidityStart") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("termValidityEnd")) ? "" : m.findErrorMsg("termValidityEnd") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jkzlOrgId")) ? "" : m.findErrorMsg("jkzlOrgId") + "；";

        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0, errorInfo.length() - 1);
    }

    @Override
    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (OrgMsgModel m : (List<OrgMsgModel>) ls) {
                addCell(ws, i, 0, m.getId(), m.findErrorMsg("id"));
                addCell(ws, i, 1, m.getFullName(), m.findErrorMsg("fullName"));
                addCell(ws, i, 2, m.getBasicUnitFlag(), m.findErrorMsg("basicUnitFlag"));
                addCell(ws, i, 3, m.getParentHosId(), m.findErrorMsg("parentHosId"));
                addCell(ws, i, 4, m.getActivityFlag(), m.findErrorMsg("activityFlag"));
                addCell(ws, i, 5, m.getOrgChanges(), m.findErrorMsg("orgChanges"));
                addCell(ws, i, 6, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 7, m.getHosManageType(), m.findErrorMsg("hosManageType"));
                addCell(ws, i, 8, m.getHosEconomic(), m.findErrorMsg("hosEconomic"));
                addCell(ws, i, 9, m.getHosTypeId(), m.findErrorMsg("hosTypeId"));
                addCell(ws, i, 10, m.getHosTypeName(), m.findErrorMsg("hosTypeName"));
                addCell(ws, i, 11, m.getAdministrativeDivision(), m.findErrorMsg("administrativeDivision"));
                addCell(ws, i, 12, m.getStreetId(), m.findErrorMsg("streetId"));
                addCell(ws, i, 13, m.getLevelId(), m.findErrorMsg("levelId"));
                addCell(ws, i, 14, m.getHosHierarchy(), m.findErrorMsg("hosHierarchy"));
                addCell(ws, i, 15, m.getHostUnit(), m.findErrorMsg("hostUnit"));
                addCell(ws, i, 16, m.getAscriptionType(), m.findErrorMsg("ascriptionType"));
                addCell(ws, i, 17, m.getDischargePatientFlag(), m.findErrorMsg("dischargePatientFlag"));
                addCell(ws, i, 18, m.getReportingClinicFlag(), m.findErrorMsg("reportingClinicFlag"));
                addCell(ws, i, 19, m.getReportingVillageClinicFlag(), m.findErrorMsg("reportingVillageClinicFlag"));
                addCell(ws, i, 20, m.getReportingOrg(), m.findErrorMsg("reportingOrg"));
                addCell(ws, i, 21, m.getFoundingTime(), m.findErrorMsg("foundingTime"));
                addCell(ws, i, 22, m.getRegisteredCapital(), m.findErrorMsg("registeredCapital"));
                addCell(ws, i, 23, m.getLegalPerson(), m.findErrorMsg("legalPerson"));
                addCell(ws, i, 24, m.getBranchOrgFlag(), m.findErrorMsg("branchOrgFlag"));
                addCell(ws, i, 25, m.getLocation(), m.findErrorMsg("location"));
                addCell(ws, i, 26, m.getPostalcode(), m.findErrorMsg("postalcode"));
                addCell(ws, i, 27, m.getTel(), m.findErrorMsg("tel"));
                addCell(ws, i, 28, m.getEmail(), m.findErrorMsg("email"));
                addCell(ws, i, 29, m.getDomainName(), m.findErrorMsg("domainName"));
                addCell(ws, i, 30, m.getRegistrationNumber(), m.findErrorMsg("registrationNumber"));
                addCell(ws, i, 31, m.getRegistrationRatificationAgency(), m.findErrorMsg("registrationRatificationAgency"));
                addCell(ws, i, 32, m.getCertificateDate(), m.findErrorMsg("certificateDate"));
                addCell(ws, i, 33, m.getOperator(), m.findErrorMsg("operator"));
                addCell(ws, i, 34, m.getEntryStaff(), m.findErrorMsg("entryStaff"));
                addCell(ws, i, 35, m.getCreateTime(), m.findErrorMsg("createTime"));
                addCell(ws, i, 36, m.getCancelTime(), m.findErrorMsg("cancelTime"));
                addCell(ws, i, 37, m.getUpdateTime(), m.findErrorMsg("updateTime"));
                addCell(ws, i, 38, m.getTermValidityStart(), m.findErrorMsg("termValidityStart"));
                addCell(ws, i, 39, m.getTermValidityEnd(), m.findErrorMsg("termValidityEnd"));
                addCell(ws, i, 40, m.getJkzlOrgId(), m.findErrorMsg("jkzlOrgId"));
                addCell(ws, i, 41, getErrorInfo(m), "");
                i++;
            }
            wwb.write();
            wwb.close();
        } catch (IOException e) {
            e.printStackTrace();
            if (wwb != null) {
                wwb.close();
            }
            throw e;
        }
    }
}
