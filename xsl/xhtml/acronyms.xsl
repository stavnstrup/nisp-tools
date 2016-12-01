<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                version='1.1'>

<!--

Name        : acronyms.xsl

Description : This stylesheet is created for the NATO Interoperability
              Standards and Profiles, and is intended for the creation
              of the acronyms pages.

              Copyright (C) 2001, 2013 Jens Stavnstrup/DALO <stavnstrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and
              NATO Command, Control and Consultation Organisation.(NC3O)
-->

<!-- ==================================================================== -->

<xsl:import href="html-common.xsl"/>

<xsl:output omit-xml-declaration="yes"/>

<xsl:param name="encoding" select="'UTF-8'"/>


<!-- Set by build file -->
<xsl:param name="nisp.lifecycle.stage" select="''"/>
<xsl:param name="nisp.lifecycle.postfix" select="''"/>
<xsl:param name="nisp.class.label" select="''"/>
<xsl:param name="nisp.release.label" select="''"/>


<xsl:template name="anchor"/>

<!-- ==================================================================== -->

<xsl:template match="acrogroup" mode="mkLetterBar">
  <xsl:param name="letter" select=""/>

  <xsl:variable name="navletter"><xsl:value-of select="@tag"/></xsl:variable>

  <dd xmlns="http://www.w3.org/1999/xhtml">
    <xsl:choose>
      <xsl:when test="$navletter = $letter">
        <xsl:attribute name="class">active</xsl:attribute>
        <xsl:value-of select="$letter"/>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">
            <xsl:choose>
              <xsl:when test="$navletter = 'A'">index.html</xsl:when>
              <xsl:otherwise>
                <xsl:text>acronyms-</xsl:text>
                <xsl:value-of select="$navletter"/>
                <xsl:text>.html</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="$navletter"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </dd>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="acrogroup">
  <xsl:variable name="letter"><xsl:value-of select="@tag"/></xsl:variable>

  <xsl:variable name="documentname">
    <xsl:choose>
      <xsl:when test="$letter='A'">index.html</xsl:when>
      <xsl:otherwise>acronyms-<xsl:value-of select="$letter"/>.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:document href="{$documentname}"
                method="saxon:xhtml" indent="yes"
                omit-xml-declaration="yes"
                encoding="{$encoding}" saxon:next-in-chain="html5.xsl">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
      <title>NC3 Acronyms</title>
      <link rel="stylesheet" href="../css/nisp.css" type="text/css" media="all" />
      <meta name="author" content="Interoperability Capability Team (IP CaT)" />
    </head>
    <body>
      <xsl:call-template name="create-header"/>
      <xsl:call-template name="create-menubar"/>
      <div id="container" class="row">
        <div id="acronyms" class="twelve columns">
          <dl class="sub-nav">
            <dt></dt>
            <xsl:apply-templates select="../acrogroup" mode="mkLetterBar">
              <xsl:with-param name="letter" select="$letter"/>
            </xsl:apply-templates>
          </dl>

          <table id="acrotable" border="0">
            <tr>
              <td width="23%"><b>Acronyms</b></td>
              <td width="54%"><b>Meaning /<br />Significance</b></td>
              <td width="23%"><b>Source</b></td>
            </tr>
            <xsl:if test="count(acronym)>0">
              <xsl:apply-templates/>
            </xsl:if>
          </table>
          <div id="acrofoot">Last Updated on <xsl:value-of select="//lastupdated"/>
             by <xsl:value-of select="//authority"/></div>
        </div>
      </div>
      <xsl:call-template name="nisp.footer"/>
    </body>
    </html>
  </xsl:document>
</xsl:template>


<xsl:template match="acronym">
  <tr xmlns="http://www.w3.org/1999/xhtml">
    <td width="23%"><xsl:value-of select="name"/></td>
    <td width="54%"><xsl:value-of select="meaning"/></td>
    <td width="23%"><xsl:value-of select="source"/></td>
  </tr>
</xsl:template>

<xsl:template match="lastupdated|authority"/>

<xsl:template match="text()"/>


<xsl:template match="accronyms">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>NC3 Acronyms</title>
    <link rel="stylesheet" href="../css/nisp.css" type="text/css" media="all" />
    <script src="../javascripts/modernizr.foundation.js" />
    <meta name="author" content="Interoperability Capability Team (IP CaT)" />
  </head>
  <body>
    <div id="container" class="row">
      <div id="acronyms" class="twelve columns">
        <table id="acrotable" border="0">
          <tr>
            <td width="23%" valign="top" align="left"><b>Acronyms</b></td>
            <td width="54%" valign="top" align="left"><b>Meaning /<br />Significance</b></td>
            <td width="23%" valign="top" align="left"><b>Source</b></td>
          </tr>
          <xsl:apply-templates select=".//acronym"/>
        </table>
      </div>
    </div>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
