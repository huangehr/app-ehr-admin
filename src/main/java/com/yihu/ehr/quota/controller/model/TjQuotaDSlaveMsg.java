package com.yihu.ehr.quota.controller.model;

import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.Location;
import com.yihu.ehr.util.excel.annotation.Row;
import com.yihu.ehr.util.excel.annotation.ValidRepeat;
import org.apache.commons.lang.StringUtils;

import java.util.Date;
import java.util.Map;
import java.util.Set;

/**
 * 指标细维度
 * @author zdm
 * @version 1.0
 * @created 2017/12/19
 */
@Row
public class TjQuotaDSlaveMsg extends ExcelUtil implements Validation {

    @Location(x=1)
    String quotaCode;  //关联 tj_quota code
    @Location(x=2)
    String slaveCode; //关联细维度表 jt_dimension_slave的code
    @Location(x=3)
    String dictSql;//与系统字典关联的sql code
    @Location(x=4)
    String keyVal;//指标对应对象的key值
    @Location(x=5)
    String sort;//纬度顺序
    String name;            //细纬度名称

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int rs = 1;
        if(StringUtils.isEmpty(quotaCode)){
            rs = 0;
            addErrorMsg("quotaCode", "指标代码不能为空！" );
        }
        if(StringUtils.isEmpty(slaveCode)){
            rs = 0;
            addErrorMsg("slaveCode", "细维度编码不能为空！" );
        }
        if(StringUtils.isEmpty(name)){
            rs = 0;
            addErrorMsg("name", "细维度名称不能为空！" );
        }
        if(!repeatMap.get("slaveCode").add(slaveCode)){
            rs = 0;
            addErrorMsg("slaveCode", "细维度编码重复！" );
        }

        if(!repeatMap.get("name").add(name)){
            rs = 0;
            addErrorMsg("name", "细维度名称重复！" );
        }
        return rs;
    }

    public String getQuotaCode() {
        return quotaCode;
    }

    public void setQuotaCode(String quotaCode) {
        this.quotaCode = quotaCode;
    }

    public String getSlaveCode() {
        return slaveCode;
    }

    public void setSlaveCode(String slaveCode) {
        this.slaveCode = slaveCode;
    }

    public String getDictSql() {
        return dictSql;
    }

    public void setDictSql(String dictSql) {
        this.dictSql = dictSql;
    }

    public String getKeyVal() {
        return keyVal;
    }

    public void setKeyVal(String keyVal) {
        this.keyVal = keyVal;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
