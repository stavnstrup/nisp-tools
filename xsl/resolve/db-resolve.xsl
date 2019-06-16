<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is intended for
renaming profiles with the attribute  toplevel="yes" to capabilityprofile. This will ensure
the old resolve-nodes.xsl stylesheet will continue to work and display mandatory and candidate
standards in NISP volume 2 and 3.

Copyright (c) 2019, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon">

<xsl:output saxon:next-in-chain="db-resolve-p2.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:template match="profile[@toplevel='yes']">
  <capabilityprofile>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>  </capabilityprofile>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
