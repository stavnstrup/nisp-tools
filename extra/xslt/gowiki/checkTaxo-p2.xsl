<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output method="text" indent="yes"/>

<xsl:template match="standards">
  <xsl:text>----------------------------------------------------&#x0A;</xsl:text>
  <xsl:apply-templates select="records/serviceprofile[status/@mode='accepted']"/>
</xsl:template>

<xsl:template match="serviceprofile">
  <xsl:variable name="myid" select="@id"/>
  <xsl:text>serviceprofile: </xsl:text><xsl:value-of select="@title"/>
  <xsl:text>  (https://nisp.nw3.dk/serviceprofile/</xsl:text><xsl:value-of select="@id"/><xsl:text>.html)&#x0A;</xsl:text>
  <xsl:text>capabilityprofile: </xsl:text><xsl:apply-templates select="/standards/profilehierachy//serviceprofile[@id=$myid]" mode="capability"/>
  <!--
  <xsl:text>capabilityprofile: </xsl:text><xsl:value-of select="/standards/profilehierachy//serviceprofile[@id=$myid]/@title" />
  -->
  <xsl:text>&#x0A;</xsl:text>

  <xsl:text>&#x0A;&#x0A;</xsl:text>
  <xsl:apply-templates select="reftaxonomy"/>
  <xsl:text>----------------------------------------------------&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="reftaxonomy">
  <xsl:variable name="tax" select="@refid"/>
  <xsl:apply-templates select="/standards/taxonomy//node[@id=$tax]"/>
  <xsl:text>&#x0A;</xsl:text>
</xsl:template>


<xsl:template match="node">
<xsl:text>taxo: </xsl:text><xsl:value-of select="@title"/>
<xsl:text> (</xsl:text><xsl:value-of select="@level"/><xsl:text>)</xsl:text>
<xsl:if test="@level &gt; 6">
<xsl:text> (</xsl:text>
<xsl:value-of select="ancestor::node[@level=6]/@title"/>
<xsl:text>)</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="serviceprofile" mode="capability">
  <xsl:value-of select="ancestor::capabilityprofile/@short"/>
</xsl:template>

</xsl:stylesheet>
