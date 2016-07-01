package com.yihu.ehr.util.excel;

import java.util.regex.Pattern;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/16
 */
public class RegUtil {
    public static Pattern codePtnNR = Pattern.compile("[0-9A-Za-z_.]{0,50}");
    public static Pattern codePtn = Pattern.compile("[0-9A-Za-z_.]{1,50}");
    public static Pattern lenPtn = Pattern.compile("[\\s\\S]{1,200}");
    public static String lenMsg = "只允许1至200个字符之间";
    public static String codeMsg = "只允许输入数字、英文、小数点与下划线！";
    public static Pattern rsMetaIdPtn = Pattern.compile("EHR_[0-9]{6}");
    public static String rsMetaIdMsg = "只允许以EHR_开头，并跟着6位数字，如：EHR_000001";

    public static boolean regLength(int min, int max, String str){

        return Pattern.compile("[\\s\\S]{"+ min +","+ max +"}").matcher(str).matches();
    }

    public static boolean regCode(String str){

        return codePtn.matcher(str).matches();
    }

    public static boolean regCodeNR(String str){

        return codePtnNR.matcher(str).matches();
    }

    public static boolean regMetaId(String str){

        return rsMetaIdPtn.matcher(str).matches();
    }

    public static boolean regLen(String str){

        return lenPtn.matcher(str).matches();
    }

    public static boolean regLength2(int min, int max, String str){

        return str.length()>=min && str.length()<=max;
    }
}
