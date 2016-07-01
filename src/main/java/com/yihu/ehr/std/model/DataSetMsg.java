package com.yihu.ehr.std.model;


import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.*;
import org.springframework.util.StringUtils;

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
@Title(names = "{'名称', '标识', '参考', '备注'}")
public class DataSetMsg extends ExcelUtil implements Validation {
    @Location(x= 1, y= 0)
    private String name;
    @Location(x= 1, y= 1)
    @ValidRepeat
    private String code;
    @Location(x= 1, y= 2)
    @ValidRepeat
    private String referenceCode;
    @Location(x= 1, y= 3)
    private String summary;

    @Child(one = "code", many = "dataSetCode")
    private List<MetaDataMsg> children = new ArrayList<>();

    private String referenceId;

    @Override
    public int validate(Map<String, Set> repeatMap) throws Exception {

        int rs = 1;
        if(!RegUtil.regCode(code)){
            rs = 0;
            addErrorMsg("code", RegUtil.codeMsg);
        }else if(!repeatMap.get("code").add(code)){
            rs = 0;
            addErrorMsg("code", "代码重复！" );
        }

        if(!RegUtil.regLength2(1, 50, name)){
            rs = 0;
            addErrorMsg("name","请输入1~50个字符");
        }

        if(!RegUtil.regLength2(0, 200, summary)){
            rs = 0;
            addErrorMsg("summary","不能超过200个字符");
        }

        if(!StringUtils.isEmpty(referenceCode)){
            repeatMap.get("referenceCode").add(referenceCode);
        }

        return rs;
    }

    public void addChild(MetaDataMsg meta){
        children.add(meta);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getReferenceCode() {
        return referenceCode;
    }

    public void setReferenceCode(String referenceCode) {
        this.referenceCode = referenceCode;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public List<MetaDataMsg> getChildren() {
        return children;
    }

    public void setChildren(List<MetaDataMsg> children) {
        this.children = children;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }
}
