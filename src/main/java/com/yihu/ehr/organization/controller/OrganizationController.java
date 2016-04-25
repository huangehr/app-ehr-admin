package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.org.OrgDetailModel;
import com.yihu.ehr.agModel.org.OrgModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.patient.controller.PatientController;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.RestTemplates;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Base64;
import java.util.*;

/**
 * @author zlf
 * @version 1.0
 * @created 2015.08.10 17:57
 */
@Controller
@RequestMapping("/organization")
public class OrganizationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String orgInitial(Model model) {
        model.addAttribute("contentPage", "organization/organization");
        return "pageView";
    }

    @RequestMapping("dialog/orgInfo")
    public String orgInfoTemplate(Model model, String orgCode, String mode, HttpSession session) {

        String getOrgUrl = "/organizations/" + orgCode;
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, username, password);
            Envelop envelop = getEnvelop(resultStr);
            OrgDetailModel orgDetailModel = toModel(toJson(envelop.getObj()), OrgDetailModel.class);
            session.setAttribute("userImageStream", orgDetailModel.getImgLocalPath() == null ? "" : orgDetailModel.getImgLocalPath());

        } catch (Exception e) {
            LogService.getLogger(OrganizationController.class).error(e.getMessage());
        }
        model.addAttribute("mode", mode);
        model.addAttribute("envelop", resultStr);
        model.addAttribute("contentPage", "organization/organizationInfoDialog");
        return "simpleView";
    }

    @RequestMapping("dialog/create")
    public String createInitial(Model model, String mode) {
        model.addAttribute("mode", mode);
        model.addAttribute("contentPage", "organization/orgCreateDialog");
        return "generalView";
    }

    @RequestMapping(value = "searchOrgs", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object searchOrgs(String searchNm, String searchWay, String orgType, String province, String city, String district, int page, int rows) {
        Envelop envelop = new Envelop();
        try {
            //获取地址的 ids
            String addrIds = "";
            if (!"".equals(province)) {
                String urlAddr = "/geographies";
                Map<String, Object> args = new HashMap<>();
                args.put("province", province);
                args.put("city", city);
                args.put("district", district);
                String envelopStrAddr = HttpClientUtil.doGet(comUrl + urlAddr, args, username, password);
                Envelop envelopAddr = getEnvelop(envelopStrAddr);
                if (envelopAddr.isSuccessFlg()) {
                    List<String> addrList = (List<String>) getEnvelopList(envelopAddr.getDetailModelList(), new ArrayList<String>(), String.class);
                    for (String id : addrList) {
                        addrIds += id + ",";
                    }
                    String[] addrIdsArrays = addrList.toArray(new String[addrList.size()]);
                    addrIds = String.join(",", addrIdsArrays);
                }
            }

            //分页查询机构列表
            String url = "/organizations";
            String filters = "";
            Map<String, Object> params = new HashMap<>();
            if (!StringUtils.isEmpty(searchNm)) {
                filters += "orgCode?" + searchNm + " g1;fullName?" + searchNm + " g1;";
            }
            if (!StringUtils.isEmpty(searchWay)) {
                filters += "settledWay=" + searchWay + ";";
            }
            if (!StringUtils.isEmpty(orgType)) {
                filters += "orgType=" + orgType + ";";
            }
            //添加地址过滤条件
            if (!"".equals(addrIds)) {
                filters += "location=" + addrIds + ";";
            }
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "");
            params.put("size", rows);
            params.put("page", page);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("deleteOrg")
    @ResponseBody
    public Object deleteOrg(String orgCode) {
        String getOrgUrl = "/organizations/" + orgCode;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;

    }

    /**
     * @param orgCode
     * @return
     */
    @RequestMapping("activity")
    @ResponseBody
    public Object activity(String orgCode, String activityFlag) {

        String url = "/organizations/" + orgCode + "/" + activityFlag;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if (Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return envelop;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("updateOrg")
    @ResponseBody
    public Object updateOrg(String orgModel, String addressModel, String mode, HttpServletRequest request) throws UnsupportedEncodingException {
        //新增或修改 根据mode 选择
        String url = "/organizations";
        String envelopStr = "";
        Envelop envelop = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        RestTemplates templates = new RestTemplates();

        String orgJsonData = URLDecoder.decode(orgModel, "UTF-8");
        String orgData[] = orgJsonData.split(";");
        if (orgData.length > 1) {
            orgModel = orgData[0];
            addressModel = orgData[1];
            mode = orgData[2];
        }

        params.add("mOrganizationJsonData", orgModel);
        params.add("geography_model_json_data", addressModel);
        try {

            request.setCharacterEncoding("UTF-8");
            InputStream inputStream = request.getInputStream();
            String imageName = request.getParameter("name");

            int temp = 0;
            byte[] tempBuffer = new byte[1024];
            byte[] fileBuffer = new byte[0];
            while ((temp = inputStream.read(tempBuffer)) != -1) {
                fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
            }
            inputStream.close();

            String restStream = Base64.getEncoder().encodeToString(fileBuffer);
            String imageStream = URLEncoder.encode(restStream, "UTF-8");

            params.add("inputStream", imageStream);
            params.add("imageName", imageName);

            if ("new".equals(mode)) {
                envelopStr = templates.doPost(comUrl + url, params);
            } else {
                ObjectMapper objectMapper = new ObjectMapper();
                //读取参数，转化为模型
                OrgDetailModel org = objectMapper.readValue(orgModel, OrgDetailModel.class);
                //查询数据库得到对应的模型
                String getOrgUrl = "/organizations/" + org.getOrgCode();
                String envelopStrGet = templates.doGet(comUrl + getOrgUrl, params);
                envelop = objectMapper.readValue(envelopStrGet, Envelop.class);
                if (!envelop.isSuccessFlg()) {
                    return envelop;
                }
                OrgDetailModel orgForUpdate = getEnvelopModel(envelop.getObj(), OrgDetailModel.class);
                //将修改值存储到查询返回的对象中
                orgForUpdate.setFullName(org.getFullName());
                orgForUpdate.setShortName(org.getShortName());
                orgForUpdate.setSettledWay(org.getSettledWay());
                orgForUpdate.setAdmin(org.getAdmin());
                orgForUpdate.setTel(org.getTel());
                orgForUpdate.setOrgType(org.getOrgType());
                orgForUpdate.setTags(org.getTags());
                orgForUpdate.setImgLocalPath("");
                String mOrgUpdateJson = objectMapper.writeValueAsString(orgForUpdate);
                params.add("mOrganizationJsonDatas", mOrgUpdateJson);
                envelopStr = templates.doPost(comUrl + "/organization", params);
            }
            return envelopStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("getOrg")
    @ResponseBody
    public Object getOrg(String orgCode) {

        String getOrgUrl = "/organizations/" + orgCode;
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode", orgCode);

        Envelop envelop = new Envelop();
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("distributeKey")
    @ResponseBody
    public Object distributeKey(String orgCode) {

        String getOrgUrl = "/organizations/key";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("org_code", orgCode);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }


    @RequestMapping("validationOrg")
    @ResponseBody
    public Object validationOrg(String orgCode) {
        String getOrgUrl = "/organizations/existence/" + orgCode;
        String resultStr = "";
        Envelop envelop = new Envelop();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, username, password);
            if (!Boolean.parseBoolean(resultStr)) {
                envelop.setSuccessFlg(true);
            } else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return envelop;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("showImage")
    @ResponseBody
    public void showImage(HttpSession session, HttpServletResponse response) throws Exception {

        response.setContentType("text/html; charset=UTF-8");
        response.setContentType("image/jpeg");
        OutputStream outputStream = null;
        String fileStream = (String) session.getAttribute("userImageStream");
        String imageStream = URLDecoder.decode(fileStream, "UTF-8");

        try {
            outputStream = response.getOutputStream();

            byte[] bytes = Base64.getDecoder().decode(imageStream);
            outputStream.write(bytes);
            outputStream.flush();
        } catch (IOException e) {
            LogService.getLogger(PatientController.class).error(e.getMessage());
        } finally {
            if (outputStream != null)
                outputStream.close();
        }
    }
}
