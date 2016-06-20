package com.yihu.ehr.util.excel;

import jxl.Workbook;
import jxl.write.*;
import org.springframework.util.StringUtils;

import java.io.File;
import java.io.OutputStream;
import java.util.List;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/19
 */
public abstract class AExcelWriter {

    public abstract void write(WritableWorkbook wwb, List ls) throws Exception;

    public void write(OutputStream os, List ls) throws Exception{
        write(Workbook.createWorkbook(os), ls);
    };

    public void write(File file, List ls) throws Exception{
        write(Workbook.createWorkbook(file), ls);
    };

    //添加单元格内容
    public void addCell(WritableSheet ws, int row, int column,  String data) throws WriteException {
        Label label = new Label(column ,row, data);
        ws.addCell(label);
    }

    //添加单元格内容
    public void addCell(WritableSheet ws, int row, int column, String data, String memo) throws WriteException {

        Label label = new Label(column ,row, data);
        if(!StringUtils.isEmpty(memo)){
            WritableCellFeatures cellFeatures = new WritableCellFeatures();
            cellFeatures.setComment(memo);
            label.setCellFeatures(cellFeatures);
        }
        ws.addCell(label);
    }
}
