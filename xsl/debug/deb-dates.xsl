<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to identify duplex standards in  the standard database.

Output from the transformation should be piped into the stylesheet
db-date2.xsl

Copyright (c) 2003, 2014  Jens Stavnstrup/DALO <js@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  
<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-dates.xsl"/>

<xsl:param name="describe" select="''"/>

<xsl:template match="standards">
  <xsl:message>Generating DB Dates</xsl:message>
  <xsl:message>  sort all time events</xsl:message>
  <history describe="{$describe}">
    <xsl:apply-templates select=".//event">
      <xsl:sort select="@date" order="descending"/>
    </xsl:apply-templates>
  </history>
</xsl:template>

<xsl:template match="event">
  <xsl:variable name="myid" select="ancestor::standard/@id|ancestor::interoperabilityprofile/@id"/>

  <event>
    <rec><xsl:number from="standards" count="standard|interoperabilityprofile" format="1" level="any"/></rec>
    <type>
      <xsl:choose>
        <xsl:when test="ancestor::interoperabilityprofile">
          <xsl:text>IP</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::standard">
          <xsl:text>S</xsl:text>
        </xsl:when>
      </xsl:choose>
    </type>
    <id><xsl:value-of select="ancestor::standard/@id|ancestor::interoperabilityprofile/@id"/></id>
    <tag><xsl:value-of select="ancestor::standard/@tag|ancestor::interoperabilityprofile/@tag"/></tag>
    <date><xsl:value-of select="@date"/></date>
    <flag><xsl:value-of select="@flag"/></flag>
    <rfcp><xsl:value-of select="@rfcp"/></rfcp>
    <version><xsl:value-of select="@version"/></version>
  </event>
</xsl:template>



</xsl:stylesheet>
