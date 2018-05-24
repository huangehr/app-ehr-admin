package com.yihu.ehr.user.controller.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
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
 * @author lincl
 * @version 1.0
 * @created 2017/6/22
 */
@Row(start = 1)
@Title(names= "{'医生账号', '姓名','身份证号', '性别', '机构代码', '机构全称', '科室名称', '医生专长', '邮箱', '联系电话', '类别', '执业类别', '从事专业类别代码', '执业范围', '执业状态', '是否注册', '是否制证', '技术职称', '学历', '行政职称', '办公电话（固）', '医生门户首页', '简介'}")
public class DoctorMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String code;
    @Location(x=1)
    private String name;
    @Location(x=2)
    @ValidRepeat
    private String idCardNo;
    @Location(x=3)
    private String sex;
    @Location(x=4)
    @ValidRepeat
    private String orgCode;
    @Location(x=5)
    @ValidRepeat
    private String orgFullName;
    @Location(x=6)
    @ValidRepeat
    private String orgDeptName;
    @Location(x=7)
    private String skill;
    @Location(x=8)
    @ValidRepeat
    private String email;
    @Location(x=9)
    @ValidRepeat
    private String phone;
    /**新版本模板:参考数据字典人员类别，旧版本模板：医生-医师（1），护士-注册护士（8）*/
    @Location(x=10)
    @ValidRepeat
    private String roleType;
    @Location(x=11)
    @ValidRepeat
    private String jobType;
    /**从事专业类别代码*/
    @Location(x=12)
    @ValidRepeat
    private String jobLevel;
    /**执业范围*/
    @Location(x=13)
    @ValidRepeat
    private String jobScope;
    /**执业状态*/
    @Location(x=14)
    @ValidRepeat
    private String jobState;
    /**是否注册*/
    @Location(x=15)
    private String registerFlag;
    /**是否制证*/
    @Location(x=16)
    private String jxzc;
    /**技术职称*/
    @Location(x=17)
    @ValidRepeat
    private String lczc;
    /**学历*/
    @Location(x=18)
    private String xlzc;
    /**行政职称*/
    @Location(x=19)
    private String xzzc;
    @Location(x=20)
    private String officeTel;
    @Location(x=21)
    private String workPortal;
    @Location(x=22)
    private String introduction;

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!repeatMap.get("code").add(code)){
            valid = 0;
            addErrorMsg("code", "医生账户重复！" );
        }
        if(!repeatMap.get("phone").add(phone)){
            valid = 0;
            addErrorMsg("phone", "医生联系电话重复！" );
        }
        if(!repeatMap.get("email").add(email)){
            valid = 0;
            addErrorMsg("email", "医生邮箱重复！" );
        }
        if(!repeatMap.get("idCardNo").add(idCardNo)){
            valid = 0;
            addErrorMsg("idCardNo", "医生身份证号重复！" );
        }
        String validateEmail="^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$";
        Pattern vEmailPa = Pattern.compile(validateEmail);
        //正则表达式的匹配器
        Matcher m = vEmailPa.matcher(email);
        //进行正则匹配
        boolean emailValue= m.matches();
        if(!emailValue){
            valid = 0;
            addErrorMsg("email", "请输入有效的邮件地址,如 username123@example.com！" );
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

        if(idCardNo.length()<15 && idCardNo.length()>18){
            valid = 0;
            addErrorMsg("idCardNo", "请输入正确的身份证号码！" );
        }
        return valid;
    }


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

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getSkill() {
        return skill;
    }

    public void setSkill(String skill) {
        this.skill = skill;
    }

    public String getWorkPortal() {
        return workPortal;
    }

    public void setWorkPortal(String workPortal) {
        this.workPortal = workPortal;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getOfficeTel() {
        return officeTel;
    }

    public void setOfficeTel(String officeTel) {
        this.officeTel = officeTel;
    }

    public String getJxzc() {
        return jxzc;
    }

    public void setJxzc(String jxzc) {
        this.jxzc = jxzc;
    }

    public String getLczc() {
        return lczc;
    }

    public void setLczc(String lczc) {
        this.lczc = lczc;
    }

    public String getXlzc() {
        return xlzc;
    }

    public void setXlzc(String xlzc) {
        this.xlzc = xlzc;
    }

    public String getXzzc() {
        return xzzc;
    }

    public void setXzzc(String xzzc) {
        this.xzzc = xzzc;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getIdCardNo() {
        return idCardNo;
    }

    public void setIdCardNo(String idCardNo) {
        this.idCardNo = idCardNo;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode;
    }

    public String getOrgFullName() {
        return orgFullName;
    }

    public void setOrgFullName(String orgFullName) {
        this.orgFullName = orgFullName;
    }

    public String getOrgDeptName() {
        return orgDeptName;
    }

    public void setOrgDeptName(String orgDeptName) {
        this.orgDeptName = orgDeptName;
    }

    public String getRoleType() {
        return roleType;
    }

    public void setRoleType(String roleType) {
        this.roleType = roleType;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getJobLevel() {
        return jobLevel;
    }

    public void setJobLevel(String jobLevel) {
        this.jobLevel = jobLevel;
    }

    public String getJobScope() {
        return jobScope;
    }

    public void setJobScope(String jobScope) {
        this.jobScope = jobScope;
    }

    public String getJobState() {
        return jobState;
    }

    public void setJobState(String jobState) {
        this.jobState = jobState;
    }

    public String getRegisterFlag() {
        return registerFlag;
    }

    public void setRegisterFlag(String registerFlag) {
        this.registerFlag = registerFlag;
    }
}
