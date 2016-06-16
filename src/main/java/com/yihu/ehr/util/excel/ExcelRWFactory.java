package com.yihu.ehr.util.excel;

import com.yihu.ehr.agModel.resource.RsMetaMsgModel;
import com.yihu.ehr.resource.model.RsDictionaryEntryMsg;
import com.yihu.ehr.resource.model.RsDictionaryMsg;
import javafx.util.Pair;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public class ExcelRWFactory {
    private static Map<String, Map<String, Method[]>> entityMap;

    static {
        entityMap = new HashMap<>();
        Class[] clzs = new Class[]{
                RsMetaMsgModel.class, RsDictionaryMsg.class, RsDictionaryEntryMsg.class};

        initEntityMap(clzs);
    }

    private static void initEntityMap(Class[] clzs){
        Map<String, Method[]> clsMtd;
        Method[] mtds;
        Field[] fields;
        String fieldName;
        for(Class clz : clzs){
            clsMtd = new HashMap<>();
            fields = clz.getDeclaredFields();
            for(Field field :fields){
                mtds = new Method[2];
                fieldName = firstToUpper(field.getName());
                try {
                    mtds[0] = clz.getMethod("set"+ fieldName, field.getType());
                    mtds[1] = clz.getMethod("get"+ fieldName);
                    clsMtd.put(field.getName(), mtds);
                } catch (NoSuchMethodException e) {}
            }
            entityMap.put(clz.getName(), clsMtd);
        }
    }

    private static String firstToUpper(String str){
        return str.substring(0,1).toUpperCase() + str.substring(1, str.length());
    }
    public static ExcelReader createReader(Class entityClz, Map<String, Integer> seq, Class entryEntity,  Map<String, Integer> entrySeq, Pair<String, String> relevancy){

        return new ExcelReader(entityClz, getMethods(entityClz), seq,
                entryEntity, getMethods(entryEntity), entrySeq, relevancy);
    }

    public static ExcelWriter createWriter(Class entityClz, Map<String, Integer> seq, Class entryEntity,  Map<String, Integer> entrySeq,
                                           String sheetNameFiled, Map<Integer, String> headerMap){

        return new ExcelWriter(entityClz, getMethods(entityClz), seq,
                entryEntity, getMethods(entryEntity), entrySeq, sheetNameFiled, headerMap);
    }

    public static Map<String, Method[]> getMethods(Class clz){
        return entityMap.get(clz.getName());
    }
}
