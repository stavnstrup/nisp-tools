<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NC3 Technical Architecture, and is
intended to identify duplex records in  the starndard database.

Output from the transformation should be piped into the stylesheet duplex2html.xsl

Copyright (c) 2003  Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  
<!--
<xsl:output method="xml" indent="no" saxon:next-in-chain="dates2html1.xsl"/>
-->
<xsl:output method="html" indent="yes"/>

<xsl:template match="standards">
  <xsl:message>Generating NCSP Records</xsl:message>
  <html>
    <head>
      <title>Overview of the NCSP Records</title>
      <style type="text/css">
        body {
          font-size: 10pt;
        }
        td { vertical-align: top; }
      </style>
    </head>
    <body>

    <h1>Overview of the NCSP Records</h1>


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

    <h2>NCSP Record Statistics</h2>

    <xsl:variable name="catA" select="count(.//ncsp-view[(@category='a') and
         (mandatory or emerging or fading or remarks or rationale)])"/>

    <xsl:variable name="catB" select="count(.//ncsp-view[(@category='b') and
         (mandatory or emerging or fading or remarks or rationale)])"/>

    <table border="0">
      <tr>
        <td></td>
        <td><b>Profiles</b></td>
        <td><b>Estimated</b></td>
      </tr>
      <tr>
        <td>Category a profiles</td>
        <td align="right"><xsl:value-of select="$catA"/></td>
        <td align="right"><xsl:number value="$catA div ($catA+$catB) * 100" format="1"/> %</td>
       </tr>
      <tr>
        <td>Category b profiles</td>
        <td align="right"><xsl:value-of select="$catB"/></td>
        <td align="right"><xsl:number value="$catB div ($catA+$catB) * 100" format="1"/> %</td>
      </tr>
    </table>

    <p>This section describes most rows in the NCSP and rationale
    tables. The rows are selected using the following criteria; A row
    is included if the mandatory, emerging, fading, remarks or
    rationale element is defined or if the ncsp-view attribute
    category is defined.</p>

    <p>In the NCSP overview, the following columns are defined.</p>

    <ul>
      <li><b>Rec</b> - the row position in this table</li>
      <li><b>Class ID</b> - The service class identifier. Put the mouse over the ID to see the title of the service class.</li>
      <li><b>A</b> - Position of applicability category A</li>
      <li><b>B</b> - Position of applicability category B</li>
      <li><b>Cat.</b> - Category type</li>
      <li><b>Mandatory, Emerging and Fading describtions</b> - </li>
      <li><b>NNEC</b> - </li>
      <li><b>Remarks</b> - Remark column used in the NCSP</li>
      <li><b>Rationale</b> - Rationale column used in the rationale document</li>
    </ul>

    <p />

    <table border="1">
      <xsl:apply-templates select="servicearea"/>
    </table>

    </body>
  </html>
</xsl:template>


<xsl:template match="servicearea">
  <tr>
    <xsl:attribute name="bgcolor">#00c0f2</xsl:attribute>
    <td colspan="9"><b><xsl:value-of select="@title"/> (ID: <xsl:value-of select="@id"/>)</b></td>
  </tr>
  <tr>
    <td><b>Row</b></td>
    <td><b>Class ID</b></td>
    <td><b>A</b></td>
    <td><b>B</b></td>
    <td><b>Cat.</b></td>
    <td><b>Mandatory, Emerging and Fading</b></td>
    <td><b>NNEC</b></td>
    <td><b>Remarks</b></td>
    <td><b>Rationale</b></td>
   </tr>
   <xsl:apply-templates select=".//ncsp-view"/>
</xsl:template>

<!--   -->

<xsl:template match="sp-view">
  <xsl:if test="mandatory or emerging or fading or remarks or rationale or @category">
  <tr>
    <td><xsl:number from="standards" 
                    count="sp-view[mandatory or emerging or fading or remarks or rationale or @category]" 
                    format="1" level="any"/></td>
    <td>
      <xsl:choose>
        <xsl:when test="class">
          <a>
           <xsl:attribute name="title"><xsl:value-of select="ancestor::serviceclass/@title"/></xsl:attribute>
           <xsl:value-of select="ancestor::serviceclass/@cid"/>
	  </a>
        </xsl:when>
        <xsl:otherwise>&nbsp;</xsl:otherwise>
      </xsl:choose>
    </td>
    <td><xsl:if test="not(@category='a')">&nbsp;</xsl:if>
      <xsl:if test="@category='a'">
        <xsl:number from="ta-standards" count="ncsp-view[(@category='a')]" format="1" level="any"/>
      </xsl:if>
    </td>
    <td><xsl:if test="not(@category='b')">&nbsp;</xsl:if>
      <xsl:if test="@category='b'">
        <xsl:number from="ta-standards" count="ncsp-view[(@category='b')]" format="1" level="any"/>
      </xsl:if>
    </td>
    <td align="center">
      <xsl:value-of select="@category"/>
      <xsl:if test="not(@category)">&nbsp;</xsl:if>
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="mandatory or emerging or fading">
          <table>
           <tr><td><b>M</b>:</td><td><xsl:value-of select="mandatory"/><br /></td></tr>
           <tr><td><b>E</b>:</td><td><xsl:value-of select="emerging"/><br /></td></tr>
           <tr><td><b>F</b>:</td><td><xsl:value-of select="fading"/></td></tr>
          </table>
        </xsl:when>
        <xsl:otherwise>&nbsp;</xsl:otherwise>
      </xsl:choose>
    </td>
    <td><xsl:value-of select="nnec"/><xsl:if test="not(nnec)">&nbsp;</xsl:if></td>
    <td><xsl:value-of select="remarks"/><xsl:if test="not(remarks)">&nbsp;</xsl:if></td>
    <td><xsl:value-of select="rationale"/><xsl:if test="not(rationale)">&nbsp;</xsl:if></td>
  </tr>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
