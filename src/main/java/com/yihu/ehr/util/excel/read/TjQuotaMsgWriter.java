package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.quota.controller.model.TjQuotaDMainMsg;
import com.yihu.ehr.quota.controller.model.TjQuotaDSlaveMsg;
import com.yihu.ehr.quota.controller.model.TjQuotaMsg;
import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.Workbook;
import jxl.write.*;
import org.apache.commons.lang.StringUtils;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class TjQuotaMsgWriter {
    //指标
    public void addHeader(WritableSheet ws) throws WriteException {
        String[] header = {"编码", "名称", "指标类型", "执行方式", "对象类", "数据源库", "数据源配置", "数据库存储", "存储配置", "存储方式", "备注"};
        int i = 0;
        for (String h : header) {
            addCell(ws, 0, i, h);
            i++;
        }
    }
    //主维度
    public void addMainHeader(WritableSheet ws) throws WriteException {
        String[] quotaMainCheader = {"指标编码", "主维度编码", "sql", "key"};
        int i = 0;
        for (String h : quotaMainCheader) {
            addCell(ws, 0, i, h);
            i++;
        }
    }

    //细维度
    public void addSlaveHeader(WritableSheet ws) throws WriteException {
        String[] quotaSlaveCheader = {"指标编码", "细维度编码", "sql", "key", "维度顺序"};
        int  i = 0;
        for (String h : quotaSlaveCheader) {
            addCell(ws, 0, i, h);
            i++;
        }
    }

    public void write(WritableWorkbook wwb, List ls ,List quotaMainErrorLs,List quotaSlaveErrorLs) throws Exception {
        try {
            WritableSheet ws;
            int i = 1;
            //指标
            if(null != ls && ls.size()>0) {
                ws = wwb.createSheet("指标", 0);
                for (TjQuotaMsg m : (List<TjQuotaMsg>) ls) {
                    addHeader(ws);
                    addCell(ws, i, 0, m.getCode(), m.findErrorMsg("code"));
                    addCell(ws, i, 1, m.getName(), m.findErrorMsg("name"));
                    addCell(ws, i, 2, m.getQuotaType(), m.findErrorMsg("quotaType"));
                    //1- 立即执行 2- 周期执行
                    if (null != m.getExecType() && "1".equals(m.getExecType())) {
                        addCell(ws, i, 3, "立即执行", m.findErrorMsg("execType"));
                    } else {
                        addCell(ws, i, 3, "周期执行", m.findErrorMsg("execType"));
                    }

                    //加法  com.yihu.quota.job.EsQuotaJob / 除法 com.yihu.quota.job.EsQuotaPercentJob
                    if (null != m.getJobClazz() && "com.yihu.quota.job.EsQuotaJob".equals(m.getJobClazz())) {
                        addCell(ws, i, 4, "加法对象类", m.findErrorMsg("jobClazz"));
                    } else {
                        addCell(ws, i, 4, "除法对象类", m.findErrorMsg("jobClazz"));
                    }

                    // 1= ElasticSearch;2=Solr;3=MySQL
                    if (null != m.getQuotaDataSource() && "1".equals(m.getQuotaDataSource())) {
                        addCell(ws, i, 5, "ElasticSearch", m.findErrorMsg("quotaDataSource"));
                    } else if (null != m.getQuotaDataSource() && "2".equals(m.getQuotaDataSource())) {
                        addCell(ws, i, 5, "Solr", m.findErrorMsg("quotaDataSource"));
                    } else {
                        addCell(ws, i, 5, "MySQL", m.findErrorMsg("quotaDataSource"));
                    }

                    addCell(ws, i, 6, m.getQuotaDataSourceConfigJson(), m.findErrorMsg("quotaDataSourceConfigJson"));

                    // 1= ElasticSearch；2=MySQL
                    if (null != m.getQuotaDataSave() && "1".equals(m.getQuotaDataSave())) {
                        addCell(ws, i, 7, "ElasticSearch", m.findErrorMsg("quotaDataSave"));
                    } else {
                        addCell(ws, i, 7, "MySQL", m.findErrorMsg("quotaDataSave"));
                    }

                    addCell(ws, i, 8, m.getQuotaDataSaveConfigJson(), m.findErrorMsg("quotaDataSaveConfigJson"));
                    addCell(ws, i, 9, m.getDataLevel(), m.findErrorMsg("dataLevel"));
                    addCell(ws, i, 10, m.getRemark(), m.findErrorMsg("remark"));

                    i++;
                }
            }
            //主维度
            if(null != quotaMainErrorLs && quotaMainErrorLs.size()>0) {
                ws = wwb.createSheet("主维度", 1);
                i = 1;
                for (TjQuotaDMainMsg m : (List<TjQuotaDMainMsg>) quotaMainErrorLs) {
                    addMainHeader(ws);
                    addCell(ws, i, 0, m.getQuotaCode(), m.findErrorMsg("quotaCode"));
                    addCell(ws, i, 1, m.getMainCode(), m.findErrorMsg("mainCode"));
                    addCell(ws, i, 2, m.getDictSql(), m.findErrorMsg("dictSql"));
                    addCell(ws, i, 3, m.getKeyVal(), m.findErrorMsg("keyVal"));
                    i++;
                }
            }
            //细维度
            if(null != quotaSlaveErrorLs && quotaSlaveErrorLs.size()>0){
                ws = wwb.createSheet("细维度", 2);
                i = 1;
                for (TjQuotaDSlaveMsg m : (List<TjQuotaDSlaveMsg>) quotaSlaveErrorLs) {
                    addSlaveHeader(ws);
                    addCell(ws, i, 0, m.getQuotaCode(), m.findErrorMsg("quotaCode"));
                    addCell(ws, i, 1, m.getSlaveCode(), m.findErrorMsg("slaveCode"));
                    addCell(ws, i, 2, m.getDictSql(), m.findErrorMsg("dictSql"));
                    addCell(ws, i, 3, m.getKeyVal(), m.findErrorMsg("keyVal"));
                    addCell(ws, i, 4, m.getSort(), m.findErrorMsg("sort"));
                    i++;
                }
            }

            wwb.write();
            wwb.close();
        } catch (IOException e) {
            e.printStackTrace();
            if (wwb != null) wwb.close();
            throw e;
        }
    }

    public void write(File file, List ls, List ms, List ss) throws Exception{
        write(Workbook.createWorkbook(file), ls, ms, ss);

    };
    //添加单元格内容
    public void addCell(WritableSheet ws, int row, int column,  String data) throws WriteException {
        Label label = new Label(column ,row, data);
        ws.addCell(label);
    }
    //添加单元格内容
    public void addCell(WritableSheet ws, int row, int column, String data, String memo) throws WriteException {

        Label label = new Label(column ,row, data);
        if(!org.springframework.util.StringUtils.isEmpty(memo)){
            WritableCellFeatures cellFeatures = new WritableCellFeatures();
            cellFeatures.setComment(memo);
            label.setCellFeatures(cellFeatures);
        }
        ws.addCell(label);
    }
}
