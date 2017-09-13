package com.yihu.ehr.util;

import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.InputStream;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import static com.yihu.ehr.util.ObjectMapperUtil.objectMapper;

/**
 * 文件上传相关
 *
 * @author 张进军
 * @date 2017/8/18 11:58
 */
public class FileUploadUtil {

    /**
     * 获取上传文件的参数
     *
     * @param inputStream 文件流
     * @param fileName    文件名
     * @return 上传文件的参数
     */
    public static Map<String, Object> getParams(InputStream inputStream, String fileName) throws Exception {
        int temp = 0;
        byte tempBuffer[] = new byte[1024];
        byte[] fileBuffer = new byte[0];
        while ((temp = inputStream.read(tempBuffer)) != -1) {
            fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
        }
        inputStream.close();

        String fileBase64Str = Base64.getEncoder().encodeToString(fileBuffer);
        FileResourceModel fileResourceModel = new FileResourceModel("", "org", "");

        Map<String, Object> params = new HashMap<>();
        if(!StringUtils.isEmpty(fileBase64Str)) {
            params.put("file_str", fileBase64Str);
            params.put("file_name", fileName);
            params.put("json_data", ObjectMapperUtil.objectMapper.writeValueAsString(fileResourceModel));
        }
        return params;
    }

}
