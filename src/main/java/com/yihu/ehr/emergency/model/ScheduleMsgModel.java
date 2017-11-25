package com.yihu.ehr.emergency.model;

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
 * @created 2017/11/20
 */
@Row(start = 1)
@Title(names= "{'姓名', '性别','工号', '角色', '手机号', '车牌号', '开始时间', '结束时间', '主班/副班'}")
public class ScheduleMsgModel extends ExcelUtil implements Validation {

    @Location(x=0)
    @ValidRepeat
    private String dutyName; // 执勤人员

    @Location(x=1)
    private String gender; //性别

    @Location(x=2)
    @ValidRepeat
    private String dutyNum; // 工号

    @Location(x=3)
    private String dutyRole; // 执勤角色

    @Location(x=4)
    @ValidRepeat
    private String dutyPhone;  // 执勤手机号码

    @Location(x=5)
    @ValidRepeat
    private String carId;// 车牌号码

    @Location(x=6)
    @ValidRepeat
    private String start; // 开始时间

    @Location(x=7)
    @ValidRepeat
    private String end;// 结束时间

    @Location(x=8)
    @ValidRepeat
    // 主副班
    private String main;

    //创建者
    private String creator;



    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;
        if(StringUtils.isEmpty(dutyName)){
            valid = 0;
            addErrorMsg("dutyName", "姓名不能为空！" );
        }

        if(StringUtils.isEmpty(dutyNum)){
            valid = 0;
            addErrorMsg("dutyNum", "工号不能为空！" );
        }
        if(StringUtils.isEmpty(dutyPhone)){
            valid = 0;
            addErrorMsg("dutyPhone", "手机号不能为空！" );
        }

        String validatePhone="^1[3|4|5|7|8][0-9]{9}$";
        //正则表达式的模式
        Pattern vPhonePa = Pattern.compile(validatePhone);
        //正则表达式的匹配器
        Matcher p = vPhonePa.matcher(dutyPhone);
        //进行正则匹配
        boolean phoneValue= p.matches();
        if(!phoneValue){
            valid = 0;
            addErrorMsg("dutyPhone", "请输入正确的手机号码！" );
        }

        if(!StringUtils.isEmpty(carId)){
            repeatMap.get("carId").add(carId);
        }else{
            valid = 0;
            addErrorMsg("carId", "车牌号不能为空！" );
        }

        if(!StringUtils.isEmpty(start)){
            repeatMap.get("start").add(start);
        }else{
            valid = 0;
            addErrorMsg("start", "开始时间不能为空！" );
        }

        if(!StringUtils.isEmpty(end)){
            if(!(end.compareTo(start)>0)){
                valid = 0;
                addErrorMsg("end", "结束时间要大于开始时间！" );
            }
            repeatMap.get("end").add(end);
        }else{
            valid = 0;
            addErrorMsg("end", "结束时间不能为空！" );
        }

        if(!StringUtils.isEmpty(main)){
            repeatMap.get("main").add(main);
            if(!("主班".equals(main)||"副班".equals(main))){
                valid = 0;
                addErrorMsg("main", "请输入主班或者副班！" );
            }
        }else{
            valid = 0;
            addErrorMsg("main", "主班/副班不能为空！" );
        }
        return valid;
    }

    public String getDutyName() {
        return dutyName;
    }

    public void setDutyName(String dutyName) {
        this.dutyName = dutyName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDutyNum() {
        return dutyNum;
    }

    public void setDutyNum(String dutyNum) {
        this.dutyNum = dutyNum;
    }

    public String getDutyRole() {
        return dutyRole;
    }

    public void setDutyRole(String dutyRole) {
        this.dutyRole = dutyRole;
    }

    public String getDutyPhone() {
        return dutyPhone;
    }

    public void setDutyPhone(String dutyPhone) {
        this.dutyPhone = dutyPhone;
    }

    public String getCarId() {
        return carId;
    }

    public void setCarId(String carId) {
        this.carId = carId;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getMain() {
        return main;
    }

    public void setMain(String main) {
        this.main = main;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }
}
