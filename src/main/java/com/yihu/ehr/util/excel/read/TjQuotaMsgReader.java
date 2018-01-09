package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.quota.controller.model.*;
import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.annotation.Location;
import jxl.Sheet;
import jxl.Workbook;

import java.util.*;

public class TjQuotaMsgReader extends AExcelReader {
    //主维度
    protected List quotaMainErrorLs = new ArrayList<>();
    protected List quotaMainCorrectLs = new ArrayList<>();
    //细维度
    protected List quotaSlaveErrorLs = new ArrayList<>();
    protected List quotaSlaveCorrectLs = new ArrayList<>();
    //主维度
    protected Map<String, Set>  quotaMainRepeat = new HashMap<>();;
    //细维度
    protected Map<String, Set> quotaSlaveRepeat = new HashMap<>();;

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            boolean correct;
            int j = 0, rows;
            //指标
            TjQuotaMsg quota;
            //主维度
            TjQuotaDMainMsg quotaMainMsg;
            //细维度
            TjQuotaDSlaveMsg quotaSlaveMsg;

            getRepeat().put("code", new HashSet<>());//指标编码
            getRepeat().put("name", new HashSet<>());//指标名称
            getRepeat().put("quotaType", new HashSet<>());//指标类型

            for(int k=0;k<sheets.length;k++){
                Sheet  sheet=null;
                //指标sheet页
                if(k==0) {
                    sheet = sheets[0];
                    correct = true;
                    if ((rows = sheet.getRows()) == 0) continue;
                    for (int i = 1; i < rows; i++, j++) {
                        quota = new TjQuotaMsg();
                        if(null != getCellCont(sheet, i, 0) && !"".equals(getCellCont(sheet, i, 0))){
                            quota.setCode(replaceBlank(getCellCont(sheet, i, 0)));
                        }
                        if(null != getCellCont(sheet, i, 1) && !"".equals(getCellCont(sheet, i, 1))){
                            quota.setName(replaceBlank(getCellCont(sheet, i, 1)));
                        }
                        if(null != getCellCont(sheet, i, 2) && !"".equals(getCellCont(sheet, i, 2))){
                            quota.setQuotaType(replaceBlank(getCellCont(sheet, i, 2)));
                        }
                        // 1- 立即执行 2- 周期执行
                        if(null != getCellCont(sheet, i, 3)){
                            if("立即执行".equals(replaceBlank(getCellCont(sheet, i, 3).trim()))){
                                quota.setExecType("1");
                            }else {
                                quota.setExecType("2");
                            }
                        }

                        if(null != getCellCont(sheet, i, 4)){
                            // 加法  com.yihu.quota.job.EsQuotaJob / 除法 com.yihu.quota.job.EsQuotaPercentJob
                            if("加法对象类".equals(replaceBlank(getCellCont(sheet, i, 4).trim()))){
                                quota.setJobClazz("com.yihu.quota.job.EsQuotaJob");
                            }else {
                                quota.setJobClazz("com.yihu.quota.job.EsQuotaPercentJob");
                            }
                        }
                        //数据源 参考表tj_data_source
                        if(null != getCellCont(sheet, i, 5)){
                            if("ElasticSearch".equals(replaceBlank(getCellCont(sheet, i, 5).toString()))){
                                quota.setQuotaDataSource("1");
                            }else if("Solr".equals(replaceBlank(getCellCont(sheet, i, 5).toString()))){
                                quota.setQuotaDataSource("2");
                            }else{
                                //mysql
                                quota.setQuotaDataSource("3");
                            }
                        }

                        //数据源配置
                        if(null != getCellCont(sheet, i, 6)){
                            quota.setQuotaDataSourceConfigJson(getCellCont(sheet, i, 6).toString());
                        }

                        //数据存储
                        if(null != getCellCont(sheet, i, 7)){
                            if("ElasticSearch".equals(replaceBlank(getCellCont(sheet, i, 7).toString()))){
                                quota.setQuotaDataSave("1");
                            }else {
                                //mysql
                                quota.setQuotaDataSave("2");
                            }
                        }
                        //数据存储配置
                        if(null != getCellCont(sheet, i, 8)){
                            quota.setQuotaDataSaveConfigJson(getCellCont(sheet, i, 8).toString());
                        }

                        if(null != getCellCont(sheet, i, 9)){
                            // 1 数据全量 2数据增量
                            if("全量".equals(replaceBlank(getCellCont(sheet, i, 9).trim()))){
                                quota.setDataLevel("1");
                            }else{
                                quota.setDataLevel("2");
                            }
                        }
                        quota.setRemark(getCellCont(sheet, i, 10));
                        quota.setExcelSeq(j);
                        if (quota.validate(repeat) == 0) {
                            correct = false;
                        }

                        if (!correct){
                            errorLs.add(quota);
                        } else{
                            correctLs.add(quota);
                        }
                        j++;

                    }
                }
                //主维度sheet页
                if(k==1){
                    sheet=sheets[1];
                    correct = true;
                    if ((rows = sheet.getRows()) == 0) continue;
                    for (int i = 1; i < rows; i++, j++) {
                        quotaMainMsg = new TjQuotaDMainMsg();
                        //主维度
                        quotaMainRepeat.put("quotaCode", new HashSet<>());
                        quotaMainRepeat.put("mainCode", new HashSet<>());
                        if(null != getCellCont(sheet, i, 0) && !"".equals(getCellCont(sheet, i, 0))){
                            quotaMainMsg.setQuotaCode(replaceBlank(getCellCont(sheet, i, 0)));
                        }
                        if(null != getCellCont(sheet, i, 1) && !"".equals(getCellCont(sheet, i, 1))){
                            quotaMainMsg.setMainCode(replaceBlank(getCellCont(sheet, i, 1)));
                        }
                        quotaMainMsg.setDictSql(getCellCont(sheet, i, 2));
                        if(null != getCellCont(sheet, i, 3) && !"".equals(getCellCont(sheet, i, 3))){
                            quotaMainMsg.setKeyVal(replaceBlank(getCellCont(sheet, i, 3)));
                        }
                        if (quotaMainMsg.validate(quotaMainRepeat) == 0) {
                            correct = false;
                        }
                        if (!correct){
                            quotaMainErrorLs.add(quotaMainMsg);
                        } else{
                            quotaMainCorrectLs.add(quotaMainMsg);
                        }
                    }
                }
                //细维度sheet页
                if(k==2){
                    sheet=sheets[2];
                    correct = true;
                    if ((rows = sheet.getRows()) == 0) continue;
                    for (int i = 1; i < rows; i++, j++) {
                        //细维度
                        quotaSlaveMsg = new TjQuotaDSlaveMsg();
                        quotaSlaveRepeat.put("quotaCode", new HashSet<>());
                        quotaSlaveRepeat.put("slaveCode", new HashSet<>());
                        if(null != getCellCont(sheet, i, 0) && !"".equals(getCellCont(sheet, i, 0))){
                            quotaSlaveMsg.setQuotaCode(replaceBlank(getCellCont(sheet, i, 0)));
                        }
                        if(null != getCellCont(sheet, i, 1) && !"".equals(getCellCont(sheet, i, 1))){
                            quotaSlaveMsg.setSlaveCode(replaceBlank(getCellCont(sheet, i, 1)));
                        }
                        quotaSlaveMsg.setDictSql(getCellCont(sheet, i, 2));
                        if(null != getCellCont(sheet, i, 3) && !"".equals(getCellCont(sheet, i, 3))){
                            quotaSlaveMsg.setKeyVal(replaceBlank(getCellCont(sheet, i, 3)));
                        }
                        if(null != getCellCont(sheet, i, 4) && !"".equals(getCellCont(sheet, i, 4))){
                            quotaSlaveMsg.setSort(replaceBlank(getCellCont(sheet, i, 4)));
                        }
                        if (quotaSlaveMsg.validate(quotaSlaveRepeat) == 0) {
                            correct = false;
                        }
                        if (!correct){
                            quotaSlaveErrorLs.add(quotaSlaveMsg);
                        } else{
                            quotaSlaveCorrectLs.add(quotaSlaveMsg);
                        }
                    }
                }
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (rwb != null) rwb.close();
        }
    }

    public List getQuotaMainErrorLs() {
        return quotaMainErrorLs;
    }

    public void setQuotaMainErrorLs(List quotaMainErrorLs) {
        this.quotaMainErrorLs = quotaMainErrorLs;
    }

    public List getQuotaMainCorrectLs() {
        return quotaMainCorrectLs;
    }

    public void setQuotaMainCorrectLs(List quotaMainCorrectLs) {
        this.quotaMainCorrectLs = quotaMainCorrectLs;
    }

    public List getQuotaSlaveErrorLs() {
        return quotaSlaveErrorLs;
    }

    public void setQuotaSlaveErrorLs(List quotaSlaveErrorLs) {
        this.quotaSlaveErrorLs = quotaSlaveErrorLs;
    }

    public List getQuotaSlaveCorrectLs() {
        return quotaSlaveCorrectLs;
    }

    public void setQuotaSlaveCorrectLs(List quotaSlaveCorrectLs) {
        this.quotaSlaveCorrectLs = quotaSlaveCorrectLs;
    }

    public Map<String, Set> getQuotaMainRepeat() {
        return quotaMainRepeat;
    }

    public void setQuotaMainRepeat(Map<String, Set> quotaMainRepeat) {
        this.quotaMainRepeat = quotaMainRepeat;
    }

    public Map<String, Set> getQuotaSlaveRepeat() {
        return quotaSlaveRepeat;
    }

    public void setQuotaSlaveRepeat(Map<String, Set> quotaSlaveRepeat) {
        this.quotaSlaveRepeat = quotaSlaveRepeat;
    }
}
