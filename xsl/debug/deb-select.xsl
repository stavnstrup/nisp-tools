<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to what standards/standardset a give bprefstandard statemnt actually referes to.

Copyright (c) 2014, 2015  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

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
  <xsl:message>Comparison of bprefstandard with referenced standard.</xsl:message>
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

    <h1>Comparison of bprefstandard  statements and refered standards/profiles</h1>

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

    <p>All bprefstandard statements contains a small text describing the
    standard it is supposed to referer to. This report reveals all
    bprefstandard statements, which refers to a wrong standard/profiles.</p>


    <p>The standard/profile columen contains "title,orgnum, pubnum, date" if it is a standard and for a profile we use the tag attribute.</p>

    <table border="1">
      <tr>
        <th>Service</th>
        <th>ID</th>
        <th>Used text</th>
        <th>Mode</th>
        <th>S/P</th>
        <th>Standard/Profile</th>
      </tr>
      <xsl:apply-templates select="bestpracticeprofile/bpserviceprofile"/>
    </table>
  </body></html>
</xsl:template>


<xsl:template match="bpserviceprofile">
  <xsl:variable name="tref" select="@tref"/>
  <xsl:if test="count(.//bprefstandard) != 0">
    <tr>
      <td><strong><xsl:value-of select="/standards/taxonomy//*[@id=$tref]/@title"/></strong></td>
      <td/><td/><td/><td/><td/>
    </tr>
    <xsl:apply-templates select=".//bprefstandard"/>
  </xsl:if>
</xsl:template>


<xsl:template match="bprefstandard">
  <xsl:variable name="ref" select="@refid"/>
  <tr>
    <td/>
    <td><xsl:value-of select="@refid"/></td>
    <td><xsl:value-of select="."/></td>
    <td>
      <xsl:choose>
        <xsl:when test="ancestor::bpgroup[@mode='mandatory']">M</xsl:when>
        <xsl:when test="ancestor::bpgroup[@mode='candidate']">C</xsl:when>
      </xsl:choose>
    </td>
    <xsl:apply-templates select="//standard[@id=$ref]"/>
  </tr>
</xsl:template>



<xsl:template match="standard">
  <td>S</td><td>
  <xsl:value-of select="document/@title"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@orgid"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@pubnum"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="document/@date"/>
  </td>
</xsl:template>


s</xsl:stylesheet>
