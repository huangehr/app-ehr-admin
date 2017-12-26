package com.yihu.ehr.quota.controller.model;


import com.yihu.ehr.std.model.MetaDataMsg;
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
 * 指标
 * @author zdm
 * @version 1.0
 * @created 2017/12/19
 */
@Sheet( name = "name")
@Title(names = "{'编码', '名称', '指标类型', '执行方式', '对象类', '数据源', '源配置', '数据存储库', '存储配置', '存储方式', '备注'}")
public class TjQuotaMsg extends ExcelUtil implements Validation {
    @Location(x=0)
    @ValidRepeat
    private String code; //业务code  验证是否重复
    @Location(x=1)
    @ValidRepeat
    private String name; //指标名称  验证是否重复
    @Location(x=2)
    @ValidRepeat
    private String quotaType;//指标类型 指标分类中查找
    @Location(x=3)
    @ValidRepeat
    private String execType="1";//执行方式 1- 立即执行 2- 周期执行
    private String cron="0 0/0 * * * ?"; //cron表达式  单次执行 0 0/0 * * * ?
    @Location(x=4)
    @ValidRepeat
    private String jobClazz;//任务类  加法  com.yihu.quota.job.EsQuotaJob / 除法 com.yihu.quota.job.EsQuotaPercentJob
    private String createTime;
    private String createUser;
    private String createUserName;
    private String status="1";//1: 正常 0：不可用  -1删除
    @Location(x=9)
    @ValidRepeat
    private String dataLevel;//存储方式 1 数据全量 2数据增量
    @Location(x=10)
    private String remark;//备注
    private String metadataCode;//数据元code
    private TjQuotaDataSaveMsg quotaDataSave = new TjQuotaDataSaveMsg();
    private TjQuotaDataSourceMsg quotaDataSource = new TjQuotaDataSourceMsg();

    @Override
    public int validate(Map<String, Set> repeatMap) throws Exception {

        int rs = 1;
        if(StringUtils.isEmpty(code)){
            rs = 0;
            addErrorMsg("code", "指标编码不能为空！" );
        }
        if(StringUtils.isEmpty(name)){
            rs = 0;
            addErrorMsg("name", "指标名称不能为空！" );
        }
        if(!repeatMap.get("code").add(code)){
            rs = 0;
            addErrorMsg("code", "指标编码重复！" );
        }

        if(!repeatMap.get("name").add(name)){
            rs = 0;
            addErrorMsg("name", "指标名称重复！" );
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

    public String getQuotaType() {
        return quotaType;
    }

    public void setQuotaType(String quotaType) {
        this.quotaType = quotaType;
    }

    public String getExecType() {
        return execType;
    }

    public void setExecType(String execType) {
        this.execType = execType;
    }

    public String getCron() {
        return cron;
    }

    public void setCron(String cron) {
        this.cron = cron;
    }

    public String getJobClazz() {
        return jobClazz;
    }

    public void setJobClazz(String jobClazz) {
        this.jobClazz = jobClazz;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDataLevel() {
        return dataLevel;
    }

    public void setDataLevel(String dataLevel) {
        this.dataLevel = dataLevel;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getMetadataCode() {
        return metadataCode;
    }

    public void setMetadataCode(String metadataCode) {
        this.metadataCode = metadataCode;
    }

    public TjQuotaDataSaveMsg getQuotaDataSave() {
        return quotaDataSave;
    }

    public void setQuotaDataSave(TjQuotaDataSaveMsg quotaDataSave) {
        this.quotaDataSave = quotaDataSave;
    }

    public TjQuotaDataSourceMsg getQuotaDataSource() {
        return quotaDataSource;
    }

    public void setQuotaDataSource(TjQuotaDataSourceMsg quotaDataSource) {
        this.quotaDataSource = quotaDataSource;
    }
}
