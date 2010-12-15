<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">
  

<xsl:output method="html" encoding="ISO-8859-1" indent="no"/>


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
