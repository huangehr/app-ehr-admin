package com.yihu.ehr.redis;

import com.yihu.ehr.agModel.redis.RedisMqChannelModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
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
 * Redis消息队列 controller
 *
 * @author 张进军
 * @date 2017/11/10 11:45
 */
@Controller
    @RequestMapping("/redis/mq/channel")
public class RedisMqChannelController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "redis/mq/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new RedisMqChannelModel();
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Redis.MqChannel.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "redis/mq/detail");
        return "simpleView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String searchContent, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        if (!StringUtils.isEmpty(searchContent)) {
            filters.append("channel?" + searchContent + " g1;channelName?" + searchContent + " gl;");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqChannel.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
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
            RedisMqChannelModel model = objectMapper.readValue(data, RedisMqChannelModel.class);
            if (StringUtils.isEmpty(model.getChannel())) {
                return failed("消息队列编码不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Redis.MqChannel.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Redis.MqChannel.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                RedisMqChannelModel updateModel = getEnvelopModel(envelopGet.getObj(), RedisMqChannelModel.class);
                updateModel.setChannel(model.getChannel());
                updateModel.setChannelName(model.getChannelName());
//                updateModel.setAuthorizedCode(model.getAuthorizedCode());
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Redis.MqChannel.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
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
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Redis.MqChannel.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证消息队列编码是否唯一
     */
    @RequestMapping("/isUniqueChannel")
    @ResponseBody
    public Object isUniqueChannel(Integer id, String channel) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("channel", channel);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqChannel.IsUniqueChannel, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证消息队列名是否唯一
     */
    @RequestMapping("/isUniqueChannelName")
    @ResponseBody
    public Object isUniqueChannelName(Integer id, String channelName) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("channelName", channelName);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.MqChannel.IsUniqueChannelName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisMqChannelController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
