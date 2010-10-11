<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">





<xsl:template match="/">
  <html><body><table border="1">
     <xsl:apply-templates select=".//standardrecord[count(.//standard)=1]"/>
  </table></body></html>
</xsl:template>


<xsl:template match="standardrecord[count(.//standard)=1]">
  <tr><td><xsl:value-of select="@id"/></td>
  <td><xsl:value-of select="./standard/@title"/></td></tr>
</xsl:template>

  


</xsl:stylesheet>
