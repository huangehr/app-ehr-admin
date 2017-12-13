package com.yihu.ehr.redis;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.redis.MRedisMqSubscriber;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Redis消息订阅者 controller
 *
 * @author 张进军
 * @date 2017/11/13 15:14
 */
@Controller
@RequestMapping("/redis/mq/subscriber")
public class RedisMqSubscriberController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model, String channel) {
        model.addAttribute("channel", channel);
        model.addAttribute("contentPage", "redis/mq/subscriber/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id, String channel) {
        Object detailModel = new MRedisMqSubscriber(channel);
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Redis.MqSubscriber.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "redis/mq/subscriber/detail");
        return "simpleView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String searchContent, String channel, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        filters.append("channel=" + channel + ";");
        if (!StringUtils.isEmpty(searchContent)) {
            filters.append("subscribedUrl?" + searchContent + ";");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqSubscriber.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 保存
     */
    @RequestMapping("/save")
    @ResponseBody
    public Object save(String data) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        try {
            MRedisMqSubscriber model = objectMapper.readValue(data, MRedisMqSubscriber.class);
            if (StringUtils.isEmpty(model.getSubscribedUrl())) {
                return failed("订阅者服务地址不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Redis.MqSubscriber.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Redis.MqSubscriber.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                MRedisMqSubscriber updateModel = getEnvelopModel(envelopGet.getObj(), MRedisMqSubscriber.class);
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Redis.MqSubscriber.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 删除
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String id) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Redis.MqSubscriber.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证指定消息队列中订阅者应用ID是否唯一
     */
    @RequestMapping("/isUniqueAppId")
    @ResponseBody
    public Object isUniqueAppId(Integer id, String channel, String appId) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("channel", channel);
            params.put("appId", appId);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqSubscriber.IsUniqueAppId, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证指定消息队列中订阅者服务地址是否唯一
     */
    @RequestMapping("/isUniqueSubscribedUrl")
    @ResponseBody
    public Object isUniqueSubscribedUrl(Integer id, String channel, String subscriberUrl) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("channel", channel);
            params.put("subscriberUrl", subscriberUrl);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqSubscriber.IsUniqueSubscribedUrl, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqSubscriberController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
