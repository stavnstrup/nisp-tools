<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NC3 Technical Architecture, and is
intended to identify duplex records in  the starndard database.

Output from the stylesheet db-dates.xsl should be piped into this stylesheet.

Copyright (c) 2003, 2014  Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="html" indent="no"/>



<xsl:template match="history">
  <xsl:message>  generate HTML view of time events</xsl:message>
  <html>
    <meta charset="utf-8" />
    <head><title>Sort all records by date</title></head>
  <body>
    <h1>Sort all records by date</h1>

    <p>Created on
    <xsl:variable name="date">
      <xsl:value-of select="date:date-time()"/>
    </xsl:variable>

    <xsl:value-of select="date:month-abbreviation($date)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="date:day-in-month()"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="date:year()"/>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    <xsl:text> using rev. </xsl:text><xsl:value-of select="@describe"/></p>


   <p>These columns describes all standards in the database. The
   records are sorted by the attributes pubnum and org in order to be
   able to identify standards added multiple times.</p>

   <ul>
     <li><b>Rec</b> - The position of the record</li>
     <li><b>Type</b> - Is this a <i>standard</i> (S), <i>serviceprofile</i> (SP), a <i>profile</i> (P) or <i>capabilityprofile</i> (CP)</li>
     <li><b>ID</b> - What ID is assiciated with this record</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>Date</b> - The date of the <i>event</i></li>
     <li><b>Flag</b> - The type of the <i>event</i> (added, changed or deleted)</li>
     <li><b>RFCP</b> - What RFCP (if any) resulted in this event</li>
     <li><b>Version</b> - The version of the TA, this event referes to</li>
   </ul>

  <p>N.B. There should only be one header for each version, otherwise
     there is a bug in the date or version field. It might also be a
     good idea to check the first and last record in each version, to
     check e.g. that we have not specified a month larger than 12 or a
     day larger than 31.</p>


  <table border="1" width="100%">
  <tr>
    <td><b>Rec</b></td>
    <td><b>Type</b></td>
    <td><b>Id</b></td>
    <td><b>Tag</b></td>
    <td><b>Date</b></td>
    <td><b>Flag</b></td>
    <td><b>RFCP</b></td>
    <td><b>Version</b></td>
  </tr>
  <xsl:apply-templates select=".//event"/>
  </table>
  </body></html>
</xsl:template>


<xsl:template match="event">
  <xsl:variable name="thisversion" select="version"/>

  <xsl:if test="position()=1 or (preceding::event[position()=1]/version != $thisversion)">
    <tr><td colspan="8" bgcolor="#00c0f2"><b>Version <xsl:value-of select="$thisversion"/></b></td></tr>
  </xsl:if>

  <tr>
    <td align="right"><xsl:value-of select="rec"/></td>
    <td align="center"><xsl:value-of select="type"/></td>
    <td><xsl:value-of select="id"/>&nbsp;</td>
    <td><xsl:value-of select="tag"/>&nbsp;</td>
     <td><xsl:value-of select="date"/></td>
    <td><xsl:value-of select="flag"/></td>
    <td>
      <xsl:if test="(rfcp='') and ((flag='added') or (flag='deleted'))">
        <xsl:attribute name="bgcolor">#FFFEA0</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="rfcp"/>&nbsp;
    </td>
    <td align="center"><xsl:value-of select="$thisversion"/>&nbsp;</td>
  </tr>
</xsl:template>


</xsl:stylesheet>
