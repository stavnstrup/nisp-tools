<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to list the parties responsible for providing expert guidedance.

Copyright (c) 2014-2017  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">

<xsl:output indent="yes" saxon:next-in-chain="p3-rp.xsl"/>

<xsl:strip-space elements="*"/>

<xsl:param name="describe" select="''"/>


<xsl:template match="standards">
  <standards describe="{$describe}">
    <xsl:apply-templates select="records|organisations"/>
  </standards>
</xsl:template>

<xsl:template match="standard[not(responsibleparty)]">
  <standard>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="document|applicability"/>
    <responsibleparty rpref="undefined"/>
    <xsl:apply-templates select="status|uuid"/>
  </standard>
</xsl:template>

<xsl:template match="standard[descendant::event[(position()=last()) and (@flag = 'deleted')]]"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
