<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:uuid="java:java.util.UUID"
                version='1.1'
                exclude-result-prefixes="uuid">

<!--
Name        : makeUUID.xsl

Description : This stylesheet creates an UUID element in all standards
              and profiles, where such an element do not exists. It is
              therefore essential, that updates such as a new version of
              the standard is not done manually, but by creating a new
              standard/profile record.

              Copyright (C) 2013-2017 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO).
-->




<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.3//EN"
            doctype-system="../schema/dtd/stddb43-draft.dtd"/>


<xsl:strip-space elements="*"/>

<xsl:template match="standard|capabilityprofile">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    <xsl:if test="not(./uuid)">
      <uuid>
        <xsl:if test="function-available('uuid:randomUUID')">
          <xsl:value-of select="uuid:randomUUID()"/>
        </xsl:if>
      </uuid>
    </xsl:if>
  </xsl:element>
  <xsl:text>&#x0a;</xsl:text>
</xsl:template>


<xsl:template match="uuid">
  <uuid>
    <xsl:value-of select="."/>
    <xsl:if test="string(.) = ''">
      <xsl:if test="function-available('uuid:randomUUID')">
        <xsl:value-of select="uuid:randomUUID()"/>
      </xsl:if>
    </xsl:if>
  </uuid>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
