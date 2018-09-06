package com.yihu.ehr.adapter.service;

import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.common.utils.ExtTypeReference;
import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.lang3.reflect.TypeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.StringUtils;

import java.io.*;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/3/19
 */

public class ExtendService<T> {
    @Value("${service-gateway.username}")
    public String username;
    @Value("${service-gateway.password}")
    public String password;
    @Value("${service-gateway.url}")
    public String comUrl;

    public String modelUrl = "";
    public String addUrl = "";
    public String modifyUrl = "";
    public String deleteUrl = "";
    public String searchUrl = "";
    public String deleteUniqUrl = "";
    public String existenceUrl = "";

    public String idField = "id";

    private final Class modelType;
    private final ExtTypeReference typeReference;

    public ExtendService() {

        this.modelType = initModelClass();
        this.typeReference = initExtTypeReference();
    }

    public void init(String searchUrl, String modelUrl, String addUrl, String modifyUrl, String deleteUrl ){
        this.addUrl = addUrl;
        this.deleteUrl = deleteUrl;
        this.modelUrl = modelUrl;
        this.modifyUrl = modifyUrl;
        this.searchUrl = searchUrl;
    }

    public void init(String searchUrl, String modelUrl, String addUrl, String modifyUrl, String deleteUrl, String deleteUniqUrl ){
        this.addUrl = addUrl;
        this.deleteUrl = deleteUrl;
        this.modelUrl = modelUrl;
        this.modifyUrl = modifyUrl;
        this.searchUrl = searchUrl;
        this.deleteUniqUrl = deleteUniqUrl;
    }

    public String isExistence(Map parms) throws Exception{

        return doGet(comUrl + existenceUrl, parms);
    }

    public String search(Map parms) throws Exception{

        return doGet(comUrl + searchUrl, parms);
    }

    public String search(String url, Map parms) throws Exception{

        return doGet(comUrl + url, parms);
    }

    public String getModel(Map parms) throws Exception{

        return doGet(comUrl + modelUrl.replace("{id}", String.valueOf(parms.get(idField))), parms);
    }

    public String delete(Map parms) throws Exception{

        return doDelete(comUrl + deleteUrl, parms);
    }

    public String deleteUniq(Map parms) throws Exception{

        return doDelete(comUrl + deleteUniqUrl.replace("{id}", String.valueOf(parms.get(idField))), parms);
    }

    public String update(Map parms) throws Exception{

        return doPut(comUrl + modifyUrl.replace("{id}", String.valueOf(parms.get(idField))), parms);
    }

    public String add(Map parms) throws Exception{

        return doPost(comUrl + addUrl, parms);
    }

    public String doPut(String url, Map parms) throws Exception{

        return HttpClientUtil.doPut(url, parms, username, password);
    }

    public String doPost(String url, Map parms) throws Exception{

        return HttpClientUtil.doPost(url, parms, username, password);
    }

