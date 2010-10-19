<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">

<xsl:strip-space elements="td"/>



<xsl:strip-space elements="s"/>

<xsl:output method="xml" indent="yes" doctype-system="allstd.dtd"/>


<xsl:template match="/">
  <allstd>
    <xsl:apply-templates select=".//standardrecord"/>
    <xsl:apply-templates select=".//profilerecord"/>
  </allstd>
</xsl:template>


<xsl:template match="standardrecord[count(.//standard)=1]">
  <s type="s1" id="{@id}" tag="{standard/@title}"/>
</xsl:template>



<xsl:template match="standardrecord[count(.//standard)>1]">
  <xsl:apply-templates select=".//standard"/>
</xsl:template>


<xsl:template match="profilerecord">
  <xsl:apply-templates select=".//standard"/>
</xsl:template>


<xsl:template match="standard">
  <s id="{@orgid}-{translate(lower-case(@pubnum),'_:/() ','--')}" tag="{@title}">
    <xsl:choose>
      <xsl:when test="./ancestor::standardrecord">
        <xsl:attribute name="type">s2</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="type">pr</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </s>
</xsl:template>



</xsl:stylesheet>
