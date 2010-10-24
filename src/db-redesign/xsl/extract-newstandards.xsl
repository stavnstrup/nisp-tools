<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">


<xsl:output method="xml" indent="yes"/>

<xsl:template match="standards">
  <new-standards>
    <xsl:apply-templates select=".//standard[@ss='yes']">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </new-standards>
</xsl:template>

<xsl:template match="standard[@ss='yes']">
  <newstandard id="{@id}">
     <title><xsl:value-of select="document/@title"/></title>
     <new-applicability><xsl:text> </xsl:text></new-applicability>
     <xsl:apply-templates select="applicability"/>
  </newstandard>
</xsl:template>



<!-- ========================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>




</xsl:stylesheet>
