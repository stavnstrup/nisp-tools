<?xml version='1.0'?>
<!--

Name        : makeNC3TA.xsl

Description : This stylesheet is a customization of Norman Walsh DocBook
              XSL-FO stylesheets  and is used to create a XSL-FO version of 
              the technical architecture. The stylesheet create as output 
              XSL-FO files according to the Word Wide Webs Consortiums 
              specification: "Extensible Stylesheet Language" version 1.0. 
              (see: http://www.w3c.org/REC/2001/XSL.html).

              The stylesheet imports stylesheet modification, which are geared 
              specifically towards The Apache Foundation Formatting Object 
              processor (FOP), which still lack implementation of multiple 
              features.

              If the stylesheet is used, whith another FO processor,
              make at minimum the following modifications to the stylesheet.

              1. Do not import the fop-bugs/*.xsl stylesheets.

              2. Use the appropiate processer extension, if available

              Copyright (C) 2001-2003 Jens Stavnstrup/DDRE <js@ddre.dk>,
              Danish Defence Research Establishment (DDRE) and 
              NATO Command, Control and Consultation Organisation.(NC3O)
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:xtbl="com.nwalsh.xalan.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                exclude-result-prefixes="#default stbl xtbl fox saxon">


<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>
<xsl:import href="nisp-layout.xsl"/>
<xsl:import href="../common/common.xsl"/>
<!--
<xsl:import href="dbxsl-bugs/pagesetup.xsl"/>
-->
<xsl:import href="fo-common.xsl"/>


<!-- Fix FOP bugs -->

<!-- Select output mode -->


<xsl:output method="xml" indent="no"
            saxon:next-in-chain="fop-bugs/fo-post-for-fop.xsl"/>


<!-- ==================================================================== -->
<!--   Global parameters used to modify the functionality of the DocBook  -->
<!--   XSL/FO stylesheets.                                                -->
<!-- ==================================================================== -->


<!-- Processor Extensions -->


<xsl:param name="fop.extensions" select="0"/>
<xsl:param name="fop1.extensions" select="1"/>
<xsl:param name="xep.extensions" select="0"/>

<!-- Stylesheet Extensions -->

<xsl:param name="use.extensions" select="1"/>
<xsl:param name="tablecolumns.extension" select="1"/> 



<xsl:template name="hyphenate-tableentries">
  <xsl:param name="entry" select="''"/>
    <xsl:choose>
      <xsl:when test="$tableentry.hyphenate = ''">
	<xsl:value-of select="$entry"/>
      </xsl:when>
      <xsl:when test="string-length($entry) &gt; 1">
	<xsl:variable name="char" select="substring($entry, 1, 1)"/>
        <xsl:value-of select="$char"/>
        <xsl:if test="contains($tableentry.hyphenate.chars, $char)">
          <!-- Do not hyphen in-between // -->
	  <xsl:if test="not($char = '/' and substring($entry,2,1) = '/')">
            <xsl:copy-of select="$tableentry.hyphenate"/>
	  </xsl:if>
	</xsl:if>
	<!-- recurse to the next character -->
        <xsl:call-template name="hyphenate-tableentries">
	  <xsl:with-param name="entry" select="substring($entry, 2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$entry"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>
				 
<xsl:param name="tableentry.hyphenate.chars">_.-/&amp;</xsl:param>
<xsl:param name="tableentry.hyphenate">­</xsl:param>
				   
<xsl:template match="entry//text()">
  <xsl:call-template name="hyphenate-tableentries">
    <xsl:with-param name="entry" select="."/>
  </xsl:call-template>
</xsl:template>
    

</xsl:stylesheet>
