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


<xsl:variable name="db" select="document('version.xml')"/>



<!-- Add version numbers -->

<xsl:template match="document">
  <xsl:variable name="myid" select="../@id"/>
  <xsl:variable name="thisver" select="$db/versions/standard[@sid=$myid]/@version"/>
  <document>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="$thisver != ''">
      <xsl:attribute name="version">
        <xsl:value-of select="$thisver"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </document>
</xsl:template>


<!-- Remove the tref attribute from standard and profile element -->

<xsl:template match="standard/@tref"/>

<xsl:template match="profile/@tref"/>

<!-- Remove the stage and ss attribute -->

<xsl:template match="@stage|@ss"/>

<!-- Remove the ncoe element -->

<xsl:template match="ncoe"/>


<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
