package com.yihu.ehr.util.excel;

import com.yihu.ehr.util.operator.DateUtil;

import java.io.File;
import java.io.IOException;

import org.apache.log4j.Logger;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/19
 */
public class TemPath {
    public static Logger logger  = Logger.getLogger(TemPath.class);
    public final static String tmpdir = System.getProperty("java.io.tmpdir");
    public final static String separator = System.getProperty("file.separator");
    public final static String defPath = "ehr" + separator;

    public static String createFileName(String userId, String type, String parentFile, String fileType) throws IOException {
        File file = new File( tmpdir + separator + defPath + parentFile + separator);
        if(!file.exists())
            file.mkdirs();

        String curPath = DateUtil.getCurrentString("yyyy_MM_dd") + separator;
        String fileUrl = tmpdir + separator + defPath + parentFile + separator + curPath;
        logger.warn("upload addrr = " + fileUrl);
        file = new File( fileUrl );
        if(!file.exists())
            file.mkdirs();
        return curPath + DateUtil.getCurrentString("HHmmss") + "_" + userId + "_" + type + fileType;
    }

    public static String getFullPath(String fileName, String parent){

        return tmpdir + separator + defPath + parent + separator + fileName;
    }

}
