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
@Title(names= "{'医生账号', '姓名', '性别', '医生专长', '医生门户首页', '邮箱', '联系电话', '办公电话（固）'}")
public class DoctorMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String code;
    @Location(x=1)
    private String name;
    @Location(x=2)
    private String sex;
    @Location(x=3)
    private String skill;
    @Location(x=4)
    private String workPortal;
    @Location(x=5)
    @ValidRepeat
    private String email;
    @Location(x=6)
    @ValidRepeat
    private String phone;
    @Location(x=7)
    @ValidRepeat
    private String officeTel;



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
//        if(!RegUtil.regCode(stdCode)){
//            addErrorMsg("stdCode", "只允许输入数字、英文、小数点与下划线！");
//            valid = 0;
//        }

//        if(!RegUtil.regLen(name)){
//            valid = 0;
//            addErrorMsg("name", RegUtil.lenMsg);
//        }
//        ;
//        String validateEmail="^[a-zA-Z0-9_-]@[a-zA-Z0-9_-](\\.[a-zA-Z0-9_-])$";
//        Pattern vEmailPa = Pattern.compile(validateEmail);
//        //正则表达式的匹配器
//        Matcher m = vEmailPa.matcher(email);
//        //进行正则匹配
//        boolean emailValue= m.matches();
//        if(!emailValue){
//            valid = 0;
//            addErrorMsg("email", "请输入有效的邮件地址,如 username@example.com！" );
//        }

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

//        String validateOfficePhone="^\\d{3,4}-\\d{7,8}$";
//        Pattern vOfficePa = Pattern.compile(validateOfficePhone);
//        //正则表达式的匹配器
//        Matcher o= vOfficePa.matcher(officeTel);
//        //进行正则匹配
//        boolean OfficeValue= o.matches();
//        if(!OfficeValue){
//            valid = 0;
//            addErrorMsg("officeTel", "请输入正确的电话号码,如:010-29392929！" );
//        }


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

}
