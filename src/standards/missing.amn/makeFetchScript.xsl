<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:param name="rdfbase" select="'http://tide.act.nato.int/em/index.php?title=Special:ExportRDF/'"/>



<xsl:template match="missing-amn-standards">
  <xsl:result-document method="text" href="getRDF.sh">
    <xsl:text>#!/bin/sh&#x0A;</xsl:text>
    <xsl:text>username='stavnstrup'&#x0A;</xsl:text>
    <xsl:text>password=$1&#x0A;</xsl:text>
    <xsl:text>if $1 == ''&#x0A;</xsl:text>
    <xsl:text>then&#x0A;</xsl:text>
    <xsl:text>  echo "Error: Password missing"&#x0A;</xsl:text>
    <xsl:text>  echo ""&#x0A;</xsl:text>
    <xsl:text>  exit 2&#x0A;</xsl:text>
    <xsl:text>fi&#x0A;</xsl:text>
    <xsl:apply-templates/>
  </xsl:result-document>
</xsl:template>


<xsl:template match="knockoff-emwiki[@type='rfc']">
  <xsl:text>wget -c -O RFC_</xsl:text>
  <xsl:value-of select="format-number(@std,'0000')"/>
  <xsl:text>.rdf </xsl:text>
  <xsl:text>--user=$username --password=$password </xsl:text>
  <xsl:value-of select="concat($rdfbase , 'RFC_', format-number(@std,'0000'))"/>
  <xsl:text>&#x0A;</xsl:text>
</xsl:template> 


<xsl:template match="knockoff-emwiki[@type='w3c']">
  <xsl:text>wget -c -O </xsl:text>
  <xsl:value-of select="@id"/>
  <xsl:text>.rdf </xsl:text>
  <xsl:text>--user=$username --password=$password </xsl:text>
  <xsl:value-of select="concat($rdfbase , @std)"/>
  <xsl:text>&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="standard"/>

<xsl:template match="comment()"/>


</xsl:stylesheet>
