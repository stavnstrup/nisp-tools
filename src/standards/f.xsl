<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>



<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

<xsl:strip-space elements="*"/>


<xsl:template match="oldfmnstandards">
  <capabilityprofile id="fmn1" title="FMN Spiral 1 Profile">
    <xsl:apply-templates/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="s1|s2">
  <profile id="{@id}" title="{@t}">
    <xsl:apply-templates/>
  </profile>
</xsl:template>


<xsl:template match="s3">
  <serviceprofile title="{@t}">
    <description><xsl:value-of select="@d"/></description>
    <xsl:apply-templates/>
  </serviceprofile>
  <xsl:text>&#x0a;</xsl:text>
</xsl:template>


<xsl:template match="g">
  <obgroup>
    <xsl:attribute name="obligation">
      <xsl:choose>
        <xsl:when test="@t='m'">mandatory</xsl:when>
        <xsl:when test="@t='o'">optional</xsl:when>
        <xsl:when test="@t='r'">required</xsl:when>
        <xsl:when test="@t='c'">conditional</xsl:when>
        <xsl:otherwise>ERROR</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="@d != ''">
      <description>
        <xsl:value-of select="@i"/>
      </description>
    </xsl:if>      
    <xsl:apply-templates/>    
  </obgroup>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
