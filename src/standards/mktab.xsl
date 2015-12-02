<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>


<xsl:template match="capabilityprofile/profile">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="profile">
  <h1><xsl:value-of select="@title"/></h1>
  <informaltable frame="all" pgwide="1">
    <tgroup cols="3">
      <colspec colwidth="16*" />
      <colspec colwidth="42*" />
      <colspec colwidth="42*" />
      <thead>
        <row>
          <entry>Service</entry>
          <entry>Standard</entry>
          <entry>Implementation Guidance</entry>
        </row>
      </thead>
      <tbody>
        <xsl:apply-templates select="serviceprofile"/>
      </tbody>
    </tgroup>
  </informaltable>
</xsl:template>

<xsl:template match="serviceprofile">
  <row>
    <entry namest="1" nameend="3">
      <para><emphasis role="bold"><xsl:value-of select="@title"/></emphasis></para>
      <para><xsl:value-of select="./description"/></para>
    </entry>
  </row>
  <row>
    <entry><xsl:apply-templates select="reftaxonomy"/></entry>
    <entry><xsl:apply-templates select="obgroup"/></entry>
    <entry><xsl:apply-templates select="guide"/></entry>
  </row>
</xsl:template>


<xsl:template match="reftaxonomy">
  <xsl:value-of select="@refid"/>
  <xsl:if test="following-sibling::reftaxonomy">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="obgroup">
  <para><emphasis><xsl:value-of select="@obligation"/></emphasis></para>
  <xsl:if test="./description">
    <para><xsl:value-of select="./description"/></para>
  </xsl:if>
  <itemizedlist>
    <xsl:apply-templates select="refstandard"/>
  </itemizedlist>
</xsl:template>


<xsl:template match="refstandard">
  <listitem><para><xsl:value-of select="@refid"/></para></listitem>
</xsl:template>

  
<xsl:template match="guide">
  <para><xsl:value-of select="."/></para>
</xsl:template>



</xsl:stylesheet>
