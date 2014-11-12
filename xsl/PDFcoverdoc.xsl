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
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="../src/schema/dtd/xhtml1/DTD/xhtml1-strict.dtd"/>



<xsl:param name="nisp.lifecycle.stage" select="''"/>

<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml" id='PDFcoverdoc'>
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A GENERATED VERSION ONLY.

     IF YOU WANT TO CHANGE THE TEXT IN THIS DOCUMENT, THEN EDIT THE
     
          xsl/PDFcoverdoc.xsl

     STYLESHEET.
     
  </xsl:comment>
  <head>
    <title>NISP in PDF</title>
  </head>
  <body>
    <h2>NISP in PDF</h2>

    <p>The following documents are PDF versions of the NISP.</p>

    <ul>
      <xsl:apply-templates select=".//docinfo"/>
      <li>
        <p><a class="check.lifecycle.postfix">
        <xsl:attribute name="href">
          <xsl:text>pdf/NISP</xsl:text>
          <xsl:text>-v</xsl:text>
          <xsl:value-of select="/documents/versioninfo/package/@major"/>
          <xsl:if test="$nisp.lifecycle.stage != 'draft'">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$nisp.lifecycle.stage"/>
          </xsl:if>
          <xsl:text>.pdf</xsl:text>
        </xsl:attribute>
        <xsl:text>NISP - All Volumes in One</xsl:text>
	</a></p>
      </li>          
    </ul>  
  </body>
  </html>
</xsl:template>


<xsl:template match="docinfo">
  <li xmlns="http://www.w3.org/1999/xhtml">
    <p><a class="check.lifecycle.postfix">
      <xsl:attribute name="href">
        <xsl:text>pdf/</xsl:text>
        <xsl:value-of select=".//target[@type='pdf']"/>
        <xsl:text>-v</xsl:text>
        <xsl:value-of select="/documents/versioninfo/package/@major"/>
        <xsl:if test="$nisp.lifecycle.stage != 'draft'">
	  <xsl:text>-</xsl:text>
          <xsl:value-of select="$nisp.lifecycle.stage"/>
        </xsl:if>
        <xsl:text>.pdf</xsl:text>
      </xsl:attribute>
      <xsl:text>NISP (</xsl:text>
      <xsl:value-of select="./titles/title"/>
      <xsl:text>) - </xsl:text>
      <xsl:value-of select="./titles/longtitle"/>     
    </a></p>
  </li>
</xsl:template>


</xsl:stylesheet>
