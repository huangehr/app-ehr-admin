package com.yihu.ehr.resource.model;

import com.yihu.ehr.util.excel.ErrorMsgUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public class RsDictionaryMsg implements ErrorMsgUtil, Validation{
    private String code;
    private String name;
    private String description;
    private int excelRow = 0;
    private Map<String, String> errMsg = new HashMap<>();

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int rs = 1;
        if(!RegUtil.regCode(code)){
            rs = 0;
            addErrorMsg("code", RegUtil.codeMsg);
        }else{
            Set<String> set = repeatMap.get("code");
            if(set==null){
                set = new HashSet<>();
                repeatMap.put("code", set);
            }

            int len = set.size();
            set.add(code);
            if(len==set.size()){
                rs = 0;
                addErrorMsg("code", "代码重复！");
            }
        }

        if(!RegUtil.regLength(1, 200, name)){
            rs = 0;
            addErrorMsg("name", "请输入1~200个字符！");
        }

        if(!RegUtil.regLength(1, 200, description)){
            rs = 0;
            addErrorMsg("description", "请输入0~200个字符！");
        }
        return rs;
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

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public int getExcelRow() {
        return excelRow;
    }
    public void setExcelRow(int excelRow) {
        this.excelRow = excelRow;
    }

    @Override
    public void addErrorMsg(String field, String msg) {
        errMsg.put(field, msg);
    }
    @Override
    public String findErrorMsg(String field) {
        return errMsg.get(field);
    }



    @Override
    public boolean equals(Object obj) {
        return getExcelRow() == ((RsDictionaryMsg) obj).getExcelRow();
    }
}
