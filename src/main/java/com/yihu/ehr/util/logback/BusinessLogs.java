package com.yihu.ehr.util.logback;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * chendi
 * <p>
 * Created by lenovo on 2017/5/10.
 */
public class BusinessLogs {

    // 日志输出
    private static Logger logger = LoggerFactory.getLogger(BusinessLogs.class);

    /**
     * 业务日志输出
     *
     * @param info 日志信息
     */
    public static void info(String caller, JSONObject info) {
        try {
            JSONObject log = new JSONObject();

            log.put("caller", caller);
            log.put("time", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS").format(new Date()));
            log.put("logType", "3");

            JSONObject data = new JSONObject();

            log.put("data", info);

            logger.info(log.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}