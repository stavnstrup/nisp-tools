<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                version="1.1"
                extension-element-prefixes="saxon"
                exclude-result-prefixes="xhtml fn">


<!--
  <xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="no"/>
-->
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

  <xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>


<xsl:template match="/">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<!-- ==================================================================== -->
<!-- Add Paul Irish stuff -->
<!-- https://gist.github.com/3169736 -->

  <xsl:template match="xhtml:html">
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$newline"/>
    <xsl:comment>paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/</xsl:comment>
    <xsl:value-of select="$newline"/>
<!--
    <xsl:comment>[if IE 8]&gt; &lt;html class="no-js lt-ie9" lang="<xsl:value-of select='@lang'/>"&gt; &lt;![endif]</xsl:comment>
-->
    <xsl:comment>[if IE 8]&gt; &lt;html class="no-js lt-ie9" lang="en"&gt; &lt;![endif]</xsl:comment>
    <xsl:value-of select="$newline"/>
    <xsl:text disable-output-escaping="yes">&lt;!--[if gt IE 8]&gt;&lt;!--&gt;</xsl:text>
 
    <html class="no-js" lang="en">
      <xsl:apply-templates select="@*"/>
      <xsl:text disable-output-escaping="yes">&lt;!--&lt;![endif]--&gt;</xsl:text>
      <xsl:value-of select="concat($newline, $newline)"/>
      <xsl:apply-templates select="*"/>
    </html>
  </xsl:template>

  <xsl:template match="xhtml:script">
    <script type="text/javascript" src="{@src}"><xsl:comment/></script>
  </xsl:template>


  <!-- ==================================================================== -->


  <xsl:template match="*">
    <!-- remove element prefix -->
    <xsl:element name="{local-name()}">
      <!-- process attributes -->
      <xsl:for-each select="@*">
        <!-- remove attribute prefix -->
        <xsl:attribute name="{local-name()}">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
