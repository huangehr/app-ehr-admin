package com.yihu.ehr.util;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.common.utils.EnvelopExt;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/25
 */
public class ObjectMapperUtil {
    @Autowired
    static ObjectMapper objectMapper = new ObjectMapper();

    public static Object toModel(String json, TypeReference typeReference) throws IOException {
        return objectMapper.readValue(json, typeReference);
    }
}
