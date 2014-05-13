<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<!--

======================================================
This stylesheet MUST be run with a XSLT 2.0 processor.
======================================================

Fix the version attribute in event element.

N.B: DO NOT USE this stylesheet unless you know what you are doing.

The potential error in the event element might be in the rfcp or the date attribute instead.

Copyright (c) 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.0//EN"
            doctype-system="../src/schema/dtd/stddb40.dtd"/>


<xsl:strip-space elements="*"/>

<xsl:preserve-space elements="standards records lists community-of-interest community"/>


<xsl:template match="event">
  <event>
    <xsl:apply-templates select="@*"/>
    <xsl:choose>
<!-- 
      <xsl:when test="@date > '2009-02-09' and @date &lt; '2010-03-27'">
        <xsl:attribute name="version">4.0</xsl:attribute>
      </xsl:when>
      <xsl:when test="@date > '2010-03-27' and @date &lt; '2011-05-03'">
        <xsl:attribute name="version">5.0</xsl:attribute>
      </xsl:when>
      <xsl:when test="@date > '2011-05-03' and @date &lt; '2012-01-24'">
        <xsl:attribute name="version">6.0</xsl:attribute>
      </xsl:when>
      <xsl:when test="@date > '2012-01-24' and @date &lt; '2013-05-02'">
        <xsl:attribute name="version">7.0</xsl:attribute>
      </xsl:when>
      <xsl:when test="@date > '2013-05-02' and @date &lt; '2014-04-01'">
        <xsl:attribute name="version">8.0</xsl:attribute>
      </xsl:when>
-->
      <xsl:when test="@date > '2014-04-01'">
        <xsl:message>9</xsl:message>
        <xsl:attribute name="version">9.0</xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </event>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
