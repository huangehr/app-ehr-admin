package com.yihu.ehr.util.excel;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/18
 */
public abstract class ExcelUtil implements Serializable {
    public int excelSeq;
    public Map<String, String> errorMsg = new HashMap<>();

    public int getExcelSeq() {
        return excelSeq;
    }

    public void setExcelSeq(int excelSeq) {
        this.excelSeq = excelSeq;
    }

    public void addErrorMsg(String field, String msg){
        errorMsg.put(field, msg);
    };

    public String findErrorMsg(String field){
        return errorMsg.get(field);
    };

    public void clearErrorMsg(){
        errorMsg.clear();
    };

    public void removeErrorMsg(String field){
        errorMsg.remove(field);
    };

    @Override
    public boolean equals(Object obj) {
        return getExcelSeq() == ((ExcelUtil) obj).getExcelSeq();
    }
}
