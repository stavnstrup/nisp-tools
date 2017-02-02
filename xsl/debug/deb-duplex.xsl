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

<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-duplex.xsl"/>


<xsl:template match="standards">
  <xsl:message>Generating DB Duplex</xsl:message>
  <xsl:message>  sort all standards by keys pubnum, orgid</xsl:message>
  <database>
    <xsl:apply-templates select=".//standard">
      <xsl:sort select="@pubnum"/>
      <xsl:sort select="@orgid"/>
    </xsl:apply-templates>
  </database>
</xsl:template>


<xsl:template match="standard">
  <xsl:variable name="myid" select="ancestor::standardrecord/@id|ancestor::profilerecord/@id"/>

  <standard>
    <rec><xsl:number from="ta-standards" count="standardrecord|profilerecord|referencerecord" format="1" level="any"/></rec>
    <std><xsl:number from="ta-standards" count="standard" format="1" level="any"/></std>
    <type>
      <xsl:choose>
        <xsl:when test="ancestor::profilerecord">
          <xsl:text>P</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::standardrecord">
          <xsl:text>S</xsl:text>
        </xsl:when>
      </xsl:choose>
    </type>
    <cs>
      <xsl:if test="descendant::standard">
        <xsl:text>Yes</xsl:text>
      </xsl:if>
    </cs>
    <stage><xsl:value-of select="ancestor::standardrecord/status/@stage|ancestor::profilerecord/status/@stage"/></stage>
    <ncsp>
      <xsl:if test="/*/servicearea/serviceclass/ncsp-list/ncsp-view/mandatory[@id=$myid]">M</xsl:if>
      <xsl:if test="/*/servicearea/serviceclass/ncsp-list/ncsp-view/candidate[@id=$myid]">C</xsl:if>
      <xsl:if test="/*/servicearea/serviceclass/ncsp-list/ncsp-view/fading[@id=$myid]">F</xsl:if>
    </ncsp>
    <org><xsl:value-of select="@orgid"/></org>
    <pubnum><xsl:value-of select="@pubnum"/></pubnum>
    <id><xsl:value-of select="$myid"/></id>
    <tag><xsl:value-of select="ancestor::standardrecord/@tag|ancestor::profilerecord/@tag"/></tag>
    <title><xsl:value-of select="@title"/></title>
    <sa><xsl:value-of select="ancestor::servicearea/@title"/></sa>
    <sc><xsl:value-of select="ancestor::serviceclass/@title"/></sc>
  </standard>
</xsl:template>


<xsl:template match="*"/>


</xsl:stylesheet>
