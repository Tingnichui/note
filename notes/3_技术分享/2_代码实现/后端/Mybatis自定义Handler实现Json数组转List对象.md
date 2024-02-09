```java
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

```java
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

```java
package com.dcy.common.mybatis;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@MappedJdbcTypes(JdbcType.VARBINARY)
@MappedTypes({List.class})
public class StringListTypeHandler extends BaseTypeHandler<List<String>> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, List<String> parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, String.join(",", parameter));
    }

    @Override
    public List<String> getNullableResult(ResultSet rs, String columnName) throws SQLException {
        String str = rs.getString(columnName);
        return (rs.wasNull() || StringUtils.isEmpty(str)) ? Collections.emptyList() : Arrays.asList(str.split(","));
    }

    @Override
    public List<String> getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String str = rs.getString(columnIndex);
        return (rs.wasNull() || StringUtils.isEmpty(str)) ? Collections.emptyList() : Arrays.asList(str.split(","));
    }

    @Override
    public List<String> getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String str = cs.getString(columnIndex);
        return (cs.wasNull() || StringUtils.isEmpty(str)) ? Collections.emptyList() : Arrays.asList(str.split(","));
    }

}


```

```xml
 <resultMap id="instruction_info_list_out_vo" type="com.dcy.szcz.common.vo.out.InstructionInfoListOutVO">
        <result column="id" property="id"/>
        <result column="parent_id" property="parentId"/>
        <result column="title" property="title"/>
        <result column="content" property="content"/>
        <result column="instruction_type" property="instructionType"/>
        <result column="emergency_level" property="emergencyLevel"/>
        <result column="serial_number" property="serialNumber"/>
        <result column="serial_number_order" property="serialNumberOrder"/>
        <result column="serial_number_year" property="serialNumberYear"/>
        <result column="release_dept_name" property="releaseDeptName"/>
        <result column="release_dept_code" property="releaseDeptCode"/>
        <result column="instruction_nature" property="instructionNature"/>
        <result column="release_user_name" property="releaseUserName"/>
        <result column="release_user_id" property="releaseUserId"/>
        <result column="release_time" property="releaseTime"/>
        <result column="destination" property="destination" typeHandler="com.dcy.common.mybatis.StringListTypeHandler"/>
        <result column="contact_person_name" property="contactPersonName"/>
        <result column="contact_person_phone_num" property="contactPersonPhoneNum"/>
        <result column="instruction_attachment" property="instructionAttachment"
                typeHandler="com.dcy.common.mybatis.StringListTypeHandler"/>
        <result column="risk_contradiction" property="riskContradiction"/>
        <result column="work_requirement" property="workRequirement"/>
        <result column="undertake_user_name" property="undertakeUserName"/>
        <result column="undertake_user_id" property="undertakeUserId"/>
        <result column="issue_person_name" property="issuePersonName"/>
        <result column="issue_person_id" property="issuePersonId"/>
        <result column="data_type" property="dataType"/>
        <result column="feedback_deadline" property="feedbackDeadline"/>
        <result column="stare_status" property="stareStatus"/>
        <result column="focus_status" property="focusStatus"/>
        <result column="receivie_dept_code" property="receivieDeptCode"
                typeHandler="com.dcy.common.mybatis.StringListTypeHandler"/>
        <result column="cc_dept_code" property="ccDeptCode" typeHandler="com.dcy.common.mybatis.StringListTypeHandler"/>
        <result column="data_src" property="dataSrc"/>
        <result column="need_feedback_count" property="needFeedbackCount"/>
        <result column="feedback_count" property="feedbackCount"/>
        <result column="need_sign_count" property="needSignCount"/>
        <result column="sign_count" property="signCount"/>
        <result column="wait_access_count" property="waitAccessCount"/>
        <result column="feedback_final_status" property="feedbackFinalStatus"/>
        <result column="sign_final_status" property="signFinalStatus"/>
        <result column="transfer_status" property="transferStatus"/>
        <result column="assess_final_status" property="assessFinalStatus"/>
    </resultMap>
```



```java
   <resultMap id="PointDetailListOutVOResultMap" type="com.dcy.poi.vo.out.PointDetailListOutVO">
        <result column="tags" property="tags" typeHandler="com.dcy.common.base.mapper.StringListTypeHandler"/>
    </resultMap>
```

参考文章

1. https://blog.csdn.net/Axela30W/article/details/125226518
2. https://blog.csdn.net/qq3434569/article/details/103896666
3. https://blog.csdn.net/li18215100977/article/details/121267367