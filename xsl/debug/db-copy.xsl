<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">
  
<xsl:output method="xml" version="1.0"
            doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
            doctype-system="../src/schema/dtd/docbkx45/docbookx.dtd"/>



<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  


<!-- ==================================================================== -->

<xsl:template match="standardrecord|profilerecord">
  <xsl:choose>
    <xsl:when test=".//event[(@flag = 'added') and (number(translate(@date,'-','')) &gt; 20030515)]"/>
    <xsl:otherwise>
      <xsl:copy>    
        <xsl:apply-templates select="@*"/> 
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
