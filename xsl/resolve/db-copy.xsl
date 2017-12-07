<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NISP, and is intended for
transforming the standards database from a relational structure to
clean tree-structure.


Copyright (c) 2009-2017, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).


-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">


<xsl:output indent="yes"/>

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.

  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- Re-create the capability profile hierachy, which is necessary when we want to create
     queries accross multiple concepts -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
    <profilehierachy>
      <xsl:apply-templates select="records/capabilityprofile"/>
    </profilehierachy>
  </standards>
</xsl:template>


<xsl:template match="capabilityprofile">
  <capabilityprofile id="{@id}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="profile" mode="copyprofile">
  <profile>
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </profile>
</xsl:template>


<xsl:template match="serviceprofile" mode="copyprofile">
  <serviceprofile id="{@id}">
    <xsl:apply-templates select="reftaxonomy"/>
    <xsl:apply-templates select="obgroup"/>
  </serviceprofile>
</xsl:template>


<xsl:template match="subprofiles" mode="copyprofile">
  <subprofile>
    <xsl:apply-templates select="refprofile" mode="copyprofile"/>
  </subprofile>
</xsl:template>


<xsl:template match="refprofile" mode="copyprofile">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="copyprofile"/>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
