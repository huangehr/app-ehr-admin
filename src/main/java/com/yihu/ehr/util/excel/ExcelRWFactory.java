package com.yihu.ehr.util.excel;

import com.yihu.ehr.resource.model.RsDictionaryMsg;
import com.yihu.ehr.resource.model.RsMetaMsgModel;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.HashMap;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public class ExcelRWFactory {
    private static Map<Class, Class[]> excelReaderMap;

    static {
        Class[] clzs = new Class[]{
                RsMetaMsgModel.class, RsDictionaryMsg.class};

        excelReaderMap = new HashMap<>();
        try {
            addPath(new File(ReaderCreator.path));
            for(Class clz : clzs){
                excelReaderMap.put(clz, ReaderCreator.create(clz));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void addPath(File f) throws Exception {
        URL u = f.toURI().toURL();
        URLClassLoader urlClassLoader = (URLClassLoader) ReaderCreator.class.getClassLoader();
        Class urlClass = URLClassLoader.class;
        Method method = urlClass.getDeclaredMethod("addURL", new Class[]{URL.class});
        method.setAccessible(true);
        method.invoke(urlClassLoader, new Object[]{u});
    }
    /**
     * 获取AExcelReader对象
     * @param clz
     * @return
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    public static AExcelReader getReader(Class clz) throws IllegalAccessException, InstantiationException {
        return (AExcelReader) excelReaderMap.get(clz)[0].newInstance();
    }

    /**
     * 获取AExcelWriter对象
     * @param clz
     * @return
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    public static AExcelWriter getWriter(Class clz) throws IllegalAccessException, InstantiationException {
        return (AExcelWriter) excelReaderMap.get(clz)[1].newInstance();
    }

}
