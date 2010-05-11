package dk.stavnstrup.nisp.apps;

import java.io.*;
import java.text.*;
import java.util.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import dk.stavnstrup.nisp.pdf.PDFInfo;


public class MakeDocInfo {

    public static void main(String[] args) {

        int numberOfArgs = args.length;

        if (numberOfArgs < 4) {
	    System.out.println("Usage: Main toolversion title filein fileout");
	    System.out.println(numberOfArgs);
	    System.exit(2);
        }


        String ver = args[0];
        String title = args[1];
        String fi = args[2];
        String fo = args[3];
       
	try {
            PDFInfo info = new PDFInfo();

	    PdfReader reader = new PdfReader(fi);
           
            info.setTitle(title);
            info.setSubject("NATO Interoperability Standards and Profiles");

	    info.setCreator("NISP Tools " + ver);
            info.setAuthor("NATO Open Systems Working Group"); 

            PdfStamper stamp = new PdfStamper(reader, new FileOutputStream(fo));
            stamp.setMoreInfo(info.toMap());
            stamp.close();

        }
        catch (Exception de) {
	    de.printStackTrace();
        }

    }
}
