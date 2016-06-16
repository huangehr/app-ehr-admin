package com.yihu.ehr.util.excel;

import com.yihu.ehr.agModel.resource.RsMetaMsgModel;
import com.yihu.ehr.util.operator.DateUtil;
import jxl.Workbook;
import jxl.write.*;
import org.springframework.util.StringUtils;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public class ExcelWriter {
    public static String tmpdir = System.getProperty("java.io.tmpdir");
    public static String separator = System.getProperty("file.separator");
    public static String fileType = ".xls";
    public static String defPath = "ehr" + separator;

    Class entity;
    Map<String, Method[]> methods;
    Map<String, Integer> seq;

    Class entryEntity;
    Map<String, Method[]> entryMethods;
    Map<String, Integer> entrySeq;

    String sheetNameFiled = null;
    Map<Integer, String> headerMap ;

    public ExcelWriter(Class entity, Map<String, Method[]> methods, Map<String, Integer> seq,
                       Class entryEntity, Map<String, Method[]> entryMethods, Map<String, Integer> entrySeq,
                       String sheetNameFiled, Map<Integer, String> headerMap) {
        this.entity = entity;
        this.methods = methods;
        this.seq =seq;
        this.entryEntity = entryEntity;
        this.entryMethods = entryMethods;
        this.entrySeq = entrySeq;
        this.sheetNameFiled = sheetNameFiled;
        this.headerMap = headerMap;
    }

    public static String createFileName(String userId, String type) throws IOException {
        File file = new File( tmpdir + defPath  );
        if(!file.exists())
            file.mkdirs();

        String curPath = DateUtil.getCurrentString("yyyy_MM_dd") + separator;
        file = new File( tmpdir + defPath + curPath );
        if(!file.exists())
            file.mkdirs();
        return curPath + DateUtil.getCurrentString("HHmmss") + "_" + userId + "_" + type + fileType;
    }

    public static String getFullPath(String fileName){
        return tmpdir + defPath + fileName;
    }

    public void createXls(Map<Object, List> map, String fileName) throws Exception {
        WritableWorkbook wwb = null;
        try {
            File f = new File( getFullPath(fileName) );
            if(f.exists())
                f.delete();
            f.createNewFile();
            WritableSheet ws;
            wwb = Workbook.createWorkbook(f);

            if(sheetNameFiled!=null){
                for(Object obj : map.keySet()){
                    ws = wwb.createSheet(String.valueOf(methods.get(sheetNameFiled)[1].invoke(obj)), 0);
                    addHeader(ws);
                    for(String field: seq.keySet()){
                        addCell(ws, 1, seq.get(field),
                                String.valueOf(methods.get(field)[1].invoke(obj)), ((ErrorMsgUtil) obj).findErrorMsg(field));
                    }

                    int j=0;
                    for(Object entry: map.get(obj)){
                        for(String field: entrySeq.keySet()){
                            addCell(ws, entrySeq.get(field), j,
                                    String.valueOf(entryMethods.get(field)[1].invoke(entry)), ((ErrorMsgUtil) entry).findErrorMsg(field));
                        }
                        j++;
                    }

                }
            }

            wwb.write();
        }catch (Exception e){
            throw e;
        }finally {
            if(wwb!=null) wwb.close();
        }
    }

    //添加单元格内容
    public static void addCell(WritableSheet ws,int column, int row, String data) throws WriteException {
        Label label = new Label(column ,row, data);
        ws.addCell(label);
    }

    //添加单元格内容
    public static void addCell(WritableSheet ws,int column, int row, String data, String memo) throws WriteException {

        Label label = new Label(column ,row, data);
        if(!StringUtils.isEmpty(memo)){
            WritableCellFeatures cellFeatures = new WritableCellFeatures();
            cellFeatures.setComment(memo);
            label.setCellFeatures(cellFeatures);
        }
        ws.addCell(label);
    }

    public void addHeader(WritableSheet ws) throws WriteException {
        if(headerMap!=null){
            for(Integer i : headerMap.keySet()){
                addCell(ws, 0, i, headerMap.get(i));
            }
        }
    }
}
