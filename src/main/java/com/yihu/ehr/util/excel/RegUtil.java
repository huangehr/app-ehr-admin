package com.yihu.ehr.util.excel;

import java.util.regex.Pattern;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/16
 */
public class RegUtil {
    public static Pattern codePtn = Pattern.compile("[0-9A-Za-z_.]{1,50}");
    public static String codeMsg = "只允许输入数字、英文、小数点与下划线！";

    public static boolean regLength(int min, int max, String str){

        return Pattern.compile("[\\s\\S]{"+ min +","+ max +"}").matcher(str).matches();
    }

    public static boolean regCode(String str){

        return codePtn.matcher(str).matches();
    }
}
