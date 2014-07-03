<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  


<xsl:output method="html" indent="no"/>

<xsl:strip-space elements="*"/>

<xsl:template match="table[@class='overview']/tr[position()>1]">
  <tr>
    <xsl:apply-templates select="@*"/>
    <td><xsl:value-of select="position()-1"/></td>
    <xsl:apply-templates/>
  </tr>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>



</xsl:stylesheet>
