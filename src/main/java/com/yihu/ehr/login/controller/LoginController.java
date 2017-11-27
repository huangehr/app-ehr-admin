package com.yihu.ehr.login.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.agModel.user.RoleOrgModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.AccessToken;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.AgAdminConstants;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.common.ListResult;
import com.yihu.ehr.model.geography.MGeographyDict;
import com.yihu.ehr.model.org.MOrganization;
import com.yihu.ehr.model.resource.MRsRolesResource;
import com.yihu.ehr.model.user.MRoles;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateTimeUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by lingfeng on 2015/6/30.
 */
@Controller
@RequestMapping("/login")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class LoginController extends BaseUIController {

    private final long a1 = getIpNum("10.0.0.0");
    private final long a2 = getIpNum("10.255.255.255");
    private final long b1 = getIpNum("172.16.0.0");
    private final long b2 = getIpNum("172.31.255.255");
    private final long c1 = getIpNum("192.168.0.0");
    private final long c2 = getIpNum("192.168.255.255");
    private final long d1 = getIpNum("10.44.0.0");
    private final long d2 = getIpNum("10.69.0.255");

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Value("${service-gateway.browseClientUrl}")
    private String browseClientUrl;
    @Value("${service-gateway.browseClientOutSizeUrl}")
    private String browseClientOutSizeUrl;
    @Value("${service-gateway.profileurl}")
    private String profileurl;
    @Value("${app.oauth2authorize}")
    private String authorize;
    @Value("${app.oauth2OutSize}")
    private String oauth2OutSize;
    @Value("${app.baseClientId}")
    private String baseClientId;
    @Value("${app.qcReportClientId}")
    private String qcReportClientId;
    @Value("${app.resourceBrowseClientId}")
    private String resourceBrowseClientId;
    @Value("${app.browseClientId}")
    public String browseClientId;
    @Value("${std.version}")
    public String stdVersion;
    @Value("${permissions.info}")
    private String permissionsInfo;

    @RequestMapping()
    public String login(Model model) {
        model.addAttribute("contentPage", "login/login");
        model.addAttribute("successFlg", true);
        return "generalView";
    }

    /**
     * 总支撑门户-oauth2验证集成
     */
    @RequestMapping(value = "/signin")
    public String signin(Model model, HttpServletRequest request) {
        String clientId = request.getParameter("clientId");
        String host = request.getHeader("referer");
        model.addAttribute("contentPage", "login/signin");
        model.addAttribute("successFlg", true);
        model.addAttribute("clientId", clientId);
        model.addAttribute("host", host);
        return "generalView";
    }

    /**
     * 质控报告-oauth2验证集成
     * 接口删除或变更时，请通告ESB项目组
     */
    @RequestMapping(value = "/signinReport")
    public String signinReport(Model model) {
        model.addAttribute("contentPage", "login/signinReport");
        model.addAttribute("successFlg", true);
        return "generalView";
    }

    /**
     * 资源视图-oauth2验证集成
     */
    @RequestMapping(value = "/signinResource")
    public String signinResource(Model model) {
        model.addAttribute("contentPage", "login/signinResource");
        model.addAttribute("successFlg", true);
        return "generalView";
    }

    /*
     * 自动登录
     */
    @RequestMapping(value = "/autoLogin", method = RequestMethod.POST)
    @ResponseBody
    public Envelop autoLogin(HttpServletRequest request, Model model,
                             @RequestParam String token,
                             @RequestParam(name = "isQcReport", required = false) String isQcReport) throws Exception {
        try {
            String clientId = request.getParameter("clientId").toString();
            Map<String, Object> params = new HashMap<>();
            if ("1".equals(isQcReport)) { // 质控报告-oauth2验证集成
                params.put("clientId", qcReportClientId);
            } else if ("2".equals(isQcReport)) { // 资源视图-oauth2验证集成
                params.put("clientId", resourceBrowseClientId);
            } else {
                params.put("clientId", clientId);
            }
            params.put("accessToken", token);
            String response = HttpClientUtil.doPost(authorize + "/oauth/validToken", params);
            Map<String, Object> map = objectMapper.readValue(response, Map.class);
            if ((Boolean) map.get("successFlg")) {
                AccessToken accessToken = objectMapper.readValue(objectMapper.writeValueAsString(map.get("data")), AccessToken.class);
                String loginName = accessToken.getUser();
                //验证通过。赋值session中的用户信息
                String userInfo = HttpClientUtil.doGet(comUrl + "/users/" + loginName, params);
                Envelop envelop = (Envelop) this.objectMapper.readValue(userInfo, Envelop.class);
                String ex = this.objectMapper.writeValueAsString(envelop.getObj());
                UserDetailModel userDetailModel = this.objectMapper.readValue(ex, UserDetailModel.class);
                // 注：SessionAttributeKeys.CurrentUser 是用 @SessionAttributes 来最终赋值，换成用 session.setAttribute() 赋值后将会被覆盖。
                model.addAttribute(SessionAttributeKeys.CurrentUser, userDetailModel);
                //session 同步到 redis
                setRedisValue(request, SessionAttributeKeys.CurrentUser, objectMapper.writeValueAsString(userDetailModel));

                HttpSession session = request.getSession();
                //增加超级管理员信息
                if(loginName.equals(permissionsInfo)) {
                    session.setAttribute(AuthorityKey.IsAccessAll, true);
                    //session 同步到 redis
                    setRedisValue(request, AuthorityKey.IsAccessAll, "true");
                }else {
                    session.setAttribute(AuthorityKey.IsAccessAll, false);
                    //session 同步到 redis
                    setRedisValue(request, AuthorityKey.IsAccessAll, "false");
                }
                session.setAttribute("isLogin", true);
                session.setAttribute("token", accessToken);
                session.setAttribute("loginName", loginName);
                session.setAttribute("userId", userDetailModel.getId());
                session.setAttribute("clientId", clientId);
                //session 同步到 redis
                setRedisValue(request, "isLogin", "true");
                setRedisObjectValue(request, "token", accessToken);
                setRedisValue(request, "loginName", loginName);
                setRedisValue(request, "userId", userDetailModel.getId());
                setRedisValue(request, "clientId", clientId);
                //获取用户的角色，机构，视图 等权限
                initUserRolePermissions(userDetailModel, loginName, request);
                //获取用户角色信息
                List<AppFeatureModel> features = getUserFeatures(userDetailModel.getId());
                Collection<GrantedAuthority> gas = new ArrayList<>();
                if (features != null) {
                    for (AppFeatureModel feature : features) {
                        if (!StringUtils.isEmpty(feature.getUrl()))
                            gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                    }
                }
                //生成认证token
                Authentication AuthenticationToken = new UsernamePasswordAuthenticationToken(request, "", gas);
                //将信息存放到SecurityContext
                SecurityContextHolder.getContext().setAuthentication(AuthenticationToken);
                return success(accessToken);
            } else {
                String msg = String.valueOf(map.get("message"));
                return failed(msg);
            }
        } catch (Exception e) {
            return failed(e.getMessage());
        }
    }

    @RequestMapping(value = "/validate", method = RequestMethod.POST)
    public String loginValid(Model model, String userName, String password, HttpServletRequest request) {
        String url = "/users/verification/" + userName;
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("psw", password);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, this.password);
            Envelop envelop = getEnvelop(resultStr);
            UserDetailModel userDetailModel = getEnvelopModel(envelop.getObj(), UserDetailModel.class);
            String loginName = userDetailModel.getLoginCode();
            //判断用户是否登入成功
            if (envelop.isSuccessFlg()) {
                //获取用户的角色，机构，视图 等权限
                initUserRolePermissions(userDetailModel, userName, request);
                //增加超级管理员信息
                HttpSession session = request.getSession();
                if(userName.equals(permissionsInfo)) {
                    session.setAttribute(AuthorityKey.IsAccessAll, true);
                    //session 同步到 redis
                    setRedisValue(request, AuthorityKey.IsAccessAll, "true");
                }else {
                    session.setAttribute(AuthorityKey.IsAccessAll, false);
                    //session 同步到 redis
                    setRedisValue(request, AuthorityKey.IsAccessAll, "false");
                }
                String lastLoginTime = null;
                //判断用户是否失效
                if (!userDetailModel.getActivated()) {
                    model.addAttribute("userName", userName);
                    model.addAttribute("successFlg", false);
                    model.addAttribute("failMsg", "该用户已失效，请联系系统管理员重新生效。");
                    model.addAttribute("contentPage", "login/login");
                    return "generalView";
                }
                //判断用户密码是否初始密码
                model.addAttribute(SessionAttributeKeys.CurrentUser, userDetailModel);
                //session 同步到 redis
                setRedisObjectValue(request, SessionAttributeKeys.CurrentUser, userDetailModel);

                if (password.equals("123456")) {
                    session.setAttribute("defaultPassWord", true);
                    //session 同步到 redis
                    setRedisValue(request, "defaultPassWord", "true");
                    model.addAttribute("contentPage", "user/changePassword");
                    return "generalView";
                } else {
                    //创建session保存用户信息
                    session.removeAttribute("defaultPassWord");
                    //session 同步到 redis
                    deleteRedisValue(request, "defaultPassWord");
                    SimpleDateFormat sdf = new SimpleDateFormat(AgAdminConstants.DateTimeFormat);
                    Date date = new Date();
                    String now = sdf.format(date);
                    if (userDetailModel.getLastLoginTime() != null) {
                        Date dateLogin = DateTimeUtils.utcDateTimeParse(userDetailModel.getLastLoginTime());
                        lastLoginTime = dateLogin == null ? "" : DateTimeUtil.simpleDateTimeFormat(dateLogin);
                    } else {
                        lastLoginTime = now;
                    }
                    model.addAttribute("last_login_time", lastLoginTime);
                    session.setAttribute("last_login_time", lastLoginTime);
                    //session 同步到 redis
                    setRedisValue(request, "last_login_time", lastLoginTime);

                    //update lastLoginTime
                    userDetailModel.setLastLoginTime(DateTimeUtils.utcDateTimeFormat(date));
                    MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<>();
                    conditionMap.add("user_json_data", toJson(userDetailModel));
                    session.setAttribute("loginCode", userDetailModel.getLoginCode());
                    session.setAttribute("userId", userDetailModel.getId());
                    //获取用户的角色，机构，视图 等权限
                    initUserRolePermissions(userDetailModel, userName, request);
                    //session 同步到 redis
                    setRedisValue(request, "loginCode", userDetailModel.getLoginCode());

                    //获取用户角色信息
                    List<AppFeatureModel> features = getUserFeatures(userDetailModel.getId());
                    Collection<GrantedAuthority> gas = new ArrayList<>();
                    if (features != null) {
                        for (AppFeatureModel feature : features) {
                            if (!StringUtils.isEmpty(feature.getUrl()))
                                gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                        }
                    }
                    //生成认证token
                    Authentication token = new UsernamePasswordAuthenticationToken(userName, password, gas);
                    AccessToken accessToken = getAccessToken(userName, password, baseClientId);
                    session.setAttribute("token", accessToken);
                    //session 同步到 redis
                    setRedisObjectValue(request, "token", accessToken);

                    //将信息存放到SecurityContext
                    SecurityContextHolder.getContext().setAuthentication(token);
                    return "redirect:/index";
                }

            } else {
                model.addAttribute("userName", userName);
                model.addAttribute("successFlg", false);
                model.addAttribute("failMsg", "用户名或密码错误，请重新输入。");
                model.addAttribute("contentPage", "login/login");
                return "generalView";
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(LoginController.class).error(e.getMessage());
            model.addAttribute("userName", userName);
            model.addAttribute("successFlg", false);
            model.addAttribute("failMsg", e.getMessage());
            model.addAttribute("contentPage", "login/login");
            return "generalView";
        }
    }

    //------------------------------------------------- 单点登录 start -------------------------------------------

    /**
     * 验证某个用户是否有数据
     * @param idCardNo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/checkInfo", method = RequestMethod.GET)
    @ResponseBody
    public Envelop check(String idCardNo,String loginCode, HttpServletRequest request) {
        initUrlInfo(loginCode,request);
        Envelop envelop = new Envelop();
        Map<String, Object> paramsMap = new HashMap<>();
        paramsMap.put("demographic_id", idCardNo);
        paramsMap.put("version", stdVersion);
        String url2 = "/" + paramsMap.get("demographic_id") + "/profile/info";
        try {
            String result = HttpClientUtil.doGet(profileurl + url2, paramsMap, username, password);
            if (StringUtils.isEmpty(result)) {
                return envelop;
            }
        } catch (Exception e) {
            return envelop;
        }
        envelop.setSuccessFlg(true);
        return envelop;
    }

    @RequestMapping(value = "/broswerSignin", method = RequestMethod.GET)
    public void signin(Model model, HttpServletRequest request, HttpServletResponse response, String idCardNo) throws Exception {
        model.addAttribute("model", request.getSession());
        model.addAttribute("idCardNo", idCardNo);
        String clientId = browseClientId;
        //获取code
        HttpSession session = request.getSession();
        AccessToken token = (AccessToken) session.getAttribute("token");
        if(token == null){
            token = objectMapper.readValue(getRedisValue(request, "token"), AccessToken.class);
        }
        String user = token.getUser();
        boolean isInnerIp = true;
        if(session.getAttribute("isInnerIp") != null){
            isInnerIp = (Boolean) session.getAttribute("isInnerIp");
        }else {
            isInnerIp = Boolean.parseBoolean(getRedisValue(request,"isInnerIp"));;
        }

        System.out.println("isInnerIp:" + isInnerIp);
        if(isInnerIp) {
            String url = browseClientUrl + "/common/login/signin?idCardNo=" + idCardNo;
            response.sendRedirect(authorize + "oauth/authorize?response_type=token&client_id=" + clientId + "&redirect_uri=" + url + "&scope=read&user=" + user);
        }else {
            String url = browseClientOutSizeUrl + "/common/login/signin?idCardNo=" + idCardNo;
            response.sendRedirect(oauth2OutSize + "oauth/authorize?response_type=token&client_id=" + clientId + "&redirect_uri=" + url + "&scope=read&user=" + user);
        }
    }

    /**
     * 初始化内外网IP信息
     * @param request
     */
    public void initUrlInfo(String loginCode ,HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if(ip != null) {
            System.out.println(ip);
            if("0:0:0:0:0:0:0:1".equals(ip)) {
                request.getSession().setAttribute("isInnerIp", true);
                //session 同步到 redis
                setRedisValue(request,"isInnerIp", "true");
            }else {
                if("127.0.0.1".equals(ip) || isInnerIP(ip)) {
                    request.getSession().setAttribute("isInnerIp", true);
                    //session 同步到 redis
                    setRedisValue(request,"isInnerIp", "true");
                }else {
                    request.getSession().setAttribute("isInnerIp", false);
                    //session 同步到 redis
                    setRedisValue(request,"isInnerIp", "false");
                }
            }
        }
    }

    public long getIpNum(String ipAddress) {
        String [] ip = ipAddress.split("\\.");
        long a = Integer.parseInt(ip[0]);
        long b = Integer.parseInt(ip[1]);
        long c = Integer.parseInt(ip[2]);
        long d = Integer.parseInt(ip[3]);
        return a * 256 * 256 * 256 + b * 256 * 256 + c * 256 + d;
    }

    public boolean isInnerIP(String ip){
        long n = getIpNum(ip);
        return (n >= a1 && n <= a2) || (n >= b1 && n <= b2) || (n >= c1 && n <= c2) || (n >= d1 && n <= d2);
    }

    //------------------------------------------------- 单点登录 end -------------------------------------------

    /**
     * 获取用的saas机构
     */
    @RequestMapping(value = "/getUserSaasOrgAndArea", method = RequestMethod.GET)
    public void getUserSaasOrgAndArea(List<String> roleOrgCodes,String loginName, HttpServletRequest request) throws Exception {
        Envelop envelop = new Envelop();
        List<String> userOrgList = new ArrayList<>();
        //使用orgCode获取saas化的机构或者区域。
        String urlUOrg = "/org/getUserOrgSaasByUserOrgCode/";
        Map<String, Object> uParams = new HashMap<>();
        uParams.put("orgCodeStr",org.apache.commons.lang.StringUtils.join(roleOrgCodes,',') );
        String resultStrUserSaasOrg = HttpClientUtil.doGet(comUrl + urlUOrg, uParams, username, password);
        envelop = getEnvelop(resultStrUserSaasOrg);
        HttpSession session = request.getSession();
        session.setAttribute(AuthorityKey.UserAreaSaas, envelop.getObj());
        session.setAttribute(AuthorityKey.UserOrgSaas, envelop.getDetailModelList());
        //session 同步到 redis
        setRedisObjectValue(request, AuthorityKey.UserAreaSaas, envelop.getObj());
        setRedisObjectValue(request, AuthorityKey.UserOrgSaas, envelop.getDetailModelList());


        userOrgList = envelop.getDetailModelList();
        List<String> districtList = (List<String>) envelop.getObj();
        String geographyUrl = "/geography_entries/";
        if(districtList != null && districtList.size() > 0){
            for(String code : districtList){
                uParams.clear();
                String mGeographyDictStr = HttpClientUtil.doGet(comUrl + geographyUrl + code, uParams, username, password);
                envelop = getEnvelop(mGeographyDictStr);
                MGeographyDict mGeographyDict = null;
                mGeographyDict = getEnvelopModel(envelop.getObj(), MGeographyDict.class);
                if(mGeographyDict != null){
                    String province = "";
                    String city = "";
                    String district = "";
                    if(mGeographyDict.getLevel() == 1){
                        province =  mGeographyDict.getName();
                    }else if(mGeographyDict.getLevel() == 2){
                        city =  mGeographyDict.getName();
                    }else if(mGeographyDict.getLevel() == 3){
                        district =  mGeographyDict.getName();
                    }
                    String  orgGeographyStr = "/organizations/geography";
                    uParams.clear();
                    uParams.put("province",province);
                    uParams.put("city",city);
                    uParams.put("district",district);
                    String mOrgsStr = HttpClientUtil.doGet(comUrl + orgGeographyStr , uParams, username, password);
                    envelop = getEnvelop(mOrgsStr);
                    if(envelop !=null && envelop.getDetailModelList() != null ){
                        List<MOrganization> organizations = (List<MOrganization>)getEnvelopList(envelop.getDetailModelList(),new ArrayList<MOrganization>(),MOrganization.class);
                        if(organizations !=null ){
                            java.util.Iterator it = organizations.iterator();
                            while(it.hasNext()){
                                MOrganization mOrganization = (MOrganization)it.next();
                                userOrgList.add(mOrganization.getCode());
                            }
                        }
                    }
                }
            }
        }
        //加上自身默认机构
        for(String code : roleOrgCodes){
            userOrgList.add(code);
        }
        userOrgList.removeAll(Collections.singleton(null));
        userOrgList.removeAll(Collections.singleton(""));
        request.getSession().setAttribute(AuthorityKey.UserOrgSaas, userOrgList);
        //session 同步到 redis
        setRedisObjectValue(request, AuthorityKey.UserOrgSaas, envelop.getDetailModelList());

    }

    @RequestMapping(value = "/userVerification")
    @ResponseBody
    public Object dataValidation(String userName, String password) {
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        Envelop envelop = new Envelop();
        String url = "";
        String resultStr = "";
        try {
            if (StringUtils.isEmpty(password)) {
                url = "/users";
                params.put("filters", "loginCode=" + userName);
                params.put("page", 1);
                params.put("size", 15);
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, this.password);
            } else {
                url = "/users/verification/" + userName;
                params.put("psw", password);
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, this.password);
            }
            envelop = mapper.readValue(resultStr, Envelop.class);
            if (!envelop.isSuccessFlg()) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("密码错误，请重新输入！");
            } else {
                envelop.setSuccessFlg(true);
            }
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("密码错误，请重新输入！");
            return envelop;
        }
        return envelop;
    }

    @RequestMapping("activityUser")
    @ResponseBody
    public Object activityUser(String userId, boolean activated) {
        String url = "/users/admin/" + userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("activity", activated);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

            if (Boolean.parseBoolean(resultStr)) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidUpdate.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 获取用户的角色，机构，视图 等权限
     * @param userDetailModel
     * @param request
     * @throws Exception
     */
    public void initUserRolePermissions(UserDetailModel userDetailModel, String loginCode, HttpServletRequest request) throws Exception {
        String loginName = loginCode;
        HttpSession session = request.getSession();
        if(loginCode.equals(permissionsInfo)){
            session.setAttribute(AuthorityKey.UserRoles, null);
            session.setAttribute(AuthorityKey.UserResource, null);
            session.setAttribute(AuthorityKey.UserAreaSaas, null);
            session.setAttribute(AuthorityKey.UserOrgSaas, null);
            //session 同步到 redis
            setRedisValue(request, AuthorityKey.UserRoles, "null");
            setRedisValue(request, AuthorityKey.UserResource, "null");
            setRedisValue(request, AuthorityKey.UserAreaSaas, "null");
            setRedisValue(request, AuthorityKey.UserOrgSaas, "null");
        }else{
            //获取用户角色
            String roleStr = "";
            List<String> roleList = new ArrayList<>();
            roleStr =  gerUserRoles(userDetailModel.getId());
            if( !StringUtils.isEmpty(roleStr)){
                roleList =  Arrays.asList(roleStr.split(","));
                session.setAttribute(AuthorityKey.UserRoles, roleList);
                //session 同步到 redis
                setRedisObjectValue(request, AuthorityKey.UserRoles, roleList);
                //获取角色机构
                List<RoleOrgModel> roleOrgModels = new ArrayList<>();
                gerRolesOrgs(roleList,roleOrgModels);
                if(roleOrgModels !=null && roleOrgModels.size() >0){
                    List<String> roleOrgCodes = new ArrayList<>();
                    for(RoleOrgModel roleOrgModel : roleOrgModels){
                        roleOrgCodes.add(roleOrgModel.getOrgCode());
                    }
                    getUserSaasOrgAndArea(roleOrgCodes, loginName, request);
                }else{
                    List<String> userOrgList = new ArrayList<>();
                    userOrgList.add(AuthorityKey.NoUserOrgSaas);
                    session.setAttribute(AuthorityKey.UserOrgSaas, userOrgList);
                    //session 同步到 redis
                    setRedisObjectValue(request, AuthorityKey.UserOrgSaas, userOrgList);
                }
                //获取角色视图
                List<String> rolesResourceIdList =  new ArrayList<>();
                List<MRsRolesResource> rolesResourceList = new ArrayList<>();
                gerRolesResource(roleList, rolesResourceList);
                if(rolesResourceList !=null && rolesResourceList.size() >0){
                    for(MRsRolesResource rsRolesResource : rolesResourceList){
                        rolesResourceIdList.add(rsRolesResource.getResourceId());
                    }
                    session.setAttribute(AuthorityKey.UserResource, rolesResourceIdList);
                    //session 同步到 redis
                    setRedisObjectValue(request, AuthorityKey.UserResource, rolesResourceIdList);
                }else{
                    rolesResourceIdList.add(AuthorityKey.NoUserResource);
                    session.setAttribute(AuthorityKey.UserResource, rolesResourceIdList);
                    //session 同步到 redis
                    setRedisObjectValue(request, AuthorityKey.UserResource, rolesResourceIdList);
                }
            }else{
                roleList.add(AuthorityKey.NoUserRole);
                session.setAttribute(AuthorityKey.UserRoles, roleList);
                //session 同步到 redis
                setRedisObjectValue(request, AuthorityKey.UserRoles, roleList);
            }
        }
    }

    /**
     * 获取用户角色
     * @param userId
     * @return
     */
    public String gerUserRoles(String userId){
        //获取用户所属角色
        String roleStr = "";
        try {
            String url = "/roles/role_user/userRolesIds";
            Map<String,Object> params = new HashMap<>();
            params.put("user_id",userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            if (envelop.isSuccessFlg() && null != envelop.getObj() && !"".equals(envelop.getObj())) {
                roleStr = envelop.getObj().toString();
            }
        } catch (Exception ex) {
            LogService.getLogger(LoginController.class).error(ex.getMessage());
        }
        return  roleStr;
    }

    /**
     * 获取角色机构
     * @param roleList 角色组列表
     * @return
     */
    public List<RoleOrgModel> gerRolesOrgs(List<String> roleList,List<RoleOrgModel> roleOrgs){
        for(String roleId : roleList){
            try {
                Map<String,Object> params = new HashMap<>();
                String roleUrl = "/roles/role/"+roleId;
                params.put("id",Long.valueOf(roleId));
                String envelopRoleStr = HttpClientUtil.doGet(comUrl + roleUrl,params, username, password);
                Envelop envelopRole = objectMapper.readValue(envelopRoleStr,Envelop.class);
                if(envelopRole.getObj() != null){
                    MRoles mRoles = objectMapper.convertValue(envelopRole.getObj(), MRoles.class);
                    if ( ! StringUtils.isEmpty( mRoles.getOrgCode() )){
                        RoleOrgModel roleOrgModel = new RoleOrgModel();
                        roleOrgModel.setOrgCode(mRoles.getOrgCode());
                        roleOrgModel.setRoleId(mRoles.getId());
                        roleOrgs.add(roleOrgModel);
                    }
                }
                String url = ServiceApi.Roles.RoleOrgsNoPage;
                params.clear();
                params.put("filters","roleId=" + roleId);
                String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
                Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
                if (envelop.isSuccessFlg() && null != envelop.getDetailModelList() &&  envelop.getDetailModelList().size()>0) {
                    List<RoleOrgModel> roleOrgModels = envelop.getDetailModelList();
                    if(roleOrgModels != null && roleOrgModels.size() > 0){
                        for(int i = 0; i < roleOrgModels.size() ;i++){
                            RoleOrgModel orgModel = objectMapper.convertValue(roleOrgModels.get(i), RoleOrgModel.class) ;
                            roleOrgs.add(orgModel);
                        }
                    }
                }
            } catch (Exception ex) {
                LogService.getLogger(LoginController.class).error(ex.getMessage());
            }
        }
        return  roleOrgs;
    }

    /**
     * 获取角色视图列表
     * @param roleList
     * @param rolesResourceList
     * @return
     */
    public List<MRsRolesResource> gerRolesResource(List<String> roleList,List<MRsRolesResource> rolesResourceList){
        for(String roleId : roleList){
            try {
                String url = ServiceApi.Resources.GetRolesGrantResources;
                Map<String,Object> params = new HashMap<>();
                params.put("rolesId",roleId);
                String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
                Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
                if (envelop.isSuccessFlg() && null != envelop.getDetailModelList() && envelop.getDetailModelList().size() > 0 ) {
                    List<MRsRolesResource> roleResourceModels = envelop.getDetailModelList();
                    if(roleResourceModels != null && roleResourceModels.size() > 0){
                        for(int i = 0; i < roleResourceModels.size() ;i++){
                            MRsRolesResource rolesResource = objectMapper.convertValue(roleResourceModels.get(i),MRsRolesResource.class) ;
                            rolesResourceList.add(rolesResource);
                        }
                    }
                }
            } catch (Exception ex) {
                LogService.getLogger(LoginController.class).error(ex.getMessage());
            }
        }
        return null;
    }

    // 暂时没用到
    /*@RequestMapping(value = "activeValidateCode")
    public String activeValidateCode(String loginCode, String validateCode, Model model) {
        XUser user = userManager.getUserByLoginCode(loginCode);
        Map<ErrorCode, String> message = new HashMap<>();

        if (user != null) {
            if (user.isActivated()) {
                Date currentTime = new Date();
                if (currentTime.before(user.getCreateDate())) {
                    if (validateCode.equals(user.getValidateCode())) {
                        model.addAttribute("successFlg", true);
                        model.addAttribute("contentPage","login/login");
                        return "generalView";
                    } else {
                        model.addAttribute("successFlg", false);
                        message.put(ErrorCode.InvalidValidateCode, "验证码不正确");
                        model.addAttribute("contentPage","login/login");
                        return "generalView";
                    }
                } else {
                    message.put(ErrorCode.ExpireValidateCode, "验证码已过期");
                    model.addAttribute("contentPage","login/login");
                    return "generalView";
                }
            } else {
                message.put(ErrorCode.MailHasValidate, "邮箱已验证，请登录！");
                model.addAttribute("contentPage","login/login");
                return "generalView";
            }
        } else {
            message.put(ErrorCode.InvalidMail, "该邮箱未注册（邮箱地址不存在）！");
            model.addAttribute("contentPage","login/login");
            return "generalView";
        }
    }*/

    // 暂时没用到
    /*@RequestMapping(value = "sendActiveCode")
    public String sendActiveCode(Model model, String loginCode, String email) {
        Map<ErrorCode, String> message = new HashMap<>();
        XUser user = userManager.getUserByCodeAndEmail(loginCode, email);

        if (user == null || "0".equals(user.getActivated())) {
            message.put(ErrorCode.InvalidUser, "用户不存在!");
            model.addAttribute("message", message);
            model.addAttribute("contentPage","login/login");
            return "generalView";
        }

        user.setValidateCode("1234");
        userManager.updateUser(user);

        StringBuffer sb = new StringBuffer("点击下面链接激活账号，48小时生效，否则重新注册账号，链接只能使用一次，请尽快激活！</br>");
        sb.append(user.getValidateCode());

        MailUtil.send(email, sb.toString());
        return "login/login";
    }*/

    /*@RequestMapping("searchUsers")
    @ResponseBody
    public Object searchUsers(String searchNm, String searchType, int page, int rows) {

        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("realName?" + searchNm + " g1;organization?" + searchNm + " g1;loginCode?" +searchNm + " g1");
        }
        if (!StringUtils.isEmpty(searchType)) {
            stringBuffer.append("userType=" + searchType);
        }

        params.put("filters", "");
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }

        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }*/

    /**
     * 通过用户名密码获取token
     */
    private AccessToken getAccessToken(String userName, String password, String clientId) {
        String result = "";
        AccessToken accessToken = new AccessToken();
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("userName", userName);
            params.put("password", password);
            params.put("clientId", clientId);
            result = HttpClientUtil.doPost(authorize + "oauth/accessToken", params);
            Map<String, Object> resultMap = objectMapper.readValue(result, Map.class);
            if ((boolean) resultMap.get("successFlg")) {
                String data = objectMapper.writeValueAsString(resultMap.get("data"));
                accessToken = objectMapper.readValue(data, AccessToken.class);
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return accessToken;
    }

    private List<AppFeatureModel> getUserFeatures(String userId) throws Exception {
        Map params = new HashMap<>();
        params.put("user_id", userId);
        String resultStr = HttpClientUtil.doGet(comUrl + "/roles/user/features", params, username, this.password);
        EnvelopExt<AppFeatureModel> envelopExt = (EnvelopExt<AppFeatureModel>) objectMapper.readValue(resultStr, new TypeReference<EnvelopExt<AppFeatureModel>>() {
        });
        if (envelopExt.isSuccessFlg()) {
            return envelopExt.getDetailModelList();
        } else {
            throw new Exception(envelopExt.getErrorMsg());
        }
    }

    /**
     * 获取当前用户的ip地址
     *
     * @return
     */
    // 暂时没用到
    /*public String requestGetAddress(HttpServletRequest request) {
        String strRead = null;
        String address = null;
        String ip = getIp();

        SystemDictId systemDict = new SystemDictId();
        String addressAPI = systemDict.AddressAPI;
        String apiKey = systemDict.Apikey;
        LoginAddress loginAddress = conventionalDictEntry.getLoginAddress(addressAPI);
        LoginAddress apiKeys = conventionalDictEntry.getLoginAddress(apiKey);
        String httpUrl = loginAddress.getValue();
        String httpArg = "ip=" + ip;

        BufferedReader reader = null;
        httpUrl = httpUrl + "?" + httpArg;

        try {
            URL url = new URL(httpUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            connection.setRequestProperty("apikey", apiKeys.getValue());
            connection.connect();
            InputStream is = connection.getInputStream();
            reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            strRead = reader.readLine();
            reader.close();

            address = getAddress(strRead);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return address;
    }*/

    private String getAddress(String citys) {
        String[] st = citys.split(",");
        List<String> list = new ArrayList<>();
        for (int i = 0; i < st.length; i++) {
            String addressEs = st[i];
            String[] address = addressEs.split(":");
            for (int j = 0; j < 1; j++) {
                String provinceCitys = address[1];

                if (provinceCitys.length() > 1) {
                    String ar = (provinceCitys.substring(1, provinceCitys.length() - 1));
                    String getCity = StringEscapeUtils.unescapeJava(ar);
                    list.add(getCity);
                }
            }
        }

        String province = list.get(3);
        String city = list.get(4);
        String provinceCity = null;
        if (province.equals("None") || province.equals("") || province == null && city.equals("None") || city.equals("") || city == null) {
            provinceCity = "未知";
        } else {
            provinceCity = province + "省" + city + "市";
        }

        return provinceCity;
    }

    /**
     * 多IP处理，可以得到最终ip
     *
     * @return
     */
    private String getIp() {
        String localIP = null;      // 本地IP，如果没有配置外网IP则返回它
        String publicIP = null;     // 外网IP
        try {
            Enumeration<NetworkInterface> netInterfaces = NetworkInterface.getNetworkInterfaces();
            InetAddress ip = null;
            boolean finded = false;// 是否找到外网IP
            while (netInterfaces.hasMoreElements() && !finded) {
                NetworkInterface ni = netInterfaces.nextElement();
                Enumeration<InetAddress> address = ni.getInetAddresses();
                while (address.hasMoreElements()) {
                    ip = address.nextElement();
                    if (!ip.isSiteLocalAddress() && !ip.isLoopbackAddress() && ip.getHostAddress().indexOf(":") == -1) {// 外网IP
                        publicIP = ip.getHostAddress();
                        finded = true;
                        break;
                    } else if (ip.isSiteLocalAddress()
                            && !ip.isLoopbackAddress()
                            && ip.getHostAddress().indexOf(":") == -1) {
                        localIP = ip.getHostAddress();
                    }
                }
            }
        } catch (SocketException e) {
            e.printStackTrace();
        }
        if (publicIP != null && !"".equals(publicIP)) {
            return publicIP;
        } else {
            return localIP;
        }
    }

}