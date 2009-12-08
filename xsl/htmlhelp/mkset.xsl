<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- ===================

 Merge the technical architecture document into one XML file containg a set of books

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.1"
                exclude-result-prefixes="#default">

<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="no"
            doctype-public="-//OASIS//DTD DocBook XML V4.5//EN" 
	    doctype-system="../../src/schema/dtd/docbkx45/docbookx.dtd"/>



<xsl:template match="/">
  <set lang="en">
    <title>NATO Interoperability Standard and Profiles</title>
    <setinfo><releaseinfo/></setinfo>
<!--
    <xsl:apply-templates select="document('nc3ta-info.xml')/book" mode="master"/>
-->
    <xsl:apply-templates select=".//docinfo"/>
    <setindex/>
  </set>
</xsl:template>


<xsl:template match="docinfo">  
  <xsl:variable name="resolvfile">
    <xsl:text>../../build.src/</xsl:text>
    <xsl:value-of select="./@id"/>
    <xsl:text>-resolved.xml</xsl:text>
  </xsl:variable>
  <xsl:apply-templates select="document($resolvfile)//book"/>
</xsl:template>



<!-- Swop title and subtitle,
     It will look stupid, when all document have the title NISP -->


<xsl:template match="//book/bookinfo/title" mode="*">
  <title><xsl:if 
       test="../volumenum &lt; 6">Vol <xsl:value-of 
       select="../volumenum"/> : </xsl:if><xsl:value-of 
       select="../subtitle"/></title>
  <subtitle><xsl:value-of select="."/></subtitle>
</xsl:template>



<xsl:template match="//book/bookinfo/subtitle"/>



<xsl:template match="index"/>


<xsl:template match="imageobject[@role='fop']"/>


<!-- BUG: HTML Help WorkShop don't like references to directories below
     the main project file
-->

<xsl:template match="imagedata/@fileref">
  <xsl:attribute name="fileref">
    <xsl:text>figures/</xsl:text>
    <xsl:value-of select="ancestor::book/@condition"/>
    <xsl:value-of select="substring-after(.,'figures')"/>
  </xsl:attribute>
</xsl:template>

<!-- prefix all id's with bkX in-case new id's are created, which doesn't follow the cnvension  -->

<xsl:template match="@id">
  <xsl:variable name="docid" select="//book/@id"/>

  <xsl:attribute name="id"><xsl:value-of 
       select="concat('bk', $docid, '-')"/><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<!-- Do the same thing with references to id's -->

<xsl:template match="xref[@linkend]">
  <xsl:variable name="docid" select="//book/@id"/>
  <xref>
    <xsl:attribute name="linkend"><xsl:value-of
       select="concat('bk', $docid, '-')"/><xsl:value-of select="@linkend"/></xsl:attribute>
  </xref>
</xsl:template>  

<xsl:template match="foototeref[@linkend]">
  <xsl:variable name="docid" select="//book/@id"/>
  <footnoteref>
    <xsl:attribute name="linkend"><xsl:value-of
       select="concat('bk', $docid, '-')"/><xsl:value-of select="@linkend"/></xsl:attribute>
  </footnoteref>
</xsl:template>  


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


<!-- =========================================================== -->

<!-- Templates used for the master files (src/master/) -->

<xsl:template match="chapterinfo" mode="master"/> 

<xsl:template match="chapter/title" mode="master"/> 


<xsl:template match="section[title='']" mode="master">
  <xsl:apply-templates select="*[name()!='title']" mode="master"/>
</xsl:template>


<xsl:template match="chapter" mode="master">
  <chapter>
    <title><xsl:value-of select="./chapterinfo/title"/></title>
    <xsl:apply-templates mode="master"/>
  </chapter>
</xsl:template>

<xsl:template match="@*|node()" mode="master">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="master"/>
    <xsl:apply-templates mode="master"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
