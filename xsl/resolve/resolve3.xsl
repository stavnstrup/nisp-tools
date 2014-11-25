<?xml version="1.0" encoding="utf-8"?>
<!--

This stylesheet is created for the NATO Interoperability Standard and
profiles (NISP), and is intended for resolving volume 2.

Copyright (c) 2014, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO).

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
    <xsl:when test="starts-with($pis, 'serviceprofile=')">
      <!-- Get the  the serviceprofile attribute -->
      <xsl:variable name="sp">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'serviceprofile'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not($sp='')">
        <xsl:apply-templates select="$db//serviceprofile[@id=$sp]"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="starts-with($pis, 'capabilitygroup=')">
      <!-- Get the  the capability attribute -->
      <xsl:variable name="cg">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'capabilitygroup'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not($cg='')">
        <xsl:apply-templates select="$db//subarea[@id=$subarea]"/>
      </xsl:if>
    </xsl:when>
  </xsl:choose>  
</xsl:template>



<xsl:template match="processing-instruction('mergeCapabilityGroup')"/>



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


<xsl:template match="serviceprofile">
  <table frame="all" pgwide="">
    <title><xsl:value-of select="profilespec/@title"/></title>
    <tgroup cols="3">
      <colspec colwidth="20*"/>
      <colspec colwidth="50*"/>
      <colspec colwidth="30*"/>
      <thead>
	<row>
	  <entry>ID:Service/Profile</entry>
	  <entry>Standard</entry>
	  <entry>Implementation Guidance</entry>
	</row>
      </thead>
      <tbody>
	<xsl:apply-templates/>
      </tbody>
    </tgroup>
  </table>
</xsl:template>


<xsl:template match="servicegroup">
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry><xsl:apply-templates select="parts"/></entry>
    <entry><xsl:value-of select="guidance"/></entry>
  </row>
</xsl:template>

<xsl:template match="parts">
  <itemizedlist>
    <xsl:apply-templates/>
  </itemizedlist>
</xsl:template>

<xsl:template match="refstandard|refprofile">
  <listitem><para><xsl:value-of select="@refid"/></para></listitem>
</xsl:template>


<xsl:template match="capabilitygroup">
  
</xsl:template>


<!-- ==================================================================== -->


<xsl:template match="servicearea">
  <xsl:variable name="id" select="@id"/>
  <table frame="all" pgwide="1">
    <title></title>
  <tgroup cols="6">
    <colspec colwidth="18*" colname="c1" />
    <colspec colwidth="17*"/>
    <colspec colwidth="17*"/>
    <colspec colwidth="17*"/>
    <colspec colwidth="13*" />
    <colspec colwidth="18*" colname="c6"/>
    <thead>
      <row>
        <entry>SUBAREA / SERVICE CATEGORY</entry>
	<entry>CATEGORY / SUBCATEGORY</entry>
        <entry>MANDATORY STANDARDS</entry>
        <entry>EMERGING</entry>
        <entry>FADING</entry>
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
      <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
      <xsl:apply-templates select="servicecategory" mode="sa-children"/>
      <xsl:apply-templates select="subarea" mode="sa-children"/>
    </tbody>
  </tgroup>
  </table>
</xsl:template>


<xsl:template match="subarea" mode="sa-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
  <xsl:apply-templates select="servicecategory" mode="sa-children"/>
</xsl:template>


<xsl:template match="servicecategory" mode="sa-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
  <xsl:apply-templates select="category" mode="sa-children"/>
</xsl:template>


<xsl:template match="category" mode="sa-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry/>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
  <xsl:apply-templates select="subcategory" mode="sa-children"/>
</xsl:template>


<xsl:template match="subcategory" mode="sa-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry/>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
</xsl:template>


<xsl:template match="sp-list" mode="sa-children">
   <xsl:apply-templates  mode="sa-children"/>
</xsl:template>



<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="sa-children">
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
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->



<xsl:template match="subarea">
  <xsl:variable name="id" select="@id"/>
  <informaltable frame="all" pgwide="1">
  <tgroup cols="5">
    <colspec colwidth="20*" colname="c1" />
    <colspec colwidth="20*"/>
    <colspec colwidth="20*"/>
    <colspec colwidth="20*"/>
    <colspec colwidth="20*" colname="c5"/>
    <thead>
      <row>
        <entry>SERVICECATEGORY / CATEGORY / SUBCATEGORY</entry>
        <entry>MANDATORY STANDARDS</entry>
        <entry>EMERGING NEAR TERM</entry>
        <entry>FADING</entry>
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
      <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children"/>
      <xsl:apply-templates select="servicecategory" mode="subarea-children"/>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="servicecategory" mode="subarea-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children"/>
  <xsl:apply-templates select="category" mode="subarea-children"/>
</xsl:template>


<xsl:template match="category" mode="subarea-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><xsl:value-of select="@title"/></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children"/>
  <xsl:apply-templates select="subcategory" mode="subarea-children"/>
</xsl:template>


<xsl:template match="subcategory" mode="subarea-children">
  <xsl:variable name="id" select="@id"/>
  <row>
    <entry><emphasis><xsl:value-of select="@title"/></emphasis></entry>
    <entry/><entry/><entry/><entry/>
  </row>
  <xsl:apply-templates select="//sp-list[@tref=$id]" mode="subarea-children"/>
</xsl:template>


<xsl:template match="sp-list" mode="subarea-children">
  <xsl:apply-templates  mode="subarea-children"/>
</xsl:template>

<!--

  Print a SP view: class/subclass, mandatory/emerging standards, applicability and remarks

-->

<xsl:template match="sp-view" mode="subarea-children">
  <xsl:if test="./header or ./subclass or ./select[@mode='mandatory'] or
                ./select[@mode='emerging'] or ./select[@mode='fading']">
    <row>
      <entry/>
      <entry><xsl:apply-templates select="./select[@mode='mandatory']"/><xsl:apply-templates 
             select="select[@mode='mandatory']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates 
           select="./select[@mode='emerging']"/><xsl:apply-templates
           select="./select[@mode='emerging']/@id" mode="addindexentry"/></entry>
      <entry><xsl:apply-templates select="./select[@mode='fading']"/></entry>
      <entry><xsl:apply-templates select="./remarks"/></entry>
    </row>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->


</xsl:stylesheet>
