<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

Copyright (c) 2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="xml" />


<!-- Sort standard and profile elements -->

<xsl:template match="records">
  <records>
    <xsl:apply-templates select="standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="profile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </records>
</xsl:template>  

<!-- Remove the tref attribute from standard and profile element -->

<xsl:template match="standard/@tref"/>

<xsl:template match="profile/@tref"/>

<!-- Remove the stage and ss attribute -->

<xsl:template match="@stage|@ss"/>



<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
