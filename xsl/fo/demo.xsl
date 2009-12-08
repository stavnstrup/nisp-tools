<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'
                xmlns:stbl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Table"
                xmlns:xtbl="com.nwalsh.xalan.Table"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:fox="http://xml.apache.org/fop/extensions"
                exclude-result-prefixes="#default stbl xtbl fox saxon">

<xsl:import href="../docbook-xsl/fo/docbook.xsl"/>

<!--
<xsl:import href="fop-bugs/fo-post-for-fop.xsl"/>
-->

<xsl:param name="use.extensions" select="1"/>

<xsl:param name="abortext.extensions" select="0"/>
<xsl:param name="fop.extensions" select="0"/>
<xsl:param name="passivetex.extensions" select="0"/>
<xsl:param name="xep.extensions" select="1"/>



<xsl:param name="double.sided" select="1"/>


</xsl:stylesheet>
