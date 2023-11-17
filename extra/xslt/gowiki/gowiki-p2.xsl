<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output indent="yes" saxon:next-in-chain="gowiki-p3.xsl"/>


<xsl:template match="standard">
  <standard>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="wikiId">
      <xsl:text>NISP-S</xsl:text>
      <xsl:number from="/standards/records" count="standard" format="00001" level="any"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </standard>
</xsl:template>


<xsl:template match="profile|serviceprofile">
  <xsl:element name="{local-name(.)}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="wikiId">
      <xsl:text>NISP-P</xsl:text>
      <xsl:number from="/standards/records" count="profile|serviceprofile" format="00001" level="any"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
