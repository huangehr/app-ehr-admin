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
 * 指标数据源
 * @author zdm
 * @version 1.0
 * @created 2017/12/19
 */
@Row
public class TjQuotaDataSourceMsg extends ExcelUtil implements Validation {
    String quotaCode;//指标编码
    @Location(x=5)
    String sourceCode;//关联 tj_data_source
    @Location(x=6)
    String configJson;//数据库配置参数

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
        if(StringUtils.isEmpty(sourceCode)){
            rs = 0;
            addErrorMsg("sourceCode", "数据源库不能为空！" );
        }
        if(StringUtils.isEmpty(configJson)){
            rs = 0;
            addErrorMsg("configJson", "数据源配置不能为空！" );
        }
        return rs;
    }

    public String getQuotaCode() {
        return quotaCode;
    }

    public void setQuotaCode(String quotaCode) {
        this.quotaCode = quotaCode;
    }

    public String getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    public String getConfigJson() {
        return configJson;
    }

    public void setConfigJson(String configJson) {
        this.configJson = configJson;
    }
}
