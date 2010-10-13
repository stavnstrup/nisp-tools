<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">

<xsl:strip-space elements="td"/>

<xsl:template match="/">
  <html><body><table border="1">
     <xsl:apply-templates select=".//profilerecord"/>
  </table></body></html>
</xsl:template>


<xsl:template match="profilerecord">
  <tr><td><xsl:value-of select="position()"/></td><td><xsl:value-of select="@id"/></td>
  <td><xsl:value-of select="@tag"/></td></tr>
  <xsl:apply-templates select="parts/standard"/>
</xsl:template>

<xsl:template match="standard">
  <tr><td/><td><xsl:value-of select="@orgid"/><xsl:text>-</xsl:text><xsl:value-of select="translate(lower-case(@pubnum),'_:/() ','--')"/></td><td><xsl:value-of select="@title"/></td></tr>
</xsl:template>


</xsl:stylesheet>
