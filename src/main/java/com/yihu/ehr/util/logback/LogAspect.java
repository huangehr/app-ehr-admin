package com.yihu.ehr.util.logback;

import com.google.gson.Gson;
import com.yihu.ehr.agModel.user.UserDetailModel;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * chendi
 * Created by lenovo on 2017/5/11.
 */
@Aspect
@Component
public class LogAspect {
    private static Logger logger = LoggerFactory.getLogger(LogAspect.class);
    private String requestPath = null; // 请求地址
    private String userName = null; // 用户名
    private Map<?, ?> inputParamMap = null; // 传入参数
    private Map<String, Object> outputParamMap = null; // 存放输出结果
    private long startTimeMillis = 0; // 开始时间
    private long endTimeMillis = 0; // 结束时间

    /**
     * @param joinPoint
     * @Title：doBeforeInServiceLayer
     * @Description: 方法调用前触发
     * 记录开始时间
     * @author chendi
     * @date 2017.05.11
     */
    @Before("execution(* com.yihu.ehr.*.controller..*.*(..))")
    public void doBeforeInServiceLayer(JoinPoint joinPoint) {
        startTimeMillis = System.currentTimeMillis(); // 记录方法开始执行的时间
    }

    /**
     * @param joinPoint
     * @Title：doAfterInServiceLayer
     * @Description: 方法调用后触发
     * 记录结束时间
     * @author chendi
     * @date 2017.05.11
     */
    @After("execution(* com.yihu.ehr.*.controller..*.*(..))")
    public void doAfterInServiceLayer(JoinPoint joinPoint) {
        endTimeMillis = System.currentTimeMillis(); // 记录方法执行完成的时间
        this.printOptLog();
    }

    /**
     * @param pjp
     * @return
     * @throws Throwable
     * @Title：doAround
     * @Description: 环绕触发
     * @author chendi
     * @date 2017.05.11
     */
    @Around("execution(* com.yihu.ehr.*.controller..*.*(..))")
    public Object doAround(ProceedingJoinPoint pjp) throws Throwable {
        /**
         * 1.获取request信息
         * 2.根据request获取session
         * 3.从session中取出登录用户信息
         */
        RequestAttributes ra = RequestContextHolder.getRequestAttributes();
        ServletRequestAttributes sra = (ServletRequestAttributes) ra;
        HttpServletRequest request = sra.getRequest();
        // 获取输入参数
        inputParamMap = request.getParameterMap();
        // 获取请求地址
        requestPath = request.getRequestURI();

        // 执行完方法的返回值：调用proceed()方法，就会触发切入点方法执行
        outputParamMap = new HashMap<String, Object>();
        Object result = pjp.proceed();// result的值就是被拦截方法的返回值
        outputParamMap.put("result", result);

        return result;
    }

    /**
     * @Title：printOptLog
     * @Description: 输出日志
     * @author chendi
     * @date 2017.05.11
     */
    private void printOptLog() {
        Gson gson = new Gson(); // 需要用到google的gson解析包
        String optTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(startTimeMillis);
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getResponse();
        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("loginCode");
//        logger.info("\n user:" + userName
//                + "  url:" + requestPath + ": op_time:" + optTime + " pro_time:" + (endTimeMillis - startTimeMillis) + "ms :"
//                + " param:" + gson.toJson(inputParamMap) + ";" + "\n result:" + gson.toJson(outputParamMap));

        JSONObject data = new JSONObject();
        UserDetailModel userModel=(UserDetailModel) session.getAttribute("current_user");
        if(null!=userModel){
            data.put("patient", userModel.getRealName());// 总支撑
        }
        data.put("url", requestPath);// 调用的控制器路径
        data.put("responseTime", endTimeMillis - startTimeMillis);// 操作响应时间长
        data.put("responseCode", response.getStatus());// 调用返回结果代码 successflag = true & false
        System.out.println(gson.toJson(outputParamMap));
        data.put("response", gson.toJson(outputParamMap));// 请求返回的结果
        data.put("appKey", "EHR");// 总支撑
        data.put("param", gson.toJson(inputParamMap)); // 请求传递的参数


        if (userName != null && !"".equals(userName)) {
            BusinessLogs.info(userName, data);
        }
    }
}
