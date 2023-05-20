# 安装npm

[npm下载和使用（超详细）](https://blog.csdn.net/chen_junfeng/article/details/110422090?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167308964016800192262902%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167308964016800192262902&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-110422090-null-null.142^v70^one_line,201^v4^add_ask&utm_term=npm&spm=1018.2226.3001.4187) 

# Docsify

[Docsify个人网站搭建详细教程](https://blog.csdn.net/m0_67393039/article/details/123251706?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167309095316800225585874%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=167309095316800225585874&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-123251706-null-null.142^v70^one_line,201^v4^add_ask&utm_term=Docsify&spm=1018.2226.3001.4187) 

[工具--docsify详解](https://blog.csdn.net/liyou123456789/article/details/124504727) 

https://docsify.js.org/#/zh-cn/quickstart 

```bash
# 全局安装
npm i docsify-cli -g
 
# 初始化项目
docsify init ./docs
 
# 本地运行
docsify serve docs
```

# 配置

> 以下是我的配置

[docsify的配置+全插件列表](https://xhhdd.cc/archives/80/comment-page-1) 

[docsify 构建文档网站之定制功能（全网最全）](https://blog.csdn.net/wugenqiang/article/details/107071378?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522167340159516800180683106%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=167340159516800180683106&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-2-107071378-null-null.blog_rank_default&utm_term=docsify&spm=1018.2226.3001.4450) 

index.html

```html
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>📚淳辉的笔记</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta name="description" content="Description">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
		<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/lib/themes/vue.css">

		<!-- 浏览器图标 -->
		<link rel="icon" href="/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
		<!-- 目录折叠 -->
		<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify-sidebar-collapse/dist/sidebar-folder.min.css" />
		<!-- 目录折叠<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify-sidebar-collapse/dist/sidebar.min.css" /> -->

	</head>
	<body>
		<div id="app"></div>
		<script>
			window.$docsify = {
				// 项目名称
				name: '📚淳辉的笔记',
				// 仓库地址，点击右上角的Github章鱼猫头像会跳转到此地址
				repo: '',
				// 侧边栏支持，默认加载的是项目根目录下的\_sidebar.md文件
				loadSidebar: true,
				// 自定义侧边栏后默认不会再生成目录，设置生成目录的最大层级（建议配置为2-4）
				subMaxLevel: 4,
				// 导航栏支持，默认加载的是项目根目录下的\_navbar.md文件
				loadNavbar: true,
				// 封面支持，默认加载的是项目根目录下的\_coverpage.md文件
				coverpage: true,
				// 只显示封面，不然封面可以下拉
				onlyCover: true,
				// 最大支持渲染的标题层级
				maxLevel: 5,
				// 小屏设备下合并导航栏到侧边栏
				mergeNavbar: true,
				// 翻页
				pagination: {
					previousText: '上一章节',
					nextText: '下一章节',
					crossChapter: true
				},
				search: {
					// 过期时间，单位毫秒，默认一天
					maxAge: 86400000,
					// 搜索提示框文字， 支持本地化，例子在下面
					placeholder: '搜索',
					noData: '找不到结果!',
					// 搜索标题的最大程级, 1 - 6
					depth: 4,
					// 是否隐藏其他侧边栏内容
					hideOtherSidebarContent: true,
				},
				// 页脚
				footer: {
					copy: '<span id="sitetime" style="font-size:14px"></span><br/><span style="font-size:14px">  Copyright <a href="https://t.1yb.co/sBOZ" target="_blank" style="font-size:14px"> 🏷️ <strong>淳辉</strong> </a>  &nbsp;  &copy; 2023.01.08 - 至今 &nbsp; <a href="https://beian.miit.gov.cn/" target="_blank" style="font-size:14px"> <strong>苏ICP备2022034064号-1</strong></a></span>',
					auth: '<br/><span style="font-size:14px"> 种一颗树最好的时间是十年前，其次是现在🌲️</span>',
					pre: '<hr/>',
					style: 'text-align: left;',
				}
			}
		</script>
		
		<!-- Docsify v4 -->
		<!-- <script src="//cdn.jsdelivr.net/npm/docsify@4"></script> -->
		<script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
		
		<!-- 目录折叠 -->
		<script src="//cdn.jsdelivr.net/npm/docsify-sidebar-collapse/dist/docsify-sidebar-collapse.min.js"></script>
		
		<!-- 翻页 -->
		<script src="//cdn.jsdelivr.net/npm/docsify-pagination/dist/docsify-pagination.min.js"></script>
		
		<!-- emoji -->
		<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/emoji.min.js"></script>

		<!-- 引入搜索模块 -->
		<script src="https://cdn.bootcdn.net/ajax/libs/docsify/4.11.2/plugins/search.min.js"></script>

		<!-- 图片缩小方法-->
		<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>

		<!--添加不蒜子访问统计-->
		<script async
			src="https://cdn.jsdelivr.net/gh/forthespada/forthespada.github.io@master/plugin/js/busuanzi.pure.mini.js">
		</script>

		<!-- 字数统计功能 -->
		<script src="//unpkg.com/docsify-count/dist/countable.js"></script>

		<!-- mouse click -->
		<script src="https://cdn.jsdelivr.net/gh/forthespada/forthespada.github.io@master/plugin/click_heart.js">
		</script>

		<!-- 添加页脚 -->
		<script src="https://cdn.jsdelivr.net/gh/wugenqiang/NoteBook@master/plugin/docsify-footer-enh.min.js"></script>

		<!-- 添加一键拷贝代码-->
		<script src="//unpkg.com/docsify-copy-code"></script>
		</script>

		<!-- 添加代码高亮 -->
		<script src="//unpkg.com/prismjs/components/prism-bash.js"></script>  
		<script src="//unpkg.com/prismjs/components/prism-java.js"></script>  
		<script src="//unpkg.com/prismjs/components/prism-sql.js"></script>
		<script src="//unpkg.com/prismjs/components/prism-java.js"></script>
		<script src="//unpkg.com/prismjs/components/prism-sql.js"></script>

		<!-- 回到顶部功能 -->
		<script src="https://cdn.jsdelivr.net/gh/forthespada/forthespada.github.io@master/plugin/jquery.js"></script>
		<script src="https://cdn.jsdelivr.net/gh/forthespada/forthespada.github.io@master/plugin/jquery.goup.js">
		</script>
		<script type="text/javascript">
			$(document).ready(function() {
				$.goup({
					trigger: 700,
					bottomOffset: 20,
					locationOffset: 8,
					title: '',
					titleAsText: true
				});
			});
		</script>

		<!-- 添加网站运行时间统计 -->
		<script language=javascript>
			function siteTime() {
				window.setTimeout("siteTime()", 1000);
				var seconds = 1000;
				var minutes = seconds * 60;
				var hours = minutes * 60;
				var days = hours * 24;
				var years = days * 365;
				var today = new Date();
				var todayYear = today.getFullYear();
				var todayMonth = today.getMonth() + 1;
				var todayDate = today.getDate();
				var todayHour = today.getHours();
				var todayMinute = today.getMinutes();
				var todaySecond = today.getSeconds();
				/* Date.UTC() -- 返回date对象距世界标准时间(UTC)1970年1月1日午夜之间的毫秒数(时间戳)
				year - 作为date对象的年份，为4位年份值
				month - 0-11之间的整数，做为date对象的月份
				day - 1-31之间的整数，做为date对象的天数
				hours - 0(午夜24点)-23之间的整数，做为date对象的小时数
			 minutes - 0-59之间的整数，做为date对象的分钟数
				seconds - 0-59之间的整数，做为date对象的秒数
				microseconds - 0-999之间的整数，做为date对象的毫秒数 */
				var t1 = Date.UTC(2023, 01, 08, 00, 00, 00); //北京时间2021-06-11
				var t2 = Date.UTC(todayYear, todayMonth, todayDate, todayHour, todayMinute, todaySecond);
				var diff = t2 - t1;
				var diffYears = Math.floor(diff / years);
				var diffDays = Math.floor((diff / days) - diffYears * 365);
				var diffHours = Math.floor((diff - (diffYears * 365 + diffDays) * days) / hours);
				var diffMinutes = Math.floor((diff - (diffYears * 365 + diffDays) * days - diffHours * hours) / minutes);
				var diffSeconds = Math.floor((diff - (diffYears * 365 + diffDays) * days - diffHours * hours - diffMinutes *
					minutes) / seconds);
				if (document.getElementById("sitetime")) {
					document.getElementById("sitetime").innerHTML = " 淳辉的笔记已运行 " + diffYears + " 年 " + diffDays + " 天 " +
						diffHours + " 小时 " + diffMinutes + " 分 " + diffSeconds + " 秒 ";
				}
			}
			siteTime();
		</script>


		<!--百度统计-->
		<!-- 		<script>
		var _hmt = _hmt || [];
		(function() {
		  var hm = document.createElement("script");
		  hm.src = "https://hm.baidu.com/hm.js?b434d13346692660cab629bae098bc59";
		  var s = document.getElementsByTagName("script")[0]; 
		  s.parentNode.insertBefore(hm, s);
		})();
		</script> -->

	</body>
</html>

```

# 生成侧边栏工具

> 我自己用Java写的，改改就行
>
> 文件要排序的话以 数字＋_  开头，比如:1_文件.txt
>
> 文件夹不排序，可以自己改一下

我的目录结构

![image-20230113001015214](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230113001015214.png)

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version>
</dependency>
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.8.11</version>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
	<version>1.2.80</version>
</dependency>
```

```java
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.exceptions.ExceptionUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.ReUtil;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @author Geng Hui
 * @date 2023/1/9 11:34
 */
public class util {

    // 忽略 某些具体的文件夹
    public static String rootDir;

    // 忽略 某些具体的文件
    public static List<String> ignoreFile;

    // 正则 忽略的文件
    public static List<String> ignoreMatchFile;

    // 忽略 某些具体的文件夹
    public static List<String> ignoreDir;

    // 正则 忽略的文件夹
    public static List<String> ignoreMatchDir;

    public static StringBuilder home = new StringBuilder();

    public static File logFile = new File("docsify-sidebar-build-log.txt");

    public static void writeLog(String content) {
        try {
            FileWriter writer = new FileWriter(logFile, Boolean.TRUE);
            writer.write("\n" + DateUtil.date() + " " + content);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static {
        try {
            // 创建日志文件
            logFile.createNewFile();

            // 读取配置文件
            File configFile = new File("sidebar-build-config.txt");
            if (configFile.exists()) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(configFile), StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                reader.close();
                JSONObject jsonObject = JSONObject.parseObject(sb.toString());
                writeLog("读取的配置文件为" + JSONObject.toJSONString(jsonObject));
                rootDir = jsonObject.getString("rootDir");
                ignoreFile = jsonObject.getObject("ignoreFile", new TypeReference<List<String>>() {
                });
                ignoreMatchFile = jsonObject.getObject("ignoreMatchFile", new TypeReference<List<String>>() {
                });
                ignoreDir = jsonObject.getObject("ignoreDir", new TypeReference<List<String>>() {
                });
                ignoreMatchDir = jsonObject.getObject("ignoreMatchDir", new TypeReference<List<String>>() {
                });
            } else {
                writeLog("配置文件不存在");
                System.exit(0);
            }
        } catch (Exception e) {
            writeLog(ExceptionUtil.stacktraceToString(e));
        }
    }

    public static void main(String[] args) {
        try {
            File rootDir = new File(util.rootDir);
            if (!rootDir.exists()) {
                writeLog(rootDir.getName() + " is not exist");
                return;
            }
            if (!rootDir.isDirectory()) {
                writeLog(rootDir.getName() + " is not directory");
                return;
            }

            FileNode node = new FileNode(rootDir.getName(), rootDir.getPath(), Boolean.TRUE, "");
            getFiletree(node);


            // 每个文件夹都生成一个侧栏边（没有必要）
//        writeFile(node);

            // 生成根目录下的侧边栏 忽略第一层目录（即根目录）
            generateHome(node);

            writeLog("生成成功");
        } catch (Exception e) {
            writeLog(ExceptionUtil.stacktraceToString(e));
        }
    }

    public static void generateHome(FileNode node) throws Exception {
        writeHomeFile(node, 0);
        File sidebar = new File(rootDir + "\\_sidebar.md");
        Writer writer = new OutputStreamWriter(new FileOutputStream(sidebar), StandardCharsets.UTF_8);
        writer.write(home.toString());
        writer.flush();
        writer.close();
    }

    public static void writeHomeFile(FileNode fileNode, int tab) {
        for (FileNode node : fileNode.getFileNodes()) {
            if (node.getDir()) {
                if (tab != 0) {
                    home.append(getSpace(tab) + "- [" + node.getName() + "](" + node.getPath().replace(rootDir, "").replaceAll("\\\\", "/") + "/)\n");
                }
                writeHomeFile(node, tab + 1);
            } else {
                if (tab != 0) {
                    home.append(getSpace(tab) + "- [" + node.getName().substring(0, node.getName().lastIndexOf(".")) + "](" + node.getPath().replace(rootDir, "").replaceAll("\\\\", "/") + ")\n");
                }
            }
        }
    }

    public static String getSpace(int i) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int j = 0; j < NumberUtil.mul(i, 2); j++) {
            stringBuilder.append(" ");
        }
        return stringBuilder.toString();
    }

    public static void writeFile(FileNode fileNode) throws Exception {
        File sidebar = new File(fileNode.getPath() + "\\_sidebar.md");
        if (!sidebar.exists()) {
            sidebar.createNewFile();
        }

        StringBuilder sb = new StringBuilder();
        if ("".equals(fileNode.getFatherDirPath())) {
            sb.append("- [首页](/README)\n");
        } else {
            String s = fileNode.getFatherDirPath().replace(rootDir, "").replaceAll("\\\\", "/");
            sb.append("- [回到上一层](" + s + "/README)\n");
        }

        for (FileNode node : fileNode.getFileNodes()) {
            if (node.getDir()) {
                sb.append("- [" + node.getName() + "](" + node.getPath().replace(rootDir, "").replaceAll("\\\\", "/") + "/)\n");
                writeFile(node);
            } else {
                sb.append("- [" + node.getName().substring(0, node.getName().lastIndexOf(".")) + "](" + node.getPath().replace(rootDir, "").replaceAll("\\\\", "/") + ")\n");
            }
        }

        FileWriter fileWriter = new FileWriter(sidebar);
        fileWriter.write(sb.toString());
        fileWriter.flush();
        fileWriter.close();
    }

    public static void getFiletree(FileNode fileNode) {
        // 忽略隐藏文件夹
        if (fileNode.getName().startsWith(".")) {
            return;
        }
        File file = new File(fileNode.getPath());

        // 遍历文件夹
        boolean isSort = true;
        List<FileNode> fileList = new ArrayList<>();
        for (File item : Objects.requireNonNull(file.listFiles())) {
            // 如果是文件夹并且没有被忽略就略过
            String itemName = item.getName();
            if ((item.isDirectory() && isIgnoreDir(itemName)) || (item.isFile() && isIgnoreFile(itemName)) || item.isHidden()) {
                continue;
            }
            if (null == ReUtil.getFirstNumber(itemName.substring(0, item.isDirectory() ? itemName.length()-1 : itemName.lastIndexOf(".")))) {
                isSort = false;
            }
            FileNode node = new FileNode(itemName, item.getPath(), item.isDirectory(), file.getPath());
            fileList.add(node);
            if (item.isDirectory()) {
                getFiletree(node);
            }
        }

        // 排序
        if (!fileList.isEmpty()) {
            if (isSort) {
                fileList = fileList.stream()
                        .sorted(Comparator.comparing(v -> Integer.parseInt(ReUtil.get("^\\d+", v.getName(), 0))))
                        .collect(Collectors.toList());

                fileList.forEach(v -> v.setName(ReUtil.delFirst("^\\d+_", v.getName())));
            } else {
                fileList = fileList.stream()
                        .sorted(Comparator.comparing(v -> ((FileNode) v).getDir()).reversed())
                        .collect(Collectors.toList());
            }

        }

        fileNode.setFileNodes(fileList);

    }

    public static boolean isIgnoreFile(String fileName) {
        for (String match : ignoreMatchFile) {
            if (ReUtil.isMatch(match, fileName)) {
                return Boolean.TRUE;
            }
        }

        for (String ignore : ignoreFile) {
            if (ignore.equals(fileName)) {
                return Boolean.TRUE;
            }
        }

        return Boolean.FALSE;
    }

    public static boolean isIgnoreDir(String dirName) {
        for (String match : ignoreMatchDir) {
            if (ReUtil.isMatch(match, dirName)) {
                return Boolean.TRUE;
            }
        }

        for (String ignore : ignoreDir) {
            if (ignore.equals(dirName)) {
                return Boolean.TRUE;
            }
        }

        return Boolean.FALSE;
    }

    public static class FileNode {

        private String name;
        private String path;
        private Boolean isDir;
        private String fatherDirPath;
        private List<FileNode> fileNodes;

        public FileNode() {
        }

        public FileNode(String name, String path, Boolean isDir, String fatherDirPath) {
            this.name = name;
            this.path = path;
            this.isDir = isDir;
            this.fatherDirPath = fatherDirPath;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public Boolean getDir() {
            return isDir;
        }

        public void setDir(Boolean dir) {
            isDir = dir;
        }

        public String getFatherDirPath() {
            return fatherDirPath;
        }

        public void setFatherDirPath(String fatherDirPath) {
            this.fatherDirPath = fatherDirPath;
        }

        public List<FileNode> getFileNodes() {
            return fileNodes;
        }

        public void setFileNodes(List<FileNode> fileNodes) {
            this.fileNodes = fileNodes;
        }

    }

}

```

# 配置Github pages

创建一个public仓库，将docsify相关文件全部上传仓库，修改分支命名为master，在setting中找到Pages配置下图

这是我的仓库地址：https://github.com/Tingnichui/note

![image-20230520024143392](https://chunhui-a.oss-cn-nanjing.aliyuncs.com/typora/img/image-20230520024143392.png)



文章

1. [Github+docsify零成本轻松打造在线文档网站](https://cloud.tencent.com/developer/news/675461)

2. [Github pages 绑定个人域名](https://segmentfault.com/a/1190000011203711)
