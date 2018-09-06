package com.yihu.ehr.emergency.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.Title;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import org.springframework.util.StringUtils;

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
@Title(names= "{'车牌号码', '初始经度','初始纬度', '归属片区', '所属医院编码', '所属医院名称', '随车手机号码', '百度鹰眼设备号'}")
public class AmbulanceMsgModel extends ExcelUtil implements Validation {

    @Location(x=0)
    @ValidRepeat
    private String id; //车牌号码

    @Location(x=1)
    private double initLongitude=0.0; //初始经度

    @Location(x=2)
    private double initLatitude=0.0;//初始纬度

    @Location(x=3)
    private String district; //归属片区

    @Location(x=4)
    @ValidRepeat
    private String orgCode; //所属医院编码

    @Location(x=5)
    @ValidRepeat
    private String orgName;//所属医院名称

    @Location(x=6)
    @ValidRepeat
    private String phone;//随车手机号码

    private String status="0"; //状态：0为待命中，1为执勤中，2为不可用

    @Location(x=7)
    private String entityName;//百度鹰眼设备号
    //创建者
    private String creator;



    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!repeatMap.get("id").add(id)){
            valid = 0;
            addErrorMsg("id", "车牌号重复！" );
        }
        if(!repeatMap.get("phone").add(phone)){
            valid = 0;
            addErrorMsg("phone", "随车手机号重复！" );
        }

        String validatePhone="^1[3|4|5|7|8][0-9]{9}$";
        //正则表达式的模式
        Pattern vPhonePa = Pattern.compile(validatePhone);
        //正则表达式的匹配器
        Matcher p = vPhonePa.matcher(phone);
        //进行正则匹配
        boolean phoneValue= p.matches();
        if(!phoneValue){
            valid = 0;
            addErrorMsg("phone", "请输入正确的手机号码！" );
        }

        if(!StringUtils.isEmpty(phone)){
            repeatMap.get("phone").add(phone);
        }
        if(!StringUtils.isEmpty(orgCode)){
            repeatMap.get("orgCode").add(orgCode);
        }
        if(!StringUtils.isEmpty(orgName)){
            repeatMap.get("orgName").add(orgName);
        }
        return valid;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getOrgName() {
        return orgName;
    }

    public void setOrgName(String orgName) {
        this.orgName = orgName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public double getInitLongitude() {
        return initLongitude;
    }

    public void setInitLongitude(double initLongitude) {
        this.initLongitude = initLongitude;
    }

    public double getInitLatitude() {
        return initLatitude;
    }

    public void setInitLatitude(double initLatitude) {
        this.initLatitude = initLatitude;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }
}
