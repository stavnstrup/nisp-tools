<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  

<xsl:output method="html" indent="yes"/>

<xsl:template match="allupcoming">
  <html>
    <head>
      <title>Upcoming stuff in the database in the NISP Standard Database</title>
      <style type="text/css">
        .head {background-color: #808080;  }
        .body, table {font-family: sans-serif;}
        .table {width: 100%;}
        .deleted { background-color: #FF5A41; color: white; font-weight: bold;}
        .missing { background-color: #FFFEA0;}
        .head { }
        .type {text-align: center;}
        .date {white-space: nowrap;}
      </style>
    </head>
    <body>


    <h1>Upcoming and fading standards and profiles in the NISP Standard Database</h1>

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
   
    <p>N.B. A standard/profile might be in several categories, i.e
    (emerging, midterm,...). This report only places the
    standard/profile in one of the possible categories.</p>

    <h2>Emerging </h2>
    <p><xsl:value-of select="count(element[@mode='emerging'])"/> emerging standards and profiles</p>
    <table border="1">
      <xsl:call-template name="header"/>
      <xsl:apply-templates select="element[@mode='emerging']">
        <xsl:sort select="@lastchange" order="ascending"/>
      </xsl:apply-templates>
    </table>


    <h2>Mid Term</h2>
    <p><xsl:value-of select="count(element[@mode='midterm'])"/> mid term standards and profiles</p>
    <table border="1">
      <xsl:call-template name="header"/>
      <xsl:apply-templates select="element[@mode='midterm']">
        <xsl:sort select="@lastchange" order="ascending"/>
      </xsl:apply-templates>
    </table>


    <h2>Far Term</h2>
    <p><xsl:value-of select="count(element[@mode='farterm'])"/> far term standards and profiles</p>
    <table border="1">
      <xsl:call-template name="header"/>
      <xsl:apply-templates select="element[@mode='farterm']">
        <xsl:sort select="@lastchange" order="ascending"/>
      </xsl:apply-templates>
    </table>


    <h2>Fading</h2>
    <p><xsl:value-of select="count(element[@mode='fading'])"/> fading standards and profiles</p>
    <table border="1">
      <xsl:call-template name="header"/>
      <xsl:apply-templates select="element[@mode='fading']">
        <xsl:sort select="@lastchange" order="ascending"/>
      </xsl:apply-templates>
    </table>
  </body></html>
</xsl:template>


<xsl:template match="element">
  <tr>
    <td class="date"><xsl:value-of select="@lastchange"/></td>
    <td><xsl:value-of select="@id"/></td>
    <td class="type"><xsl:value-of select="@type"/></td>
    <td><xsl:value-of select="@orgid"/></td>
    <td><xsl:value-of select="@pubnum"/></td>
    <td><xsl:value-of select="@title"/></td>
  </tr>
</xsl:template>


<xsl:template name="header">
 <tr class="head">
   <td><b>Date</b></td>
   <td><b>ID</b></td>
   <td><b>Type</b></td>
   <td><b>Org</b></td>
   <td><b>PubNum</b></td>
   <td><b>Title</b></td>
  </tr>
</xsl:template>


</xsl:stylesheet>
