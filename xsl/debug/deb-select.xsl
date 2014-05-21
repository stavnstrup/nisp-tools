<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to what standards/profiles a given select statemnt actually referes to.

Copyright (c) 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  
<xsl:output method="html" indent="yes"/>

<xsl:param name="describe" select="''"/>


<xsl:template match="standards">
  <xsl:message>Comparison of selectstatement with referenced standard/profile.</xsl:message>
  <html>
    <head>
      <title>Comparison of text in select statement and referenced standards/profiles</title>
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


    <h1>Comparison of select statements and refered standards/profiles</h1>

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
    <xsl:text> using rev. </xsl:text><xsl:value-of select="$describe"/></p>

    <p>All select statements contains a small text describing the
    standard it is supposed to referer to. This report reveals all
    select statements, which refers to a wrong standard/profiles.</p>


    <p>The standard/profile columen contains "title,orgnum, pubnum, date" if it is a standard and for a profile we use the tag attribute.</p>

    <table border="1">
      <tr>
        <th>Service</th>
        <th>Mandatory</th>
        <th>Emerging</th>
        <th>Fading</th>
        <th>S/P</th>
        <th>Standard/Profile</th>
      </tr>
      <xsl:apply-templates select="lists/sp-list"/>
    </table>
  </body></html>
</xsl:template>


<xsl:template match="sp-list">
  <xsl:variable name="tref" select="@tref"/>
  <xsl:if test="count(.//select) != 0">
    <tr>
      <td><strong><xsl:value-of select="/standards/taxonomy//*[@id=$tref]/@title"/></strong></td>
      <td/><td/><td/><td/><td/>
    </tr>
    <xsl:apply-templates select=".//select"/>
  </xsl:if>
</xsl:template>


<xsl:template match="select[@mode='mandatory']">
  <xsl:variable name="ref" select="@id"/>
  <tr>
    <td/>
    <td>(<strong><xsl:value-of select="$ref"/></strong>)<xsl:text> </xsl:text><xsl:value-of select="."/></td>
    <td/>
    <td/>
    <xsl:apply-templates select="//standard[@id=$ref]"/>
    <xsl:apply-templates select="//profile[@id=$ref]"/>
  </tr>
</xsl:template>

<xsl:template match="select[@mode='emerging']">
  <xsl:variable name="ref" select="@id"/>
  <tr>
    <td/>
    <td/>
    <td>(<strong><xsl:value-of select="$ref"/></strong>)<xsl:text> </xsl:text><xsl:value-of select="."/></td>
    <td/>
    <xsl:apply-templates select="//standard[@id=$ref]"/>
    <xsl:apply-templates select="//profile[@id=$ref]"/>
  </tr>
</xsl:template>

<xsl:template match="select[@mode='fading']">
  <xsl:variable name="ref" select="@id"/>
  <tr>
    <td/>
    <td/>
    <td/>
    <td>(<strong><xsl:value-of select="$ref"/></strong>)<xsl:text> </xsl:text><xsl:value-of select="."/></td>
    <xsl:apply-templates select="//standard[@id=$ref]"/>
    <xsl:apply-templates select="//profile[@id=$ref]"/>
  </tr>
</xsl:template>



<xsl:template match="standard">
  <td>S</td><td>
  (<strong><xsl:value-of select="@id"/></strong>)<xsl:text> </xsl:text>
  <xsl:value-of select="document/@title"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@orgid"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@pubnum"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@date"/>
  </td>
</xsl:template>


<xsl:template match="profile">
  <td>P</td><td>
  (<strong><xsl:value-of select="@id"/></strong>)<xsl:text> </xsl:text>
  <xsl:value-of select="@tag"/>
  </td>
</xsl:template>

</xsl:stylesheet>
