package com.yihu.ehr.portal.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by zhangdan on 2018/4/21.
 */
@Controller
@RequestMapping("/survey")
public class SurveyController extends BaseUIController {
    @Value("${service-gateway.adminInnerUrl}")
    private String adminInnerUrl;


    @RequestMapping(value = "/allMethod")
    @ResponseBody
    public Envelop getSurveyAllMethod(@RequestParam(value = "redicUrl") String redicUrl,
                                      @RequestParam(value = "postOrGet") String postOrGet,
                                      @RequestParam(value = "paramJson",required = false) String paramJson){

        try {
            Map<String, Object> params = new HashMap<String, Object>();
            if(!StringUtils.isEmpty(paramJson)){
                JSONObject jsonObject = new JSONObject(paramJson);
                Iterator<String> sIterator = jsonObject.keys();
                while(sIterator.hasNext()){
                    // 获得key
                    String key = sIterator.next();
                    // 根据key获得value, value也可以是JSONObject,JSONArray,使用对应的参数接收即可
                    String value = jsonObject.getString(key);
                    params.put(key,value);
                }
            }

            String envelopStr = "";
            if (!StringUtils.isEmpty(postOrGet) && "get".equals(postOrGet.toLowerCase())){
                envelopStr = HttpClientUtil.doGet(adminInnerUrl + redicUrl, params);
            }else if (!StringUtils.isEmpty(postOrGet) && "post".equals(postOrGet.toLowerCase())){
                envelopStr = HttpClientUtil.doPost(adminInnerUrl + redicUrl, params);
            }
            return toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            e.printStackTrace();
            return failed(e.getMessage());
        }
    }

    //---新增问卷模板---
    @RequestMapping(value = "/addTemplate", method = RequestMethod.GET)
    public String addTemplate(@ApiParam(name = "模板id", value = "模板id",defaultValue = "0") @RequestParam(value = "templateId", required = false) String templateId,
                              @ApiParam(name = "mode标签", value = "mode标签",defaultValue = "") @RequestParam(value = "mode", required = false) String mode,
                              Model model){
        if (!StringUtils.isEmpty(templateId)){
            model.addAttribute("templateId",templateId);
        }
        if (!StringUtils.isEmpty(mode)){
            model.addAttribute("mode",mode);
        }
        model.addAttribute("contentPage","/questiontemplate/addtemplate");
        return "pageView";
    }

    //---编辑问卷模板---
    @RequestMapping(value = "/editTemplate", method = RequestMethod.GET)
    public String editTemplate(@ApiParam(name = "模板id", value = "模板id",defaultValue = "0") @RequestParam(value = "templateId", required = true) String templateId,
                               @ApiParam(name = "mode标签", value = "mode标签",defaultValue = "") @RequestParam(value = "mode", required = true) String mode,
                               Model model){
        model.addAttribute("templateId",templateId);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/questiontemplate/addtemplate");
        return "pageView";
    }

    //页面跳转（新增问题页面）
    @RequestMapping(value ="/addQuestion",method = RequestMethod.GET)
    @ApiOperation(value = "页面跳转（新增问题页面）")
    public String infoInit(@ApiParam(name = "mode标签", value = "mode标签",defaultValue = "") @RequestParam(value = "mode", required = false) String mode,
                           Model model) {
        if (!StringUtils.isEmpty(mode)) {
            model.addAttribute("mode", mode);
        }
        model.addAttribute("contentPage", "/question/question_add");
        return "pageView";
    }

    //页面跳转（编辑问题页面）
    @RequestMapping(value ="/editQuestion",method = RequestMethod.GET)
    @ApiOperation(value = "页面跳转（编辑问题页面）")
    public String editQuestion(@ApiParam(name = "问题id", value = "问题id",defaultValue = "0") @RequestParam(value = "questionId", required = true) String questionId,
                               @ApiParam(name = "mode标签", value = "mode标签",defaultValue = "") @RequestParam(value = "mode", required = true) String mode,
                               Model model){
        model.addAttribute("questionId",questionId);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/question/question_edit");
        return "pageView";
    }

    //跳转到问题查看页
    @RequestMapping(value = "/seeQuestion", method = RequestMethod.GET)
    @ApiOperation(value = "跳转到问题查看页")
    public String seeQuestion(@ApiParam(name = "questionId", value = "问题id",defaultValue = "0") @RequestParam(value = "questionId", required = true) String questionId,
                              @ApiParam(name = "type", value = "问题类型（0单选 1多选 2问答）",defaultValue = "") @RequestParam(value = "type", required = true) String type,
                              Model model){
        model.addAttribute("questionId",questionId);
        model.addAttribute("type",type);
        model.addAttribute("contentPage","/question/see_question");
        return "pageView";
    }

    @RequestMapping(value = "/questionList", method = RequestMethod.GET)
    @ApiOperation(value = "问题管理列表")
    public String initQuestionList(Model model){
        model.addAttribute("contentPage","/question/question_list");
        return "pageView";
    }

    @RequestMapping(value = "/templateList", method = RequestMethod.GET)
    @ApiOperation(value = "问题管理列表")
    public String initTemplateList(Model model){
        model.addAttribute("contentPage","/questiontemplate/template_list");
        return "pageView";
    }

}
