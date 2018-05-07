package com.yihu.ehr.archive.controller;

import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
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
    public Envelop list (
            @RequestParam(value = "filters", required = false) String filters,
            @RequestParam(value = "sorts", required = false) String sorts,
            @RequestParam(value = "page") int page,
            @RequestParam(value = "size") int size,
            @RequestParam(value = "rows") int rows) throws Exception {
        size = rows;
        Map<String, Object> params = new HashMap<String, Object>();
        if (StringUtils.isEmpty(filters)) {
            params.put("filters", "identify_flag=0");
        } else {
            params.put("filters", "identify_flag=0;" + filters);
        }
        String url = "/pack-resolve/api/v1.0/archiveRelation";
        params.put("sorts", "-relation_date");
        params.put("page", page);
        params.put("size", size);
        String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
        return toModel(envelopStr, Envelop.class);
    }

}
