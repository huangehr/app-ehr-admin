package com.yihu.ehr.user.controller.model;

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
 * 卫统导出的医生数据导入
 *
 * @author zdm
 * @version 1.0
 * @created 2018/7/5
 */
@Row(start = 1)
@Title(names = "{'机构id', '机构编码','机构名称', '姓名', '身份证件种类', '身份证件号码', '出生日期', '性别代码', '民族代码', '参加工作日期'," +
        " '办公室电话号码', '手机号码', '所在科室代码', '科室实际名称', '从事专业类别代码', '医师/卫生监督员执业证书编码', '医师执业类别代码', " +
        "'医师执业范围代码', " + "'是否多地点执业医师', '第2执业单位的机构类别', '第3执业单位的机构类别', '是否获得国家住院医师规范化培训合格证书', '住院医师规范化培训合格证书编码', " +
        "'行政/业务管理职务代码', " + "'专业技术资格(评)代码', '专业技术职务(聘)代码', '学历代码', '学位代码', '所学专业代码', " +
        "'专业特长1', " + "'专业特长2', '专业特长3', '年内人员流动情况', '调入/调出时间', '编制情况', " +
        "'是否注册为全科医学专业', " + "'全科医生取得培训合格证书情况', '是否由乡镇卫生院或社区卫生服务机构派驻村卫生室工作', '是否从事统计信息化业务工作', '统计信息化业务工作'}")
public class WtDoctorMsgModel extends ExcelUtil implements Validation {
    @Location(x = 0)
    private String orgId;
    @Location(x = 1)
    @ValidRepeat
    private String orgCode;
    @Location(x = 2)
    private String orgFullName;
    @Location(x = 3)
    private String name;
    @Location(x = 4)
    private String sfzjzl;
    @Location(x = 5)
    @ValidRepeat
    private String idCardNo;
    @Location(x = 6)
    private String csrq;
    @Location(x = 7)
    private String sex;
    @Location(x = 8)
    private String mzdm;
    @Location(x = 9)
    private String cjgzrq;
    @Location(x = 10)
    private String officeTel;
    @Location(x = 11)
    @ValidRepeat
    private String phone;
    @Location(x = 12)
    private String szksdm;
    @Location(x = 13)
    private String dept_name;
    @Location(x = 14)
    private String role_type;
    @Location(x = 15)
    private String yszyzsbm;
    @Location(x = 16)
    private String job_type;
    @Location(x = 17)
    private String job_scope;
    @Location(x = 18)
    private String sfdddzyys;
    @Location(x = 19)
    private String dezydwjglb;
    @Location(x = 20)
    private String dszydwjglb;
    @Location(x = 21)
    private String sfhdgjzs;
    @Location(x = 22)
    private String zyyszsbm;
    @Location(x = 23)
    private String xzzc;
    @Location(x = 24)
    private String lczc;
    @Location(x = 25)
    private String zyjszwdm;
    @Location(x = 26)
    private String xldm;
    @Location(x = 27)
    private String xwdm;
    @Location(x = 28)
    private String szydm;
    @Location(x = 29)
    private String zktc1;
    @Location(x = 30)
    private String zktc2;
    @Location(x = 31)
    private String zktc3;
    @Location(x = 32)
    private String nnryldqk;
    @Location(x = 33)
    private String drdcsj;
    @Location(x = 34)
    private String bzqk;
    @Location(x = 35)
    private String sfzcqkyx;
    @Location(x = 36)
    private String qdhgzs;
    @Location(x = 37)
    private String xzsqpzgz;
    @Location(x = 38)
    private String sfcstjgz;
    @Location(x = 39)
    private String tjxxhgz;

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;
        if (!StringUtils.isEmpty(phone)&&!repeatMap.get("phone").add(phone)) {
            valid = 0;
            addErrorMsg("phone", "医生联系电话重复！");
        }
        if (!repeatMap.get("idCardNo").add(idCardNo)) {
            valid = 0;
            addErrorMsg("idCardNo", "医生身份证号重复！");
        }

        String validatePhone = "^1[3|4|5|7|8][0-9]{9}$";
        //正则表达式的模式
        Pattern vPhonePa = Pattern.compile(validatePhone);
        //正则表达式的匹配器
        Matcher p = vPhonePa.matcher(phone);
        //进行正则匹配
        boolean phoneValue = p.matches();
        if (!StringUtils.isEmpty(phone)&&!phoneValue) {
            valid = 0;
            addErrorMsg("phone", "请输入正确的手机号码！");
        }

        if (!StringUtils.isEmpty(phone)) {
            repeatMap.get("phone").add(phone);
        }

