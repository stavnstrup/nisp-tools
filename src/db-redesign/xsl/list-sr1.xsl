<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">




<xsl:template match="/">
  <html><body><table border="1">
    <tr><td><strong>STD</strong></td><td><strong>Id</strong></td><td><strong>Title</strong></td></tr>
     <xsl:apply-templates select=".//standardrecord[count(.//standard)=1]"/>
  </table></body></html>
</xsl:template>


<xsl:template match="standardrecord[count(.//standard)=1]">
  <tr><td><xsl:value-of select="position()"/></td><td><xsl:value-of select="@id"/></td>
  <td><xsl:value-of select="./standard/@title"/></td></tr>
</xsl:template>

  


</xsl:stylesheet>
