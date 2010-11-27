<?xml version="1.0" encoding="ISO-8859-1"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NC3 Technical Architecture, and is
intended to identify duplex records in  the starndard database.

Output from the stylesheet db-duplex.xsl should be piped into this stylesheet.

Copyright (c) 2003  Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default">
  
<xsl:output method="html" encoding="ISO-8859-1" indent="no"/>


<xsl:template match="database">
  <xsl:variable name="title">Try to identify duplex standards in the NC3TA Standard Database</xsl:variable>

  <xsl:message><xsl:text>  </xsl:text><xsl:value-of select="$title"/></xsl:message>
  <html>
    <head><title><xsl:value-of select="$title"/></title></head>
  <body>
    <h1><xsl:value-of select="$title"/></h1>

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
    </p>


   <p>These columns describes all standards in the database. The
   records are sorted by the attributes pubnum and org in order to be
   able to identify standards added multiple times.</p>

   <ul>
     <li><b>Rec</b> - The position of the record</li>
     <li><b>Std</b> - The position of the <i>standard</i> in the database</li>
     <li><b>Type</b> - Is this a <i>standardrecord</i> (S) or a <i>profilerecord</i> (P)</li>
     <li><b>CS</b> - Is this a Cover standard (does it have substandards</li>
     <li><b>Stage</b> - Stage info for the embeding record</li>
     <li><b>NCSP</b> - Status of embedding record  in the NCSP (Volume 4)</li>
     <li><b>Organisation</b> - What organisation have published this standard number</li>
     <li><b>Pubnum</b> - The publicationnumber of a <i>standard</i></li>
     <li><b>ID</b> - What ID is assiciated with this record</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>Title</b> - The title of the <i>standard</i></li>
     <li><b>Service Area</b> - In what service area is this standard located</li>
     <li><b>Service Class</b> - In what service class is this standard located</li>
   </ul>

  <p>All cells marked in yellow, indicates a <b>potential</b> problem
     in the database. Either the org or pubnum are missing, or
     multiple standards have an identical pubication number (which might be
     perfectly legal).</p>


  <table border="1" width="100%">
  <tr>
    <td><b>Rec</b></td>
    <td><b>Std</b></td>
    <td><b>Type</b></td>
    <td><b>CS</b></td>
    <td><b>Stage</b></td>
    <td><b>NCSP</b></td>
    <td><b>Organisation</b></td>
    <td><b>Pubnumber</b></td>
    <td><b>Id</b></td>
    <td><b>Tag</b></td>
    <td><b>Title</b></td>
    <td><b>Service Area</b></td>
    <td><b>Service Class</b></td>
  </tr>
  <xsl:apply-templates select=".//standard"/>
  </table>
  </body></html>
</xsl:template>


<xsl:template match="standard">
  <xsl:variable name="thispubnum" select="pubnum"/>
  <xsl:variable name="org" select="org"/>
  <tr>
    <td align="right"><xsl:value-of select="rec"/></td>
    <td align="right"><xsl:value-of select="std"/></td>
    <td align="center"><xsl:value-of select="type"/></td>
    <td><xsl:value-of select="cs"/>&nbsp;</td>
    <td><xsl:value-of select="stage"/>&nbsp;</td>
    <td align="center"><xsl:value-of select="ncsp"/>&nbsp;</td>
    <xsl:choose>
      <xsl:when test="$org=''"><td bgcolor="yellow">&nbsp;</td></xsl:when>
      <xsl:otherwise><td><xsl:value-of select="org"/></td></xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="(following::standard/pubnum=$thispubnum) or (preceding::standard/pubnum=$thispubnum)">
        <td bgcolor="yellow"><b><xsl:value-of select="$thispubnum"/></b>&nbsp;</td>
      </xsl:when>
      <xsl:otherwise>
        <td><xsl:value-of select="$thispubnum"/>&nbsp;</td>
      </xsl:otherwise>
    </xsl:choose>
    <td><xsl:value-of select="id"/>&nbsp;</td>
    <td><xsl:value-of select="tag"/></td>
    <td><xsl:value-of select="title"/>&nbsp;</td>
    <td><xsl:value-of select="sa"/></td>
    <td><xsl:value-of select="sc"/></td>
  </tr>
</xsl:template>

<xsl:template match="*"/>


</xsl:stylesheet>
