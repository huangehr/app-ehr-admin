package com.yihu.ehr.util.excel;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public interface ErrorMsgUtil {

    public void addErrorMsg(String field, String msg);
    public String findErrorMsg(String field);

    public int getExcelRow();
    public void setExcelRow(int excelRow);
}
