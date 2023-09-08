https://blog.csdn.net/baidu_41858046/article/details/116881842

```
import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Constraint(validatedBy = CheckXssImpl.class)
public @interface CheckXss {

    String message() default "非法输入";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
```





```
import org.apache.commons.lang3.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CheckXssImpl implements ConstraintValidator<CheckXss, String> {

    //    private final String XSS_PATTERN = "((?i)<script.*?>)||((?i)prompt\\s*\\()|((?i)document\\.cookie)|((?i)location\\.href)|((?i)window\\.location)|((?i)onerror\\s*\\()|((?i)eval\\s*\\()|((?i)window\\.open\\s*\\()|((?i)innerHTML)|((?i)onclick\\s*\\()|((?i)onmouseover\\s*\\()|((?i)onsubmit\\s*\\()|((?i)onload\\s*\\()|((?i)onfocus\\s*\\()|((?i)onblur\\s*\\()|((?i)onkeyup\\s*\\()|((?i)onkeydown\\s*\\()|((?i)onkeypress\\s*\\()|((?i)onmouseout\\s*\\()|((?i)src=)|((?i)href=)|((?i)background=)|((?i)expression\\s*\\()|((?i)XMLHttpRequest\\s*\\()|((?i)ActiveXObject\\s*\\()|((?i)iframe)|((?i)document\\.write\\s*\\()|((?i)document\\.writeln\\s*\\()|((?i)setTimeout\\s*\\()|((?i)setInterval\\s*\\()|((?i)onreadystatechange\\s*\\()|((?i)appendChild\\s*\\()|((?i)createTextNode\\s*\\()|((?i)createElement\\s*\\()|((?i)getElementsByTagName\\s*\\()|((?i)getElementsByClassName\\s*\\()|((?i)querySelector\\s*\\()|((?i)querySelectorAll\\s*\\()|((?i)document\\.location)|((?i)document\\.body\\.innerHTML)|((?i)document\\.forms)|((?i)document\\.images)|((?i)document\\.links)|((?i)document\\.URL)|((?i)document\\.domain)|((?i)document\\.referrer)|((?i)history\\.back\\s*\\()";
    private final String XSS_PATTERN = "(eval\\((.*)\\))|" +
            "(<[\\\\s]*?script[^>]*?>[\\\\s\\\\S]*?<[\\\\s]*?\\\\/[\\\\s]*?script[\\\\s]*?>)|" +
            "((?i)alert\\s*\\()|(<[\\\\s]*?javascript[^>]*?>[\\\\s\\\\S]*?<[\\\\s]*?\\\\/[\\\\s]*?javascript[\\\\s]*?>)";

    private final Pattern pattern = Pattern.compile(XSS_PATTERN);

    @Override
    public void initialize(CheckXss checkXss) {

    }

    @Override
    public boolean isValid(String content, ConstraintValidatorContext constraintValidatorContext) {
        if (StringUtils.isNotBlank(content)) {
            Matcher matcher = pattern.matcher(content);
            if (matcher.find()) {
                return false;
            }
        }
        return true;
    }

}
```

