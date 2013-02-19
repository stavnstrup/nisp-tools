<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<!--

This stylesheet is created for the NISP, and is intended for
creating a coverpage for the PDF documents.

Copyright (c) 2013 Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:output method="xml" version="1.0" encoding="UTF-8"
            indent="yes"
            doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
            doctype-system="../src/schema/dtd/docbkx45/docbookx.dtd"/>


<xsl:template match="/">

  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A GENERATED VERSION ONLY.

     IF YOU WANT TO CHANGE THE TEXT IN THIS DOCUMENT, THEN EDIT THE
     
          XSL/PDFcoverdoc.xsl

     STYLESHEET.
     
  </xsl:comment>

  <chapter condition="PDFcoverdoc">
    <chapterinfo>
      <title>NISP in PDF</title>
      <corpauthor>C3B Interoperability Profiles Capability Team (IP CaT)</corpauthor>
    </chapterinfo>
  
    <title/>
    <section><title>NISP in PDF</title>

      <para>The following documents are of PDF versions of the NISP.</para>

      <itemizedlist>
          <xsl:apply-templates select=".//docinfo"/>
       </itemizedlist>
    </section>
  </chapter>  
   
</xsl:template>


<xsl:template match="docinfo">
  <listitem>
    <para>
      <ulink>
        <xsl:attribute name="url">
          <xsl:text>pdf/NISP-</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>-v</xsl:text>
          <xsl:value-of select="/documents/versioninfo/package/@major"/>
          <xsl:text>.pdf</xsl:text>
        </xsl:attribute>
        <xsl:text>NISP (</xsl:text>
        <xsl:value-of select="./titles/title"/>
        <xsl:text>) - </xsl:text>
        <xsl:value-of select="./titles/longtitle"/>     
      </ulink>
    </para>
  </listitem>
</xsl:template>


</xsl:stylesheet>
