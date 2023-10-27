<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:uuid="java:java.util.UUID"
                version='1.1'
                exclude-result-prefixes="uuid">

<!--
Name        : makeUUID.xsl

Description : Create fancy tags.
              Format defined during the NISP Design workshop in october 2023.

              Copyright (C) 2023 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO).
-->


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.8//EN"
            doctype-system="../schema/dtd/stddb48.dtd"/>


<xsl:strip-space elements="*"/>

<xsl:template match="standard|coverdoc">
  <xsl:variable name="myorg" select="document/@orgid"/>
  <xsl:variable name="myid" select="@id"/>
  <xsl:element name="{local-name(.)}">
    <xsl:attribute name="id" select="./@id"/>
    <xsl:attribute name="tag">
      <xsl:apply-templates select="/standards/organisations/orgkey[@key=$myorg]/@short"/>
      <xsl:if test="document/@pubnum !=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="document/@pubnum"/>
      </xsl:if>
      <xsl:if test="document/@date !=''">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="substring(document/@date, 1, 4)"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="starts-with(document/@orgid, 'nato') and (/standards/records/coverdoc//refstandard[@refid=$myid])">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="/standards/records/coverdoc[.//refstandard/@refid=$myid]/document/@pubnum"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
  <xsl:text>&#x0a;</xsl:text>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
