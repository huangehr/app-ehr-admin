package com.yihu.ehr.quota.controller.model;


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
 * 指标数据存储库
 * @author zdm
 * @version 1.0
 * @created 2017/12/19
 */
@Row
public class TjQuotaDataSaveMsg extends ExcelUtil implements Validation {

    String quotaCode;//指标编码
    @Location(x=7)
    String saveCode;//关联 tj_data_save code
    @Location(x=8)
    String configJson;//数据存储库相关配置


    /**
     * 验证数据格式是否正确
     * @param repeatMap
     * @return
     * @throws Exception
     */
    @Override
    public int validate(Map<String, Set> repeatMap) throws Exception {
        int rs = 1;
        if(StringUtils.isEmpty(quotaCode)){
            rs = 0;
            addErrorMsg("quotaCode", "指标代码不能为空！" );
        }
        if(StringUtils.isEmpty("slaveCode")){
            rs = 0;
            addErrorMsg("slaveCode", "数据存储库不能为空！" );
        }
        if(StringUtils.isEmpty("name")){
            rs = 0;
            addErrorMsg("name", "存储配置不能为空！" );
        }
        return rs;
    }

    public String getQuotaCode() {
        return quotaCode;
    }

    public void setQuotaCode(String quotaCode) {
        this.quotaCode = quotaCode;
    }

    public String getSaveCode() {
        return saveCode;
    }

    public void setSaveCode(String saveCode) {
        this.saveCode = saveCode;
    }

    public String getConfigJson() {
        return configJson;
    }

    public void setConfigJson(String configJson) {
        this.configJson = configJson;
    }
}
