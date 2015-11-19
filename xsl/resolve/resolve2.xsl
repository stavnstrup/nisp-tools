<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NATO Interoperability Standard and
profiles (NISP), and is intended for resolving volume 2.

Copyright (c) 2002-2015, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
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
    <xsl:when test="starts-with($pis, 'node=')">
      <!-- Get the  the node attribute -->
      <xsl:variable name="node">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	  <xsl:with-param name="attribute" select="'node'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not($node='')">
        <xsl:apply-templates select="$db//node[@id=$node]" mode="highlevel"/>
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

<!-- This template can properly be merged into the procesing
     instruction template, but assumes that the node seleted is at a
     sufficiently high level and do not "have" any standards.

-->

<xsl:template match="node" mode="highlevel">
  <xsl:variable name="id" select="@id"/>
  <informaltable frame="all" pgwide="1">
  <tgroup cols="3">
    <colspec colwidth="33*" colname="c1" />
    <colspec colwidth="33*"/>
    <colspec colwidth="33*" colname="c3"/>
    <thead>
      <row>
        <entry>Service</entry>
	<entry>Standards</entry>
        <entry>Remarks</entry>
      </row>
    </thead>
    <tbody>
<!--
      Let us for now ASSUME, no standards are associated with this node
           
      <xsl:apply-templates select="//sp-list[@tref=$id]" mode="sa-children"/>
-->     
      <xsl:apply-templates mode="lowlevel"/>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="node" mode="lowlevel">
  <xsl:variable name="id" select="@id"/>
  <xsl:apply-templates select="//sp-list[@tref=$id]"  mode="lowlevel"/>
  <xsl:apply-templates mode="lowlevel"/>
</xsl:template>


<xsl:template match="sp-list" mode="lowlevel">
  <xsl:variable name="tref" select="@tref"/>
  <xsl:if test="count(./sp-view)>0">
  <row>
    <entry>
      <xsl:value-of select="//node[@id=$tref]/@title"/>
    </entry>
    <entry>
      <xsl:if test="count(sp-list/select[@mode='mandatory'])>0">
        <para><emphasis role="bold">Mandatory</emphasis></para>
      </xsl:if>
      <itemizedlist>
        <xsl:apply-templates mode="lowlevel"/>
      </itemizedlist>
    </entry>
    <entry></entry>
  </row>
  </xsl:if>
</xsl:template>


<xsl:template match="sp-view" mode="lowlevel">
  <listitem>
    <para><xsl:value-of select="select"/></para>
  </listitem>
</xsl:template>


<xsl:template match="node1">
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


</xsl:stylesheet>
