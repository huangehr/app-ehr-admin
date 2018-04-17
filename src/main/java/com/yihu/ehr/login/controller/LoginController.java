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
            if (!ehrUserSimple.getActivated()) {
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
            String url = browseClientUrl + "/common/login/signin?idCardNo=" + idCardNo;
            response.sendRedirect(authorize + "oauth/sso?response_type=token&client_id=" + clientId + "&redirect_uri=" + url + "&scope=read&user=" + user);
        } else {
            String url = browseClientOutSizeUrl + "/common/login/signin?idCardNo=" + idCardNo;
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
        String loginName = loginCode;
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
                List<RoleOrgModel> roleOrgModels = gerRolesOrgs(roleList);
                if (roleOrgModels.size() > 0){
                    List<String> roleOrgCodes = new ArrayList<>();
                    for (RoleOrgModel roleOrgModel : roleOrgModels){
                        roleOrgCodes.add(roleOrgModel.getOrgCode());
                    }
                    getUserSaasOrgAndArea(roleOrgCodes, request);
                } else {
                    List<String> userOrgList = new ArrayList<>();
                    userOrgList.add(AuthorityKey.NoUserOrgSaas);
                    session.setAttribute(AuthorityKey.UserOrgSaas, userOrgList);
                }
                //获取角色视图
                List<String> rolesResourceIdList =  new ArrayList<>();
                List<String> rolesResourceList = getRolesResource(userId, roleList);
                if (rolesResourceList != null && rolesResourceList.size() >0){
                    for (String rsRolesResource : rolesResourceList){
                        rolesResourceIdList.add(rsRolesResource);
                    }
                    session.setAttribute(AuthorityKey.UserResource, rolesResourceIdList);
                } else {
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
            return objectMapper.readValue(httpResponse.getContent(), List.class);
        }
        return new ArrayList<>();
    }

    /**
     * 获取用的saas机构
     */
    @RequestMapping(value = "/getUserSaasOrgAndArea", method = RequestMethod.GET)
    public void getUserSaasOrgAndArea(List<String> roleOrgCodes, HttpServletRequest request) throws Exception {
        //使用orgCode获取saas化的机构或者区域。
        String urlUOrg = "/org/getUserOrgSaasByUserOrgCode/";
        Map<String, Object> uParams = new HashMap<>();
        uParams.put("orgCodeStr", StringUtils.join(roleOrgCodes, ',') );
        String resultStrUserSaasOrg = HttpClientUtil.doGet(comUrl + urlUOrg, uParams, username, password);
        Envelop envelop = getEnvelop(resultStrUserSaasOrg);
        HttpSession session = request.getSession();
        session.setAttribute(AuthorityKey.UserAreaSaas, envelop.getObj());
        List<String> userOrgList = envelop.getDetailModelList();
        List<String> districtList = (List<String>) envelop.getObj();
        String geographyUrl = "/geography_entries/";
        if (districtList != null && districtList.size() > 0){
            for (String code : districtList){
                uParams.clear();
                String mGeographyDictStr = HttpClientUtil.doGet(comUrl + geographyUrl + code, uParams, username, password);
                envelop = getEnvelop(mGeographyDictStr);
                MGeographyDict mGeographyDict = null;
                mGeographyDict = getEnvelopModel(envelop.getObj(), MGeographyDict.class);
                if (mGeographyDict != null){
                    String province = "";
                    String city = "";
                    String district = "";
                    if (mGeographyDict.getLevel() == 1){
                        province =  mGeographyDict.getName();
                    } else if(mGeographyDict.getLevel() == 2){
                        city =  mGeographyDict.getName();
                    } else if(mGeographyDict.getLevel() == 3){
                        district =  mGeographyDict.getName();
                    }
                    String  orgGeographyStr = "/organizations/geography";
                    uParams.clear();
                    uParams.put("province", province);
                    uParams.put("city", city);
                    uParams.put("district", district);
                    String mOrgsStr = HttpClientUtil.doGet(comUrl + orgGeographyStr , uParams, username, password);
                    envelop = getEnvelop(mOrgsStr);
                    if (envelop != null && envelop.getDetailModelList() != null ){
                        List<MOrganization> organizations = (List<MOrganization>)getEnvelopList(envelop.getDetailModelList(),new ArrayList<MOrganization>(),MOrganization.class);
                        if (organizations !=null ){
                            java.util.Iterator it = organizations.iterator();
                            while (it.hasNext()){
                                MOrganization mOrganization = (MOrganization)it.next();
                                if (!userOrgList.contains(mOrganization.getCode())) {
                                    userOrgList.add(mOrganization.getCode());
                                }
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
        session.setAttribute(AuthorityKey.UserOrgSaas, userOrgList);
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
    public List<RoleOrgModel> gerRolesOrgs(List<String> roleList) throws Exception {
        List<RoleOrgModel> roleOrgs = new ArrayList<>();
        for (String roleId : roleList){
            Map<String, Object> params = new HashMap<>();
            /*String roleUrl = "/roles/role/" + roleId;
            params.put("id", Long.valueOf(roleId));
            String envelopRoleStr = HttpClientUtil.doGet(comUrl + roleUrl, params, username, password);
            Envelop envelopRole = objectMapper.readValue(envelopRoleStr,Envelop.class);
            if (envelopRole.getObj() != null){
                MRoles mRoles = objectMapper.convertValue(envelopRole.getObj(), MRoles.class);
                if ( ! StringUtils.isEmpty( mRoles.getOrgCode() )){
                    RoleOrgModel roleOrgModel = new RoleOrgModel();
                    roleOrgModel.setOrgCode(mRoles.getOrgCode());
                    roleOrgModel.setRoleId(mRoles.getId());
                    roleOrgs.add(roleOrgModel);
                }
            }*/
            String url = ServiceApi.Roles.RoleOrgsNoPage;
            params.put("filters", "roleId=" + roleId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
            Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
            if (envelop.isSuccessFlg() && envelop.getDetailModelList().size() > 0) {
                List<RoleOrgModel> roleOrgModels = envelop.getDetailModelList();
                if (roleOrgModels != null && roleOrgModels.size() > 0){
                    for(int i = 0; i < roleOrgModels.size() ;i++){
                        RoleOrgModel orgModel = objectMapper.convertValue(roleOrgModels.get(i), RoleOrgModel.class) ;
                        roleOrgs.add(orgModel);
                    }
                }
            }
        }
        return  roleOrgs;
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