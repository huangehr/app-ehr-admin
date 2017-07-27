package com.yihu.ehr.user.controller.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.Title;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;

import java.util.Map;
import java.util.Set;

/**
 * Created by xingwang on 2017/7/14.
 */
@Row(start = 1)
@Title(names= "{'部门编号', '部门名称','父级部门编号', '父级部门名称', '科室电话', '科室荣誉(国家重点科室,省级重点科室,医院特色专科)', '机构代码', '所属机构', '科室介绍', '科室位置', '科室类型'}")
public class OrgDeptMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String code;
    @Location(x=1)
    @ValidRepeat
    private String name;
    @Location(x=2)
//    @ValidRepeat
    private String parentDeptId;
    @Location(x=3)
    private String parentDeptName;
    @Location(x=4)
    private String phone;
    @Location(x=5)
    private String gloryId;
    @Location(x=6)
    @ValidRepeat
    private String orgCode;
    @Location(x=7)
//    @ValidRepeat
    private String orgName;
    @Location(x=8)
//    @ValidRepeat
    private String introduction;
    @Location(x=9)
    private String place;
    @Location(x=10)
    private String pyCode;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getParentDeptId() {
        return parentDeptId;
    }

    public void setParentDeptId(String parentDeptId) {
        this.parentDeptId = parentDeptId;
    }

    public String getParentDeptName() {
        return parentDeptName;
    }

    public void setParentDeptName(String parentDeptName) {
        this.parentDeptName = parentDeptName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGloryId() {
        return gloryId;
    }

    public void setGloryId(String gloryId) {
        this.gloryId = gloryId;
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

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public String getPyCode() {
        return pyCode;
    }

    public void setPyCode(String pyCode) {
        this.pyCode = pyCode;
    }

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!repeatMap.get("code").add(code)){
            valid = 0;
            addErrorMsg("code", "部门编号重复！" );
        }

        if(!repeatMap.get("name").add(name)){
//            valid = 0;
//            addErrorMsg("name", "部门名称重复！" );
        }

        if(!repeatMap.get("orgCode").add(orgCode)){
//            valid = 0;
//            addErrorMsg("orgCode", "机构代码重复！" );
        }
        return valid;
    }
}
