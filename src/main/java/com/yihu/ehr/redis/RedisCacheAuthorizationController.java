package com.yihu.ehr.redis;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.redis.MRedisCacheAuthorization;
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
 * 缓存授权 Controller
 *
 * @author 张进军
 * @date 2017/11/27 16:21
 */
@Controller
@RequestMapping("/redis/cache/authorization")
public class RedisCacheAuthorizationController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model, String categoryCode) {
        model.addAttribute("categoryCode", categoryCode);
        model.addAttribute("contentPage", "redis/cache/authorization/list");
        return "emptyView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id, String categoryCode) {
        Object detailModel = new MRedisCacheAuthorization(categoryCode);
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Redis.CacheAuthorization.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheAuthorizationController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "redis/cache/authorization/detail");
        return "simpleView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String searchContent, String categoryCode, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        filters.append("categoryCode=" + categoryCode + ";");
        if (!StringUtils.isEmpty(searchContent)) {
            filters.append("appId?" + searchContent + ";");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheAuthorization.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
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
            MRedisCacheAuthorization model = objectMapper.readValue(data, MRedisCacheAuthorization.class);
            if (StringUtils.isEmpty(model.getAppId())) {
                return failed("应用ID不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Redis.CacheAuthorization.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Redis.CacheAuthorization.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                MRedisCacheAuthorization updateModel = getEnvelopModel(envelopGet.getObj(), MRedisCacheAuthorization.class);
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Redis.CacheAuthorization.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
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
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Redis.CacheAuthorization.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 验证指定缓存分类下应用ID是否唯一
     */
    @RequestMapping("/isUniqueAppId")
    @ResponseBody
    public Object isUniqueAppId(Integer id, String categoryCode, String appId) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("categoryCode", categoryCode);
            params.put("appId", appId);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheAuthorization.IsUniqueAppId, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

}
