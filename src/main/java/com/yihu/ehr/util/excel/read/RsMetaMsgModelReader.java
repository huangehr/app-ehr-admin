package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.resource.model.RsMetaMsgModel;

import java.util.HashSet;

import jxl.Sheet;
import jxl.Workbook;

public class RsMetaMsgModelReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            RsMetaMsgModel p;
            getRepeat().put("id", new HashSet<>());
            getRepeat().put("dictCode", new HashSet<>());

            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) continue;
                for (int i = 1; i < rows; i++, j++) {
                    p = new RsMetaMsgModel();
                    //数据元编码
                    if(null != getCellCont(sheet, i, 0)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setId(replaceBlank(getCellCont(sheet, i, 0)));
                    }else{
                        p.setId(getCellCont(sheet, i, 0));
                    }
                    //数据元名称
                    if(null != getCellCont(sheet, i, 1)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setName(replaceBlank(getCellCont(sheet, i, 1)));
                    }else{
                        p.setName(getCellCont(sheet, i, 1));
                    }
                    //业务领域
                    if(null != getCellCont(sheet, i, 2)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setDomain(replaceBlank(getCellCont(sheet, i, 2)));
                    }else{
                        p.setDomain(getCellCont(sheet, i, 2));
                    }
                    //内部标识符
                    if(null != getCellCont(sheet, i, 3)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setStdCode(replaceBlank(getCellCont(sheet, i, 3)));
                    }else{
                        p.setStdCode(getCellCont(sheet, i, 3));
                    }
                    //类型
                    if(null != getCellCont(sheet, i, 4)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setColumnType(replaceBlank(getCellCont(sheet, i, 4)));
                    }else{
                        p.setColumnType(getCellCont(sheet, i, 4));
                    }
                    //类型
                    if(null != getCellCont(sheet, i, 5)){
                        //replaceBlank去除空格、回车、换行、制表符
                        p.setDictCode(replaceBlank(getCellCont(sheet, i, 5)));
                    }else{
                        p.setDictCode(getCellCont(sheet, i, 5));
                    }

                    p.setNullAble(getCellCont(sheet, i, 6));
                    p.setDescription(getCellCont(sheet, i, 7));

                    p.setExcelSeq(j);
                    int rs = p.validate(repeat);
                    if (rs == 0)
                        errorLs.add(p);
                    else if (rs == 1)
                        correctLs.add(p);
                }
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (rwb != null) rwb.close();
        }
    }
}
