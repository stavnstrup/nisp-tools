<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NISP, and is intended for
transforming the standards database from a relational structure to
clean tree-structure.


Copyright (c) 2009-2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

$Id: db-resolve.xsl 165 2010-05-28 20:39:29Z stavnstrup $

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="xml" version="1.0" encoding="ISO-8859-1"/>



<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  

<!-- ==================================================================== -->



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
