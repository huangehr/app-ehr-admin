package com.yihu.ehr.organization.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.Title;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;

import java.util.*;

/**
 * Created by zdm on 2017/10/19
 */
@Row(start = 1)
@Title(names= "{'机构ID', '机构名称','是否基层单位', '上级机构ID', '是否启用', '机构变动情况', '组织机构代码', '机构分类管理代码', '经济类型代码', '卫生机构类别代码', '卫生机构类别代码名称', '行政区划代码', '街道/乡镇代码','医院等级（级）', '医院等级（等）', '设置/主办单位(村卫生室不填)', '政府办机构隶属关系', '是否填报出院病人表', '是否代报诊所', '是否代报村卫生室', '诊所、村卫生室所属代报机构','单位开业/成立时间','注册资金(万元)','法定代表人(负责人)','是否分支机构','地址','邮政编码','电话号码','电子邮箱','单位网站域名', '批准文号/注册号','登记批准机构','办证日期','经办人','录入人','新增机构创建时间','作废时间','最后修改时间','有效期起','有效期止', '健康之路同步机构ID'}")
public class OrgMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    private String id;
    @Location(x=1)
    private String fullName;
    @Location(x=2)
    private String basicUnitFlag;
    @Location(x=3)
    private String parentHosId;
    @Location(x=4)
    private String activityFlag;
    @Location(x=5)
    private String orgChanges;
    @Location(x=6)
    @ValidRepeat
    private String orgCode;
    @Location(x=7)
    private String hosManageType;
    @Location(x=8)
    private String hosEconomic;
    @Location(x=9)
    private String hosTypeId;
    @Location(x=10)
    private String hosTypeName;
    @Location(x=11)
    private String administrativeDivision;
    @Location(x=12)
    private String streetId;
    @Location(x=13)
    private String levelId;
    @Location(x=14)
    private String hosHierarchy;
    @Location(x=15)
    private String hostUnit;
    @Location(x=16)
    private String ascriptionType;
    @Location(x=17)
    private String dischargePatientFlag;
    @Location(x=18)
    private String reportingClinicFlag;
    @Location(x=19)
    private String reportingVillageClinicFlag;
    @Location(x=20)
    private String reportingOrg;
    @Location(x=21)
    private String foundingTime;
    @Location(x=22)
    private String registeredCapital;
    @Location(x=23)
    private String legalPerson;
    @Location(x=24)
    private String branchOrgFlag;
    @Location(x=25)
    private String location;
    @Location(x=26)
    private String postalcode;
    @Location(x=27)
    private String tel;
    @Location(x=28)
    private String email;
    @Location(x=29)
    private String domainName;
    @Location(x=30)
    private String registrationNumber;
    @Location(x=31)
    private String registrationRatificationAgency;
    @Location(x=32)
    private String certificateDate;
    @Location(x=33)
    private String operator;
    @Location(x=34)
    private String entryStaff;
    @Location(x=35)
    private String createTime;
    @Location(x=36)
    private String cancelTime;
    @Location(x=37)
    private String updateTime;
    @Location(x=38)
    private String termValidityStart;
    @Location(x=39)
    private String termValidityEnd;
    @Location(x=40)
    private String jkzlOrgId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getBasicUnitFlag() {
        return basicUnitFlag;
    }

    public void setBasicUnitFlag(String basicUnitFlag) {
        this.basicUnitFlag = basicUnitFlag;
    }

    public String getParentHosId() {
        return parentHosId;
    }

    public void setParentHosId(String parentHosId) {
        this.parentHosId = parentHosId;
    }

    public String getActivityFlag() {
        return activityFlag;
    }

    public void setActivityFlag(String activityFlag) {
        this.activityFlag = activityFlag;
    }

    public String getOrgChanges() {
        return orgChanges;
    }

    public void setOrgChanges(String orgChanges) {
        this.orgChanges = orgChanges;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public String getHosManageType() {
        return hosManageType;
    }

    public void setHosManageType(String hosManageType) {
        this.hosManageType = hosManageType;
    }

    public String getHosEconomic() {
        return hosEconomic;
    }

    public void setHosEconomic(String hosEconomic) {
        this.hosEconomic = hosEconomic;
    }

    public String getHosTypeId() {
        return hosTypeId;
    }

    public void setHosTypeId(String hosTypeId) {
        this.hosTypeId = hosTypeId;
    }

    public String getHosTypeName() {
        return hosTypeName;
    }

    public void setHosTypeName(String hosTypeName) {
        this.hosTypeName = hosTypeName;
    }

    public String getAdministrativeDivision() {
        return administrativeDivision;
    }

    public void setAdministrativeDivision(String administrativeDivision) {
        this.administrativeDivision = administrativeDivision;
    }

    public String getStreetId() {
        return streetId;
    }

    public void setStreetId(String streetId) {
        this.streetId = streetId;
    }

    public String getLevelId() {
        return levelId;
    }

    public void setLevelId(String levelId) {
        this.levelId = levelId;
    }

    public String getHosHierarchy() {
        return hosHierarchy;
    }

    public void setHosHierarchy(String hosHierarchy) {
        this.hosHierarchy = hosHierarchy;
    }

    public String getHostUnit() {
        return hostUnit;
    }

    public void setHostUnit(String hostUnit) {
        this.hostUnit = hostUnit;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getDischargePatientFlag() {
        return dischargePatientFlag;
    }

    public void setDischargePatientFlag(String dischargePatientFlag) {
        this.dischargePatientFlag = dischargePatientFlag;
    }

    public String getReportingClinicFlag() {
        return reportingClinicFlag;
    }

    public void setReportingClinicFlag(String reportingClinicFlag) {
        this.reportingClinicFlag = reportingClinicFlag;
    }

    public String getReportingVillageClinicFlag() {
        return reportingVillageClinicFlag;
    }

    public void setReportingVillageClinicFlag(String reportingVillageClinicFlag) {
        this.reportingVillageClinicFlag = reportingVillageClinicFlag;
    }

    public String getReportingOrg() {
        return reportingOrg;
    }

    public void setReportingOrg(String reportingOrg) {
        this.reportingOrg = reportingOrg;
    }

    public String getFoundingTime() {
        return foundingTime;
    }

    public void setFoundingTime(String foundingTime) {
        this.foundingTime = foundingTime;
    }

    public String getRegisteredCapital() {
        return registeredCapital;
    }

    public void setRegisteredCapital(String registeredCapital) {
        this.registeredCapital = registeredCapital;
    }

    public String getBranchOrgFlag() {
        return branchOrgFlag;
    }

    public void setBranchOrgFlag(String branchOrgFlag) {
        this.branchOrgFlag = branchOrgFlag;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getPostalcode() {
        return postalcode;
    }

    public void setPostalcode(String postalcode) {
        this.postalcode = postalcode;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDomainName() {
        return domainName;
    }

    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getRegistrationRatificationAgency() {
        return registrationRatificationAgency;
    }

    public void setRegistrationRatificationAgency(String registrationRatificationAgency) {
        this.registrationRatificationAgency = registrationRatificationAgency;
    }

    public String getCertificateDate() {
        return certificateDate;
    }

    public void setCertificateDate(String certificateDate) {
        this.certificateDate = certificateDate;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public String getEntryStaff() {
        return entryStaff;
    }

    public void setEntryStaff(String entryStaff) {
        this.entryStaff = entryStaff;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCancelTime() {
        return cancelTime;
    }

    public void setCancelTime(String cancelTime) {
        this.cancelTime = cancelTime;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    public String getTermValidityStart() {
        return termValidityStart;
    }

    public void setTermValidityStart(String termValidityStart) {
        this.termValidityStart = termValidityStart;
    }

    public String getTermValidityEnd() {
        return termValidityEnd;
    }

    public void setTermValidityEnd(String termValidityEnd) {
        this.termValidityEnd = termValidityEnd;
    }

    public String getJkzlOrgId() {
        return jkzlOrgId;
    }

    public void setJkzlOrgId(String jkzlOrgId) {
        this.jkzlOrgId = jkzlOrgId;
    }

    public String getLegalPerson() {
        return legalPerson;
    }

    public void setLegalPerson(String legalPerson) {
        this.legalPerson = legalPerson;
    }

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;
        if(!repeatMap.get("orgCode").add(orgCode)){
            valid = 0;
            addErrorMsg("orgCode", "机构代码重复！" );
        }
        return valid;
    }

}