        if (idCardNo.length() < 15 && idCardNo.length() > 18) {
            valid = 0;
            addErrorMsg("idCardNo", "请输入正确的身份证号码！");
        }
        return valid;
    }

    public String getOrgId() {
        return orgId;
    }

    public void setOrgId(String orgId) {
        this.orgId = orgId;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSfzjzl() {
        return sfzjzl;
    }

    public void setSfzjzl(String sfzjzl) {
        this.sfzjzl = sfzjzl;
    }

    public String getIdCardNo() {
        return idCardNo;
    }

    public void setIdCardNo(String idCardNo) {
        this.idCardNo = idCardNo;
    }

    public String getCsrq() {
        return csrq;
    }

    public void setCsrq(String csrq) {
        this.csrq = csrq;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getMzdm() {
        return mzdm;
    }

    public void setMzdm(String mzdm) {
        this.mzdm = mzdm;
    }

    public String getCjgzrq() {
        return cjgzrq;
    }

    public void setCjgzrq(String cjgzrq) {
        this.cjgzrq = cjgzrq;
    }

    public String getOfficeTel() {
        return officeTel;
    }

    public void setOfficeTel(String officeTel) {
        this.officeTel = officeTel;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSzksdm() {
        return szksdm;
    }

    public void setSzksdm(String szksdm) {
        this.szksdm = szksdm;
    }

    public String getDept_name() {
        return dept_name;
    }

    public void setDept_name(String dept_name) {
        this.dept_name = dept_name;
    }

    public String getRole_type() {
        return role_type;
    }

    public void setRole_type(String role_type) {
        this.role_type = role_type;
    }

    public String getYszyzsbm() {
        return yszyzsbm;
    }

    public void setYszyzsbm(String yszyzsbm) {
        this.yszyzsbm = yszyzsbm;
    }

    public String getJob_type() {
        return job_type;
    }

    public void setJob_type(String job_type) {
        this.job_type = job_type;
    }

    public String getJob_scope() {
        return job_scope;
    }

    public void setJob_scope(String job_scope) {
        this.job_scope = job_scope;
    }

    public String getSfdddzyys() {
        return sfdddzyys;
    }

    public void setSfdddzyys(String sfdddzyys) {
        this.sfdddzyys = sfdddzyys;
    }

    public String getDezydwjglb() {
        return dezydwjglb;
    }

    public void setDezydwjglb(String dezydwjglb) {
        this.dezydwjglb = dezydwjglb;
    }

    public String getDszydwjglb() {
        return dszydwjglb;
    }

    public void setDszydwjglb(String dszydwjglb) {
        this.dszydwjglb = dszydwjglb;
    }

    public String getSfhdgjzs() {
        return sfhdgjzs;
    }

    public void setSfhdgjzs(String sfhdgjzs) {
        this.sfhdgjzs = sfhdgjzs;
    }

    public String getZyyszsbm() {
        return zyyszsbm;
    }

    public void setZyyszsbm(String zyyszsbm) {
        this.zyyszsbm = zyyszsbm;
    }

    public String getXzzc() {
        return xzzc;
    }

    public void setXzzc(String xzzc) {
        this.xzzc = xzzc;
    }

    public String getLczc() {
        return lczc;
    }

    public void setLczc(String lczc) {
        this.lczc = lczc;
    }

    public String getZyjszwdm() {
        return zyjszwdm;
    }

    public void setZyjszwdm(String zyjszwdm) {
        this.zyjszwdm = zyjszwdm;
    }

    public String getXldm() {
        return xldm;
    }

    public void setXldm(String xldm) {
        this.xldm = xldm;
    }

    public String getXwdm() {
        return xwdm;
    }

    public void setXwdm(String xwdm) {
        this.xwdm = xwdm;
    }

    public String getSzydm() {
        return szydm;
    }

    public void setSzydm(String szydm) {
        this.szydm = szydm;
    }

    public String getZktc1() {
        return zktc1;
    }

    public void setZktc1(String zktc1) {
        this.zktc1 = zktc1;
    }

    public String getZktc2() {
        return zktc2;
    }

    public void setZktc2(String zktc2) {
        this.zktc2 = zktc2;
    }

    public String getZktc3() {
        return zktc3;
    }

    public void setZktc3(String zktc3) {
        this.zktc3 = zktc3;
    }

    public String getNnryldqk() {
        return nnryldqk;
    }

    public void setNnryldqk(String nnryldqk) {
        this.nnryldqk = nnryldqk;
    }

    public String getDrdcsj() {
        return drdcsj;
    }

    public void setDrdcsj(String drdcsj) {
        this.drdcsj = drdcsj;
    }

    public String getBzqk() {
        return bzqk;
    }

    public void setBzqk(String bzqk) {
        this.bzqk = bzqk;
    }

    public String getSfzcqkyx() {
        return sfzcqkyx;
    }

    public void setSfzcqkyx(String sfzcqkyx) {
        this.sfzcqkyx = sfzcqkyx;
    }

    public String getQdhgzs() {
        return qdhgzs;
    }

    public void setQdhgzs(String qdhgzs) {
        this.qdhgzs = qdhgzs;
    }

    public String getXzsqpzgz() {
        return xzsqpzgz;
    }

    public void setXzsqpzgz(String xzsqpzgz) {
        this.xzsqpzgz = xzsqpzgz;
    }

    public String getSfcstjgz() {
        return sfcstjgz;
    }

    public void setSfcstjgz(String sfcstjgz) {
        this.sfcstjgz = sfcstjgz;
    }

    public String getTjxxhgz() {
        return tjxxhgz;
    }

    public void setTjxxhgz(String tjxxhgz) {
        this.tjxxhgz = tjxxhgz;
    }
}
