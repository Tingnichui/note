## 并发与多线程

## OOP

[什么是OOP](https://blog.csdn.net/weixin_42200954/article/details/116205347?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167480311516800180656735%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167480311516800180656735&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-116205347-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=oop&spm=1018.2226.3001.4187) 

>  面向对象编程，OOP特征分别是封装、继承、多态
>
> - 封装：封装是指将对象信息状态通过访问权限修饰符隐藏在对象内部，不允许外部程序直接访问，如果外部程序要访问对象内部，可以调用内部提供的get或set方法。
> - 继承：子类继承了父类所有的成员方法和属性，并且可以拥有自己特性。继承解决了代码的复用问题
> - 多态：父类或接口定义的引用变量可以指向子类或具体实现类的实例对象。提高了程序的拓展性。

### 面向对象设计原则

[面向对象设计的七大设计原则详解](https://blog.csdn.net/qq_34760445/article/details/82931002?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167480347616800225521470%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167480347616800225521470&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-82931002-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E9%9D%A2%E5%90%91%E5%AF%B9%E8%B1%A1%E8%AE%BE%E8%AE%A1%E5%8E%9F%E5%88%99&spm=1018.2226.3001.4187) 

**设计目标**：开闭原则、里氏代换原则、迪米特原则

**设计方法**：单一职责原则、接口分隔原则、依赖倒置原则、组合/聚合复用原则

1. 开闭原则：软件实体（模块，类，方法等）应该对扩展开放，对修改关闭
2. 里氏替换原则：所有引用基类的地方必须能透明地使用其派生类的对象，子类可以扩展父类的功能，但不能改变父类原有的功能
3. 迪米特原则（最少知道原则）：只与你直接的朋友们通信，不要跟“陌生人”说话，降低类之间的耦合，每个类尽量减少对其他类的依赖，因此，很容易使得系统的功能模块功能独立，相互之间不存在（或很少有）依赖关系
4. 单一职责原则：只能让一个类/接口/方法有且仅有一个职责，永远不要让一个类存在多个改变的理由，如果一个类需要改变，改变它的理由永远只有一个。如果存在多个改变它的理由，就需要重新设计该类
5. 接口分隔原则（Interface Segregation Principle ，ISP）：不能强迫用户去依赖那些他们不使用的接口
   - **接口的设计原则**：接口的设计应该遵循最小接口原则，不要把用户不使用的方法塞进同一个接口里。如果一个接口的方法没有被使用到，则说明该接口过胖，应该将其分割成几个功能专一的接口。
   - **接口的依赖（继承）原则**：如果一个接口a继承另一个接口b，则接口a相当于继承了接口b的方法，那么继承了接口b后的接口a也应该遵循上述原则：不应该包含用户不使用的方法。 反之，则说明接口a被b给污染了，应该重新设计它们的关系。

6. 依赖倒置原则（Dependency Inversion Principle ，DIP）：高层模块不应该依赖于低层模块，二者都应该依赖于抽象，抽象不应该依赖于细节，细节应该依赖于抽象，针对接口编程，不要针对实现编程。
7. 组合/聚合复用原则（Composite/Aggregate Reuse Principle ，CARP）：尽量使用组合/聚合，不要使用类继承，即在一个新的对象里面使用一些已有的对象，使之成为新对象的一部分，新对象通过向这些对象的委派达到复用已有功能的目的。就是说要尽量的使用合成和聚合，而不是继承关系达到复用的目的。

### 设计模式

[23 种设计模式详解（全23种）](https://blog.csdn.net/A1342772/article/details/91349142?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167480635816782427495068%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167480635816782427495068&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-91349142-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F&spm=1018.2226.3001.4187) 

1. 创建型模式，共五种：工厂方法模式、抽象工厂模式、单例模式、建造者模式、原型模式。
2. 结构型模式，共七种：适配器模式、装饰器模式、代理模式、外观模式、桥接模式、组合模式、享元模式。
3. 行为型模式，共十一种：策略模式、模板方法模式、观察者模式、迭代子模式、责任链模式、命令模式、备忘录模式、状态模式、访问者模式、中介者模式、解释器模式。

### 场景

[重新理解“场景”：见天地、见众生、见自己](https://blog.csdn.net/iamsujie/article/details/92871872?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167480775116800182147650%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167480775116800182147650&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-92871872-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%9C%BA%E6%99%AF&spm=1018.2226.3001.4187) 

场景 = 物理环境 + 社会环境 + 内心环境

1. **物理环境**：你在开车时用手机和办公室里用手机，对于交互的需求肯定不同。
2. **社会环境**：你在拥挤的地铁车厢里，周围都是人，这时候某产品给要你面部识别一下，就比较尴尬，而独处时就没问题。
3. **内心环境**：你刚搞定一个大项目，和刚被老板骂了，这两种情况下，想听的歌肯定不同。

## 反射

[Java基础之—反射（非常重要）](https://blog.csdn.net/sinat_38259539/article/details/71799078?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167480796316800225564626%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167480796316800225564626&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-71799078-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=%E5%8F%8D%E5%B0%84&spm=1018.2226.3001.4187) 

[Java 反射真的很慢吗？](https://juejin.cn/post/6844904098207105038) 

[Java安全基础之Java的反射机制](https://www.51cto.com/article/721057.html) 

JAVA反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性；这种动态获取的信息以及动态调用对象的方法的功能称为java语言的反射机制。

作用：获取方法、变量、构造方法、注解等

性能：

1. 反射调用过程中会产生大量的临时对象，这些对象会占用内存，可能会导致频繁 gc，从而影响性能。
2. 反射调用方法时会从方法数组中遍历查找，并且会检查可见性等操作会耗时。
3. 反射在达到一定次数时，会动态编写字节码并加载到内存中，这个字节码没有经过编译器优化，也不能享受JIT优化。
4. 反射一般会涉及自动装箱/拆箱和类型转换，都会带来一定的资源开销。

安全：

## JavaAgent

[Java探针--javaagent--使用/实例](https://blog.csdn.net/feiying0canglang/article/details/121794917?ops_request_misc=%7B%22request%5Fid%22%3A%22167171341116800192245164%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=167171341116800192245164&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~pc_rank_34-1-121794917-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=Java探针--javaagent&spm=1018.2226.3001.4187)

[Java探针(javaagent)](http://events.jianshu.io/p/cc88c8b0181b)

> 不修改目标应用达到代码增强的目的，就好像spring的aop一样，但是java agent是直接修改字节码，而不是通过创建代理类。例如skywalking就是使用java agent技术，为目标应用代码植入监控代码，监控代码进行数据统计上报的。这种方式实现了解耦，通用的功能。
>
> javaagent结合javassist功能更强大：可以创建类、方法、变量等。 这实际上提供了一种虚拟机级别的 AOP 实现方式。通过以上方法就能实现对一些框架或是技术的采集点进行字节码修改，完成这些功能：对应用进行监控，对执行指定方法或是接口时额外添加操作（打印日志、打印方法执行时间、采集方法的入参和结果等）。很多APM监控系统就是基于此实现的，例如：Arthas、SkyWalking

### debug底层实现

[IDEA 的 debug 怎么实现？出于这个好奇心，我越挖越深！](https://blog.csdn.net/u013256816/article/details/116505992) 

### JVMTI

[Java黑科技之源：JVMTI完全解读](https://blog.csdn.net/duqi_2009/article/details/94518203) 

### athas

[JVM进程诊断利器——arthas介绍](https://blog.csdn.net/u013332124/article/details/84888074?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167481322016800184146510%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167481322016800184146510&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-84888074-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=athas&spm=1018.2226.3001.4187) 

## JDK

### JDK1.8新特性

[JDK1.8 新特性（全）](https://blog.csdn.net/qq_29411737/article/details/80835658?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167481339516800182738161%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167481339516800182738161&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-80835658-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=jdk8%E6%96%B0%E7%89%B9%E6%80%A7&spm=1018.2226.3001.4187) 

- Lambda表达式
- 函数式接口
- 方法引用和构造器调用
- Stream API
- 接口中的默认方法和静态方法
- 新时间日期API

### 泛型

[Java泛型详解，史上最全图文详解](https://blog.csdn.net/ChenRui_yz/article/details/122935621?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167481347416800215068432%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167481347416800215068432&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-2-122935621-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=java%E6%B3%9B%E5%9E%8B&spm=1018.2226.3001.4187) 

[为什么说Java的泛型是“假泛型”？](https://blog.csdn.net/qq_21556263/article/details/83211891?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167481783516800186547737%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167481783516800186547737&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-83211891-null-null.142^v71^insert_chatgpt,201^v4^add_ask&utm_term=java%E5%81%87%E6%B3%9B%E5%9E%8B&spm=1018.2226.3001.4187) 

泛型的好处是在编译的时候检查类型安全，并且所有的强制转换都是自动和隐式的，提高代码的重用率

**类型擦除**——Java 的泛型仅仅在编译期有效，在运行期则会被擦除，也就是说所有的泛型参数类型在编译后都会被清除掉，可以通过反射验证

### 序列化

[序列化和反序列化](https://blog.csdn.net/weixin_45858542/article/details/121871998) 

[面试官：三年工作经验，你连序列化都说不明白？](https://z.itpub.net/article/detail/0C1A0D0554C079E0D882253855CBB0B9) 

序列化 (Serialization)是将对象的状态信息转换为可以存储或传输的形式的过程。在序列化期间，对象将其当前状态写入到临时或持久性存储区。以后，可以通过从存储区中读取或[反序列化](https://so.csdn.net/so/search?q=反序列化&spm=1001.2101.3001.7020)对象的状态，重新创建该对象。

`Serializable`接口只是一个做标记用的，只要是实现了`Serializable`接口的类都是可以被序列化的，然而真正的序列化动作不需要靠它完成。

serialVersionUID是序列化前后的唯一标识符，static、transient修实的字段不会被序列化，如果两个类是完全不同的，但是他们的序列化版本号都是1L，那么对于JVM来说他们也是可以进行反序列化重构的

### IO模型

[浅聊Linux的五种IO模型](https://segmentfault.com/a/1190000039898780) 

[IO 多路复用](https://mp.weixin.qq.com/s?__biz=MzAwNDA2OTM1Ng==&mid=2453152561&idx=2&sn=5c3ebf4c86200f6e0e5bcd970e1a4948&scene=21#wechat_redirect) 

1. 阻塞式 IO （Blocking IO）：应用进程从发起 IO 系统调用，至内核返回成功标识，这整个期间是处于阻塞状态的。
2. 非阻塞式IO（Non-Blocking IO）：应用进程可以将 Socket 设置为非阻塞，这样应用进程在发起 IO 系统调用后，会立刻返回。应用进程可以轮询的发起 IO 系统调用，直到内核返回成功标识。
3. IO 多路复用（IO Multiplexin）：可以将多个应用进程的 Socket 注册到一个 Select（多路复用器）上，然后使用一个进程来监听该 Select（该操作会阻塞），Select 会监听所有注册进来的 Socket。只要有一个 Socket 的数据准备好，就会返回该Socket。再由应用进程发起 IO 系统调用，来完成数据读取。
4. 信号驱动 IO（Signal Driven IO）：可以为 Socket 开启信号驱动 IO 功能，应用进程需向内核注册一个信号处理程序，该操作并立即返回。当内核中有数据准备好，会发送一个信号给应用进程，应用进程便可以在信号处理程序中发起 IO 系统调用，来完成数据读取了。
5. 异步 IO（Asynchronous IO）： 应用进程发起 IO 系统调用后，会立即返回。当内核中数据完全准备后，并且也复制到了用户空间，会产生一个信号来通知应用进程。

前四种模型的第二阶段是相同的，都是处于阻塞状态，其主要区别在第一阶段。而异步 IO 模型则不同，应用进程在这两个阶段是完全不阻塞的。

### 异常管理

[Java 异常处理的 20 个最佳实践，你知道几个？](https://aijishu.com/a/1060000000020699)

1. 编译异常（检查性异常）：必须在在方法的 throws 子句中声明的异常。它们扩展了异常，旨在成为一种“在你面前”的异常类型。JAVA希望你能够处理它们，因为它们以某种方式依赖于程序之外的外部因素。检查的异常表示在正常系统操作期间可能发生的预期问题。 当你尝试通过网络或文件系统使用外部系统时，通常会发生这些异常。 大多数情况下，对检查性异常的正确响应应该是稍后重试，或者提示用户修改其输入
2. 运行异常（非检查性异常）：不需要在throws子句中声明的异常。 由于程序错误，JVM并不会强制你处理它们，因为它们大多数是在运行时生成的。 它们扩展了 RuntimeException。 最常见的例子是 NullPointerException， 未经检查的异常可能不应该重试，正确的操作通常应该是什么都不做，并让它从你的方法和执行堆栈中出来。
3. ERROR：严重的运行时环境问题，肯定无法恢复。 例如 OutOfMemoryError，LinkageError 和 StackOverflowError，通常会让程序崩溃。

### 关键字

[java关键字(详解）](https://developer.aliyun.com/article/233946) 

1. final：final 关键字可以应用于类，以指示不能扩展该类（不能有子类）。final 关键字可以应用于方法，以指示在子类中不能重写此方法。一个类不能同时是 abstract 又是 final。abstract 意味着必须扩展类，final 意味着不能扩展类。一个方法不能同时是 abstract 又是 final。abstract 意味着必须重写方法，final 意味着不能重写方法。
2. static：关键字可以应用于内部类（在另一个类中定义的类）、方法或字段（类的成员变量）。通常，static 关键字意味着应用它的实体在声明该实体的类的任何特定实例外部可用。static（内部）类可以被其他类实例化和引用（即使它是顶级类）。在上面的示例中，另一个类中的代码可以实例化 MyStaticClass 类，方法是用包含它的类名来限定其名称，如 MyClass.MyStaticClass。static 字段（类的成员变量）在类的所有实例中只存在一次。可以从类的外部调用 static 方法，而不用首先实例化该类。这样的引用始终包括类名作为方法调用的限定符。模式：public final static varName = ; 通常用于声明可以在类的外部使用的类常量。在引用这样的类常量时需要用类名加以限定。在上面的示例中，另一个类可以用 MyClass.MAX_OBJECTS 形式来引用 MAX_OBJECTS 常量。
3. transient： 应用于类的成员变量，以便指出该成员变量不应在包含它的类实例已序列化时被序列化。当一个对象被串行化的时候，transient型变量的值不包括在串行化的表示中，然而非transient型的变量是被包括进去的。Java的serialization提供了一种持久化对象实例的机制。当持久化对象时，可能有一个特殊的对象数据成员，我们不想用serialization机制来保存它。为了在一个特定对象的一个域上关闭serialization，可以在这个域前加上关键字transient。transient是Java语言的关键字，用来表示一个域不是该对象串行化的一部分。当一个对象被串行化的时候，transient型变量的值不包括在串行化的表示中，然而非transient型的变量是被包括进去的。

## JVM

### 内存结构

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/v2-abefb713de46f1e6dd241246c0afe263_720w.webp)

[一文搞懂JVM内存结构](https://blog.csdn.net/rongtaoup/article/details/89142396) 

[JVM内存结构和Java内存模型](https://zhuanlan.zhihu.com/p/38348646) 

[JVM 内存结构](https://doocs.github.io/jvm/01-jvm-memory-structure.html) 

[面试官 | JVM 为什么使用元空间替换了永久代？](https://zhuanlan.zhihu.com/p/111809384) 

1. 堆（Heap）：线程共享。所有的对象实例以及数组都要在堆上分配。回收器主要管理的对象。

   堆的作用是存放对象实例和数组。从结构上来分，可以分为新生代和老年代。而新生代又可以分为Eden 空间、From Survivor 空间（s0）、To Survivor 空间（s1）。 所有新生成的对象首先都是放在新生代的。需要注意，Survivor的两个区是对称的，没先后关系，所以同一个区中可能同时存在从Eden复制过来的对象，和从前一个Survivor复制过来的对象，而复制到老年代的只有从第一个Survivor区过来的对象。而且，Survivor区总有一个是空的。

2. 方法区（Method Area）：线程共享。存储类信息、常量、静态变量、即时编译器编译后的代码。JDK 1.8 同 JDK 1.7 比，最大的差别就是：元数据区取代了永久代。元空间的本质和永久代类似，都是对 JVM 规范中方法区的实现。不过元空间与永久代之间最大的区别在于：元数据空间并不在虚拟机中，而是使用本地内存。

3. 虚拟机栈（VM Stack）：线程私有。存储局部变量表、操作栈、动态链接、方法出口，对象指针。

4. 本地方法栈（Native Method Stack）：线程私有。为虚拟机使用到的Native 方法服务。如Java使用c或者c++编写的接口服务时，代码在此区运行

5. 程序计数器（Program Counter Register）：线程私有，可以看作是当前线程所执行的字节码的行号指示器。指向下一条要执行的指令

**局部变量表**：栈帧中，由一个**局部变量表存储数据**。局部变量表中存储了**基本数据类型**（boolean、byte、char、short、int、float、long、double）的**局部变量（包括参数）、和对象的引用（String、数组、对象等），但是不存储对象的内容**。局部变量表所需的内存空间在**编译期间完成分配**，在方法运行期间不会改变局部变量表的大小。局部变量的容量以**变量槽（Variable Slot）**为最小单位，每个变量槽最大存储32位的数据类型。对于64位的数据类型（long、double），JVM 会为其分配两个连续的变量槽来存储。以下简称 Slot 。为了尽可能的节省栈帧空间，局部变量表中的 **Slot 是可以复用**的。方法中定义的局部变量，其作用域不一定会覆盖整个方法。当方法运行时，如果已经**超出了某个变量的作用域**，即变量失效了，那这个变量对应的 Slot 就可以交给其他变量使用，也就是所谓的 **Slot 复用**。通过一个例子来理解变量“失效”。

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/2019041019553012.png)

![img](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/20190410210752310.png)

**堆：**堆是Java虚拟机所管理的内存中最大的一块存储区域。堆内存被所有**线程共享**。主要存放使用**new**关键字创建的对象。所有**对象实例以及数组**都要在堆上分配。垃圾收集器就是根据GC算法，收集堆上**对象所占用的内存空间（收集的是对象占用的空间而不是对象本身）**。

Java堆分为**年轻代**（Young Generation）和**老年代**（Old Generation）；**年轻代又分为伊甸园（Eden）和幸存区（Survivor区）；幸存区又分为From Survivor空间和 To Survivor空间。**

老年代存储**长期存活的对象和大对象**。年轻代中存储的对象，经过多次GC后仍然存活的对象会移动到老年代中进行存储。老年代空间占满后，会触发**Full GC**。

***\*注：\**Full GC**是清理整个堆空间，包括年轻代和老年代。如果Full GC之后，堆中仍然无法存储对象，就会抛出**OutOfMemoryError**异常。



元数据去：

字符串存在永久代中，容易出现性能问题和内存溢出。

类及方法的信息等比较难确定其大小，因此对于永久代的大小指定比较困难，太小容易出现永久代溢出，太大则容易导致老年代溢出。

永久代会为 GC 带来不必要的复杂度，并且回收效率偏低。

Oracle 可能会将HotSpot 与 JRockit 合二为一。

- 为了解决永久代的OOM问题，元数据和class对象存放在永久代中，容易出现性能问题和内存溢出。
- 类及方法的信息等比较难确定其大小，因此对于永久代大小指定比较困难，大小容易出现永久代溢出，太大容易导致老年代溢出（堆内存不变，此消彼长）。
- 永久代会为GC带来不必要的复杂度，并且回收效率偏低。



### 内存模型

[深入理解JVM-内存模型（jmm）和GC](https://www.jianshu.com/p/76959115d486) 

### GC

[详解Java的垃圾回收机制（GC）](https://segmentfault.com/a/1190000038256027) 

[Java性能优化之JVM GC（垃圾回收机制）](https://zhuanlan.zhihu.com/p/25539690) 

### 类加载机制

[jvm类加载器，类加载机制详解，看这一篇就够了](https://segmentfault.com/a/1190000037574626) 

[你确定你真的理解"双亲委派"了吗？！](https://www.cnblogs.com/hollischuang/p/14260801.html) 

### JIT





## 常见问题排查







## 其他

### String、StringBuffer和StringBuilder的区别

[深入理解String、StringBuffer和StringBuilder](https://blog.csdn.net/Mr_wxc/article/details/107296135?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166812990116800192298540%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166812990116800192298540&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-107296135-null-null.142^v63^js_top,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=stringbuffer%E5%92%8Cstringbuilder&spm=1018.2226.3001.4187)

[彻底弄懂StringBuffer与StringBuilder的区别](https://blog.csdn.net/lzxlfly/article/details/90581670?ops_request_misc=&request_id=&biz_id=102&utm_term=stringbuffer%E5%92%8Cstringbuilder&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-90581670.142^v63^js_top,201^v3^control_2,213^v2^t3_esquery_v1&spm=1018.2226.3001.4187)

string final修饰的，不可变，底层为char数组，储存在字符串常量池中。StringBuffer、StringBuilder和String类似，底层也是用一个数组来存储字符串的值，并且数组的默认长度为16

### 内部类

[详解 Java 内部类](https://blog.csdn.net/Hacker_ZhiDian/article/details/82193100?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166973542116800213055341%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166973542116800213055341&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-82193100-null-null.142^v67^pc_rank_34_queryrelevant25,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=%E5%86%85%E9%83%A8%E7%B1%BB&spm=1018.2226.3001.4187) 

普通内部类：依赖外部类，创建时需要先创建外部类，new OutClass().new InClass()，普通内部类中不能定义static属性，可以访问外部类所有属性，外部类通过内部类对象访问内部类所有属性
静态内部类：独立于外部类，创建时不需要创建外部类，new OutClass.InClass()，静态内部类无法访问外部类的非静态成员，外部类可以访问静态内部类所有属性
匿名内部类：new 接口或者抽象类 并重写方法
局部内部类：局部声明一个类去使用，只在局部方法体中使用
[幕后英雄的用武之地——浅谈Java内部类的四个应用场景](https://blog.csdn.net/hivon/article/details/606312?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166973803816800180664854%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166973803816800180664854&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-606312-null-null.142^v67^pc_rank_34_queryrelevant25,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=%E5%86%85%E9%83%A8%E7%B1%BB%E4%BD%BF%E7%94%A8%E5%9C%BA%E6%99%AF&spm=1018.2226.3001.4187) 

1.普通内部类：如果一个类依赖某一个外部类或者只有这个外部类使用

2.匿名内部类：解决一些非面向对象的语句块，提炼出模板，通过匿名内部类实现逻辑代码（模板方法）

3.匿名内部类：一些多算法场合，具体的算法实现由用户自己完成，只要求他实现相关接口（模板方法）

4.将工厂进一步抽象，而将具体的工厂类交由具体类的创建者来实现，不过实现主要逻辑的是抽象工厂的实现类，其中抽象类的方法调用了其子类实现，如果将这个子类换个类传入就类似于上场景2和场景3，这个方法的特点在于将具体类的实现和它的具体工厂类绑定起来，由具体类的实现者在这个内部类的具体工厂里去产生一个具体类的对象，这当然容易得多。虽然需要每一个具体类都创建一个具体工厂类，但由于具体工厂类是一个内部类，这样也不会随着具体类的增加而不断增加新的工厂类，使得代码看起来很臃肿，这也是本方法不得不使用内部类的一个原因吧。

### HashMap 在 jdk 1.7 和 1.8 的区别

1.7数组+链表，1.8数组+链表+红黑树，1.8的扩容策略数组容量未达到64时，以2倍进行扩容，超过64之后若桶中元素个数不小于7就将链表转换为红黑树，但如果红黑树中的元素个数小于6就会还原为链表，当红黑树中元素不小于32的时候才会再次扩容。

### 线程有哪几种状态？

[线程的几种状态](https://blog.csdn.net/weixin_46186282/article/details/125926966?ops_request_misc=&request_id=&biz_id=102&utm_term=%E7%BA%BF%E7%A8%8B%E6%9C%89%E5%93%AA%E5%87%A0%E7%A7%8D%E7%8A%B6%E6%80%81%EF%BC%9F&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-1-125926966.nonecase&spm=1018.2226.3001.4187) 

新建、就绪、运行、阻塞、等待/超时等待、终止

### 线程池

[两道面试题，深入线程池，连环17问](https://mp.weixin.qq.com/s?__biz=MzAwNDA2OTM1Ng==&mid=2453152340&idx=2&sn=ab8af46dbbb7e40b8a174ff6547bac23&scene=21#wechat_redirect)

[线程池和队列](https://blog.csdn.net/u011208600/article/details/105199451/) 

[LinkedBlockingQueue和ArrayBlockingQueue](https://blog.csdn.net/qq_38262266/article/details/108813401?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167169845716800211539972%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167169845716800211539972&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-1-108813401-null-null.142^v68^pc_new_rank,201^v4^add_ask,213^v2^t3_esquery_v1&utm_term=LinkedBlockingQueue%E5%92%8C&spm=1018.2226.3001.4187) 

线程池类似于生产者-消费者模式，内部通过队列储存任务，内部线程从队列获取任务消费。

**线程池的5种状态：**

- RUNNING：能接受新任务，并处理阻塞队列中的任务
- SHUTDOWN：不接受新任务，但是可以处理阻塞队列中的任务
- STOP：不接受新任务，并且不处理阻塞队列中的任务，并且还打断正在运行任务的线程，就是直接撂担子不干了！
- TIDYING：所有任务都终止，并且工作线程也为0，处于关闭之前的状态
- TERMINATED：已关闭。

**ThreadPoolExecutor 构造参数：**

- 核心线程数：数量不足即便线程空闲也会创建，CPU 密集型核心线程数设置为 CPU核数+1，I/O 密集型核心线程数设置为 2*CPU核数
- 最大线程数：
- 超过核心线程空闲时间：0就是不销毁
- 时间单位
- 工作队列：如果线程数已经达到核心线程数，那么新增加的任务只会往任务队列里面塞，不会直接给予某个线程，如果任务队列也满了，新增最大线程数的线程时，任务是可以直接给予新建的线程执行的，而不是入队。**直接提交队列：**使用SynchronousQueue队列，提交的任务不会被保存，总是会马上提交执行,多了就执行拒绝策略；**有界任务队列**：有界的任务队列可以使用ArrayBlockingQueue实现；**无界任务队列：**有界任务队列可以使用LinkedBlockingQueue；**优先任务队列：**优先任务队列通过PriorityBlockingQueue实现，PriorityBlockingQueue队列可以自定义规则根据任务的优先级顺序先后执行
- 拒绝策略：AbortPolicy策略：该策略会直接抛出异常，阻止系统正常工作；CallerRunsPolicy策略：如果线程池的线程数量达到上限，该策略会把任务队列中的任务放在调用者线程当中运行；DiscardOledestPolicy策略：该策略会丢弃任务队列中最老的一个任务，也就是当前任务队列中最先被添加进去的，马上要被执行的那个任务，并尝试再次提交；DiscardPolicy策略：该策略会默默丢弃无法处理的任务，不予任何处理。当然使用此策略，业务场景中需允许任务的丢失；
  以上内置的策略均实现了RejectedExecutionHandler接口，当然你也可以自己扩展RejectedExecutionHandler接口，定义自己的拒绝策略，我们看下示例代码：
- 大家可以看到除了第一个任务直接创建线程执行外，其他的任务都被放入了优先任务队列，按优先级进行了重新排列执行，且线程池的线程数一直为corePoolSize，也就是只有一个。
  通过运行的代码我们可以看出PriorityBlockingQueue它其实是一个特殊的无界队列，它其中无论添加了多少个任务，线程池创建的线程数也不会超过corePoolSize的数量，只不过其他队列一般是按照先进先出的规则处理任务，而PriorityBlockingQueue队列可以自定义规则根据任务的优先级顺序先后执行

### Reactor模式

[设计模式 - Reactor 模式](https://blog.csdn.net/saienenen/article/details/111400911) 

Reactor模式也叫反应器模式，采用基于事件驱动的设计，当有事件触发时，才会调用处理器进行数据处理。使用Reactor模式，对线程的数量进行控制，一个线程处理大量的事件。