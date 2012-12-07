<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NISP, and is intended for
generation of Rich Text Format files. 

The following changes to the FO file are applied:

   Repæace percentages specification with proportional spec.


Copyright (c) 2012, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO)

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.1'
                exclude-result-prefixes="#default">



<!-- ==================================================================== -->

<!-- Percentages are not supported everywhere by the RTF converter  -->

<xsl:template match="fo:table-column[contains(@column-width,'%')]">
  <fo:table-column>
    <xsl:attribute name="column-number">
      <xsl:value-of select="@column-number"/>
    </xsl:attribute>
    <xsl:attribute name="column-width">
       <xsl:text>proportional-column-width(</xsl:text>
       <xsl:value-of select="substring-before(@column-width,'%')"/>
       <xsl:text>)</xsl:text>
    </xsl:attribute>
  </fo:table-column>
</xsl:template>


<!-- ==================================================================== -->



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
