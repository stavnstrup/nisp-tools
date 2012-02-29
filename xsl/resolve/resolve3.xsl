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

  <!-- Get the  the type attribute -->
  <xsl:variable name="type">
    <xsl:call-template name="dbmerge-attribute">
      <xsl:with-param name="pi" select="$pis"/>
      <xsl:with-param name="attribute" select="'type'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- Get the  the name attribute -->
  <xsl:variable name="name">
    <xsl:call-template name="dbmerge-attribute">
      <xsl:with-param name="pi" select="$pis"/>
      <xsl:with-param name="attribute" select="'name'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- Get the  the mode attribute -->
  <xsl:variable name="mode">
    <xsl:call-template name="dbmerge-attribute">
      <xsl:with-param name="pi" select="$pis"/>
      <xsl:with-param name="attribute" select="'mode'"/>
    </xsl:call-template>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>PI: </xsl:text>
    <xsl:value-of select="$pis"/>
  </xsl:message>
  <xsl:message>
    <xsl:text>Type: </xsl:text>
    <xsl:value-of select="$type"/>
  </xsl:message>
  <xsl:message>
    <xsl:text>Name: </xsl:text>
    <xsl:value-of select="$name"/>
  </xsl:message>
  <xsl:message>
    <xsl:text>Mode: </xsl:text>
    <xsl:value-of select="$mode"/>
  </xsl:message>
  <xsl:message/>
-->

  <xsl:choose>
    <xsl:when test="$type='servicearea'">
      <xsl:apply-templates select="$db//servicearea[@id=$name]">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$type='subarea'">
      <xsl:apply-templates select="$db//subarea[@id=$name]">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="yes">You can only merge servicearea and subarea elements.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
<!--
  <xsl:choose>
    <xsl:when test="starts-with($pis, 'area=')">

      <xsl:if test="not($area='')">
        <xsl:apply-templates select="$db//servicearea[@id=$area]"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="starts-with($pis, 'subarea=')">
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
-->
</xsl:template>


<xsl:template match="XXXprocessing-instruction('dbmerge')">

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
      <xsl:variable name="mode">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'mode'"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:message>
         <xsl:text>PI: </xsl:text>
         <xsl:value-of select="$pis"/>
      </xsl:message>
      <xsl:message>
         <xsl:text>Area: </xsl:text>
         <xsl:value-of select="$area"/>
      </xsl:message>
      <xsl:message>
         <xsl:text>Mode: </xsl:text>
         <xsl:value-of select="$mode"/>
      </xsl:message>

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

<xsl:template match="select|remarks">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->



<xsl:template match="@*" mode="addindexentry">
  <xsl:variable name="id" select="."/>

  <xsl:variable name="record" select="$db//standard[@id=$id]|$db//profile[@id=$id]"/>
  <xsl:for-each select="$record//document">
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
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
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
        <entry>
          <xsl:choose>
            <xsl:when test="$mode='midterm'">EMERGING MID TERM</xsl:when>
            <xsl:when test="$mode='farterm'">EMERGING FAR TERM</xsl:when>
          </xsl:choose>
        </entry>
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
      <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="servicecategory" mode="sa-children">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>       
      <xsl:apply-templates select="subarea" mode="sa-children">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="subarea" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="servicecategory" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="servicecategory" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="category" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="category" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry/>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="subcategory" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="subcategory" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <row>
    <entry/>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="sp-list" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <xsl:apply-templates  mode="sa-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>



<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="sa-children">
  <xsl:param name="mode" select=""/>

  <xsl:if test="./header or ./subclass or contains(./select/@mode, $mode)">
    <row>
      <entry/><entry/>
      <entry><xsl:apply-templates 
           select="./select[@mode=$mode]"/><xsl:apply-templates
           select="./select[@mode=$mode]/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->



<xsl:template match="subarea">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <informaltable frame="all" pgwide="1">
  <tgroup cols="3">
    <colspec colwidth="25*" colname="c1" />
    <colspec colwidth="25*"/>
    <colspec colwidth="50*" colname="c3"/>
    <thead>
      <row>
        <entry>SERVICECATEGORY / CATEGORY / SUBCATEGORY</entry>
        <entry>
          <xsl:choose>
            <xsl:when test="$mode='midterm'">EMERGING MID TERM</xsl:when>
            <xsl:when test="$mode='farterm'">EMERGING FAR TERM</xsl:when>
          </xsl:choose>
        </entry>
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
      <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="servicecategory" mode="subarea-children">
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="servicecategory" mode="subarea-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="category" mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="category" mode="subarea-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="subcategory" mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="subcategory" mode="subarea-children">
  <xsl:param name="mode" select=""/>

  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="sp-list" mode="subarea-children">
  <xsl:param name="mode" select=""/>

  <xsl:apply-templates  mode="subarea-children">
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>

<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="subarea-children">
  <xsl:param name="mode" select=""/>

  <xsl:if test="./header or ./subclass or ./select[@mode=$mode]">
    <row>
      <entry/>
      <entry><xsl:apply-templates 
           select="./select[@mode=$mode]"/><xsl:apply-templates
           select="./select[@mode=$mode]/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->


</xsl:stylesheet>
