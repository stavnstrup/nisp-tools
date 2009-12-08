<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NC3 Technical Architecture, and is
intendet for the one-page HTML version.

Copyright (c) 2001, Jens Stavnstrup/DDRE <js@ddre.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns:saxon="http://icl.com/saxon"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#default">

<xsl:import href="../docbook-xsl/xhtml/chunk.xsl"/>

<xsl:output method="saxon:xhtml" encoding="utf-8" omit-xml-declaration="yes"
indent="yes"/>

<!-- TOC and secrion parameters -->

<xsl:param name="section.label.includes.component.label" select="1"/>

<xsl:param name="section.autolabel" select="1"/>

<xsl:variable name="toc.section.depth">2</xsl:variable>

<xsl:param name="generate.component.toc" select="2"/>

<xsl:param name="generate.section.toc.level" select="2"/>

<xsl:param name="generate.toc">
  book toc
</xsl:param> 

<!-- Extension functions -->

<xsl:param name="linenumbering.everyNth" select="'1'"/>
<xsl:param name="linenumbering.extension" select="'1'"/>

<xsl:param name="use.extensions" select="1"/>

<xsl:param name="use.tablecolumns.extension" select="1"/>

<xsl:param name="saxon.tablecolumns" select="1"/>



<xsl:param name="spacing.paras" select="1"/>


<xsl:param name="biography.collection" select="biography.xml"/>

<xsl:param name="id.warnings" select="0"/>

<!--

<xsl:param name="html.stylesheet">../style/nc3ta.css</xsl:param>


  <xsl:param name="chapter.autolabel" select="0"/>
-->


<!-- from autoc (in 1.50.0) -->

<!-- We don't want the toc in chapters and sections -->

<!--
<xsl:template name="component.toc">
      <xsl:variable name="nodes" select="section|sect1|refentry
                                         |article|bibliography|glossary
                                         |appendix|bridgehead[not(@renderas)]
                                         |.//bridgehead[@renderas='sect1']"/>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:element name="{$toc.list.type}">
            <xsl:apply-templates select="$nodes" mode="toc"/>
          </xsl:element>
        </div>
      </xsl:if>
</xsl:template>




<xsl:template name="section.toc">
  <xsl:variable name="nodes"
                select="section|sect1|sect2|sect3|sect4|sect5|refentry
                        |bridgehead"/>
  <xsl:if test="$nodes">
    <div class="toc">
      <xsl:element name="{$toc.list.type}">
        <xsl:apply-templates select="$nodes" mode="toc"/>
      </xsl:element>
    </div>
  </xsl:if>
</xsl:template>
-->


</xsl:stylesheet>

