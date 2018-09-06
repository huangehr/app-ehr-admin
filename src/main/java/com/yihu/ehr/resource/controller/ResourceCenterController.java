package com.yihu.ehr.resource.controller;

import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Controller - 资源中心首页
 * Created by progr1mmer on 2018/1/9.
 */

@Controller
@RequestMapping("/resourceCenter")
public class ResourceCenterController extends BaseUIController{

    // ------------------------------- 统计相关 start ------------------------------------
    /**
     * 顶部栏 - 居民建档数
     * @return
     */
    @ResponseBody
    @RequestMapping("/getPatientArchiveCount")
    public Envelop getPatientArchiveCount() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getPatientArchiveCount";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 顶部栏 - 医疗资源建档数
     * @return
     */
    @ResponseBody
    @RequestMapping("/getMedicalResourcesCount")
    public Envelop getMedicalResourcesCount() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getMedicalResourcesCount";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 顶部栏 - 健康档案建档数
     * @return
     */
    @ResponseBody
    @RequestMapping("/getHealthArchiveCount")
    public Envelop getHealthArchiveCount() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getHealthArchiveCount";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 顶部栏 - 电子病例建档数
     * @return
     */
    @ResponseBody
    @RequestMapping("/getElectronicCasesCount")
    public Envelop getElectronicCasesCount() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getElectronicCasesCount";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 全员人口个案库 - 健康卡绑定量
     * @return
     */
    @ResponseBody
    @RequestMapping("/getHealthCardBindingAmount")
    public Envelop getHealthCardBindingAmount() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getHealthCardBindingAmount";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 全员人口个案库 - 信息分布
     * @return
     */
    @ResponseBody
    @RequestMapping("/getInfoDistribution")
    public Envelop getInfoDistribution() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getInfoDistribution";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 全员人口个案库 - 新增情况
     * @return
     */
    @ResponseBody
    @RequestMapping("/getNewSituation")
    public Envelop getNewSituation() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getNewSituation";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 医疗资源库 - 医疗机构建档分布
     * @return
     */
    @ResponseBody
    @RequestMapping("/getOrgArchives")
    public Envelop getOrgArchives() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getOrgArchives";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 医疗资源库 - 医疗人员分布
     * @return
     */
    @ResponseBody
    @RequestMapping("/getMedicalStaffDistribution")
    public Envelop getMedicalStaffDistribution() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getMedicalStaffDistribution";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 医疗资源库 - 医护人员比例
     * @return
     */
    @ResponseBody
    @RequestMapping("/getMedicalStaffRatio")
    public Envelop getMedicalStaffRatio() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getMedicalStaffRatio";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 健康档案 - 累计整合档案数
     * @return
     */
    @ResponseBody
    @RequestMapping("/getCumulativeIntegration")
    public Envelop getCumulativeIntegration() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getCumulativeIntegration";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 健康档案 - 累计待整合档案数
     * @return
     */
    @ResponseBody
    @RequestMapping("/gteTotallyToBeIntegrated")
    public Envelop gteTotallyToBeIntegrated() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/gteTotallyToBeIntegrated";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 健康档案 - 档案来源分布情况
     * @return
     */
    @ResponseBody
    @RequestMapping("/getArchiveSource")
    public Envelop getArchiveSource() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getArchiveSource";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 健康档案 - 健康档案分布情况
     * @return
     */
    @ResponseBody
    @RequestMapping("/getArchiveDistribution")
    public Envelop getArchiveDistribution() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getArchiveDistribution";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 健康档案 - 健康档案入库情况分析
     * @return
     */
    @ResponseBody
    @RequestMapping("/getStorageAnalysis")
    public Envelop getStorageAnalysis() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getStorageAnalysis";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 电子病例 - 电子病例来源分布情况
     * @return
     */
    @ResponseBody
    @RequestMapping("/getElectronicMedicalSource")
    public Envelop getElectronicMedicalSource() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getElectronicMedicalSource";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 电子病例 - 电子病历采集医院分布
     * @return
     */
    @ResponseBody
    @RequestMapping("/getElectronicMedicalOrgDistributed")
    public Envelop getElectronicMedicalOrgDistributed() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getElectronicMedicalOrgDistributed";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 电子病例 - 电子病历采集科室分布
     * @return
     */
    @ResponseBody
    @RequestMapping("/getElectronicMedicalDeptDistributed")
    public Envelop getElectronicMedicalDeptDistributed() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getElectronicMedicalDeptDistributed";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        }catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 电子病例 - 电子病历采集采集情况
     * @return
     */
    @ResponseBody
    @RequestMapping("/getElectronicMedicalAcquisitionSituation")
    public Envelop getElectronicMedicalAcquisitionSituation() {
        Envelop envelop = new Envelop();
        String url = "/resource/center/getElectronicMedicalAcquisitionSituation";
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }
    // ------------------------------- 统计相关 end ------------------------------------

    // ------------------------------- 大数据展示相关 start ------------------------------------
    /**
     * 成果展示
     * @return
     */
    @ResponseBody
    @RequestMapping("/achievements")
    public Envelop achievements() {
        Envelop envelop = new Envelop();
        String url = "/resource/api/v1.0/resource/center/achievements";
        try {
            String resultStr = HttpClientUtil.doGet(adminInnerUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 可视化
     * @return
     */
    @ResponseBody
    @RequestMapping("/visualization")
    public Envelop visualization() {
        Envelop envelop = new Envelop();
        String url = "/resource/api/v1.0/resource/center/visualization";
        try {
            String resultStr = HttpClientUtil.doGet(adminInnerUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 数据分析
     * @return
     */
    @ResponseBody
    @RequestMapping("/dataAnalysis")
    public Envelop dataAnalysis() {
        Envelop envelop = new Envelop();
        String url = "/resource/api/v1.0/resource/center/dataAnalysis";
        try {
            String resultStr = HttpClientUtil.doGet(adminInnerUrl + url, username, password);
            envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 分级管理
     * @return
     */
    @ResponseBody
    @RequestMapping("/hierarchicalManagement")
    public Envelop hierarchicalManagement() {
        String url = "/resource/api/v1.0/resource/center/hierarchicalManagement";
        try {
            String resultStr = HttpClientUtil.doGet(adminInnerUrl + url, username, password);
            Envelop envelop = toModel(resultStr, Envelop.class);
            return envelop;
        } catch (Exception e) {
            return failed(e.getMessage());
        }
    }

    // ------------------------------- 大数据展示相关 end ------------------------------------

}
