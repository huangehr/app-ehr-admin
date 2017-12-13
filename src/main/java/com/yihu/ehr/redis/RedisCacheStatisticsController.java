package com.yihu.ehr.redis;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 缓存统计 Controller
 *
 * @author 张进军
 * @date 2017/11/30 17:07
 */
@Controller
@RequestMapping("/redis/cache/statistics")
public class RedisCacheStatisticsController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 统计缓存分类的缓存个数
     */
    @RequestMapping("/getCategoryKeys")
    @ResponseBody
    public Object getCategoryKeys() {
        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheStatistics.GetCategoryKeys, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheStatisticsController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 统计缓存分类的缓存内存比率（近似值，比实际略小）
     */
    @RequestMapping("/getCategoryMemory")
    @ResponseBody
    public Object getCategoryMemory() {
        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheStatistics.GetCategoryMemory, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheStatisticsController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
