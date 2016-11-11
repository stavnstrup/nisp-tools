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

<xsl:template match="@*" mode="addindexentry">
  <xsl:variable name="id" select="."/>

  <xsl:variable name="record" select="$db//standard[@id=$id]|$db//setofstandards[@id=$id]"/>
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

<xsl:template match="select|remarks">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->


<!-- This template can properly be merged into the procesing
     instruction template, but assumes that the node seleted is at a
     sufficiently high level and do not "have" any standards.

-->

<xsl:template match="node" mode="highlevel">
  <xsl:variable name="id" select="@id"/>
  <informaltable frame="all" pgwide="1">
  <tgroup cols="2">
    <colspec colwidth="24*" colname="c1" />
    <colspec colwidth="76*" colname="c2"/>
    <thead>
      <row>
        <entry>Service</entry>
	<entry>Standards</entry>
      </row>
    </thead>
    <tbody>
      <xsl:apply-templates select="." mode="lowlevel"/>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="node" mode="lowlevel">
  <xsl:variable name="id" select="@id"/>
  <xsl:apply-templates select="//bpserviceprofile[@tref=$id]"  mode="lowlevel"/>
  <xsl:apply-templates mode="lowlevel"/>
</xsl:template>


<xsl:template match="bpserviceprofile" mode="lowlevel">
  <xsl:variable name="tref" select="@tref"/>
  <row>
    <entry>
      <xsl:value-of select="//node[@id=$tref]/@title"/>
    </entry>
    <entry>
      <xsl:apply-templates select="bpgroup"/>
    </entry>
  </row>
</xsl:template>


<xsl:template match="bpgroup">
  <xsl:if test="count(./bprefstandard)>0">
    <xsl:choose>
      <xsl:when test="@mode='mandatory'">
        <para><emphasis>Mandatory</emphasis></para>
      </xsl:when>
      <xsl:when test="@mode='emerging'">
        <para><emphasis>Emerging</emphasis></para>
      </xsl:when>
      <xsl:when test="@mode='fading'">
        <para><emphasis>Fading</emphasis></para>
      </xsl:when>
    </xsl:choose>
    <itemizedlist spacing="compact">
      <xsl:apply-templates mode="lowlevel"/>
    </itemizedlist>
  </xsl:if>
</xsl:template>


<xsl:template match="bprefstandard" mode="lowlevel">
  <xsl:variable name="curid" select="@refid"/>
  <xsl:variable name="record" select="$db//standard[@id=$curid]|$db//setofstandards[@id=$curid]"/>
  <listitem>
    <para>
      <xsl:choose>
        <xsl:when test="$record/status/uri != ''">
	  <ulink url="{$record/status/uri}">
            <xsl:value-of select="."/>
          </ulink>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@refid" mode="addindexentry"/>
    </para>
  </listitem>
</xsl:template>




<!-- ==================================================================== -->


</xsl:stylesheet>
