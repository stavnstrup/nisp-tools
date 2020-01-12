<?xml version="1.0"?>
<!--

This stylesheet contains templates used by all resolver stylesheets.

Copyright (c) 2003-2019, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:import href="../common/common.xsl"/>

<xsl:param name="dbdir" select="'../../build.src/'"/>
<xsl:param name="dbname" select="'resolved-standards.xml'"/>


<!-- The directory relevant for this document, we need this with PDF and HTMLHelp -->
<xsl:param name="documentdir" select="''"/>
<xsl:param name="docid" select="''"/>
<xsl:param name="nisp.image.ext" select="''"/>

<xsl:param name="use.show.indexterms" select="0"/>

<xsl:param name="svgpdfdebug" select="0"/>

<xsl:param name="describe" select="''"/>


<!-- ==================================================================== -->


<xsl:template match="book">
  <book>
    <xsl:attribute name="condition"><xsl:value-of select="$documentdir"/></xsl:attribute>
    <xsl:apply-templates select="@*[local-name() != 'condition']"/>
    <xsl:attribute name="id"><xsl:value-of select="$docid"/></xsl:attribute>
    <xsl:apply-templates/>
  </book>
</xsl:template>


<!-- This is a BAD BAD hack and is used add Git Revision number to the a subject field in PDF mete data -->

<xsl:template match="subjectset">
  <subjectset>
    <subject>
      <subjectterm>
        <xsl:text>Git revision </xsl:text>
        <xsl:value-of select="$describe"/>
      </subjectterm>
    </subject>
  </subjectset>
</xsl:template>


<!-- ==================================================================== -->

<!-- Add mediaobject to info element -->

<xsl:template match="bookinfo">
  <bookinfo>
    <xsl:apply-templates/>
    <mediaobject>
      <imageobject>
        <imagedata fileref="../figures/NATO_OTAN_Insignia.svg" contentwidth="9cm"/>
      </imageobject>
    </mediaobject>
  </bookinfo>

  <!-- Add NSO preable stuff -->
  <preface role="promulgation">
    <title>NATO LETTER OF PROMULGATION</title>
    <para>The enclosed Allied Data Publication <xsl:value-of select="$allied.publication.number"/>, Edition 
    <xsl:value-of select="$allied.publication.edition"/>, Version <xsl:value-of select="$allied.publication.version"/> NATO 
    Interoperability Standards and Profiles, which has been approved by the nations in the C3B, is promulgated herewith. 
    The agreement of nations to use this publication is recorded in STANAG 5524.</para>
    <para><xsl:value-of select="$allied.publication.number"/>, Edition <xsl:value-of select="$allied.publication.edition"/>, 
    Version <xsl:value-of select="$allied.publication.version"/> is effective on receipt.</para>
    <para>No part of this publication may be reproduced, stored in a retrieval system, used commercially, adapted, or transmitted in any form or by any means, electronic,
    mechanical, photo-copying, recording or otherwise, without the prior permission of the publisher. With the exception of commercial sales, this does not apply to member
    or partner nations, or NATO commands and bodies.</para>
    <para>This publication shall be handled in accordance with C-M(2002)60.</para>
    <para><address format="linespecific">Zoltán GULYÁS
Brigadier General, HUNAF
Director, NATO Standardization Office</address></para>
  </preface>
  <preface>
    <title>RESERVED FOR NATIONAL LETTER OF PROMULGATION</title>
  </preface>
  <preface>
    <title>RECORD OF RESERVATIONS</title>
       <informaltable frame="all" pgwide="1">
      <tgroup cols="2">
        <colspec colwidth="18*" colname="c1"/>
        <colspec colwidth="82*" colname="c2"/>
        <thead>
          <row>
            <entry>CHAPTER</entry>
            <entry>RECORD OF RESERVATION BY NATIONS</entry>
          </row>
        </thead>
        <tbody>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry namest="c1" nameend="c2">Note: The reservations listed on this page include only those that were recorded at time of
            promulgation and may not be complete. Refer to the NATO Standardization Document
            Database for the complete list of existing reservations.</entry>
          </row>
        </tbody>
      </tgroup>
    </informaltable>
  </preface>
    <preface>
    <title>RECORD OF SPECIFIC RESERVATIONS</title>
    <informaltable frame="all" pgwide="1">
      <tgroup cols="2">
        <colspec colwidth="18*" colname="c1"/>
        <colspec colwidth="82*" colname="c2"/>
        <tbody>
          <row>
            <entry>[nation]</entry>
            <entry>[detail of reservation]</entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry></entry>
            <entry></entry>
          </row>
          <row>
            <entry namest="c1" nameend="c2">Note: The reservations listed on this page include only those that were recorded at time of
promulgation and may not be complete. Refer to the NATO Standardization Document
Database for the complete list of existing reservations.</entry>
          </row>
        </tbody>
      </tgroup>
    </informaltable>
  </preface>
  <toc/>
</xsl:template>


<xsl:template match="biblioid">
  <biblioid>
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates/>
  </biblioid>
  <issuenum>Edition <xsl:value-of select="$allied.publication.edition"/> Version <xsl:value-of select="$allied.publication.version"/></issuenum>
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
            <xsl:apply-templates select="./imageobject/imagedata/@*[local-name()!='fileref']"/>
          </xsl:element>
        </xsl:element>

        <!-- FOP Version -->
        <xsl:element name="imageobject">
          <xsl:attribute name="role">fo</xsl:attribute>
          <xsl:element name="imagedata">
            <xsl:attribute name="fileref">
               <xsl:value-of
                  select="substring-before(./imageobject/imagedata/@fileref,
                  '.svg')"/>
               <xsl:text>.svg</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="scalefit">1</xsl:attribute>
            <xsl:attribute name="width">100%</xsl:attribute>
            <xsl:attribute name="contentdepth">100%</xsl:attribute>
            <xsl:apply-templates select="./imageobject/imagedata/@*[local-name() != 'fileref']"/>
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
      <xsl:message terminate="yes">Taxonomy area not found.</xsl:message>
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
