package dk.stavnstrup.nisp.apps;

import java.io.*;
import java.text.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
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
            // Merge code found at http://itextpdf.com/examples/iia.php?id=141

            Document bigPDF = new Document();
            PdfCopy copy = new PdfCopy(bigPDF, new FileOutputStream("CombinedPDFDocument.pdf"));
            bigPDF.open();
            PdfReader ReadInputPDF;
            int page_offset = 0;
            int number_of_pages;
            // Create a bookmarklist
            ArrayList<HashMap<String, Object>> bookmarks =
               new ArrayList<HashMap<String, Object>>();
            List<HashMap<String, Object>> tmp;
            for (int i = 2; i < numberOfArgs; i++) {
                 ReadInputPDF = new PdfReader(args[i]);
                 // merge the bookmarks
                 tmp = SimpleBookmark.getBookmark(ReadInputPDF);
                 SimpleBookmark.shiftPageNumbers(tmp, page_offset, null);
                 bookmarks.addAll(tmp);
                 // add the pages
                 number_of_pages = ReadInputPDF.getNumberOfPages();
                 page_offset += number_of_pages;
                 for (int page = 0; page < number_of_pages; ) {
                     copy.addPage(copy.getImportedPage(ReadInputPDF, ++page));
                 }
                 copy.freeReader(ReadInputPDF);
                 ReadInputPDF.close();     
            }
            // Add the merged bookmarks
            copy.setOutlines(bookmarks);
            bigPDF.close();
            
            // Stamp the document
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

