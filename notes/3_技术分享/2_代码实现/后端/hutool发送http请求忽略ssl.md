

```java
String result = HttpUtil.createPost(url)
                    .contentType(MediaType.APPLICATION_JSON_VALUE)
                    .setSSLSocketFactory(SSLUtils.getSSLSocketFactory())
                    .body(JSON.toJSONString(reportRequest.getRequestBody()))
                    .execute().body();
```



```java
import javax.net.ssl.*;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;

public class SSLUtils {
    /**
     * 忽略https证书验证
     * @return
     */
    public static SSLSocketFactory getSSLSocketFactory() {
        try {
            SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, getTrustManager(), new SecureRandom());
            return sslContext.getSocketFactory();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static TrustManager[] getTrustManager() {
        TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    //检查客户端证书，若不信任该证书抛出异常，咱们自己就是客户端不用检查
                    @Override
                    public void checkClientTrusted(X509Certificate[] chain, String authType) {
                    }
                    //检查服务器的证书，若不信任该证书抛出异常，可以不检查默认都信任
                    @Override
                    public void checkServerTrusted(X509Certificate[] chain, String authType) {
                    }
                    //返回受信任的X509证书数组
                    @Override
                    public X509Certificate[] getAcceptedIssuers() {
                        return new X509Certificate[]{};
                    }
                }
        };
        return trustAllCerts;
    }

}
```

## 参考文章

1. [【java】hutool发送http请求，配置ssl忽略](https://blog.csdn.net/daohangtaiqian/article/details/131551228)