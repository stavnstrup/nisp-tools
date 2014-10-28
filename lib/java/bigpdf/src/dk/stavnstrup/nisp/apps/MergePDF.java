package dk.stavnstrup.nisp.apps;

import java.io.*;
import java.text.*;
import java.util.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import dk.stavnstrup.nisp.pdf.PDFInfo;

public class MergePDF {

    public static void main(String[] args) {

        int numberOfArgs = args.length;

        if (numberOfArgs < 3) {
	    System.out.println("Usage: Main toolversion fileout filein+");
	    System.out.println(numberOfArgs);
	    System.exit(2);
        }

        String ver = args[0]; // Get NISP tool version
        String fo = args[1];  // Get name of final outputfile
       
	try {
            // Merge code found at http://thinktibits.blogspot.dk/2011/05/merge-two-pdf-files-java-itext-example.html

            Document PDFCombineUsingJava = new Document();
            PdfCopy copy = new PdfCopy(PDFCombineUsingJava, new FileOutputStream("CombinedPDFDocument.pdf"));
            PDFCombineUsingJava.open();
            PdfReader ReadInputPDF;
            int number_of_pages;
            for (int i = 2; i < numberOfArgs; i++) {
                 ReadInputPDF = new PdfReader(args[i]);
                 number_of_pages = ReadInputPDF.getNumberOfPages();
                 for (int page = 0; page < number_of_pages; ) {
                     copy.addPage(copy.getImportedPage(ReadInputPDF, ++page));
                 }
            }
            PDFCombineUsingJava.close();

	    PdfReader reader = new PdfReader("CombinedPDFDocument.pdf");           
            PDFInfo info = new PDFInfo();
            info.setTitle("NATO Interoperability Standards and Profiles");

	    info.setCreator("NISP Tools " + ver);
            info.setAuthor("Interoperability Profiles Capability Team"); 

            PdfStamper stamp = new PdfStamper(reader, new FileOutputStream(fo));
            stamp.setMoreInfo(info.toMap());
            stamp.close();
        }
        catch (Exception de) {
	    de.printStackTrace();
        }
    }
}
