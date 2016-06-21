package com.yihu.ehr.util.excel;

import java.io.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/19
 */
public class ObjectFileRW {

    public static void write(File file, Object obj) throws IOException {
        ObjectOutputStream oos = null;
        try {
            if(file.exists()){
                file.delete();
                file.createNewFile();
            }
            oos = new ObjectOutputStream(new FileOutputStream(file));
            oos.writeObject(obj);
            oos.flush();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if(oos!=null) oos.close();
        }
    }

    public static Object read(File file) throws IOException, ClassNotFoundException {
        ObjectInputStream ois = null;
        try {
            ois = new ObjectInputStream(new FileInputStream(file));
            Object temp = ois.readObject();
            return temp;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if(ois!=null) ois.close();
        }
    }
}
