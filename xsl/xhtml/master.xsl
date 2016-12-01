<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

Name:         master.xml

Description:  This stylesheet is created for the NATO Interoperability Standards and Profiles, and is
              intended for the NISP XHTML "container" documents
              in src/master/.

              Copyright (C) 2001, 2014 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and
              NATO Command, Control and Consultation Organisation.(NC3O)

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                version='1.1'>


<xsl:import href="../common/common.xsl"/>

<xsl:import href="html-common.xsl"/>


<xsl:output output="saxon:xhtml" saxon:next-in-chain="html5.xsl"/>


<!-- Set by build file -->
<xsl:param name="nisp.lifecycle.stage" select="''"/>
<xsl:param name="nisp.lifecycle.postfix" select="''"/>
<xsl:param name="nisp.class.label" select="''"/>
<xsl:param name="nisp.release.label" select="''"/>



<xsl:template name="system.head.content">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width" />
</xsl:template>




<!-- ==================================================================== -->

<xsl:template name="user.preroot"/>


<!-- ==================================================================== -->
<!--                                                                      -->
<!-- ==================================================================== -->

<!--
<xsl:template match="/">
  <xsl:apply-templates select="chapter"/>
</xsl:template>
-->

<xsl:template match="xhtml:head">
  <head xmlns="http://www.w3.org/1999/xhtml">
    <meta charset="UTF-8" />
    <meta http-equiv="Content-Language" content="en-uk" />
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />

    <title><xsl:value-of select="title"/></title>
    <link rel="stylesheet" href="css/nisp.css" type="text/css" media="all" />
    <meta name="author" content="Interoperability Capability Team (IP CaT)" />
  </head>
</xsl:template>

<xsl:template name="anchor"/>

<xsl:template match="xhtml:html">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="xhtml:head"/>
  <body>
    <xsl:call-template name="create-header">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>
    <xsl:call-template name="create-menubar">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>

    <div class="row" id="container">
      <xsl:choose>
        <xsl:when test="@id='PDFcoverdoc'">
          <div class="twelve columns pdffiles" id="docbook">
            <xsl:apply-templates select="xhtml:body"/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="nine columns" id="docbook">
            <xsl:apply-templates select="xhtml:body"/>
          </div>
          <div class="three columns">
            <div class="panel getpdf">
              <h5>NISP in PDF</h5>
              <p>Get all NISP volumes as PDF files.</p>
              <div class="btn"><a class="small button" href="PDFcoverdoc.html">Get PDF</a></div>
              <hr />
              <h5>NISP Database</h5>
              <p>Search the database.</p>
              <div class="btn"><a class="small button" href="https://nhqc3s.hq.nato.int/Apps/Architecture/NISP2/">Search</a></div>
            </div>
          </div>
        </xsl:otherwise>
	</xsl:choose>
    </div>
    <xsl:call-template name="nisp.footer">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>
  </body>
  </html>
</xsl:template>



<xsl:template match="a[@class='check.lifecycle.postfix'] ">
  <xsl:variable name="new.file.name">
    <xsl:value-of select="substring-before(./@href,'.')"/>
    <xsl:if test="$nisp.lifecycle.stage != 'draft'">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$nisp.lifecycle.stage"/>
    </xsl:if>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring-after(./@href,'.')"/>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$new.file.name"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>




</xsl:stylesheet>
