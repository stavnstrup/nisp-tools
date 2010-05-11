/*
 * $Id: PDFInfo.java,v 1.7.2.1 2002/05/31 00:17:16 chrisg Exp $
 * Copyright (C) 2001 The Apache Software Foundation. All rights reserved.
 * For details on use and redistribution please refer to the
 * LICENSE file included with these sources.
 */

package dk.stavnstrup.nisp.pdf;

// Java
import java.util.TimeZone;
import java.util.Date;
import java.util.Calendar;
import java.text.*;
import java.util.*;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.PrintWriter;

/**
 * class representing an /Info object
 */

public class PDFInfo  {

    /**
     * the Author of the document
     */
    protected String author;

    /**
     * the date the document was created
     */
    protected String creationDate;

    /**
     * the application creating the document
     */
    protected String creator;

    /**
     * the application producing the PDF
     */
    protected String producer;

    /**
     * the title of the document
     */
    protected String title;
    
    /*
     * the subject of the document
     */
    protected String subject;
    
    /*
     * the keywords associated with the document
     */
    protected String keywords;
    

    /**
     * create an Info object
     *
     * @param number the object's number
     */
    public PDFInfo() {
      //	this.creationDate = getDateString();
    }


    /**
     * set the author string
     *
     * @param author the author string
     */
    public void setAuthor(String author) {
        this.author = author;
    }

    /**
     * set the creator string
     *
     * @param creator the creator string
     */
    public void setCreator(String creator) {
        this.creator = creator;
    }

    /**
     * set the creation date string
     *
     */
    private String getDateString() {
	DateFormat datefmt = new SimpleDateFormat("yyyyMMddHHmmss");
        DecimalFormat decfmt = new DecimalFormat("00");
        decfmt.setPositivePrefix("+");
        decfmt.setNegativePrefix("-");

        Calendar now = Calendar.getInstance();
        TimeZone tz = now.getTimeZone();
        
        return  "D:" + datefmt.format(now.getTime())
                     + decfmt.format(tz.getRawOffset() / 3600000) 
                     + "'00'";	 
    }

    /**
     * set the producer string
     *
     * @param producer the producer string
     */
    public void setProducer(String producer) {
        this.producer = producer;
    }

    /**
     * set the title string
     *
     * @param title the title string
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * set the subject string
     *
     * @param subject the subject string
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }

    /**
     * set the keywords string
     *
     * @param keywords the keywords string
     */
    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }


    /** 
     * produce the PDF representation of the object
     *
     * @return the PDF
     */
    public HashMap toMap() {

        HashMap infomap = new HashMap(); 

	//        infomap.put("CreationDate", this.creationDate);

        infomap.put("ModDate", getDateString());

        if (this.producer != null) {
            infomap.put("Producer", this.producer);

        }

        if (this.author != null) {
            infomap.put("Author", this.author);

        }
        if (this.creator != null) {
            infomap.put("Creator", this.creator);
	}
        if (this.title != null) {
            infomap.put("Title", this.title);
	}
        if (this.subject != null) {
            infomap.put("Subject",  this.subject);
	}
        if (this.keywords != null) {
	    infomap.put("Keywords", this.keywords);
        }

        return infomap;

    }

}