    public String doLargePost(String url, Map<String, Object> params) throws Exception {
        HttpClient httpClient = new HttpClient();
        String response = "";
        PostMethod postMethod = null;
        new StringBuilder();

        try {
            try {
                if(!StringUtils.isEmpty(username) && !StringUtils.isEmpty(password)) {
                    UsernamePasswordCredentials e = new UsernamePasswordCredentials(username, password);
                    httpClient.getState().setCredentials(AuthScope.ANY, e);
                }
//                int so = httpClient.getHttpConnectionManager().getParams().getSoTimeout();
//                so = httpClient.getHttpConnectionManager().getParams().getConnectionTimeout();
//                httpClient.getHttpConnectionManager().getParams().setSoTimeout(6000);
//                httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(6000);
                postMethod = new PostMethod(url);
                postMethod.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "UTF-8");
                for(Object key : params.keySet()){
                    postMethod.addParameter((String) key, String.valueOf(params.get(key)));
                }

                postMethod.getParams().setParameter("http.method.retry-handler", new DefaultHttpMethodRetryHandler());
                int e2 = httpClient.executeMethod(postMethod);
//                HttpConnectionManagerParams httpConnectionManagerParams = new HttpConnectionManagerParams();
//                httpClient.getHttpConnectionManager().setParams();
                if(e2 != 200) {
                    throw new Exception("请求出错: " + postMethod.getStatusLine());
                }
                BufferedReader reader = new BufferedReader(new InputStreamReader(postMethod.getResponseBodyAsStream(), "UTF-8"));
                StringBuffer stringBuffer = new StringBuffer();
                String str = "";
                while((str = reader.readLine()) != null){
                    stringBuffer.append(str);
                }
                response = stringBuffer.toString();
            } catch (HttpException var16) {
                var16.printStackTrace();
            } catch (IOException var17) {
                var17.printStackTrace();
            }catch (Exception e){
                e.printStackTrace();
            }

            return response;
        } finally {
            ;
        }
    }

    public String doGet(String url, Map parms) throws Exception{

        return HttpClientUtil.doGet(url, parms, username, password);
    }

    public String doDelete(String url, Map parms) throws Exception{

        return HttpClientUtil.doDelete(url, parms, username, password);
    }

    private static final String BOUNDARY = "----------HV2ymHFg03ehbqgZCaKO6jyH";
    private StringBuffer appendParm(StringBuffer contentBody, Map<String, Object> formData){

        for(String key: formData.keySet()){
            contentBody.append("\r\n")
                    .append("Content-Disposition: form-data; name=\"")
                    .append(key + "\"")
                    .append("\r\n")
                    .append("\r\n")
                    .append(formData.get(key))
                    .append("\r\n")
                    .append("--")
                    .append(BOUNDARY);
        }
        return contentBody;
    }

    private HttpURLConnection openConnection(URL url) throws IOException {

        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(60000);
        connection.setDoOutput(true);
        connection.setDoInput(true);
        connection.setUseCaches(false);
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Connection", "Keep-Alive");
        connection.setRequestProperty("Charset", "UTF-8");
        connection.setRequestProperty("Content-Type",
                "multipart/form-data; boundary=" + BOUNDARY);
        return connection;
    }

    public String doPostFile(String urlStr, Map<String, Object> formData, String fileName, String fileKey, InputStream is, int size) throws IOException {

        HttpURLConnection connection = openConnection(new URL(urlStr));
        OutputStream out = connection.getOutputStream();

        // 传输内容
        StringBuffer contentBody = new StringBuffer("--" + BOUNDARY);

        // 1. 处理文字形式的POST请求
        appendParm(contentBody, formData);
        out.write(contentBody.toString().getBytes("utf-8"));

        // 2. 处理文件上传
        contentBody = new StringBuffer();
        contentBody.append("\r\n")
                .append("Content-Disposition:form-data; name=\"")
                .append(fileKey + "\"; ") // form中field的名称
                .append("filename=\"")
                .append(fileName + "\"") // 上传文件的文件名
                .append("\r\n")
                .append("Content-Type:application/octet-stream")
                .append("\r\n\r\n");
        out.write(contentBody.toString().getBytes("utf-8"));

        // 开始真正向服务器写文件
        DataInputStream dis = new DataInputStream(is);
        int bytes = 0;
        byte[] bytes1 = new byte[1024];
        byte[] bufferOut = new byte[0];
        while ((bytes = dis.read(bytes1))!=-1){
            bufferOut = ArrayUtils.addAll(bufferOut, ArrayUtils.subarray(bytes1, 0, bytes ));
        }
        out.write(bufferOut);
        dis.close();

        // 3. 写结尾
        String endBoundary = "\r\n--" + BOUNDARY + "--\r\n";
        out.write(endBoundary.getBytes("utf-8"));
        out.flush();
        out.close();

        // 4. 从服务器获得回答的内容
        String strLine = "";
        String strResponse = "";
        InputStream in = connection.getInputStream();
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        while ((strLine = reader.readLine()) != null) {
            strResponse += strLine + "\n";
        }
        connection.disconnect();
        return strResponse;
    }

    private Class initModelClass() {
        Type genType = this.getClass().getGenericSuperclass();
        Type[] parameters = ((ParameterizedType) genType).getActualTypeArguments();
        return (Class) parameters[0];
    }

    public Class getModelClass() {

        return this.modelType;
    }

    public T newModel() {
        try {
            return (T) getModelClass().newInstance();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private ExtTypeReference initExtTypeReference(){

        return initExtTypeReference(modelType);
    }

    public ExtTypeReference initExtTypeReference(Class clz){
        ExtTypeReference typeReference = new ExtTypeReference();
        ParameterizedType p = TypeUtils.parameterize(EnvelopExt.class, clz);
        typeReference.setType(p);
        return typeReference;
    }

    public ExtTypeReference getExtTypeReference(){

        return typeReference;
    }

    public String searchSysDictEntries(int dictId) throws Exception {
        PageParms pageParms = new PageParms(50, 1)
                .addEqualNotNull("dictId", dictId);
        return doGet(comUrl + "/dictionaries/entries", pageParms);
    }
}
