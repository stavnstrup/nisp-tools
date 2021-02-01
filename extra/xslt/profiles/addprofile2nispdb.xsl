<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<!--
Name        : addprofile2nispdb

Description : Add new profile, and related standards and organisations to NISP Database.
-->

<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.8//EN"
            doctype-system="../schema/dtd/stddb48.dtd"/>

<xsl:param name="new.profile.source.dir"/>
<xsl:param name="new.profile.source.name"/>
<xsl:variable name="new.profile" select="document(concat($new.profile.source.dir,'/',$new.profile.source.name))/nispadditions"/>

<xsl:template match="records">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
		<xsl:apply-templates select="$new.profile/standards/*"/>
		<xsl:apply-templates select="$new.profile/profileset/*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="organisations">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
		<xsl:apply-templates select="$new.profile/organisations/*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
