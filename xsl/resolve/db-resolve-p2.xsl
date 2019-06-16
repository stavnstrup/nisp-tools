<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is intended for
tagging serviceprofile due to their dual functionallity.

We add a type attribute to the servicprofile using the following rules
  bsp: serviceprofiles which is part of the basic standards profile (BSP)
  coi: any other service profile, which is part of a capability profile like FMN.

Copyright (c) 2018, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon">

<xsl:output saxon:next-in-chain="db-resolve-p3.xsl"/>

<xsl:strip-space elements="*"/>

<!-- ==================================================================== -->

<!-- Add type attribute to all service profile, to be able to differentiate serviceprofiles,
     which are part of the Base Standards Profile and those which are not -->

<xsl:template match="serviceprofile">
  <xsl:variable name="myid" select="@id"/>
  <serviceprofile>
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="/standards//capabilityprofile[@id='bsp']//refprofile[@refid=$myid]">
          <xsl:text>bsp</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>coi</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </serviceprofile>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
