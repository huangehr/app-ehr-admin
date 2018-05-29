package com.yihu.ehr.login.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.agModel.user.AccessToken;
import com.yihu.ehr.agModel.user.RoleOrgModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.AgAdminConstants;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.geography.MGeographyDict;
import com.yihu.ehr.model.org.MOrganization;
import com.yihu.ehr.model.user.EhrUserSimple;
import com.yihu.ehr.model.user.MRoleOrg;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
import com.yihu.ehr.util.http.IPInfoUtils;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.rmi.MarshalledObject;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by lingfeng on 2015/6/30.
 */
@Controller
@RequestMapping("/login")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class LoginController extends BaseUIController {


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
        model.addAttribute("menuId", request.getParameter("menuId"));
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
        String response = HttpClientUtil.doPost(adminInnerUrl + "/authentication/oauth/validToken", params);
        AccessToken accessToken = objectMapper.readValue(response, AccessToken.class);
        String loginName = accessToken.getUser();
        //验证通过。赋值session中的用户信息
        String userInfo = HttpClientUtil.doGet(adminInnerUrl + "/basic/api/v1.0/users/" + loginName, params);
        UserDetailModel userDetailModel = this.objectMapper.readValue(userInfo, UserDetailModel.class);
        //存储基本信息
        UsersModel usersModel = new UsersModel();
        usersModel.setId(userDetailModel.getId());
        usersModel.setRealName(userDetailModel.getRealName());
        usersModel.setEmail(userDetailModel.getEmail());
        usersModel.setOrganizationCode(userDetailModel.getOrganization());
        usersModel.setTelephone(userDetailModel.getTelephone());
        usersModel.setLoginCode(userDetailModel.getLoginCode());
        usersModel.setUserType(userDetailModel.getUserType());
        usersModel.setActivated(userDetailModel.getActivated());
        SimpleDateFormat dateFormat = new SimpleDateFormat(AgAdminConstants.DateTimeFormat);
        if (userDetailModel.getLastLoginTime() != null) {
            usersModel.setLastLoginTime(userDetailModel.getLastLoginTime());
        } else {
            String now = dateFormat.format(new Date());
            usersModel.setLastLoginTime(now);
        }
        // 注：SessionAttributeKeys.CurrentUser 是用 @SessionAttributes 来最终赋值，换成用 session.setAttribute() 赋值后将会被覆盖。
        model.addAttribute(SessionAttributeKeys.CurrentUser, usersModel);
        HttpSession session = request.getSession();
        //增加超级管理员信息
        if (loginName.equals(permissionsInfo)) {
            session.setAttribute(AuthorityKey.IsAccessAll, true);
        } else {
            session.setAttribute(AuthorityKey.IsAccessAll, false);
        }
        model.addAttribute("last_login_time", usersModel.getLastLoginTime());
        session.setAttribute("last_login_time", usersModel.getLastLoginTime());
        session.setAttribute("isLogin", true);
        session.setAttribute("token", accessToken);
        session.setAttribute("loginName", loginName);
        session.setAttribute("userId", usersModel.getId());
        session.setAttribute("clientId", clientId);
        //获取用户的角色，机构，视图 等权限
        initUserRolePermissions(usersModel.getId(), loginName, request);
        //获取用户角色信息
        List<AppFeatureModel> features = getUserFeatures(usersModel.getId());
        Collection<GrantedAuthority> gas = new ArrayList<>();
        if (features != null) {
            for (AppFeatureModel feature : features) {
                if (!StringUtils.isEmpty(feature.getUrl())) {
                    gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                }
            }
        }
        //生成认证token
        //Authentication AuthenticationToken = new UsernamePasswordAuthenticationToken(request, "", gas);
        Authentication authentication = new UsernamePasswordAuthenticationToken(loginName, userDetailModel.getPassword(), gas);
        //将信息存放到SecurityContext
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return success(accessToken);

    }

    @RequestMapping(value = "/validate", method = RequestMethod.POST)
    public String loginValid(Model model, String userName, String password, HttpServletRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>(2);
        params.put("client_id", baseClientId);
        params.put("username", userName);
        params.put("password", password);
        String url = "/authentication/oauth/login";
        HttpResponse httpResponse = HttpUtils.doPost(adminInnerUrl + url, params);
        //判断用户是否登入成功
        if (httpResponse.isSuccessFlg()) {
            EhrUserSimple ehrUserSimple = objectMapper.readValue(httpResponse.getContent(), EhrUserSimple.class);
            //增加超级管理员信息
            HttpSession session = request.getSession();
            //判断用户是否失效
            if (ehrUserSimple.getActivated() != null && !ehrUserSimple.getActivated()) {
                model.addAttribute("userName", userName);
                model.addAttribute("successFlg", false);
                model.addAttribute("failMsg", "该用户已失效，请联系系统管理员重新生效。");
                model.addAttribute("contentPage", "login/login");
                return "generalView";
            }
            //判断用户密码是否初始密码
            if (password.equals("123456")) {
                session.setAttribute("defaultPassWord", true);
                model.addAttribute("contentPage", "user/changePassword");
                return "generalView";
            } else {
                SimpleDateFormat dateFormat = new SimpleDateFormat(AgAdminConstants.DateTimeFormat);
                //存储基本信息
                UsersModel usersModel = new UsersModel();
                usersModel.setId(ehrUserSimple.getId());
                usersModel.setRealName(ehrUserSimple.getRealName());
                usersModel.setEmail(ehrUserSimple.getEmail());
                usersModel.setOrganizationCode(ehrUserSimple.getOrganization());
                usersModel.setTelephone(ehrUserSimple.getTelephone());
                usersModel.setLoginCode(ehrUserSimple.getLoginCode());
                usersModel.setUserType(ehrUserSimple.getUserType());
                usersModel.setActivated(ehrUserSimple.getActivated());
                if (ehrUserSimple.getLastLoginTime() != null) {
                    usersModel.setLastLoginTime(dateFormat.format(ehrUserSimple.getLastLoginTime()));
                } else {
                    String now = dateFormat.format(new Date());
                    usersModel.setLastLoginTime(now);
                }
                // 注：SessionAttributeKeys.CurrentUser 是用 @SessionAttributes 来最终赋值，换成用 session.setAttribute() 赋值后将会被覆盖。
                model.addAttribute(SessionAttributeKeys.CurrentUser, usersModel);
                //增加超级管理员信息
                if (userName.equals(permissionsInfo)) {
                    session.setAttribute(AuthorityKey.IsAccessAll, true);
                } else {
                    session.setAttribute(AuthorityKey.IsAccessAll, false);
                }
                session.removeAttribute("defaultPassWord");
                model.addAttribute("last_login_time", usersModel.getLastLoginTime());
                session.setAttribute("last_login_time", usersModel.getLastLoginTime());
                session.setAttribute("isLogin", true);
                AccessToken accessToken = new AccessToken();
                accessToken.setAccessToken(ehrUserSimple.getAccessToken());
                accessToken.setRefreshToken(ehrUserSimple.getRefreshToken());
                accessToken.setExpiresIn(ehrUserSimple.getExpiresIn());
                accessToken.setState(ehrUserSimple.getState());
                accessToken.setTokenType(ehrUserSimple.getTokenType());
                accessToken.setUser(ehrUserSimple.getUser());
                session.setAttribute("token", accessToken);
                session.setAttribute("loginName", userName);
                session.setAttribute("userId", ehrUserSimple.getId());
                session.setAttribute("clientId", baseClientId);
                //获取用户的角色，机构，视图 等权限
                initUserRolePermissions(ehrUserSimple.getId(), userName, request);
                //获取用户角色信息
                List<AppFeatureModel> features = getUserFeatures(ehrUserSimple.getId());
                Collection<GrantedAuthority> gas = new ArrayList<>();
                if (features != null) {
                    for (AppFeatureModel feature : features) {
                        if (!StringUtils.isEmpty(feature.getUrl())) {
                            gas.add(new SimpleGrantedAuthority(feature.getUrl()));
                        }
                    }
                }
                //生成认证token
                Authentication token = new UsernamePasswordAuthenticationToken(userName, password, gas);
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
    public Envelop check (String idCardNo, HttpServletRequest request) throws Exception {
        initUrlInfo(request);
        Map<String, Object> paramsMap = new HashMap<>();
        paramsMap.put("demographic_id", idCardNo);
        paramsMap.put("version", stdVersion);
        String url2 =  "/profile/baseInfo";
        String result = HttpClientUtil.doGet(profileurl + url2, paramsMap, username, password);
        Map<String, Object> resultMap = objectMapper.readValue(result, Map.class);
        if (resultMap != null && resultMap.size() > 0) {
            return success(true);
        }
        return failed("该居民暂无档案信息");
    }

    @RequestMapping(value = "/broswerSignin", method = RequestMethod.GET)
    public void signin(Model model, HttpServletRequest request, HttpServletResponse response, String idCardNo) throws Exception {
        model.addAttribute("model", request.getSession());
        model.addAttribute("idCardNo", idCardNo);
        String clientId = browseClientId;
        //获取code
        HttpSession session = request.getSession();
        AccessToken token = (AccessToken) session.getAttribute("token");
        String user = token.getUser();
        boolean isInnerIp = true;
        if(session.getAttribute("isInnerIp") != null){
            isInnerIp = (Boolean) session.getAttribute("isInnerIp");
        }
        //System.out.println("isInnerIp:" + isInnerIp);
        if (isInnerIp) {
            String url = browseClientUrl + "/app/home/html/signin.html?idCardNo=" + idCardNo;
            response.sendRedirect(authorize + "oauth/sso?response_type=token&client_id=" + clientId + "&redirect_uri=" + url + "&scope=read&user=" + user);
        } else {
            String url = browseClientOutSizeUrl + "/app/home/html/signin.html?idCardNo=" + idCardNo;
            response.sendRedirect(oauth2OutSize + "oauth/sso?response_type=token&client_id=" + clientId + "&redirect_uri=" + url + "&scope=read&user=" + user);
        }
    }



    /**
     * 初始化内外网IP信息
     * @param request
     */
    public void initUrlInfo(HttpServletRequest request) {
        String ip = IPInfoUtils.getIPAddress(request);
        if (ip != null) {
            if ("0:0:0:0:0:0:0:1".equals(ip)) {
                request.getSession().setAttribute("isInnerIp", true);
            } else {
                if ("127.0.0.1".equals(ip) || IPInfoUtils.isInnerIP(ip)) {
                    request.getSession().setAttribute("isInnerIp", true);
                } else {
                    request.getSession().setAttribute("isInnerIp", false);
                }
            }
        }
    }

    //------------------------------------------------- 单点登录 end -------------------------------------------

    /**
     * 获取用户的角色，机构，视图 等权限
     * @param userId
     * @param request
     * @throws Exception
     */
    public void initUserRolePermissions(String userId, String loginCode, HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        if (loginCode.equals(permissionsInfo)){
            session.setAttribute(AuthorityKey.UserRoles, null);
            session.setAttribute(AuthorityKey.UserResource, null);
            session.setAttribute(AuthorityKey.UserAreaSaas, null);
            session.setAttribute(AuthorityKey.UserOrgSaas, null);
        } else{
            //获取用户角色
            List<String> roleList = gerUserRoles(userId);
            if (!roleList.isEmpty()){
                session.setAttribute(AuthorityKey.UserRoles, roleList);
                //获取角色机构
                List<Map<String, Object>> roleOrgModels = gerRolesOrgs(roleList);
                if (roleOrgModels.size() > 0){
                    Set<String> roleOrgCodes = new HashSet<>();
                    roleOrgModels.forEach(item -> {
                        roleOrgCodes.add((String) item.get("orgCode"));
                    });
                    getUserSaasOrgAndArea(roleOrgCodes, request);
                } else {
                    List<String> userOrgList = new ArrayList<>();
                    userOrgList.add(AuthorityKey.NoUserOrgSaas);
                    session.setAttribute(AuthorityKey.UserOrgSaas, userOrgList);
                }
                //获取角色视图
                List<String> rolesResourceList = getRolesResource(userId, roleList);
                if (rolesResourceList != null && rolesResourceList.size() >0){
                    session.setAttribute(AuthorityKey.UserResource, rolesResourceList);
                } else {
                    List<String> rolesResourceIdList = new ArrayList<>();
                    rolesResourceIdList.add(AuthorityKey.NoUserResource);
                    session.setAttribute(AuthorityKey.UserResource, rolesResourceIdList);
                }
            } else {
                roleList.add(AuthorityKey.NoUserRole);
                session.setAttribute(AuthorityKey.UserRoles, roleList);
            }
        }
    }

    /**
     * 获取用户角色
     * @param userId
     * @return
     */
    public List<String> gerUserRoles(String userId) throws Exception {
        //获取用户所属角色
        String url = "/basic/api/v1.0/roles/clientRole";
        Map<String,Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("clientId", baseClientId);
        HttpResponse httpResponse = HttpUtils.doGet(adminInnerUrl + url, params);
        if (httpResponse.isSuccessFlg()) {
            List<String> list = new ArrayList<>();
            List<String> temp = objectMapper.readValue(httpResponse.getContent(), List.class);
            temp.forEach(item -> {
                if (!list.contains(item)) {
                    list.add(item);
                }
            });
            return list;
        }
        return new ArrayList<>();
    }

    /**
     * 获取用的saas机构   响应时间很久
     */
    @RequestMapping(value = "/getUserSaasOrgAndArea", method = RequestMethod.GET)
    public void getUserSaasOrgAndArea(Set<String> roleOrgCodes, HttpServletRequest request) throws Exception {
        //获取地区saas
        String saas = "/basic/api/v1.0/org/getUserOrgSaasByUserOrgCode/";
        Map<String, Object> params = new HashMap<>();
        params.put("userOrgCode", StringUtils.join(roleOrgCodes, ',') );
        params.put("type", "1");
        HttpResponse areaSaasResponse = HttpUtils.doGet(adminInnerUrl + saas, params);
        HttpSession session = request.getSession();
        List<String> _areaSaasList = new ArrayList<>();
        if (areaSaasResponse.isSuccessFlg()) {
            List<String> areaSaasList = toModel(areaSaasResponse.getContent(), List.class);
            areaSaasList.forEach(item -> {
                if (!_areaSaasList.contains(item)) {
                    _areaSaasList.add(item);
                }
            });
        }
        session.setAttribute(AuthorityKey.UserAreaSaas, _areaSaasList);
        //获取机构saas
        params.put("type", "2");
        HttpResponse orgSaasResponse = HttpUtils.doGet(adminInnerUrl + saas, params);
        if (orgSaasResponse.isSuccessFlg()) {
            List<String> orgSaasList = objectMapper.readValue(orgSaasResponse.getContent(), List.class);
            if (_areaSaasList.size() > 0) {
                StringBuilder stringBuilder = new StringBuilder();
                _areaSaasList.forEach(item -> {
                    stringBuilder.append(item).append(",");
                });
                String childOrgSaas = "/basic/api/v1.0/org/childOrgSaasByAreaCode";
                params.clear();
                params.put("area", stringBuilder.toString());
                HttpResponse childOrgSaasResponse = HttpUtils.doPost(adminInnerUrl + childOrgSaas, params);
                if (childOrgSaasResponse.isSuccessFlg()) {
                    List<String> temp = toModel(childOrgSaasResponse.getContent(), List.class);
                    temp.forEach(item -> {
                        if (!orgSaasList.contains(item)) {
                            orgSaasList.add(item);
                        }
                    });
                }
            }
            //加上自身默认机构
            roleOrgCodes.forEach(item -> {
                if (!orgSaasList.contains(item)) {
                    orgSaasList.add(item);
                }
            });
            orgSaasList.removeAll(Collections.singleton(null));
            orgSaasList.removeAll(Collections.singleton(""));
            session.setAttribute(AuthorityKey.UserOrgSaas, orgSaasList);
        } else {
            session.setAttribute(AuthorityKey.UserOrgSaas, new ArrayList<>());
        }
    }

    @RequestMapping(value = "/userVerification")
    @ResponseBody
    public Object dataValidation(String userName, String password) throws Exception {
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        Envelop envelop = new Envelop();
        String url;
        String resultStr;
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
        return envelop;
    }

    @RequestMapping("/activityUser")
    @ResponseBody
    public Object activityUser(String userId, boolean activated) throws Exception {
        String url = "/users/admin/" + userId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("activity", activated);
        resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

        if (Boolean.parseBoolean(resultStr)) {
            result.setSuccessFlg(true);
        } else {
            result.setSuccessFlg(false);
            result.setErrorMsg("更新失败");
        }
        return result;

    }

    /**
     * 获取角色机构
     * @param roleList 角色组列表
     * @return
     */
    public List<Map<String, Object>> gerRolesOrgs(List<String> roleList) throws Exception {
        StringBuilder stringBuilder = new StringBuilder();
        roleList.forEach(item -> {
            stringBuilder.append(item).append(",");
        });
        Map<String, Object> params = new HashMap<>();
        String url = "/basic/api/v1.0/roles/role_orgs/no_page";
        params.put("filters", "roleId=" + stringBuilder.toString());
        HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
        if (response.isSuccessFlg()) {
            List<Map<String, Object>> list = objectMapper.readValue(response.getContent(), List.class);
            return list;
        }
        return new ArrayList<>();
    }

    /**
     * 获取角色视图列表
     * @param roleList
     * @return
     */
    public List<String> getRolesResource(String userId, List<String> roleList) throws Exception {
        List<String> rolesResourceList = new ArrayList<>();
        for (String roleId : roleList){
            String url = ServiceApi.Resources.GetRolesGrantResources;
            Map<String,Object> params = new HashMap<>();
            params.put("rolesId", roleId);
            params.put("userId", userId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            if (envelop.isSuccessFlg() && null != envelop.getDetailModelList() && envelop.getDetailModelList().size() > 0 ) {
                List<String> roleResourceModels = envelop.getDetailModelList();
                if (roleResourceModels != null && roleResourceModels.size() > 0){
                    for (int i = 0; i < roleResourceModels.size() ;i++){
                        rolesResourceList.add(roleResourceModels.get(i));
                    }
                }
            }
        }
        return rolesResourceList;
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

}