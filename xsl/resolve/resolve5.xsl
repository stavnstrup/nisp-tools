<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NATO Interoperability Standard and
profiles (NISP), and is intended for merging of the standard database
and the rationale document.

Copyright (c) 2002-2009, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistics Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="#default saxon">


<xsl:import href="../common/common.xsl"/>
<xsl:import href="resolve-common.xsl"/>


<xsl:output method="xml" indent="no"
            saxon:next-in-chain="resolve-fix.xsl"/>



<xsl:variable name="db"
              select="document(concat($dbdir, $dbname))"/>


<xsl:preserve-space elements="informaltable"/>

<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A MERGED VERSION OF
     
     THE RATIONALE DOCUMENT AND THE STANDARD DATABASE

  </xsl:comment>
  <xsl:apply-templates/>
</xsl:template>  


<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbmerge')">

  <!-- We don't care what the argument is, just process everything -->

  <xsl:apply-templates select="$db//standards"/>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="indexterm">
  <xsl:variable name="orgid" select="./primary"/>

  <xsl:variable name="orgname">
    <xsl:choose>
      <xsl:when test="$orgid != ''"><xsl:value-of
                select="$db//standards/organisations/orgkey[@key=$orgid]/@text"/></xsl:when>
      <xsl:otherwise><primary><xsl:text>UNKNOWN ORG</xsl:text></primary></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$use.show.indexterms != 0">
    <emphasis role="bold">
      <xsl:text> [</xsl:text>
      <xsl:value-of select="$orgname"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="./secondary"/>
      <xsl:text>] </xsl:text>
    </emphasis>
  </xsl:if>

  <indexterm>
    <primary><xsl:value-of select="$orgname"/></primary>
    <xsl:copy-of select="secondary"/>
  </indexterm>
</xsl:template>


<xsl:template match="comment()"/>


<xsl:template match="ncoe|select|remarks|rationale">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="standards">
  <informaltable frame="all" pgwide="1">
  <tgroup cols="6">
    <colspec colwidth="18*" colname="c1"/>
    <colspec colwidth="17*"/>
    <colspec colwidth="17*"/>
    <colspec colwidth="17*"/>
    <colspec colwidth="13*"/>
    <colspec colwidth="18*" colname="c6"/>
    <thead>
      <row>
        <entry>SUBAREA / SERVICE CATEGORY</entry>
        <entry>CATEGORY / SUBCATEGORY</entry>
        <entry>MANDATORY STANDARDS</entry>
        <entry>EMERGING NEAR TERM</entry>
        <entry>FADING</entry>
        <entry>Rationale</entry>
      </row>
    </thead>
  
    <xsl:apply-templates select="servicearea"/>
  </tgroup>
  </informaltable>
</xsl:template>

<!-- ==================================================================== -->
<!-- Note that this template erroranousley created multiple tbody 
     element. 
     
     However, when translating the resulting document to XHTML and PDF,
     no error occurs in the final document.  
-->


<xsl:template match="servicearea">
  <tbody>
    <row>
      <entry namest="c1" nameend="c6" align="left"><emphasis role="bold"><xsl:call-template name="capitalize">
        <xsl:with-param name="string" 
        select="./@title"/></xsl:call-template></emphasis></entry>
    </row>
    <xsl:apply-templates select="sp-list"/>
    <xsl:apply-templates select="subarea"/>
    <xsl:apply-templates select="servicecategory"/>
  </tbody>
</xsl:template>


<!-- ==================================================================== -->


<xsl:template match="subarea">
  <row>
    <entry align="left"><emphasis
           role="bold"><xsl:value-of select="./@title"/></emphasis>
    </entry><entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list"/>
  <xsl:apply-templates select="servicecategory"/>
</xsl:template>

<!-- ==================================================================== -->


<xsl:template match="servicecategory">
  <row>
    <entry align="left"><xsl:value-of select="./@title"/></entry>
    <entry/><entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list"/>
  <xsl:apply-templates select="category"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="category">
  <row>
    <entry/>
    <entry align="left"><emphasis
           role="bold"><xsl:value-of select="./@title"/></emphasis></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list"/>
  <xsl:apply-templates select="subcategory"/>
</xsl:template>



<!-- ==================================================================== -->

<xsl:template match="subcategory">
  <row>
    <entry/>
    <entry align="left"><xsl:value-of select="./@title"/></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list"/>
</xsl:template>



<!-- ==================================================================== -->


<xsl:template match="sp-list">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="sp-view">

  <xsl:if test="./header or ./subclass or ./select[@mode='mandatory'] or
                ./select[@mode='emerging'] or ./select[@mode='fading']">
    <row>
      <entry/><entry/>
      <entry><xsl:apply-templates select="./select[@mode='mandatory']"/><xsl:apply-templates 
             select="select[@mode='mandatory']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates 
           select="./select[@mode='emerging']"/><xsl:apply-templates
           select="./select[@mode='emerging']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./select[@mode='fading']"/></entry>
      <entry><xsl:apply-templates select="./rationale"/></entry>
    </row>
  </xsl:if>
</xsl:template>



<xsl:template match="@*" mode="addindexentry">
  <xsl:variable name="id" select="."/>

  <xsl:variable name="record" select="$db//standardrecord[@id=$id]|$db//profilerecord[@id=$id]"/>
<!--
  <xsl:message>
    <xsl:text>id : </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$record/@id"/>
  </xsl:message>
-->
  <xsl:for-each select="$record//standard">
     <xsl:variable name="org" select="@orgid"/>
     <indexterm>
       <xsl:choose>
         <xsl:when test="@orgid != ''"><primary><xsl:value-of
                   select="ancestor::standards/organisations/orgkey[@key=$org]/@text"/></primary></xsl:when>
         <xsl:otherwise><primary><xsl:text>UNKNOWN ORG</xsl:text></primary></xsl:otherwise>
       </xsl:choose>
       <xsl:choose>
         <xsl:when test="@pubnum != ''"><secondary><xsl:value-of select="./@pubnum"/></secondary></xsl:when>
       </xsl:choose>
     </indexterm>
    </xsl:for-each>
</xsl:template>



</xsl:stylesheet>


