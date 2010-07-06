<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:template match="standardrecord[count(.//standard)=1]">
  <newstandard>
    <xsl:apply-templates select="@*"/>
    <document>
       <xsl:apply-templates select="standard/@*"/>
       <xsl:apply-templates select="standard/*"/>
    </document>
    <xsl:apply-templates select="*[node()!='standard']"/>
  </newstandard>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
