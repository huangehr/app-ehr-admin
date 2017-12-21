package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.std.model.DictionaryEntryMsg;
import com.yihu.ehr.std.model.DictionaryMsg;
import com.yihu.ehr.util.excel.AExcelReader;
import jxl.Sheet;
import jxl.Workbook;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class DictionaryMsgReader extends AExcelReader {

    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();

            boolean correct = true;
            int j = 0, rows;
            Map<String, Set> childRepeat;

            DictionaryMsg p;
            DictionaryEntryMsg child;
            getRepeat().put("code", new HashSet<>());

            for (Sheet sheet : sheets) {
                correct = true;
                if ((rows = sheet.getRows()) == 0) continue;
                p = new DictionaryMsg();
                //标识
                if(null != getCellCont(sheet, 0, 1)){
                    //replaceBlank去除空格、回车、换行、制表符
                    p.setCode(replaceBlank(getCellCont(sheet, 0, 1)));
                }else{
                    p.setCode(getCellCont(sheet, 0, 1));
                }

                //名称
                if(null != getCellCont(sheet, 1, 1)){
                    //replaceBlank去除空格、回车、换行、制表符
                    p.setName(replaceBlank(getCellCont(sheet, 1, 1)));
                }else{
                    p.setName(getCellCont(sheet, 1, 1));
                }

                p.setExcelSeq(j);
                if (p.validate(repeat) == 0)
                    correct = false;
                childRepeat = new HashMap<>();
                childRepeat.put("code", new HashSet<>());
                for (int i = 0; i < rows; i++) {
                    child = new DictionaryEntryMsg();
                    child.setDictCode(p.getCode());

                    //编码
                    if(null != getCellCont(sheet, i, 3)){
                        //replaceBlank去除空格、回车、换行、制表符
                        child.setCode(replaceBlank(getCellCont(sheet, i, 3)));
                    }else{
                        child.setCode(getCellCont(sheet, i, 3));
                    }

                    //名称
                    if(null != getCellCont(sheet, i, 4)){
                        //replaceBlank去除空格、回车、换行、制表符
                        child.setName(replaceBlank(getCellCont(sheet, i, 4)));
                    }else{
                        child.setName(getCellCont(sheet, i, 4));
                    }
                    child.setExcelSeq(i);
                    int vrs = child.validate(childRepeat);
                    if (vrs == -1)
                        continue;
                    else if (vrs == 0)
                        correct = false;
                    p.addChild(child);
                }

                if (!correct)
                    errorLs.add(p);
                else
                    correctLs.add(p);
                j++;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (rwb != null) rwb.close();
        }
    }
}
