package com.yihu.ehr.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/22
 */
public class ControllerTools {
    private static ObjectMapper objectMapper = new ObjectMapper();

    public static boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
    }

    public static void print(HttpServletResponse response, Envelop envelop) throws IOException {
        response.getWriter().print(toJson(envelop));
    }

    public static void print(HttpServletResponse response, String msg) throws IOException {
        response.getWriter().print(toJson(exception(msg)));
    }

    public static void print(HttpServletResponse response, Exception e) throws IOException {
        response.getWriter().print(toJson(exception(e)));
    }
    
    public static Envelop exception(Exception e) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        envelop.setErrorMsg(e.getMessage());
        return envelop;
    }

    public static Envelop exception(String msg) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        envelop.setErrorMsg(msg);
        return envelop;
    }

    public static String toJson(Object data) {
        try {
            return objectMapper.writeValueAsString(data);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
