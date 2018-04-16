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
@Title(names= "{'机构代码', '机构全名','医院类型', '医院归属', '机构简称', '机构类型', '医院等级', '医院法人', '联系人', '联系方式', '中西医标识', '床位', '机构地址', '交通路线', '入驻方式', '经度', '纬度', '标签', '医院简介','医院等次','经济类型代码','卫生机构分类','卫生机构大分类','机构性质1','机构性质Ⅱ','是否开放显示','健康之路机构id'}")
public class OrgMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String orgCode;         // 机构代码,对医院编码属性需要调研
    @Location(x=1)
    private String fullName;        // 全名
    @Location(x=2)
    private String hosTypeId; //医院类型
    @Location(x=3)
    private String ascriptionType;// 医院归属  1.部属医院2.省属医院3.市属医院9：未知
    @Location(x=4)
    private String shortName;        // 简称
    @Location(x=5)
    private String orgType;        // 机构类型,如:行政\科研等
    @Location(x=6)
    private String levelId;  //医院等级
    @Location(x=7)
    private String legalPerson;//医院法人
    @Location(x=8)
    private String admin;            // 联系人
    @Location(x=9)
    @ValidRepeat
    private String phone;   // 联系方式
    @Location(x=10)
    private String zxy;// 中西医标识
    @Location(x=11)
    private String berth;//核定床位
    private String location;        // 机构地址
    private String provinceId;
    @Location(x=12)
    private String provinceName;// 机构地址--省
    private String cityId;
    @Location(x=13)
    private String cityName;// 机构地址---市
    private String districtId;
    @Location(x=14)
    private String district;// 机构地址---县
    @Location(x=15)
    private String town;// 机构地址---镇
    @Location(x=16)
    private String street;// 机构地址--街道
    @Location(x=17)
    private String traffic;// 交通路线
    @Location(x=18)
    private String settledWay;    // 接入方式：直连/平台接入
    @Location(x=19)
    private String ing;//经度
    @Location(x=20)
    private String lat;//纬度
    @Location(x=21)
    private String tags;//标签
    @Location(x=22)
    private String introduction;//简介

    private boolean isAdDivisionExist;//判断是否存在最小行政区域
    private Integer administrativeDivision;//最小行政区域id

    private String hosHierarchy;//医院等次 ：1：特等、2：甲等、3：乙等、4：丙等、9：未评

    private String hosEconomic;//经济类型代码 与 资源字典对应

    private String classification;//卫生机构分类，值参考系统字典卫生机构分类

    private String bigClassification;//卫生机构大分类，值参考系统字典卫生机构大分类

    private String nature;//机构性质1，1公立、2民营

    private String branchType;//机构性质Ⅱ，1总院、2分院

    private String displayStatus;//与总部同步数据补充字段是否开放显示：0：不显示 1:显示

    private String jkzlOrgId;//总部机构id-同步数据使用

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getOrgCode() {
        return orgCode;
    }
    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public String getDistrictId() {
        return districtId;
    }

    public void setDistrictId(String districtId) {
        this.districtId = districtId;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getAdmin() {
        return admin;
    }
    public void setAdmin(String admin) {
        this.admin = admin;
    }

    public String getFullName() {
        return fullName;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }

    public String getSettledWay() {
        return settledWay;
    }
    public void setSettledWay(String settledWay) {
        this.settledWay = settledWay;
    }

    public String getShortName() {
        return shortName;
    }
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }

    public String getOrgType() {
        return orgType;
    }
    public void setOrgType(String orgType) {
        this.orgType = orgType;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getTraffic() {
        return traffic;
    }

    public void setTraffic(String traffic) {
        this.traffic = traffic;
    }

    public String getProvinceId() {
        return provinceId;
    }

    public void setProvinceId(String provinceId) {
        this.provinceId = provinceId;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getHosTypeId() {
        return hosTypeId;
    }

    public void setHosTypeId(String hosTypeId) {
        this.hosTypeId = hosTypeId;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getLegalPerson() {
        return legalPerson;
    }

    public void setLegalPerson(String legalPerson) {
        this.legalPerson = legalPerson;
    }

    public String getLevelId() {
        return levelId;
    }

    public void setLevelId(String levelId) {
        this.levelId = levelId;
    }

    public String getZxy() {
        return zxy;
    }

    public void setZxy(String zxy) {
        this.zxy = zxy;
    }

    public String getIng() {
        return ing;
    }

    public void setIng(String ing) {
        this.ing = ing;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getTown() {
        return town;
    }

    public void setTown(String town) {
        this.town = town;
    }

    public String getBerth() {
        return berth;
    }

    public void setBerth(String berth) {
        this.berth = berth;
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

    public boolean isAdDivisionExist() {
        return isAdDivisionExist;
    }

    public void setAdDivisionExist(boolean adDivisionExist) {
        isAdDivisionExist = adDivisionExist;
    }

    public Integer getAdministrativeDivision() {
        return administrativeDivision;
    }

    public void setAdministrativeDivision(Integer administrativeDivision) {
        this.administrativeDivision = administrativeDivision;
    }

    public String getHosHierarchy() {
        return hosHierarchy;
    }

    public void setHosHierarchy(String hosHierarchy) {
        this.hosHierarchy = hosHierarchy;
    }

    public String getHosEconomic() {
        return hosEconomic;
    }

    public void setHosEconomic(String hosEconomic) {
        this.hosEconomic = hosEconomic;
    }

    public String getClassification() {
        return classification;
    }

    public void setClassification(String classification) {
        this.classification = classification;
    }

    public String getBigClassification() {
        return bigClassification;
    }

    public void setBigClassification(String bigClassification) {
        this.bigClassification = bigClassification;
    }

    public String getNature() {
        return nature;
    }

    public void setNature(String nature) {
        this.nature = nature;
    }

    public String getBranchType() {
        return branchType;
    }

    public void setBranchType(String branchType) {
        this.branchType = branchType;
    }

    public String getDisplayStatus() {
        return displayStatus;
    }

    public void setDisplayStatus(String displayStatus) {
        this.displayStatus = displayStatus;
    }

    public String getJkzlOrgId() {
        return jkzlOrgId;
    }

    public void setJkzlOrgId(String jkzlOrgId) {
        this.jkzlOrgId = jkzlOrgId;
    }
}
