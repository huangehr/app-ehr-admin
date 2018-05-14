package com.yihu.ehr.device.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.Title;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author zdm
 * @version 1.0
 * @created 2017/11/15
 */
@Row(start = 1)
@Title(names= "{'设备名称','归属机构代码', '归属机构名称','设备代号', '采购数量', '产地', '厂家', '设备型号', " +
        "'采购时间','新旧情况','设备价格','使用年限','状态','是否配置GPS'}")
public class DeviceMsgModel extends ExcelUtil implements Validation {

    @Location(x=0)
    private String deviceName; //设备名称

    @Location(x=1)
    @ValidRepeat
    private String orgCode; //归属机构代码

    @Location(x=2)
    @ValidRepeat
    private String orgName; //归属机构名称

    @Location(x=3)
    private String deviceType;//设备代号

    @Location(x=4)
    private String purchaseNum;//采购数量

    /**
     * 产地
     * 1进口 2国产/合资
     */
    @Location(x=5)
    private String originPlace;

    /**
     * 厂家
     */
    @Location(x=6)
    private String manufacturerName;

    /**
     * 设备型号
     */
    @Location(x=7)
    private String deviceModel;

    /**
     * 采购时间
     */
    @Location(x=8)
    private String purchaseTime;


    /**
     * 新旧情况 1新设备 2	二手设备
     */
    @Location(x=9)
    private String isNew;

    /**
     * 设备价格
     */
    @Location(x=10)
    private double devicePrice;
    /**
     * 使用年限
     */
    @Location(x=11)
    private Integer yearLimit;

    /**
     * 状态 1启用 2未启用 3报废

     */
    @Location(x=12)
    private String status;

    /**
     * 是否配置GPS  1是 0否
     *
     */
    @Location(x=13)
    private String isGps;

    //创建者
    private String creator;


    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!StringUtils.isEmpty(orgCode)){
            repeatMap.get("orgCode").add(orgCode);
        }
        return valid;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getPurchaseNum() {
        return purchaseNum;
    }

    public void setPurchaseNum(String purchaseNum) {
        this.purchaseNum = purchaseNum;
    }

    public String getOriginPlace() {
        return originPlace;
    }

    public void setOriginPlace(String originPlace) {
        this.originPlace = originPlace;
    }

    public String getManufacturerName() {
        return manufacturerName;
    }

    public void setManufacturerName(String manufacturerName) {
        this.manufacturerName = manufacturerName;
    }

    public String getDeviceModel() {
        return deviceModel;
    }

    public void setDeviceModel(String deviceModel) {
        this.deviceModel = deviceModel;
    }

    public String getPurchaseTime() {
        return purchaseTime;
    }

    public void setPurchaseTime(String purchaseTime) {
        this.purchaseTime = purchaseTime;
    }

    public String getIsNew() {
        return isNew;
    }

    public void setIsNew(String isNew) {
        this.isNew = isNew;
    }

    public double getDevicePrice() {
        return devicePrice;
    }

    public void setDevicePrice(double devicePrice) {
        this.devicePrice = devicePrice;
    }

    public Integer getYearLimit() {
        return yearLimit;
    }

    public void setYearLimit(Integer yearLimit) {
        this.yearLimit = yearLimit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getIsGps() {
        return isGps;
    }

    public void setIsGps(String isGps) {
        this.isGps = isGps;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }
}
