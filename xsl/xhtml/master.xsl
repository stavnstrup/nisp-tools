<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

Name:         master.xml

Description:  This stylesheet is created for the NATO Interoperability Standards and Profiles, and is
              intendet for the NISP XHTML "container" documents
              in src/master/.

              Copyright (C) 2001, 2013 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and 
              NATO Command, Control and Consultation Organisation.(NC3O)

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                version='1.1'>


<xsl:import href="../docbook-xsl/xhtml5/docbook.xsl"/>
<xsl:import href="../common/common.xsl"/>
<xsl:import href="html-common.xsl"/>


<xsl:output output="saxon:xhtml" saxon:next-in-chain="html5.xsl"/>

<!-- ==================================================================== -->
<!--  Global parameters used to modify the functionality of the DocBook   -->
<!--  XHTML stylesheets                                                   -->
<!-- ==================================================================== -->

<!-- ToC/LoT/Index Generation -->

<xsl:variable name="toc.section.depth">3</xsl:variable>

<!-- Extensions -->

<xsl:param name="use.extensions" select="1"/>

<xsl:param name="tablecolumns.extension" select="1"/>


<!-- Automatic Labeling -->

<xsl:param name="chapter.autolabel" select="0"/>

<xsl:param name="section.autolabel" select="0"/>

<xsl:param name="section.label.includes.component.label" select="0"/>


<!-- HTML -->

<xsl:param name="css.decoration" select="0"/>

<xsl:param name="spacing.paras" select="'1'"/>


<!-- Miscellaneous -->

<xsl:param name="show.comments" select="0"/>


<!-- Chunking -->

<xsl:param name="docbook.css.source"></xsl:param>
<xsl:param name="html.ext">.html</xsl:param>


<xsl:param name="chunk.section.depth" select="1"/>

<xsl:param name="html.extra.head.links" select="1"/>


<!-- By default we don't include the
     Implementation handbook of the HTMLHelp page version -->

<xsl:param name="include.ihb" select="0"/>

<xsl:param name="include.hhc" select="0"/>

<xsl:param name="id.warnings" select="0"/>

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


<xsl:template match="/">
  <xsl:apply-templates select="chapter"/>
</xsl:template>

<xsl:template match="chapter">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="Content-Language" content="en-uk" />
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />    

    <title><xsl:value-of select="./chapterinfo/title"/></title>
    <link rel="stylesheet" href="css/nisp.css" type="text/css" media="all" />
    <script type="text/javascript" src="javascripts/modernizr.foundation.js"></script>
    <meta name="author" content="Interoperability Capability Team (IP CaT)" /> 
  </head>
  <body>
    <xsl:call-template name="create-header">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>
    <xsl:call-template name="create-menubar">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>

    <div class="row" id="container">
      <xsl:choose>
        <xsl:when test="@condition='PDFcoverdoc'">
          <div class="twelve columns pdffiles" id="docbook">
            <xsl:apply-templates select="chapterinfo" mode="titlepage.mode"/>
            <xsl:apply-templates/>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div class="nine columns" id="docbook">
            <xsl:apply-templates select="chapterinfo" mode="titlepage.mode"/>
            <xsl:apply-templates/>
          </div>
          <div class="three columns">
            <div class="panel getpdf">
              <h5>NISP in PDF</h5>
              <p>Get all NISP volumes as PDF files.</p>
              <a class="small button" href="PDFcoverdoc.html">Get PDF</a>
            </div>
          </div>
        </xsl:otherwise>
	</xsl:choose>
    </div>
    <xsl:call-template name="nisp.footer">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>
    <script type="text/javascript" src="javascripts/jquery.js"></script>
    <script type="text/javascript" src="javascripts/foundation.min.js"></script>
    <script type="text/javascript" src="javascripts/app.js"></script>
  </body>
  </html>
</xsl:template>


<xsl:template match="ulink[@condition='check.lifecycle.postfix'] ">
  <xsl:variable name="new.file.name">
    <xsl:value-of select="substring-before(./@url,'.')"/>
    <xsl:if test="$nisp.lifecycle.stage != 'draft'">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$nisp.lifecycle.stage"/>
    </xsl:if>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="substring-after(./@url,'.')"/>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$new.file.name"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
</xsl:template>



</xsl:stylesheet>

