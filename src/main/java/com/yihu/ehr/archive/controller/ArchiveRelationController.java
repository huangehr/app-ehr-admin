package com.yihu.ehr.archive.controller;

import com.yihu.ehr.emergency.controller.AmbulanceController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by progr1mmer on 2018/4/4.
 */
@Controller
@RequestMapping("/archiveRelation")
public class ArchiveRelationController extends BaseUIController {

    @RequestMapping(value = "/page", method = RequestMethod.GET)
    @ApiOperation(value = "获取未识别档案关联列表")
    @ResponseBody
    public Envelop list(
            @RequestParam(value = "fields", required = false) String fields,
            @RequestParam(value = "filters", required = false) String filters,
            @RequestParam(value = "sorts", required = false) String sorts,
            @RequestParam(value = "page") int page,
            @RequestParam(value = "size") int size) {
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            if (StringUtils.isEmpty(filters)) {
                params.put("filters", "identifyFlag=0;idCardNo<>null");
            } else {
                params.put("filters", "identifyFlag=0;idCardNo<>null;" + filters);
            }
            String url = "/basic/api/v1.0/archiveRelation";
            //String url = "/basic/api/v1.0/patientArchive/getArRelationList";
            params.put("sorts", "-relationDate");
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            return toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            e.printStackTrace();
            return failed(e.getMessage());
        }
    }

}
