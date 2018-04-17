<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.4//EN"
            doctype-system="../schema/dtd/stddb44.dtd"/>

<!--

Sort standard and profiles by id.

Copyright (c) 2014, 2018  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->


<xsl:template match="records">
  <records>
    <xsl:apply-templates select="standard">
       <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="capabilityprofile">
       <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="profile">
       <xsl:sort select="@id"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="serviceprofile">
       <xsl:sort select="@id"/>
    </xsl:apply-templates>
  </records>
</xsl:template>

<xsl:template match="bestpracticeprofile">
  <bestpracticeprofile>
    <xsl:apply-templates>
      <xsl:sort select="@genTitle"/>
    </xsl:apply-templates>
  </bestpracticeprofile>
</xsl:template>

<xsl:template match="organisations">
  <organisations>
    <xsl:apply-templates>
      <xsl:sort select="@key"/>
    </xsl:apply-templates>
  </organisations>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
