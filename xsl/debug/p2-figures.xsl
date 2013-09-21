<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default">




<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>

<xsl:param name="fop1.extensions" select="1"/>


<xsl:param name="use.extensions" select="1"/>


<xsl:param name="page.margin.inner" select="'25mm'"/>      <!-- G -->
<xsl:param name="page.margin.outer" select="'25mm'"/>      <!-- H -->
<xsl:param name="page.margin.top" select="'15mm'"/>        <!-- A -->

<xsl:param name="paper.type" select="'A4'"/>
<xsl:param name="double.sided" select="1"/>

<xsl:param name="region.before.extent" select="'42pt'"/>   <!-- B -->
<xsl:param name="body.margin.top" select="'56pt'"/>        <!-- C -->

<xsl:param name="region.after.extent" select="'48pt'"/>    <!-- D -->
<xsl:param name="page.margin.bottom" select="'14mm'"/>     <!-- E -->
<xsl:param name="body.margin.bottom" select="'57pt'"/>     <!-- F -->

<xsl:param name="body.start.indent" select="'0pc'"/>

<xsl:param name="body.font.master" select="12"/>

<xsl:param name="title.margin.left" select="'0pc'"/>

<xsl:param name="draft.mode" select="''"/> <!-- Set by build file -->
<xsl:param name="draft.watermark.image" select="'../images/draft.svg'"/>




</xsl:stylesheet>
