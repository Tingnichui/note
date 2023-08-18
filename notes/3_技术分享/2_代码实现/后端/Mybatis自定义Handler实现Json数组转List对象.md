```
package com.dcy.common.base.mapper;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

@MappedJdbcTypes(JdbcType.VARBINARY)
@MappedTypes({List.class})
public abstract class ListTypeHandler<T> extends BaseTypeHandler<List<T>> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, List<T> parameter, JdbcType jdbcType)
            throws SQLException {
        String content = CollectionUtils.isEmpty(parameter) ? null : JSON.toJSONString(parameter);
        ps.setString(i, content);
    }

    @Override
    public List<T> getNullableResult(ResultSet rs, String columnName) throws SQLException {
        return this.getListByJsonArrayString(rs.getString(columnName));
    }

    @Override
    public List<T> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return this.getListByJsonArrayString(rs.getString(columnIndex));
    }

    @Override
    public List<T> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return this.getListByJsonArrayString(cs.getString(columnIndex));
    }

    private List<T> getListByJsonArrayString(String content) {
        return StringUtils.isBlank(content) ? new ArrayList<>() : JSON.parseObject(content, this.specificType());
    }

    /**
     * 具体类型，由子类提供
     *
     * @return 具体类型
     */
    protected abstract TypeReference<List<T>> specificType();
}
```

```
package com.dcy.common.base.mapper;

import com.alibaba.fastjson.TypeReference;

import java.util.List;

public class StringListTypeHandler extends ListTypeHandler<String> {
    @Override
    protected TypeReference<List<String>> specificType() {
        return new TypeReference<List<String>>() {
        };
    }
}
```



```
   <resultMap id="PointDetailListOutVOResultMap" type="com.dcy.poi.vo.out.PointDetailListOutVO">
        <result column="tags" property="tags" typeHandler="com.dcy.common.base.mapper.StringListTypeHandler"/>
    </resultMap>
```

参考文章

1. https://blog.csdn.net/Axela30W/article/details/125226518
2. https://blog.csdn.net/qq3434569/article/details/103896666
3. https://blog.csdn.net/li18215100977/article/details/121267367