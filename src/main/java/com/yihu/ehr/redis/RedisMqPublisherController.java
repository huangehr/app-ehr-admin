package com.yihu.ehr.redis;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.redis.MRedisMqPublisher;
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
 * Redis消息发布者 controller
 *
 * @author 张进军
 * @date 2017/11/20 15:28
 */
@Controller
@RequestMapping("/redis/mq/publisher")
public class RedisMqPublisherController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model, String channel) {
        model.addAttribute("channel", channel);
        model.addAttribute("contentPage", "redis/mq/publisher/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id, String channel) {
        Object detailModel = new MRedisMqPublisher(channel);
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Redis.MqPublisher.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqPublisherController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "redis/mq/publisher/detail");
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
            filters.append("appId?" + searchContent + ";");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqPublisher.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqPublisherController.class).error(e.getMessage());
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
            MRedisMqPublisher model = objectMapper.readValue(data, MRedisMqPublisher.class);
            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Redis.MqPublisher.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Redis.MqPublisher.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                MRedisMqPublisher updateModel = getEnvelopModel(envelopGet.getObj(), MRedisMqPublisher.class);
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Redis.MqPublisher.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqPublisherController.class).error(e.getMessage());
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
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Redis.MqPublisher.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqPublisherController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证指定队列中发布者应用ID是否唯一
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
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqPublisher.IsUniqueAppId, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqPublisherController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
