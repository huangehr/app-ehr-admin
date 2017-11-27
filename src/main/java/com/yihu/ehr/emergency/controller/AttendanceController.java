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

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zdm on 2017/11/15.
 */
@Controller
@RequestMapping("/attendance")
public class AttendanceController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    static final String parentFile = "ambulance";

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ApiOperation(value = "保存出勤记录")
    public Envelop save(
            @ApiParam(name = "attendance", value = "出勤记录")
            @RequestParam String attendance, HttpServletRequest request) throws Exception {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            Map<String,Object> map = objectMapper.readValue(attendance,Map.class);
            String url = "/attendance/save";
            map.put("creator",request.getSession().getAttribute("userId"));
            attendance=objectMapper.writeValueAsString(map);
            params.put("attendance", attendance);
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AttendanceController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ApiOperation(value = "更新出勤记录")
    public Envelop update(
            @ApiParam(name = "carId", value = "车牌号码")
            @RequestParam(value = "carId") String carId,
            @ApiParam(name = "status", value = "任务状态")
            @RequestParam(value = "status") String status) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/attendance/update";
            params.put("carId", carId);
            params.put("status", status);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AttendanceController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ApiOperation("获取出勤列表(支持车牌号码查询)")
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
            String url = "/attendance/list";
            params.put("filters", filters);
            params.put("fields", fields);
            params.put("sorts", sorts);
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AttendanceController.class).error(e.getMessage());
        }
        return envelop;
    }
}
