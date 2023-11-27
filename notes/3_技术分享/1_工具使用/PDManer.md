DO生成

```
{{  var today=new Date();
    var fullYear=today.getFullYear();
    var month=today.getMonth() + 1;
    var days=today.getDate();
    
    var pkVarName = "undefinedId";
    var pkDataType = "String";
    it.entity.fields.forEach(function(field){
        if(field.primaryKey){
            pkVarName = it.func.camel(field.defKey,false);
            pkDataType = field["type"];
            return;
        }
    });
    
    var pkgName = it.entity.env.base.nameSpace;
    var beanClass = it.entity.env.base.codeRoot;
    var beanVarName = beanClass.charAt(0).toLowerCase()+beanClass.slice(1);
    var serviceClass = beanClass+'Service';
    var serviceVarName= beanVarName+'Service';
    
}}package com.chunhui.web.pojo.po;
$blankline
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;
$blankline

 /**
 * {{=it.entity.defName}};{{=it.entity.comment}}
 * @author : genghui
 * @date : {{=fullYear}}-{{=month}}-{{=days}}
 */
@Data
@TableName("{{=it.entity.defKey}}")
public class {{=beanClass}} extends BaseDO {
{{~it.entity.fields:field:index}}
    {{? field.defKey != "id" && field.defKey != "create_by" && field.defKey != "create_time" && field.defKey != "update_by" && field.defKey != "update_time" && field.defKey != "del_flag" }}
    /**
     * {{=it.func.join(field.defName,field.comment,';')}}
     */
    private {{=field.type}} {{=it.func.camel(field.defKey,false)}};
    {{?}}
{{~}}
$blankline

}
```

