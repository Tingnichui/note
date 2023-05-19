## Spring

### 启动过程

[Spring容器启动流程（源码解读）](https://juejin.cn/post/6906637797080170510) 

主要看adstractapplationcontext中的refresh方法，首先扫描包下（spring factories文件指定其他class自动注入）class文件根据是否有@Component@Service等注解生成beandefination，然后冻结所有的bean定义开始循环创建bean。在获取bean时，首先从一级缓存获取，为空就标记创建然后通过反射去实例化bean返回beanwrapper，将lamada函数放入三级缓存后通过bean后置处理器填充属性【此处将会处理循环依赖】，接着[初始化bean](https://blog.csdn.net/weixin_38192427/article/details/116449682?ops_request_misc=&request_id=&biz_id=102&utm_term=initializeBean&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-116449682.nonecase&spm=1018.2226.3001.4187)，[初始化完成后判断从一二级缓存拿看是否单例](https://blog.csdn.net/qq_18297675/article/details/103674833)，随后加入到一级缓存

扩展点

### 事务

### 设计模式应用

### 源码

## Mybatis

### mybatis嵌套查询和嵌套结果

[Mybatis基于xml的一对一、一对多、多对多嵌套结果查询和嵌套查询](https://blog.csdn.net/qq_41615095/article/details/127900150) 

嵌套查询:是指通过执行另外一条SQL映射语句来返回预期的复杂类型，会执行多条sql语句
嵌套结果查询：是使用嵌套结果映射来处理重复的联合结果的子集，只会执行一条复杂的sql语句

## Spring MVC

### 工作流程

doservice进来后调用doDispatch方法，在doDispatch方法中首先检查是不是multipart类型，如果是的话进行解析，接下来进入getHandler方法去获取执行链，在这个方法中对应的handler（在mvc中handler就是controller，通过url路径获取对应的controller），获取到handler后再通过getHandlerExecutionChain方法获取HandlerExecutionChain执行链，其中会将handler放入执行链中，获取到执行链后调用getHandlerAdapter方法获取适配器HandlerAdapter(适配器模式)，获取到适配器之后调用handle方法，再handle方法中会对session、请求参数做处理，然后调用对应的controller方法（如果是aop会走动态代理）获取返回结果，最后处理返回结果，比如@ResponseBody注解等

## Spring Boot

## 容器