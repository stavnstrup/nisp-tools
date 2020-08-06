<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>


<xsl:output indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="section">
  <sect2>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </sect2>
</xsl:template>

<xsl:template match="/section">
  <sect1>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </sect1>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
