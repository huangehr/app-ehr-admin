package com.yihu.ehr.resource.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.Title;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import jdk.nashorn.internal.ir.annotations.Ignore;
import org.springframework.util.StringUtils;

import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/13
 */
@Row(start = 1)
@Title(names= "{'资源标准编码', '数据元名称', '业务领域', '内部标识符', '类型', '关联字典', '是否允空', '说明'}")
public class RsMetaMsgModel extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String id;
    @Location(x=1)
    private String name;
    @Location(x=2)
    private String domain;
    @Location(x=3)
    private String stdCode;
    @Location(x=4)
    private String columnType;
    @Location(x=5)
    @ValidRepeat
    private String dictCode;
    @Location(x=6)
    private String nullAble;
    @Location(x=7)
    private String description;

    private int dictId;


    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!repeatMap.get("id").add(id)){
            valid = 0;
            addErrorMsg("id", "资源标准编码重复！" );
        }
        else if(!RegUtil.regMetaId(id)){
            addErrorMsg("id", RegUtil.rsMetaIdMsg);
            valid = 0;
        }

        if(!RegUtil.regCodeNR(stdCode)){
            addErrorMsg("stdCode", "只允许输入数字、英文、小数点与下划线！");
            valid = 0;
        }
        if(!StringUtils.isEmpty(dictCode)){
            repeatMap.get("dictCode").add(dictCode);
        }

        return valid;
    }


    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getDomain() {
        return domain;
    }
    public void setDomain(String domain) {
        this.domain = domain;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getStdCode() {
        return stdCode;
    }
    public void setStdCode(String stdCode) {
        this.stdCode = stdCode;
    }
    public String getColumnType() {
        return columnType;
    }
    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }
    public String getNullAble() {
        return nullAble;
    }
    public void setNullAble(String nullAble) {
        this.nullAble = nullAble;
    }
    public String getDictCode() {
        return dictCode;
    }
    public void setDictCode(String dictCode) {
        this.dictCode = dictCode;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public int getDictId() {
        return dictId;
    }
    public void setDictId(int dictId) {
        this.dictId = dictId;
    }
}
