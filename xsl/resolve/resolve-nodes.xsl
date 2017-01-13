<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NATO Interoperability Standard and
profiles (NISP), and is intended for resolving volume 2.

Copyright (c) 2002-2017, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
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
      <xsl:variable name="obligation">
        <xsl:call-template name="dbmerge-attribute">
          <xsl:with-param name="pi" select="$pis"/>
	        <xsl:with-param name="attribute" select="'obligation'"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="not($node='')">
        <xsl:apply-templates select="$db//node[@id=$node]" mode="highlevel">
          <xsl:with-param name="obligation" select="$obligation"/>
        </xsl:apply-templates>
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
  <xsl:param name="obligation" select="''"/>

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
      <xsl:apply-templates select="." mode="lowlevel">
        <xsl:with-param name="obligation" select="$obligation"/>
      </xsl:apply-templates>
    </tbody>
  </tgroup>
  </informaltable>
</xsl:template>


<xsl:template match="node" mode="lowlevel">
  <xsl:param name="obligation" select="''"/>

  <xsl:variable name="id" select="@id"/>
  <xsl:apply-templates select="//bpserviceprofile[@tref=$id]"  mode="lowlevel">
    <xsl:with-param name="obligation" select="$obligation"/>
  </xsl:apply-templates>
  <xsl:apply-templates mode="lowlevel">
    <xsl:with-param name="obligation" select="$obligation"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="bpserviceprofile" mode="lowlevel">
  <xsl:param name="obligation" select="''"/>

  <xsl:variable name="tref" select="@tref"/>

  <xsl:if test="count(bpgroup[@mode=$obligation]/bprefstandard)>0">
  <row>
    <entry>
      <xsl:value-of select="//node[@id=$tref]/@title"/>
    </entry>
    <entry>
      <xsl:apply-templates select="bpgroup[@mode=$obligation]"/>
    </entry>
  </row>
  </xsl:if>
</xsl:template>


<xsl:template match="bpgroup">
  <xsl:if test="count(./bprefstandard)>0">
    <itemizedlist spacing="compact">
      <xsl:apply-templates mode="lowlevel"/>
    </itemizedlist>
  </xsl:if>
</xsl:template>


<xsl:template match="bprefstandard" mode="lowlevel">
  <xsl:variable name="curid" select="@refid"/>
  <xsl:variable name="record" select="$db//standard[@id=$curid]"/>
  <listitem>
    <para>
      <xsl:choose>
        <xsl:when test="$record/status/uri != ''">
	        <ulink url="{$record/status/uri}">
            <xsl:call-template name="display-standard">
              <xsl:with-param name="std" select="$record"/>
            </xsl:call-template>
          </ulink>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="display-standard">
            <xsl:with-param name="std" select="$record"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@refid" mode="addindexentry"/>
    </para>
  </listitem>
</xsl:template>

<xsl:template name="display-standard">
  <xsl:param name="std"/>

  <xsl:variable name="myorgid" select="$std/document/@orgid"/>

  <xsl:value-of select="$std/document/@title"/>
  <xsl:if test="$std/document/@orgid != '' or $std/document/@pubnum !='' or $std/document/@date != ''">
    <xsl:text> (</xsl:text>
    <xsl:if test="$std/document/@orgid != ''">
      <xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@short"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="$std/document/@pubnum !=''">
      <xsl:value-of select="$std/document/@pubnum"/>
    </xsl:if>
    <xsl:if test="($std/document/@orgid !='' or $std/document/@pubnum !='') and $std/document/@date !=''">
      <xsl:text>:</xsl:text>
    </xsl:if>
    <xsl:if test="$std/document/@date !=''">
      <xsl:value-of select="substring($std/document/@date,1,4)"/>
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->


</xsl:stylesheet>
