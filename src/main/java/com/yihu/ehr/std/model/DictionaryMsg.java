package com.yihu.ehr.std.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
@Sheet( name = "name")
@Title(names = "{'代码', '名称', '说明'}")
public class DictionaryMsg extends ExcelUtil implements Validation {
    @Location(x= 1, y= 0)
    @ValidRepeat
    private String code;
    @Location(x= 1, y= 1)
    private String name;
//    @Location(x= 1, y= 2)
    private String description;

    @Child(one = "code", many = "dictCode")
    private List<DictionaryEntryMsg> children = new ArrayList<>();

    @Override
    public int validate(Map<String, Set> repeatMap) throws Exception {
        int rs = 1;
         if(!repeatMap.get("code").add(code)){
            rs = 0;
            addErrorMsg("code", "代码重复！" );
        }
        if(!RegUtil.regLen(code)){
            rs = 0;
            addErrorMsg("code", RegUtil.lenMsg);
        }
        if(!RegUtil.regLen(name)){
            rs = 0;
            addErrorMsg("name", RegUtil.lenMsg);
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
    public List<DictionaryEntryMsg> getChildren() {
        return children;
    }
    public void setChildren(List<DictionaryEntryMsg> children) {
        this.children = children;
    }
    public boolean addChild(DictionaryEntryMsg child){
        return children.add(child);
    }
}
