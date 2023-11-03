<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output indent="yes" saxon:next-in-chain="gowiki-p3.xsl"/>



<xsl:template match="profilespec">
  <xsl:variable name="myorg" select="@orgid"/>
  <profilespec>
    <xsl:attribute name="tag">
      <xsl:apply-templates select="/standards/organisations/orgkey[@key=$myorg]/@short"/>
      <xsl:if test="@pubnum !=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@pubnum"/>
      </xsl:if>
      <xsl:if test="@date !=''">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="substring(@date, 1, 4)"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </profilespec>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
