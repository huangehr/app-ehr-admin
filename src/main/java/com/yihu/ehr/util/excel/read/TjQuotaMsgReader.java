package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.quota.controller.model.*;
import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class TjQuotaMsgReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            boolean correct;
            int j = 0, rows;
            //主维度
            Map<String, Set>  quotaMainRepeat;
            //细维度
            Map<String, Set> quotaSlaveRepeat;
            //指标数据存储库
            Map<String, Set>  tjQuotaDataSaveMsgRepeat;
            //指标数据源
            Map<String, Set>  tjQuotaDataSourceMsgRepeat;

            //指标
            TjQuotaMsg quota;
            //主维度
            TjQuotaDMainMsg quotaMain;
            //细维度
            TjQuotaDSlaveMsg quotaSlave;
            //指标数据存储库
            TjQuotaDataSaveMsg tjQuotaDataSaveMsg;
            //指标数据源
            TjQuotaDataSourceMsg tjQuotaDataSourceMsg;

            getRepeat().put("code", new HashSet<>());
            getRepeat().put("name", new HashSet<>());
            for(int k=0;k<sheets.length;k++){
                Sheet  sheet=null;
                //指标sheet页
                if(k==0) {
                    sheet = sheets[0];
                    correct = true;
                    if ((rows = sheet.getRows()) == 0) continue;
                    for (int i = 1; i < rows; i++, j++) {
                        quota = new TjQuotaMsg();
                        quota.setCode(getCellCont(sheet, i, 0));
                        quota.setName(getCellCont(sheet, i, 1));
                        quota.setQuotaType(getCellCont(sheet, i, 2));
                        // 1- 立即执行 2- 周期执行
                        if(null != getCellCont(sheet, i, 3)){
                            if("立即执行".equals(getCellCont(sheet, i, 3).trim())){
                                quota.setExecType("1");
                            }else {
                                quota.setExecType("2");
                            }
                        }

                        if(null != getCellCont(sheet, i, 4)){
                            // 加法  com.yihu.quota.job.EsQuotaJob / 除法 com.yihu.quota.job.EsQuotaPercentJob
                            if("加法对象类".equals(getCellCont(sheet, i, 4).trim())){
                                quota.setJobClazz("com.yihu.quota.job.EsQuotaJob");
                            }else {
                                quota.setJobClazz("com.yihu.quota.job.EsQuotaPercentJob");
                            }
                        }
                        if(null != getCellCont(sheet, i, 9)){
                            // 1 数据全量 2数据增量
                            if("全量".equals(getCellCont(sheet, i, 9).trim())){
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



                        //指标数据源
                        tjQuotaDataSourceMsgRepeat = new HashMap<>();
                        tjQuotaDataSourceMsgRepeat.put("quotaCode", new HashSet<>());
                        tjQuotaDataSourceMsgRepeat.put("sourceCode", new HashSet<>());
                        //指标数据源
                        tjQuotaDataSourceMsg = new TjQuotaDataSourceMsg();
                        tjQuotaDataSourceMsg.setQuotaCode(quota.getCode());
                        tjQuotaDataSourceMsg.setSourceCode(getCellCont(sheet, i, 5));
                        tjQuotaDataSourceMsg.setConfigJson(getCellCont(sheet, i, 6));
                        if (tjQuotaDataSourceMsg.validate(tjQuotaDataSourceMsgRepeat) == 0) {
                            correct = false;
                        }
                        quota.setQuotaDataSource(tjQuotaDataSourceMsg);

                        //指标数据存储库
                        tjQuotaDataSaveMsgRepeat = new HashMap<>();
                        tjQuotaDataSaveMsgRepeat.put("quotaCode", new HashSet<>());
                        tjQuotaDataSaveMsgRepeat.put("saveCode", new HashSet<>());
                        //指标数据存储库
                        tjQuotaDataSaveMsg = new TjQuotaDataSaveMsg();
                        tjQuotaDataSaveMsg.setQuotaCode(quota.getCode());
                        tjQuotaDataSaveMsg.setSaveCode(getCellCont(sheet, i, 7));
                        tjQuotaDataSaveMsg.setConfigJson(getCellCont(sheet, i, 8));
                        if (tjQuotaDataSaveMsg.validate(tjQuotaDataSaveMsgRepeat) == 0) {
                            correct = false;
                        }
                        quota.setQuotaDataSave(tjQuotaDataSaveMsg);

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
                        quotaMain = new TjQuotaDMainMsg();
                        //主维度
                        quotaMainRepeat = new HashMap<>();
                        quotaMainRepeat.put("quotaCode", new HashSet<>());
                        quotaMainRepeat.put("mainCode", new HashSet<>());
                        quotaMainRepeat.put("name", new HashSet<>());
                        //主维度
                        quotaMain.setQuotaCode(getCellCont(sheet, i, 0));
                        quotaMain.setMainCode(getCellCont(sheet, i, 1));
                        quotaMain.setName(getCellCont(sheet, i, 2));
                        quotaMain.setDictSql(getCellCont(sheet, i, 3));
                        quotaMain.setKeyVal(getCellCont(sheet, i, 4));
                        if (quotaMain.validate(quotaMainRepeat) == 0) {
                            correct = false;
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
                        quotaSlave = new TjQuotaDSlaveMsg();
                        //细维度
                        quotaSlaveRepeat = new HashMap<>();
                        quotaSlaveRepeat.put("quotaCode", new HashSet<>());
                        quotaSlaveRepeat.put("slaveCode", new HashSet<>());
                        quotaSlaveRepeat.put("name", new HashSet<>());
                        //主维度
                        quotaSlave.setQuotaCode(getCellCont(sheet, i, 0));
                        quotaSlave.setSlaveCode(getCellCont(sheet, i, 1));
                        quotaSlave.setName(getCellCont(sheet, i, 2));
                        quotaSlave.setDictSql(getCellCont(sheet, i, 3));
                        quotaSlave.setKeyVal(getCellCont(sheet, i, 4));
                        quotaSlave.setSort(getCellCont(sheet, i, 5));
                        if (quotaSlave.validate(quotaSlaveRepeat) == 0) {
                            correct = false;
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
}
