package com.yihu.ehr.util.excel;

import com.yihu.ehr.util.excel.annotation.*;
import sun.nio.cs.UnicodeEncoder;
import sun.nio.cs.ext.GBK;

import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.StandardJavaFileManager;
import javax.tools.ToolProvider;
import java.io.*;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.charset.Charset;
import java.util.Arrays;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/18
 */
public class ReaderCreator {
    static String splitMark = System.getProperty("file.separator");
    static String path = System.getProperty("user.home") +splitMark+ "ehr" + splitMark + "app" + splitMark;
    static String packege = "com.yihu.ehr.util.excel.read";



    public static Class[] create(Class clz) throws Exception {
        Class[] clzs = new Class[2];
        clzs[0] = create(clz, createSource(clz), "Reader");
        clzs[1] = create(clz, createWSource(clz), "Writer");
        return clzs;
    }

    public static Class create(Class clz, String source, String type) throws Exception {
        BufferedWriter writer = null;
        try{
            File file = new File(path + packege.replace(".", splitMark) + splitMark);
            if(!file.exists() && !file.mkdirs())
                throw new Exception("创建文件目录失败");

            String clzName = clz.getSimpleName() + type;
            String filePath = file.getPath() +splitMark+ clzName + ".java";
            file = new File(filePath);
            if(file.exists())
                file.delete();

            //输出文件
            writer = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(file), "UTF-8"));
            writer.write(source);
            writer.flush();
    //        FileWriter fw = new FileWriter(file);
    //        fw.write(source);
    //        fw.flush();

            //编译
            compile(filePath);
            //加载类并返回
            return loadClass(clzName);
        }catch (Exception e){
            if(writer!=null) writer.close();
            throw e;
        }
    }

//    public static Class create(Class clz) throws Exception {
//        File file = new File(path + packege.replace(".", splitMark) + splitMark);
//        if(!file.exists() && !file.mkdirs())
//            throw new Exception("创建文件目录失败");
//
//        String clzName = clz.getSimpleName() + "Reader";
//        String source = createSource(clz);
//        String filePath = file.getPath() +splitMark+ clzName + ".java";
//        file = new File(filePath);
//        if(file.exists())
//            file.delete();
//
//        //输出文件
//        FileWriter fw = new FileWriter(file);
//        fw.write(source);
//        fw.flush();
//
//        //编译
//        compile(filePath);
//        //加载类并返回
//        return loadClass(clzName);
//    }



