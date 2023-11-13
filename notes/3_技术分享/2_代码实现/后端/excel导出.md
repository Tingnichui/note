```java
package excel;

import cn.hutool.core.util.RandomUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Slf4j
public class export {

    private static final int rowsNum = 20;
    private static final List<List<String>> DATA = new ArrayList<>();

    static {
        for (int i = 0; i <= rowsNum; i++) {
            List<String> temp = new ArrayList<>();
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            temp.add(RandomUtil.randomNumbers(32));
            DATA.add(temp);
            System.err.println(i);
        }
    }


    public static void main(String[] args) throws Exception {
        File file = new File("D://tempfile//" + System.currentTimeMillis() + ".xlsx");
        if (!file.exists()) {
            file.createNewFile();
        }
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        workbook.setCompressTempFiles(true);

        try (FileOutputStream outputStream = new FileOutputStream(file)) {
            String title = "标题1,标题2,标题3,标题4,标题5,标题6,标题7,标题8,标题9,标题10,标题11,标题12,标题13,标题14,标题15,标题16,标题17,标题18,标题19";
            createSheet(workbook,"test1", title, getData(1,10));
            createSheet(workbook,"test1", title, getData(1,10));
            workbook.write(outputStream);
            System.err.println("success");
        } catch (Throwable e) {
            log.error("出现异常", e);
        } finally {
            workbook.dispose();
        }
    }

    private static List<List<String>> getData(int start, int pagesize) {
        if (start > rowsNum) return null;
        int end = start + pagesize;
        return DATA.subList(start, Math.min(end, rowsNum));
    }

    public static SXSSFWorkbook doCreateSheet(SXSSFWorkbook workbook, String sheetName, List<String> title, List<List<String>> rows) {
        // 先获取sheet 如果不存在则创建
        SXSSFSheet sheet = workbook.getSheet(sheetName);
        if (null == sheet) {
            sheet = workbook.createSheet(sheetName);
        }
        // 如果还未写入数据 创建标题
        int lastRowNum = sheet.getLastRowNum();
        if (-1 == lastRowNum) {
            SXSSFRow titleRow = sheet.createRow(0);
            for (int j = 0; j < title.size(); j++) {
                titleRow.createCell(j).setCellValue(StringUtils.isNotBlank(title.get(j)) ? title.get(j) : "");
            }
        }
        // 填充内容
        for (int i = 0; i < rows.size(); i++) {
            List<String> list = rows.get(i);
            int lastRowNum1 = sheet.getLastRowNum();
            SXSSFRow row = sheet.createRow(lastRowNum1 + 1);
            for (int j = 0; j < list.size(); j++) {
                row.createCell(j).setCellValue(StringUtils.isNotBlank(list.get(j)) ? list.get(j) : "");
            }
        }
        return workbook;
    }

    public static SXSSFWorkbook createSheet(SXSSFWorkbook workbook, String sheetName, String title, List<List<String>> rows) {
        List<String> titleList = Arrays.asList(title.split(","));
        return doCreateSheet(workbook, sheetName, titleList, rows);
    }

}

```



## workbook区别

**Apache POI包中的HSSFWorkbook、XSSFWorkbook、SXSSFWorkbook的区别如下:**

- HSSFWorkbook：一般用于操作Excel2003以前（包括2003）的版本，扩展名是.xls。
- XSSFWorkbook：一般用于操作Excel2007及以上的版本，扩展名是.xlsx。
- SXSSFWorkbook（POI 3.8+版本）：一般用于大数据量的导出。比如数据量超过5000条即可考虑这种工作表

**第一种：HSSFWorkbook**

针对EXCEL 2003版本，扩展名为.xls，此种的局限就是导出的行数最多为65535行。因为导出行数受限，不足7万行，所以一般不会发送内存溢出(OOM)的情况

**第二种：XSSFWorkbook**

这种形式的出现是由于第一种HSSF的局限性产生的，因为其导出行数较少，XSSFWorkbook应运而生，其对应的是EXCEL2007+ ，扩展名为.xlsx ，最多可以导出104万行，不过这样就伴随着一个问题–OOM内存溢出。因为使用XSSFWorkbook创建的book sheet row cell 等是存在内存中的，并没有持久化到磁盘上，那么随着数据量的增大，内存的需求量也就增大。那么很有可能出现 OOM了，那么怎么解决呢？

**第三种:SXSSFWorkbook** 　poi.jar 3.8+

SXSSFWorkbook可以根据行数将内存中的数据持久化写到文件中。

此种的情况就是设置最大内存条数，比如设置最大内存量为5000行， new SXSSFWookbook(5000)，当行数达到 5000 时，把内存持久化写到文件中，以此逐步写入，避免OOM。这样就完美解决了大数据下导出的问题

另注：HSSFWorkbook的Excel Sheet导出条数上限(<=2003版)是65535行、256列,

​     XSSFWorkbook的Excel Sheet导出条数上限(>=2007版)是1048576行,16384列,

​     如果数据量超过了此上限,那么可以使用SXSSFWorkbook来导出。实际上上万条数据， 甚至上千条数据就可以考虑使用        SXSSFWorkbook了。

## 参考文章

1. [Java POI三种Workbook：HSSFworkbook,XSSFworkbook,SXSSFworkbook主要区别](https://www.cnblogs.com/wh445306/p/16751844.html)
2. https://juejin.cn/post/6844904024500600839