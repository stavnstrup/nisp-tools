<?xml version="1.0"?>

<!--

This stylesheet is created for the NC3 Technical Architecture, and is
intended to identify duplex records in  the starndard database.

Output from the transformation should be piped into the stylesheet duplex2html.xsl

Copyright (c) 2003  Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  

<xsl:output method="xml" indent="no" saxon:next-in-chain="short2html.xsl"/>


<!--
<xsl:output method="xml" indent="yes"/>
-->
<xsl:template match="ta-standards">
  <xsl:message>Generating DB Short</xsl:message>
  <xsl:message>  sort all maturity (mandatory/emerging/fading) by key id</xsl:message>
  <database>
    <xsl:apply-templates select=".//mandatory|.//emerging|.//fading">
      <xsl:sort select="@id"/>
    </xsl:apply-templates>
  </database>
</xsl:template>


<xsl:template match="mandatory|emerging|fading">
  <standard>
    <area>
      <xsl:attribute name="id"><xsl:value-of select="ancestor::servicearea/@id"/></xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="ancestor::servicearea/@title"/></xsl:attribute>
    </area>
    <class>
      <xsl:attribute name="id"><xsl:value-of select="ancestor::serviceclass/@cid"/></xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="ancestor::serviceclass/@title"/></xsl:attribute>
    </class>
<!--
    <line><xsl:apply-templates select=".." mode="viewpos"/></line>
-->
    <type>
      <xsl:choose>
        <xsl:when test="name(.)='mandatory'">M<xsl:text></xsl:text></xsl:when>
        <xsl:when test="name(.)='emerging'">E<xsl:text></xsl:text></xsl:when>
        <xsl:when test="name(.)='fading'">F<xsl:text></xsl:text></xsl:when>
      </xsl:choose>
    </type>
    <id><xsl:value-of select="@id"/></id>
    <text><xsl:value-of select="."/></text>
  </standard>
</xsl:template>


<xsl:template match="ncsp-view" mode="viewpos">
  <xsl:value-of select="position()"/>
</xsl:template>


</xsl:stylesheet>
