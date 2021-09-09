<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>

<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.8//EN"
            doctype-system="../schema/dtd/stddb48.dtd"/>

<xsl:strip-space elements="*"/>


<xsl:template match="refgroup/refstandard">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:choose>
    <xsl:when test="local-name(/standards/records/*[@id=$myid])='coverdoc'">
      <xsl:apply-templates select="/standards/records/coverdoc[@id=$myid]/coverstandards/*"/>
    </xsl:when>
    <xsl:otherwise>
      <refstandard refid="{$myid}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="standard|coverdoc|profilespec|serviceprofile|profile">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@*"/>
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
