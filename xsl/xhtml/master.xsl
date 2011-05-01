<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

Name:         master.xml

Description:  This stylesheet is created for the NC3 Technical Architecture, and is
              intendet for the NC3 TA HTML "container" documents
              in src/master/.

              Copyright (C) 2001,2011 Jens Stavnstrup/DALO <stavnatrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and 
              NATO Command, Control and Consultation Organisation.(NC3O)

$Id $

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                version='1.1'>


<xsl:import href="../docbook-xsl/xhtml/docbook.xsl"/>

<xsl:import href="../common/common.xsl"/>

<xsl:import href="html-common.xsl"/>


<xsl:output method="saxon:xhtml" encoding="ISO-8859-1"
            doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>



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

<xsl:param name="chunk.section.depth" select="1"/>

<xsl:param name="html.extra.head.links" select="1"/>


<!-- By default we don't include the
     Implementation handbook of the HTMLHelp page version -->

<xsl:param name="include.ihb" select="0"/>

<xsl:param name="include.hhc" select="0"/>

<xsl:param name="id.warnings" select="0"/>


<!-- ==================================================================== -->
<!--          Create NavigationBar for master documents                   -->
<!-- ==================================================================== -->


<xsl:template name="create-navbar">

  <xsl:variable name="menu" select="/processing-instruction('menu')"/>

  <div id="nav" xmlns="http://www.w3.org/1999/xhtml">
    <ul>
      <xsl:choose>
        <xsl:when test="$menu='contact'">
          <li id="menuhead">Contacts</li>
          <li><a href="userinfo.html">User information</a></li>
          <li><a href="introduction.html">Introduction</a></li>
          <li><a href="member.html">Becoming a member</a></li>
        </xsl:when>

        <xsl:when test="$menu='disclaimer'">
          <li id="menuhead">Disclaimer</li>
        </xsl:when>

        <xsl:otherwise>
          <li id="menuhead">NISP Volumes</li>
       
          <xsl:variable name="docs" select="document('../../src/documents.xml')"/>
          <xsl:variable name="bookid" select="/book/@id"/>

          <li><a href="about.html">About the volumes</a></li>

          <xsl:for-each select="$docs//docinfo">
            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:text></xsl:text>
                  <xsl:value-of select="../@dir"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="./targets/target[@type='html']"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="./titles/longtitle"/>
                </xsl:attribute>
                <xsl:value-of select="./titles/short"/>
                <xsl:if test="not(./titles/short='')">
                  <xsl:text> - </xsl:text>
                </xsl:if>
                <xsl:value-of select="./titles/longtitle"/>
              </a>
            </li>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <li><img src="images/menu_icon-onder.gif" alt="NATO Logo" width="195" height="72"/></li>
    </ul>
  </div>
</xsl:template>



<!-- ==================================================================== -->
<!--                                                                      -->
<!-- ==================================================================== -->


<xsl:template match="/">
  <xsl:apply-templates select="chapter"/>
</xsl:template>

<xsl:template match="chapter">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><xsl:value-of select="./chapterinfo/title"/></title>
    <link rel="stylesheet" href="css/nisp.css" type="text/css" media="all" />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <meta http-equiv="Content-Language" content="en-uk" />
    <meta name="MSSmartTagsPreventParsing" content="true" />
    <meta name="author" content="NATO Open Systems Working Group (NOSWG)" /> 
   
<!--
      #tophead { background-image: url(images/cgey/logo_NATO-top.gif); }
      #bottomhead { background-image: url(images/cgey/logo_NATO-bottom.gif); }
      #menubar { background-image: url(images/cgey/menu_strook.gif); }
      #taFooter { background-image: url(images/cgey/credit_strook.gif); }
    </style>
-->
  </head>
  <body>
    <xsl:call-template name="create-header">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>

    <xsl:call-template name="create-menubar">
      <xsl:with-param name="prefix" select="''"/>
    </xsl:call-template>

    <div id="container">
      <div id="nav">
        <xsl:call-template name="create-navbar"/>
      </div>
      <div id="docbook">
        <xsl:apply-templates select="chapterinfo" mode="titlepage.mode"/>
        <xsl:apply-templates/>
      </div>
    </div>
    <div id="footer">Copyright &#x00A9; NATO - OTAN 1998-2011 | <a href="disclaimer.html">Disclaimer</a></div>

  </body>
  </html>
</xsl:template>


<xsl:template match="ulink[@condition='fix.for.internet']">
  <xsl:variable name="new.file.name">
    <xsl:value-of select="substring-before(./@url,'.')"/>
    <xsl:value-of select="$nisp.lifecycle.postfix"/>
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

