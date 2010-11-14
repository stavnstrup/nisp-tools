<?xml version="1.0" encoding="ISO-8859-1"?>
<!--

This stylesheet contains templates used by all resolver stylesheets.

Copyright (c) 2003-2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

$Id$

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:param name="dbdir" select="'../../build.src/'"/>
<xsl:param name="dbname" select="'resolved-standards.xml'"/>


<!-- The directory relevant for this document, we need this with PDF and HTMLHelp -->
<xsl:param name="documentdir" select="''"/>
<xsl:param name="docid" select="''"/>
<xsl:param name="nisp.image.ext" select="''"/>

<xsl:param name="use.show.indexterms" select="0"/>

<xsl:param name="svgpdfdebug" select="0"/> 

<xsl:variable name="embedsvg"
	      select="document('../../src/documents.xml')//docinfo[@id=$docid]/targets/target[@type='pdf']/@embedsvg"/>


<!-- ==================================================================== -->


<xsl:template match="book">
  <xsl:message>
    <xsl:text>embedsvg: </xsl:text>
    <xsl:value-of select="$embedsvg"/>
  </xsl:message>
  <xsl:copy>
    <xsl:attribute name="condition"><xsl:value-of select="$documentdir"/></xsl:attribute>
    <xsl:apply-templates select="@*[not(@condition)]"/>
    <xsl:attribute name="id"><xsl:value-of select="$docid"/></xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


<!-- ==================================================================== -->

<!-- Rewrite the mediaobject element -->

<xsl:template match="mediaobject">
  <xsl:element name="mediaobject">
    <xsl:choose>
      <xsl:when test="count(imageobject)>1">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- We have only one imagedata element --> 

        <!-- HTML Version -->
        <xsl:element name="imageobject">
          <xsl:attribute name="role">html</xsl:attribute>
          <xsl:element name="imagedata">
            <xsl:attribute name="fileref">
               <xsl:value-of 
                  select="substring-before(./imageobject/imagedata/@fileref,
                  '.svg')"/>
               <xsl:text>.</xsl:text>
               <xsl:value-of select="$nisp.image.ext"/>
            </xsl:attribute>
            <xsl:apply-templates select="./imagedata/@*[not(@fileref)]"/>
          </xsl:element>
        </xsl:element>

        <!-- FOP Version -->
        <xsl:element name="imageobject">
          <xsl:attribute name="role">fo</xsl:attribute>
          <xsl:element name="imagedata">
            <xsl:attribute name="fileref">
<!--
               <xsl:text>../</xsl:text>
               <xsl:value-of select="$documentdir"/>
               <xsl:text>/</xsl:text>
-->
               <xsl:value-of 
                  select="substring-before(./imageobject/imagedata/@fileref,
                  '.svg')"/>
               <xsl:choose>
                 <xsl:when test="$embedsvg='yes'"><xsl:text>.svg</xsl:text></xsl:when>
                 <xsl:otherwise>
                   <xsl:text>.</xsl:text>
                   <xsl:value-of select="$nisp.image.ext"/>
                 </xsl:otherwise>
	       </xsl:choose>
            </xsl:attribute>
	    <xsl:attribute name="scalefit">1</xsl:attribute>
	    <xsl:attribute name="width">100%</xsl:attribute>
	    <xsl:attribute name="contentdepth">100%</xsl:attribute>
            <xsl:apply-templates select="./imagedata/@*[not(@fileref)]"/>
          </xsl:element>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<!-- ==================================================================== -->


<xsl:template name="dbmerge-attribute">
  <xsl:param name="pi" select="./processing-instruction('dbmerge')"/>
  <xsl:param name="attribute"/>
  <xsl:param name="count" select="1"/>

  <xsl:variable name="pivalue">
    <xsl:value-of select="concat(' ', normalize-space($pi))"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($pivalue, concat(' ', $attribute, '='))">
      <xsl:variable name="rest" select="substring-after($pivalue, concat(' ', $attribute, '='))"/>    
      <xsl:variable name="quote" select="substring($rest, 1, 1)"/>
      <xsl:value-of select="substring-before(substring($rest,2), $quote)"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- not found -->
<!--
      <xsl:choose>
        <xsl:when test="$attribute='area'">
          <xsl:message terminate="yes">Servicearea id not found.</xsl:message>
	</xsl:when>
        <xsl:when test="$attribute='subarea'">
	  <xsl:message terminate="yes">Subarea id not found</xsl:message>
        </xsl:when>
      </xsl:choose>
-->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="*[@condition='ignore']"/>

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
