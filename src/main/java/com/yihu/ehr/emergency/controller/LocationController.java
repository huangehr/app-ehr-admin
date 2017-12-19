package com.yihu.ehr.emergency.controller;

import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zdm on 2017/11/15.
 */
@Controller
@RequestMapping("/location")
public class LocationController extends BaseUIController {

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ApiOperation("获取待命地点列表")
    @ResponseBody
    public Envelop list(
            @ApiParam(name = "fields", value = "返回的字段，为空返回全部字段")
            @RequestParam(value = "fields", required = false) String fields,
            @ApiParam(name = "filters", value = "过滤器，为空检索所有条件")
            @RequestParam(value = "filters", required = false) String filters,
            @ApiParam(name = "sorts", value = "排序，规则参见说明文档")
            @RequestParam(value = "sorts", required = false) String sorts,
            @ApiParam(name = "page", value = "分页大小", defaultValue = "1")
            @RequestParam(value = "page", required = false) int page,
            @ApiParam(name = "size", value = "页码", defaultValue = "15")
            @RequestParam(value = "size", required = false) int size) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/location/list";
            //params.put("filters", filters);
            //params.put("fields", fields);
            //params.put("sorts", sorts);
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(LocationController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ApiOperation("保存单条记录")
    @ResponseBody
    public Envelop save(
            @ApiParam(name = "location", value = "待命地点")
            @RequestParam(value = "location") String location,
            HttpServletRequest request){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/location/save";
            Map<String, Object> locationMap = objectMapper.readValue(location, Map.class);
            HttpSession session = request.getSession();
            locationMap.put("creator", session.getAttribute("userId"));
            params.put("location", objectMapper.writeValueAsString(locationMap));
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(LocationController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ApiOperation("更新单条记录")
    @ResponseBody
    public Envelop update(
            @ApiParam(name = "location", value = "排班")
            @RequestParam(value = "location") String location,
            HttpServletRequest request){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/location/update";
            Map<String, Object> locationMap = objectMapper.readValue(location, Map.class);
            HttpSession session = request.getSession();
            locationMap.put("modifier", session.getAttribute("userId"));
            params.put("location", objectMapper.writeValueAsString(locationMap));
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(LocationController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ApiOperation("删除待命地点")
    @ResponseBody
    public Envelop delete(
            @ApiParam(name = "ids", value = "id列表(int)1,2,3,...")
            @RequestParam(value = "ids") String ids){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/location/delete";
            params.put("ids", ids);
            String envelopStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(LocationController.class).error(e.getMessage());
        }
        return envelop;
    }
}
