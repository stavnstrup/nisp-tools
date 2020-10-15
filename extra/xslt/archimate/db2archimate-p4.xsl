<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:am="http://www.opengroup.org/xsd/archimate/3.0/"
                xsi:schemaLocation="http://www.opengroup.org/xsd/archimate/3.0/ http://www.opengroup.org/xsd/archimate/3.1/archimate3_Diagram.xsd"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="am xsi"
                version='2.0'>

<xsl:output indent="yes"/>

<xsl:template match="am:label[../../am:label = 'Relations']">
  <label xmlns="http://www.opengroup.org/xsd/archimate/3.0/">
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </label>
  <xsl:apply-templates select="//am:relationship" mode="listRelation"/>
</xsl:template>

<xsl:template match="am:relationship" mode="listRelation">
  <item xmlns="http://www.opengroup.org/xsd/archimate/3.0/" identifierRef="{@identifier}"/>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
