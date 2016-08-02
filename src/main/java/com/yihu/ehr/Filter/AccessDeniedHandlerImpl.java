package com.yihu.ehr.Filter;

import com.yihu.ehr.util.ControllerTools;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/22
 */

/**
 * 错误信息拦截器
 */
public class AccessDeniedHandlerImpl implements AccessDeniedHandler {

    private String errorPage;

    /**
     * 拦截错误信息， 并按逻辑返回错误到前端页面
     * @param request
     * @param response
     * @param accessDeniedException
     * @throws IOException
     * @throws ServletException
     */
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException)
            throws IOException, ServletException {

        if(ControllerTools.isAjaxRequest(request)){
            response.setHeader("noPermission", "true");
            ControllerTools.print(response, "{}");
        }else if (!response.isCommitted()) {
            if (errorPage != null) {
                // Set the 403 status code.
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                // forward to error page.
                RequestDispatcher dispatcher = request.getRequestDispatcher(errorPage);
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, accessDeniedException.getMessage());
            }
        }
    }

    public void setErrorPage(String errorPage) {
        if ((errorPage != null) && !errorPage.startsWith("/")) {
            throw new IllegalArgumentException("errorPage must begin with '/'");
        }
        this.errorPage = errorPage;
    }
}

