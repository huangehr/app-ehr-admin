package com.yihu.ehr.std.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.Set;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
@Row
public class DictionaryEntryMsg extends ExcelUtil implements Validation {

    private String dictCode;
    @Location(x=3)
    @ValidRepeat
    private String code;
    @Location(x=4)
    private String name;

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int rs = 1;
        if(StringUtils.isEmpty(code) && StringUtils.isEmpty(name))
            return -1;
        if(!repeatMap.get("code").add(code)) {
            rs = 0;
            addErrorMsg("code", "代码重复！");
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

    public String getDictCode()
    {
        return dictCode;
    }
    public void setDictCode(String dictCode)
    {
        this.dictCode = dictCode;
    }
    public String getCode()
    {
        return code;
    }
    public void setCode(String code)
    {
        this.code = code;
    }
    public String getName()
    {
        return name;
    }
    public void setName(String name)
    {
        this.name = name;
    }
}
