package com.yihu.ehr.redis;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.redis.MRedisCacheCategory;
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
 * 缓存分类 Controller
 *
 * @author 张进军
 * @date 2017/11/24 16:08
 */
@Controller
@RequestMapping("/redis/cache/category")
public class RedisCacheCategoryController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "redis/cache/category/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new MRedisCacheCategory();
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Redis.CacheCategory.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "redis/cache/category/detail");
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
            filters.append("code?" + searchContent + ";name?" + searchContent + ";");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheCategory.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
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
            MRedisCacheCategory model = objectMapper.readValue(data, MRedisCacheCategory.class);
            if (StringUtils.isEmpty(model.getCode())) {
                return failed("缓存分类编码不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Redis.CacheCategory.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Redis.CacheCategory.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                MRedisCacheCategory updateModel = getEnvelopModel(envelopGet.getObj(), MRedisCacheCategory.class);
                updateModel.setName(model.getName());
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Redis.CacheCategory.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
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
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Redis.CacheCategory.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证缓存分类编码是否唯一
     */
    @RequestMapping("/isUniqueCode")
    @ResponseBody
    public Object isUniqueCode(Integer id, String code) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("code", code);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheCategory.IsUniqueCode, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证缓存分类名是否唯一
     */
    @RequestMapping("/isUniqueName")
    @ResponseBody
    public Object isUniqueName(Integer id, String name) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("name", name);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Redis.CacheCategory.IsUniqueName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(RedisCacheCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
