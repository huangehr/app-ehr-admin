package com.yihu.ehr.util.excel;

import javafx.util.Pair;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import java.io.File;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public class ExcelReader {

    Class entity;
    Map<String, Method[]> methods;
    Map<String, Integer> seq;

    Class entryEntity;
    Map<String, Method[]> entryMethods;
    Map<String, Integer> entrySeq;

    Pair<String, String> relevancy = null;

    List errorLs;
    List correctLs;

    Map errorMap;
    Map correctMap;
    Map<String, Set> repeat = new HashMap<>();

    public ExcelReader(Class entity, Map<String, Method[]> methods, Map<String, Integer> seq,
                       Class entryEntity, Map<String, Method[]> entryMethods, Map<String, Integer> entrySeq,
                       Pair<String, String> relevancy) {
        this.entity = entity;
        this.methods = methods;
        this.seq =seq;
        this.entryEntity = entryEntity;
        this.entryMethods = entryMethods;
        this.entrySeq = entrySeq;
        this.relevancy = relevancy;
    }

    public void read(File file) throws Exception {
        Workbook rwb = null;
        try {
            if(entryEntity!=null){
                read2(Workbook.getWorkbook(file));
            }
        }catch (Exception e){
            throw e;
        }finally {
            if(rwb!=null) rwb.close();
        }
    }

    public void read(InputStream is) throws Exception {
        Workbook rwb = null;
        try {
            rwb = Workbook.getWorkbook(is);
            if(entryEntity!=null){
                read2(rwb);
            }
        }catch (Exception e){
            throw e;
        }finally {
            if(rwb!=null) rwb.close();
        }
    }

    private void read2(Workbook rwb) throws Exception{
        Sheet[] sheets = rwb.getSheets();
        int rows;
        boolean correct = true;
        Object obj, entry, relevancyVal;
        errorMap = new HashMap<>();
        correctLs = new ArrayList<>();
        List entries;
        Cell cell;
        int j = 0;

        Map<String, Set> entryRepeat;
        for(Sheet sheet : sheets){
            if((rows = sheet.getRows()) == 0)continue;
            obj = entity.newInstance();
            for(String k: seq.keySet()){
                cell= sheet.getCell(1, seq.get(k));
                methods.get(k)[0].invoke(obj, cell.getContents());
                if(cell.getCellFeatures()!=null)
                    ((ErrorMsgUtil) obj).addErrorMsg(k, cell.getCellFeatures().getComment());
            }
            relevancyVal = methods.get(relevancy.getValue())[1].invoke(obj);
            ((ErrorMsgUtil) obj).setExcelRow(j);
            if(((Validation) obj).validate(repeat)==0)
                correct = false;

            entries = new ArrayList<>();
            entryRepeat = new HashMap<>();
            for(int i=0; i<rows; i++){
                entry = entryEntity.newInstance();
                entryMethods.get(relevancy.getKey())[0].invoke(entry, relevancyVal);
                for(String k: entrySeq.keySet()){
                    cell= sheet.getCell(entrySeq.get(k), i);
                    entryMethods.get(k)[0].invoke(entry, cell.getContents());
                    if(cell.getCellFeatures()!=null)
                        ((ErrorMsgUtil) obj).addErrorMsg(k, cell.getCellFeatures().getComment());
                }
                ((ErrorMsgUtil) obj).setExcelRow(i);
                int vrs = ((Validation) entry).validate(entryRepeat);
                if(vrs==-1)
                    continue;
                else if(vrs==0)
                    correct = false;
                entries.add(entry);
            }

            if(!correct)
                errorMap.put(obj, entries);
            else
                correctLs.add(new Pair<>(obj, entries));
            j++;
        }
        rwb.close();
    }

    public Map getErrorMap(){
        return errorMap;
    }

    public Map getCorrectMap() {
        return correctMap;
    }

    public List getErrorLs() {
        return errorLs;
    }

    public List getCorrectLs() {
        return correctLs;
    }

    public Map<String, Set> getRepeat() {
        return repeat;
    }
}
