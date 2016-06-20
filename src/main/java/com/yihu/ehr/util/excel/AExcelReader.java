package com.yihu.ehr.util.excel;

import jxl.Sheet;
import jxl.Workbook;

import java.io.File;
import java.io.InputStream;
import java.util.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/18
 */
public abstract class AExcelReader {
    protected List errorLs = new ArrayList<>();
    protected List correctLs = new ArrayList<>();
    protected Map<String, Set> repeat = new HashMap<>();

    public abstract void read(Workbook rwb) throws Exception;

    public void read(File file) throws Exception {
        read(Workbook.getWorkbook(file));
    }

    public void read(InputStream is) throws Exception {
        read(Workbook.getWorkbook(is));
    }

    protected String getCellCont(Sheet sheet, int row, int col){
        return sheet.getCell(col, row).getContents();
    }

    public List getErrorLs() {
        return errorLs;
    }

    public void setErrorLs(List errorLs) {
        this.errorLs = errorLs;
    }

    public List getCorrectLs() {
        return correctLs;
    }

    public void setCorrectLs(List correctLs) {
        this.correctLs = correctLs;
    }

    public Map<String, Set> getRepeat() {
        return repeat;
    }

    public void setRepeat(Map<String, Set> repeat) {
        this.repeat = repeat;
    }
}
