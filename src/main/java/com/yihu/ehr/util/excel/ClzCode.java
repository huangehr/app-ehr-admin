package com.yihu.ehr.util.excel;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/18
 */
public class ClzCode {

    public final static String code4 = "package com.yihu.ehr.util.excel.read;\n" +
            "$import" +
            "import com.yihu.ehr.util.excel.AExcelWriter;\n" +
            "import jxl.Workbook;\n" +
            "import jxl.write.WritableSheet;\n" +
            "import jxl.write.WritableWorkbook;\n" +
            "import jxl.write.WriteException;\n" +
            "import org.apache.commons.lang.StringUtils;\n" +
            "import java.io.File;\n" +
            "import java.io.IOException;\n" +
            "import java.io.OutputStream;\n" +
            "import java.util.List;\n" +
            "public class $clzNameWriter extends AExcelWriter{\n" +
            "\n" +
            "    public void addHeader(WritableSheet ws) throws WriteException {\n" +
            "        String[] header = $header;\n" +
            "        if(header!=null){\n" +
            "            int i =0;\n" +
            "            for(String h : header){\n" +
            "                addCell(ws, i, 0, h);\n" +
            "                i++;\n" +
            "            }\n" +
            "        }\n" +
            "    }\n" +
            "    \n" +
            "    public void write(WritableWorkbook wwb, List ls) throws Exception {\n" +
            "        try {\n" +
            "            WritableSheet ws;\n" +
            "            int i = 0;\n" +
            "            for($clzName m : (List<$clzName>) ls){\n" +
            "                $util" +
            "                i++;" +
            "            }\n" +
            "            wwb.write();\n" +
            "            wwb.close();\n" +
            "        } catch (IOException e) {\n" +
            "            e.printStackTrace();\n" +
            "            if(wwb!=null) wwb.close();\n" +
            "            throw e;\n" +
            "        }\n" +
            "    }\n" +
            "}\n";

    public final static String code3 =
            "package com.yihu.ehr.util.excel.read;\n" +
                    "$import\n" +
                    "import com.yihu.ehr.util.excel.AExcelWriter;\n" +
                    "import java.io.File;\n" +
                    "import jxl.Workbook;\n" +
                    "import jxl.write.WritableSheet;\n" +
                    "import jxl.write.WritableWorkbook;\n" +
                    "import jxl.write.WriteException;\n" +
                    "import java.io.IOException;\n" +
                    "import java.io.OutputStream;\n" +
                    "import java.util.List;\n" +
                    "public class $clzNameWriter extends AExcelWriter{\n" +
                    "    public void addHeader(WritableSheet ws) throws WriteException {\n" +
                    "        String[] header = $header;\n" +
                    "        if(!\"\".equals(header)){\n" +
                    "            int i =0;\n" +
                    "            for(String h : header){\n" +
                    "                addCell(ws, 0, i, h);\n" +
                    "                i++;\n" +
                    "            }\n" +
                    "        }\n" +
                    "    }\n" +
                    "    \n" +
                    "    public void write(WritableWorkbook wwb, List ls) throws Exception {\n" +
                    "        try {\n" +
                    "            WritableSheet ws = wwb.createSheet(\"sheet1\", 0);\n" +
                    "            addHeader(ws);\n" +
                    "            int i = $start;\n" +
                    "            for($clzName m : (List<$clzName>) ls){\n" +
                    "                $util" +
                    "                i++;\n" +
                    "            }\n" +
                    "            wwb.write();\n" +
                    "            wwb.close();\n" +
                    "        } catch (IOException e) {\n" +
                    "            e.printStackTrace();\n" +
                    "            if(wwb!=null) wwb.close();\n" +
                    "            throw e;\n" +
                    "        }\n" +
                    "    }\n" +
                    "}";

    public final static String code2 = "package com.yihu.ehr.util.excel.read;\n" +
            "\n" +
            "import com.yihu.ehr.util.excel.AExcelReader;\n" +
            "$import\n" +
            "import java.util.HashSet;\n" +
            "import jxl.Sheet;\n" +
            "import jxl.Workbook;\n" +
            "\n" +
            "public class $clzName extends AExcelReader {\n" +
            "    \n" +
            "    public void read(Workbook rwb) throws Exception{\n" +
            "        try {\n" +
            "            Sheet[] sheets = rwb.getSheets();\n" +
            "            int j = 0, rows;\n" +
            "            $declare p;\n" +
            "            $repeat\n" +
            "            for(Sheet sheet : sheets){\n" +
            "                if((rows = sheet.getRows()) == 0) continue;\n" +
            "                for(int i=$start; i<rows; i++,j++){\n" +
            "                    p = new $declare();\n" +
            "                    $util\n" +
            "                    p.setExcelSeq(j);\n" +
            "                    int rs = p.validate(repeat);\n" +
            "                    if(rs==0)\n" +
            "                        errorLs.add(p);\n" +
            "                    else if(rs==1)\n" +
            "                        correctLs.add(p);\n" +
            "                }\n" +
            "            }\n" +
            "        }catch (Exception e){\n" +
            "            throw e;\n" +
            "        }finally {\n" +
            "            if(rwb!=null) rwb.close();\n" +
            "        }\n" +
            "    }\n" +
            "}\n";


    public final static String code1 =
            "package com.yihu.ehr.util.excel.read;\n" +
                    "\n" +
                    "import com.yihu.ehr.util.excel.AExcelReader;\n" +
                    "$import" +
                    "import jxl.Sheet;\n" +
                    "import jxl.Workbook;\n" +
                    "import java.util.HashSet;\n" +
                    "import java.util.Map;\n" +
                    "import java.util.Set;\n" +
                    "import java.util.HashMap;\n" +
                    "\n" +
                    "public class $clzName extends AExcelReader {\n" +
                    "\n" +
                    "    public void read(Workbook rwb) throws Exception{\n" +
                    "        try {\n" +
                    "            Sheet[] sheets = rwb.getSheets();\n" +
                    "\n" +
                    "            boolean correct = true;\n" +
                    "            int j = 0, rows;\n" +
                    "            Map<String, Set> childRepeat;\n" +
                    "\n" +
                    "            $declare" +
                    "            $pRepeat" +
                    "\n" +
                    "            for(Sheet sheet : sheets){\n" +
                    "                correct = true;\n" +
                    "                if((rows = sheet.getRows()) == 0) continue;\n" +
                    "                $parentUtil" +
                    "                p.setExcelSeq(j);\n" +
                    "                if(p.validate(repeat)==0)\n" +
                    "                    correct = false;\n" +

                    "                childRepeat = new HashMap<>();" +
                    "                $cRepeat" +
                    "                for(int i=0; i<rows; i++){\n" +
                    "                    $childUtil" +
                    "                    child.setExcelSeq(i);\n" +
                    "                    int vrs = child.validate(childRepeat);\n" +
                    "                    if(vrs==-1)\n" +
                    "                        continue;\n" +
                    "                    else if(vrs==0)\n" +
                    "                        correct = false;\n" +
                    "                    p.addChild(child);\n" +
                    "                }\n" +
                    "\n" +
                    "                if(!correct)\n" +
                    "                    errorLs.add(p);\n" +
                    "                else\n" +
                    "                    correctLs.add(p);\n" +
                    "                j++;\n" +
                    "            }\n" +
                    "        }catch (Exception e){\n" +
                    "            throw e;\n" +
                    "        }finally {\n" +
                    "            if(rwb!=null) rwb.close();\n" +
                    "        }\n" +
                    "    }\n" +
                    "}\n";


}
