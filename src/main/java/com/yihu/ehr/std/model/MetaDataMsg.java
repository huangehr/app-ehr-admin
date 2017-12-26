package com.yihu.ehr.std.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import org.apache.commons.lang.StringUtils;

import java.util.Map;
import java.util.Set;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
@Row
public class MetaDataMsg extends ExcelUtil implements Validation {

    @Location(x=1)
    @ValidRepeat
    String innerCode;
    @Location(x=2)
    String code;
    @Location(x=3)
    String name;
    @Location(x=4)
    String definition;
    @Location(x=5)
    String type;
    @Location(x=6)
    String format;
    @Location(x=7)
    @ValidRepeat
    String dictCode;
    @Location(x=8)
    String columnName;
    @Location(x=9)
    String columnType;
    @Location(x=10 )
    String columnLength;
    @Location(x=11)
    String primaryKey;
    @Location(x=12)
    String nullable;

    int hashCode;
    String dataSetCode;
    String dictId = "";


//    long dataSetId;
//    boolean isHbaseFullTextRetrieval;
//    boolean isHbasePrimaryKey;
//    String dictName;



    @Override
    public int validate(Map<String, Set> repeatMap) {
        int rs = 1;
        if(!RegUtil.regCode(innerCode)){
            rs = 0;
            addErrorMsg("innerCode", RegUtil.codeMsg);
        } else if(!repeatMap.get("innerCode").add(innerCode)) {
            rs = 0;
            addErrorMsg("innerCode", "内部代码重复！");
        }

        if(!RegUtil.regCode(code)){
            rs = 0;
            addErrorMsg("code", RegUtil.codeMsg);
        }

        if(!RegUtil.regLen(name)){
            rs = 0;
            addErrorMsg("name", RegUtil.lenMsg);
        }else if(name.indexOf("'")!=-1){
            rs = 0;
            addErrorMsg("name", "不允许输入'");
        }

        if(!RegUtil.regLength2(0, 200, definition)){
            rs = 0;
            addErrorMsg("definition", "不得超过200个字符");
        }

        if(!RegUtil.regLength2(0, 10, type)){
            rs = 0;
            addErrorMsg("type", "不得超过10个字符");
        }

        if(!RegUtil.regLength2(0, 50, format)){
            rs = 0;
            addErrorMsg("format", "不得超过50个字符");
        }

        if(!RegUtil.regLength2(1, 64, columnName)){
            rs = 0;
            addErrorMsg("columnName", "请输入1~64个字符");
        }else if(!repeatMap.get("columnName").add(columnName)){
            rs = 0;
            addErrorMsg("columnName", "列名重复");
        }

        if(!RegUtil.regLength2(0, 50, columnType)){
            rs = 0;
            addErrorMsg("columnType", "不得超过50个字符");
        }

        if(!RegUtil.regLength2(0, 15, columnLength)){
            rs = 0;
            addErrorMsg("columnLength", "不得超过15个字符");
        }

        if(StringUtils.isEmpty(primaryKey)){
            primaryKey = "0";
        }

        if(!primaryKey.equals("0") && !primaryKey.equals("1")){
            rs = 0;
            addErrorMsg("primaryKey", "只允许输入0或1， 不填默认为0");
        }

        if(StringUtils.isEmpty(nullable)){
            //该数据不填，默认为可以为空  nullable = "1"
            nullable = "1";
        }

        if(!nullable.equals("0") && !nullable.equals("1")){
            rs = 0;
            addErrorMsg("nullable", "只允许输入0或1， 不填默认为1");
        }else if(primaryKey.equals("1") && nullable.equals(primaryKey)){
            addErrorMsg("nullable", "主键不允许为空");
        }

        return rs;
    }

    public String getInnerCode() {
        return innerCode;
    }

    public void setInnerCode(String innerCode) {
        this.innerCode = innerCode;
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

    public String getDefinition() {
        return definition;
    }

    public void setDefinition(String definition) {
        this.definition = definition;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getDictCode() {
        return dictCode;
    }

    public void setDictCode(String dictCode) {
        this.dictCode = dictCode;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnType() {
        return columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }

    public String getColumnLength() {
        return columnLength;
    }

    public void setColumnLength(String columnLength) {
        this.columnLength = columnLength;
    }

    public String getPrimaryKey() {
        return primaryKey;
    }

    public void setPrimaryKey(String primaryKey) {
        this.primaryKey = primaryKey;
    }

    public String getNullable() {
        return nullable;
    }

    public void setNullable(String nullable) {
        this.nullable = nullable;
    }

    public int getHashCode() {
        return hashCode;
    }

    public void setHashCode(int hashCode) {
        this.hashCode = hashCode;
    }

    public String getDataSetCode() {
        return dataSetCode;
    }

    public void setDataSetCode(String dataSetCode) {
        this.dataSetCode = dataSetCode;
    }

    public String getDictId() {
        return dictId;
    }

    public void setDictId(String dictId) {
        this.dictId = dictId;
    }
}
