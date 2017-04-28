package com.yihu.ehr.Filter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.ObjectMapperUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/22
 */

/**
 * �����ɫ��Ϣ
 */
@Service("roleCache")
public class RoleCache {
//    private final static Map<String, CopyOnWriteArrayList<String>> resourceMap = new ConcurrentHashMap<>();
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Value("${app.clientId}")
    private String clientId;

    private final static CopyOnWriteArrayList<String> resourceList = new CopyOnWriteArrayList<>();
//    private final static Set<String> resourceList = Collections.synchronizedSet(new HashSet<String>());
    public RoleCache() throws Exception {
        //loadRole();
    }

    private List<AppFeatureModel> getAppFeatures() throws Exception {
        Map parms = new HashMap<>();
        String url = "/filterFeatureNoPage";
        parms.put("filters", "appId="+clientId);
        String rs = HttpClientUtil.doGet(comUrl + url, parms,username,password);
//        ObjectMapperUtil objectMapperUtil = new ObjectMapperUtil();
        EnvelopExt<AppFeatureModel> envelopExt = (EnvelopExt<AppFeatureModel>)
                ObjectMapperUtil.toModel(rs, new TypeReference<EnvelopExt<AppFeatureModel>>() {});
        return envelopExt.getDetailModelList();
        //return null;
    }

    public boolean contains(String url){
        return resourceList.contains(url);
    }

    public void addRes(String res){
        synchronized (resourceList){
            resourceList.add(res);
        }
    }

    public void removeRes(String res){
        synchronized (resourceList) {
            resourceList.remove(res);
        }
    }

    /**
     * ��ʼ�����Ȩ����Ϣ
     */
    @PostConstruct
    private void loadRole() throws Exception {
        List<AppFeatureModel> appFeatureModelList = getAppFeatures();
        for(AppFeatureModel feature: appFeatureModelList){
            if(!StringUtils.isEmpty(feature.getUrl()))
                resourceList.add(feature.getUrl());
        }

//        CopyOnWriteArrayList<String> cas = new CopyOnWriteArrayList<>();
//        cas.add("dataCenterAdmin");
//        resourceMap.put("appDel", cas );
//
//        cas = new CopyOnWriteArrayList<>();
//        cas.add("dataCenterAdmin");
//        resourceMap.put("/app/platform/initial", cas );
//
//        cas = new CopyOnWriteArrayList<>();
//        cas.add("dataCenterAdmin");
//        resourceMap.put("/app/platform/list", cas );
//
//        cas = new CopyOnWriteArrayList<>();
//        cas.add("admin2");
//        resourceMap.put("/app/api/initial", cas );
//
//        cas = new CopyOnWriteArrayList<>();
//        cas.add("admin2");
//        resourceMap.put("appAdd", cas );
    }

//    /**
//     * ��ȡ�ɷ���key��Դ�Ľ�ɫ
//     * @param key ��Դ
//     * @return ��ɫ��
//     */
//    public CopyOnWriteArrayList getConfigAttributes(String key){
//        return resourceMap.get(key);
//    }

//    /**
//     * �ж��Ƿ�ca�Ƿ񱻸���key����Ȩ��
//     * @param key ��Դ��Ϣ
//     * @param ca  ��ɫ
//     * @return
//     */
//    public boolean hasRole(String key, String ca){
//        Collection c = resourceMap.get(key);
//        if(c!=null)
//            return c.contains(ca);
//        return true;
//    }
//
//    /**
//     * �ж��Ƿ�ca�Ƿ񱻸���key����Ȩ��
//     * @param key ��Դ��Ϣ
//     * @param c  ��ɫ��
//     * @return
//     */
//    public boolean hasRole(String key, Collection<String> c) {
//        CopyOnWriteArrayList elements = resourceMap.get(key);
//        for (Object e: c) {
//            if(elements.indexOf(e)>=0)
//                return true;
//        }
//        return false;
//    }
//
//    /**
//     * ���Ȩ����Ϣ
//     * @param key ��Դ��Ϣ
//     * @param ca  ��ɫ
//     */
//    public void addCache(String key, String ca){
//        if(resourceMap.get(key)==null){
//            resourceMap.put(key, new CopyOnWriteArrayList<>());
//        }
//        resourceMap.get(key).add(ca);
//    }
//
//    /**
//     * ɾ��Ȩ����Ϣ
//     * @param key ��Դ��Ϣ
//     * @param ca ��ɫ
//     */
//    public void removeCache(String key, String ca){
//        if(resourceMap.get(key)!=null){
//            resourceMap.get(key).remove(ca);
//        }
//    }

}