//    public static Class createWriter(Class clz) throws Exception {
//        File file = new File(path + packege.replace(".", splitMark) + splitMark);
//        if(!file.exists() && !file.mkdirs())
//            throw new Exception("创建文件目录失败");
//
//        String clzName = clz.getSimpleName() + "Writer";
//        String source = createWSource(clz);
//        String filePath = file.getPath() +splitMark+ clzName + ".java";
//        file = new File(filePath);
//        if(file.exists())
//            file.delete();
//
//        //输出文件
//        FileWriter fw = new FileWriter(file);
//        fw.write(source);
//        fw.flush();
//
//        //编译
//        compile(filePath);
//        //加载类并返回
//        return loadClass(clzName);
//    }

    private static Class loadClass(String clzName) throws Exception {
//        File file = new File(path);
//        URL[] urls = new URL[] { file.toURI().toURL() };
//        URLClassLoader ul = new URLClassLoader(urls);
//        return ul.loadClass(packege + "." +clzName);
        return Class.forName(packege + "." +clzName);
    }


    private static void compile(String filePath) throws IOException {

        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        StandardJavaFileManager fileMgr = compiler.getStandardFileManager(null, null, Charset.forName("UTF-8"));
        Iterable units = fileMgr.getJavaFileObjects(filePath);
        JavaCompiler.CompilationTask t = compiler.getTask(null, fileMgr, null, null, null,
                units);
        t.call();
        fileMgr.close();
    }

    private static String createSource(Class clz) throws UnsupportedEncodingException {
        if(clz.getAnnotation(Sheet.class)!=null){
            return createReadSheetSour(clz);
        }else
            return createReadRowSour(clz);
    }

    private static String createWSource(Class clz) throws UnsupportedEncodingException {
        if(clz.getAnnotation(Sheet.class)!=null){
            return createWriterSheetSour(clz);
        }else
            return createWriteRowSour(clz);
    }

    /**
     * 创建不含子类的writer
     * @param clz
     * @return
     */
    private static String createWriteRowSour(Class clz) throws UnsupportedEncodingException {

        String code = ClzCode.code3;

        Annotation annotation = clz.getAnnotation(Row.class);
        if(annotation!=null)
            code = code.replace("$start", ((Row) annotation).start() + "");

        annotation = clz.getAnnotation(Title.class);
        if(annotation!=null)
            code = code.replace("$header", ((Title) annotation).names().replace("'", "\""));


        String clzName = clz.getSimpleName();

        Field[] fields = clz.getDeclaredFields();

        StringBuilder str = new StringBuilder();
        Location location;
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("addCell(ws, i, "+ location.x() +", m.get"+ firstToUpper(field.getName()) +"(), m.findErrorMsg(\""+ field.getName() +"\"));\n");
            }
        }

        code= code
                .replace("$clzName", clzName)
                .replace("$import", "import "+clz.getName() + ";\n")
                .replace("$util", str);
        return new String(code.getBytes(), "UTF-8");
    }
    /**
     * 创建含子类的writer
     * @param clz
     * @return
     */
    private static String createWriterSheetSour(Class clz) throws UnsupportedEncodingException {
        String code = ClzCode.code4;
        Annotation annotation;
        if((annotation = clz.getAnnotation(Title.class))!=null)
            code = code.replace("$header", ((Title) annotation).names().replace("'", "\""));

        String clzName = clz.getSimpleName();
        Field[] fields = clz.getDeclaredFields();

        StringBuilder str = new StringBuilder();
        if((annotation = clz.getAnnotation(Sheet.class))!=null)
            str.append("ws = wwb.createSheet(m.get"+ firstToUpper(((Sheet)annotation).name())+"(), i);\naddHeader(ws);\n");

        Class childClz=null;
        Location location;
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("addCell(ws, "+ location.y() +", "+ location.x() +", m.get"+ firstToUpper(field.getName()) +"(), m.findErrorMsg(\""+ field.getName() +"\"));\n");
            }
            else if((annotation = field.getAnnotation(Child.class))!=null){
                childClz = getChildClz(field);
            }
        }

        if((annotation = childClz.getAnnotation(Row.class))==null)
            str.append("int j= "+ ((Row) annotation).start()+";\n");
        else
            str.append("int j= 0;\n");

        str.append("for("+ childClz.getSimpleName() +" e : m.getChildren()){");
        fields = childClz.getDeclaredFields();
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("addCell(ws, j, "+ location.x() +", e.get"+ firstToUpper(field.getName())+"(), e.findErrorMsg(\""+ field.getName() +"\"));\n");
            }
        }
        str.append("j++;\n}");
        code = code.replace("$clzName", clzName)
                .replace("$import", "import " + clz.getName() + ";\nimport " + childClz.getName() + ";\n")
                .replace("$util", str);
        return new String(code.getBytes(), "UTF-8");
    }


    /**
     * 创建不含子类的reader
     * @param clz
     * @return
     */
    private static String createReadRowSour(Class clz) throws UnsupportedEncodingException {
        Annotation annotation = clz.getAnnotation(Row.class);
        int start = 0;
        if(annotation!=null)
            start = ((Row) annotation).start();

        String code = ClzCode.code2;
        String clzName = clz.getSimpleName();

        Field[] fields = clz.getDeclaredFields();

        StringBuilder str = new StringBuilder();
        Location location;
        String repeat = "";
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("p.set"+ firstToUpper(field.getName()) +"( getCellCont(sheet, i, "+ location.x() +") );\n");
                if(field.getAnnotation(ValidRepeat.class)!=null)
                    repeat += "getRepeat().put(\""+ field.getName() +"\", new HashSet<>());\n";
            }
        }

        code = code.replace("$start", start+"")
                .replace("$clzName", clzName + "Reader")
                .replace("$import", "import "+clz.getName() + ";\n")
                .replace("$declare", clzName)
                .replace("$repeat", repeat)
                .replace("$util", str);
        return new String(code.getBytes(), "UTF-8");
    }

    /**
     * 创建含有子类的reader
     * @param clz
     * @return
     */
    private static String createReadSheetSour(Class clz) throws UnsupportedEncodingException {
        String code = ClzCode.code1;
        String clzName = clz.getSimpleName();

        Field[] fields = clz.getDeclaredFields();

        StringBuilder str = new StringBuilder("p = new "+ clzName +"();\n");
        Class childClz=null;
        Annotation annotation;
        Location location;
        Child child  = null;
        String pRepeat = "";
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("p.set"+ firstToUpper(field.getName()) +"( getCellCont(sheet, "+ location.y() +", "+ location.x() +") );\n");
                if(field.getAnnotation(ValidRepeat.class)!=null)
                    pRepeat += "getRepeat().put(\""+ field.getName() +"\", new HashSet<>());\n";
            }
            else if((annotation = field.getAnnotation(Child.class))!=null){
                child = (Child) annotation;
                childClz = getChildClz(field);
            }
        }

        code = code.replace("$clzName", clzName+ "Reader")
                .replace("$import", "import "+clz.getName() + ";\nimport "+ childClz.getName() +";\n")
                .replace("$declare", clzName + " p;\n " + childClz.getSimpleName() + " child;\n")
                .replace("$pRepeat", pRepeat)
                .replace("$parentUtil", str);

        str = new StringBuilder("child = new "+ childClz.getSimpleName() +"();\n");
        if(child!=null)
            str.append("child.set" + firstToUpper(child.many()) + "( p.get"+ firstToUpper(child.one()) +"() );");

        pRepeat = "";
        fields = childClz.getDeclaredFields();
        for(Field field : fields){
            if((annotation = field.getAnnotation(Location.class))!=null){
                location = (Location) annotation;
                str.append("child.set"+ firstToUpper(field.getName()) +"( getCellCont(sheet, i, "+ location.x() +") );\n");
                if(field.getAnnotation(ValidRepeat.class)!=null)
                    pRepeat += "childRepeat.put(\""+ field.getName() +"\", new HashSet<>());\n";
            }
        }
        code = code.replace("$cRepeat", pRepeat).replace("$childUtil", str);
        return new String(code.getBytes(), "UTF-8");
    }

    private static String firstToUpper(String str){
        return str.substring(0,1).toUpperCase() + str.substring(1, str.length());
    }

    private static Class getChildClz(Field field){
        Type genType = field.getAnnotatedType().getType();
        if ((genType instanceof ParameterizedType)) {
            return (Class) ((ParameterizedType) genType).getActualTypeArguments()[0];
        }
        return null;
    }
}
