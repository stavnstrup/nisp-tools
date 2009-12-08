<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to identify duplex records in  the starndard database.

Output from the transformation should be piped into the stylesheet
db-date2.xsl

Copyright (c) 2003,2008  Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  
<xsl:output method="xml" indent="no" saxon:next-in-chain="db-dates2.xsl"/>


<xsl:template match="standards">
  <xsl:message>Generating DB Dates</xsl:message>
  <xsl:message>  sort all time events</xsl:message>
  <history>
    <xsl:apply-templates select=".//event">
      <xsl:sort select="@date" order="descending"/>
    </xsl:apply-templates>
  </history>
</xsl:template>

<xsl:template match="event">
  <xsl:variable name="myid" select="ancestor::standardrecord/@id|ancestor::profilerecord/@id"/>

  <event>
    <rec><xsl:number from="ta-standards" count="standardrecord|profilerecord" format="1" level="any"/></rec>
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
    <id><xsl:value-of select="ancestor::standardrecord/@id|ancestor::profilerecord/@id"/></id>
    <tag><xsl:value-of select="ancestor::standardrecord/@tag|ancestor::profilerecord/@tag"/></tag>
    <stage><xsl:value-of select="ancestor::standardrecord/status/@stage|ancestor::profilerecord/status/@stage"/></stage>
    <ncsp>
      <xsl:if test="/*/servicearea/servicecategory/*/sp-list/sp-view/mandatory[@id=$myid]">M</xsl:if>
      <xsl:if test="/*/servicearea/servicecategory/*/sp-list/sp-view/emerging[@id=$myid]">E</xsl:if>
      <xsl:if test="/*/servicearea/servicecategory/*/sp-list/sp-view/midterm[@id=$myid]">EM</xsl:if>
      <xsl:if test="/*/servicearea/serviceclass/*/sp-list/sp-view/farterm[@id=$myid]">EF</xsl:if>
      <xsl:if test="/*/servicearea/serviceclass/*/sp-list/sp-view/fading[@id=$myid]">F</xsl:if>
    </ncsp>
    <date><xsl:value-of select="@date"/></date>
    <flag><xsl:value-of select="@flag"/></flag>
    <rfcp><xsl:value-of select="@rfcp"/></rfcp>
    <version><xsl:value-of select="@version"/></version>
  </event>
</xsl:template>



</xsl:stylesheet>
