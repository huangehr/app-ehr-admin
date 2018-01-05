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
 * 指标主维度
 * @author zdm
 * @version 1.0
 * @created 2017/12/19
 */
@Row
public class TjQuotaDMainMsg extends ExcelUtil implements Validation {
    @Location(x=0)
    String quotaCode;  //关联 tj_quota code
    @Location(x=1)
    String mainCode; //关联主维度表 jt_dimension_main 的code
    @Location(x=2)
    String dictSql;//与系统字典关联的sql code
    @Location(x=3)
    String keyVal;// 指标对应对象的key值

    @Override
    public int validate(Map<String, Set> repeatMap) {
        int rs = 1;
        if(StringUtils.isEmpty(quotaCode)){
            rs = 0;
            addErrorMsg("quotaCode", "指标代码不能为空！" );
        }
        if(StringUtils.isEmpty(mainCode)){
            rs = 0;
            addErrorMsg("mainCode", "主维度编码不能为空！" );
        }
        return rs;
    }

    public String getQuotaCode() {
        return quotaCode;
    }

    public void setQuotaCode(String quotaCode) {
        this.quotaCode = quotaCode;
    }

    public String getMainCode() {
        return mainCode;
    }

    public void setMainCode(String mainCode) {
        this.mainCode = mainCode;
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

}
