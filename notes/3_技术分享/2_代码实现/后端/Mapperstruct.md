```java
package com.xxx.xxxx.convert;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import org.mapstruct.Named;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

@Component
public class TypeConvert {

    @Named("toJsonString")
    public String toJsonString(Object obj) {
        if (null == obj) {
            return null;
        }
        return JSON.toJSONString(obj);
    }

    @Named("jsonStringToStringArray")
    public List<String> jsonStringToStringArray(String jsonStr) {
        if (StrUtil.isEmpty(jsonStr)) {
            return Collections.emptyList();
        }
        return JSON.parseArray(jsonStr, String.class);
    }
}
```



```java
@Mapper(uses = TypeConvert.class)
public interface QbxxPublicationFileConvert {

    @Mapping(target = "publicationFileIds", source = "publicationFileIds", qualifiedByName = "toJsonString")
    QbxxPublicationFile toQbxxPublicationFile(QbxxPublicationFileCreateInVO qbxxPublicationFileCreateInVO);

    @Mapping(target = "publicationFileIds", source = "publicationFileIds", qualifiedByName = "toJsonString")
    QbxxPublicationFile toQbxxPublicationFile(QbxxPublicationFileUpdateInVO qbxxPublicationFileUpdateInVO);

    @Mapping(target = "publicationFileIds", qualifiedByName = "jsonStringToStringArray")
    QbxxPublicationFileListOutVO toOut(QbxxPublicationFile qbxxPublicationFile);

    @Mapping(target = "publicationFileIds", qualifiedByName = "jsonStringToStringArray")
    List<QbxxPublicationFileListOutVO> toOutList(List<QbxxPublicationFile> qbxxPublicationFiles);
}
```

