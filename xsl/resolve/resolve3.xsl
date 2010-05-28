<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NATO Interoperability Standard and
profiles (NISP), and is intended for resolving volume 3.

Copyright (c) 2002-2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

$Id$

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



<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbmerge')">

  <xsl:variable name="pis"><xsl:value-of select="."/></xsl:variable>

  <xsl:choose>
    <xsl:when test="starts-with($pis, 'area=')">
      <!-- Get the  the area attribute -->
      <xsl:variable name="area">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'area'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not($area='')">
        <xsl:apply-templates select="$db//servicearea[@id=$area]"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="starts-with($pis, 'subarea=')">
      <!-- Get the  the subarea attribute -->
      <xsl:variable name="subarea">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'subarea'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not($subarea='')">
        <xsl:apply-templates select="$db//subarea[@id=$subarea]"/>
      </xsl:if>
    </xsl:when>
  </xsl:choose>  
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbmerge-attribute">
  <xsl:param name="pi" select="./processing-instruction('dbmerge')"/>
  <xsl:param name="attribute"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="contains($pi, concat($attribute, '='))">
      <xsl:variable name="rest" 
            select="substring-after($pi, concat($attribute, '='))"/>    
      <xsl:variable name="quote" select="substring($rest, 1, 1)"/>
      <xsl:value-of select="substring-before(substring($rest,2), $quote)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- not found -->
      <xsl:choose>
        <xsl:when test="$attribute='area'">
          <xsl:message terminate="yes">Servicearea id not found.</xsl:message>
	</xsl:when>
        <xsl:when test="$attribute='subarea'">
	  <xsl:message terminate="yes">Subarea id not found</xsl:message>
        </xsl:when>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
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


<!-- ==================================================================== -->


<xsl:template match="ncoe"/>

<xsl:template match="select|remarks">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->



<xsl:template match="@*" mode="addindexentry">
  <xsl:variable name="id" select="."/>

  <xsl:variable name="record" select="$db//standardrecord[@id=$id]|$db//profilerecord[@id=$id]"/>
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


<!-- ==================================================================== -->


<xsl:template match="servicearea">
  <informaltable frame="all" pgwide="1">
  <tgroup cols="4">
    <colspec colwidth="20*" colname="c1" />
    <colspec colwidth="20*"/>
    <colspec colwidth="30*"/>
    <colspec colwidth="30*" colname="c6"/>
    <thead>
      <row>
        <entry>SUBAREA / SERVICE CATEGORY</entry>
	<entry>CATEGORY / SUBCATEGORY</entry>
        <entry>EMERGING MID TERM</entry>
        <entry>Remarks</entry>
      </row>
<!--
      <row>
        <entry namest="c1" nameend="c6" align="left"><emphasis  role="bold"><xsl:text>Service Area : </xsl:text><xsl:call-template name="capitalize">
          <xsl:with-param name="string" 
               select="@title"/></xsl:call-template></emphasis></entry>
      </row>
-->
    </thead>
    <tbody>
      <xsl:apply-templates select="sp-list" mode="sa-children"/>
      <xsl:apply-templates select="servicecategory" mode="sa-children"/>
      <xsl:apply-templates select="subarea" mode="sa-children"/>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="subarea" mode="sa-children">
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="sa-children"/>
  <xsl:apply-templates select="servicecategory" mode="sa-children"/>
</xsl:template>


<xsl:template match="servicecategory" mode="sa-children">
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="sa-children"/>
  <xsl:apply-templates select="category" mode="sa-children"/>
</xsl:template>


<xsl:template match="category" mode="sa-children">
  <row>
    <entry/>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="sa-children"/>
  <xsl:apply-templates select="subcategory" mode="sa-children"/>
</xsl:template>


<xsl:template match="subcategory" mode="sa-children">
  <row>
    <entry/>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="sa-children"/>
</xsl:template>


<xsl:template match="sp-list" mode="sa-children">
   <xsl:apply-templates  mode="sa-children"/>
</xsl:template>



<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="sa-children">
  <xsl:if test="./header or ./subclass or contains(./select/@mode, 'midterm')">
    <row>
      <entry/><entry/>
      <entry><xsl:apply-templates 
           select="./select[@mode='midterm']"/><xsl:apply-templates
           select="./select[@mode='midterm']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->



<xsl:template match="subarea">
  <informaltable frame="all" pgwide="1">
  <tgroup cols="3">
    <colspec colwidth="25*" colname="c1" />
    <colspec colwidth="25*"/>
    <colspec colwidth="50*" colname="c3"/>
    <thead>
      <row>
        <entry>SERVICECATEGORY / CATEGORY / SUBCATEGORY</entry>
        <entry>EMERGING MID TERM</entry>
        <entry>Remarks</entry>
      </row>
<!--
      <row>
        <entry namest="c1" nameend="c5" align="left"><emphasis  role="bold"><xsl:text>Subarea : </xsl:text><xsl:call-template name="capitalize">
          <xsl:with-param name="string" 
               select="@title"/></xsl:call-template></emphasis></entry>
      </row>
-->
    </thead>
    <tbody>
      <xsl:apply-templates select="sp-list" mode="subarea-children"/>
      <xsl:apply-templates select="servicecategory" mode="subarea-children"/>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="servicecategory" mode="subarea-children">
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="subarea-children"/>
  <xsl:apply-templates select="category" mode="subarea-children"/>
</xsl:template>


<xsl:template match="category" mode="subarea-children">
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="subarea-children"/>
  <xsl:apply-templates select="subcategory" mode="subarea-children"/>
</xsl:template>


<xsl:template match="subcategory" mode="subarea-children">
  <row>
    <entry><emphasis><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="sp-list" mode="subarea-children"/>
</xsl:template>


<xsl:template match="sp-list" mode="subarea-children">
  <xsl:apply-templates  mode="subarea-children"/>
</xsl:template>

<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="subarea-children">
  <xsl:if test="./header or ./subclass or ./select[@mode='midterm']">
    <row>
      <entry/>
      <entry><xsl:apply-templates 
           select="./select[@mode='midterm']"/><xsl:apply-templates
           select="./select[@mode='midterm']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->


</xsl:stylesheet>
