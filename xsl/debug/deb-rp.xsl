<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to list the parties responsible for providing expert guidedance.

Copyright (c) 2017  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">

<xsl:output indent="yes" saxon:next-in-chain="p2-rp.xsl"/>

<!-- Remove deleted standards -->

<xsl:template match="standard[descendant::event[(position()=last()) and (@flag = 'deleted')]]"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
