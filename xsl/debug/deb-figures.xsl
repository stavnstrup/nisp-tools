<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                version='1.1'
                exclude-result-prefixes="#default svg saxon">

<xsl:import href="../common/common.xsl"/>


<!--
<xsl:output method="xml" indent="yes"/>
-->

<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-figures.xsl"/>


<!-- omit-xml-declaration="yes"/> -->

<xsl:param name="nisp.image.ext" select="''"/>

<xsl:variable name="alldocs" select="document('../../src/documents.xml')"/>


<xsl:template match="documents">
  <xsl:variable name="date">
    <xsl:value-of select="date:date-time()"/>
  </xsl:variable>

  <article>
    <title>All NISP figures</title>
    <subtitle>
      <xsl:value-of select="date:month-abbreviation($date)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="date:day-in-month()"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="date:year()"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    </subtitle>
    <xsl:apply-templates select="$alldocs//docinfo"/>
  </article>
</xsl:template>


<xsl:template match="docinfo">
  <sect1>
    <title>
      <xsl:value-of select="./titles/title"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="./titles/longtitle"/>
    </title>

    <xsl:variable name="doclocation">
      <xsl:text>../../build.src/</xsl:text>
      <xsl:value-of select="substring-before(main,'.')"/>
      <xsl:text>-resolved.xml</xsl:text>
    </xsl:variable>

    <xsl:variable name="thisdoc" select="document($doclocation)"/>

    <para>There are <xsl:value-of select="count($thisdoc//figure)"/> figures in the document.</para>

    <xsl:apply-templates select="$thisdoc//figure"/>
  </sect1>
</xsl:template>


<xsl:template match="figure">
  <xsl:variable name="svgbasename">
    <xsl:value-of select="substring-before(substring-after(mediaobject/imageobject[1]/imagedata/@fileref, '../figures/'),'.')"/>
  </xsl:variable>

  <figure float="0">
    <title>
      <xsl:value-of select="./title"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$svgbasename"/>
      <xsl:text>.svg)</xsl:text>
    </title>
    <mediaobject>
      <imageobject>
        <imagedata scalefit="1" width="100%" contentdepth="100%">
          <xsl:attribute name="fileref">
            <xsl:text>../../src/figures/</xsl:text>
            <xsl:value-of select="$svgbasename"/>
            <xsl:text>.svg</xsl:text>
          </xsl:attribute>
        </imagedata>
      </imageobject>
    </mediaobject>
  </figure>
</xsl:template>



</xsl:stylesheet>
