<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version='1.1'
                exclude-result-prefixes="xi">

<!--

Creates the olinks masterdatabase.

$Id $

-->

<xsl:output method="xml" version="1.0" encoding="utf-8"
            indent="yes"
            doctype-system="../schema/dtd/targetdatabase.dtd"/>

<xsl:template match="documents">
<targetset>
  <targetsetinfo> This is the target database document used to create
  cross-references between document in the NISP.</targetsetinfo>
  <sitemap>
    <dir name="..">
      <xsl:apply-templates/>
    </dir>
  </sitemap>
</targetset>
</xsl:template>


<xsl:template match="directory">
  <dir>
    <xsl:attribute name="name">
      <xsl:value-of select="@dir"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </dir>
</xsl:template>


<xsl:template match="docinfo">
  <document>
    <xsl:attribute name="targetdoc">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:variable name="href">
      <xsl:value-of select="@id"/>
      <xsl:text>-target.db</xsl:text>
    </xsl:variable>
    <xi:include  href="{$href}"/>
  </document>
</xsl:template>


</xsl:stylesheet>
